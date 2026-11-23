package com.techcommerce.auth;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpHeaders;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.time.Instant;
import java.util.List;
import java.util.Optional;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtService jwtService;
    private final UserRepository userRepository;

    public JwtAuthenticationFilter(JwtService jwtService, UserRepository userRepository) {
        this.jwtService = jwtService;
        this.userRepository = userRepository;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        if (SecurityContextHolder.getContext().getAuthentication() == null) {
            authenticateRequest(request, response);
        }
        filterChain.doFilter(request, response);
    }

    private void authenticateRequest(HttpServletRequest request, HttpServletResponse response) {
        Instant now = Instant.now();
        Optional<String> tokenOpt = JwtService.readCookie(request, JwtService.ACCESS_COOKIE_NAME);
        if (tokenOpt.isEmpty()) {
            String authHeader = request.getHeader(HttpHeaders.AUTHORIZATION);
            if (StringUtils.hasText(authHeader) && authHeader.startsWith("Bearer ")) {
                tokenOpt = Optional.of(authHeader.substring(7).trim());
            }
        }

        if (tokenOpt.isPresent()) {
            Optional<UserPrincipal> principalOpt = jwtService.parseAccessToken(tokenOpt.get());
            if (principalOpt.isPresent()) {
                Optional<User> userOpt = userRepository.findById(principalOpt.get().id());
                if (userOpt.isPresent() && userOpt.get().isEnabled() && !userOpt.get().isCurrentlyLocked(now)) {
                    setSecurityContext(userOpt.get(), request);
                    return;
                }
            }
        }

        // Fallback to Refresh Token rotation if ACCESS_TOKEN is missing or expired
        JwtService.readCookie(request, JwtService.REFRESH_COOKIE_NAME)
                .flatMap(rawRefresh -> jwtService.rotateRefreshToken(rawRefresh, response))
                .ifPresent(user -> setSecurityContext(user, request));
    }

    private void setSecurityContext(User user, HttpServletRequest request) {
        UserPrincipal principal = UserPrincipal.from(user);
        UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(
                principal,
                null,
                List.of(new SimpleGrantedAuthority("ROLE_" + user.getRole()))
        );
        SecurityContextHolder.getContext().setAuthentication(auth);
        request.setAttribute("currentUser", principal);
    }
}
