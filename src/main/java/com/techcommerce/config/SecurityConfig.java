package com.techcommerce.config;

import com.techcommerce.auth.JwtAuthenticationFilter;
import com.techcommerce.auth.OAuth2AuthenticationSuccessHandler;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.config.oauth2.client.CommonOAuth2Provider;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.registration.ClientRegistration;
import org.springframework.security.oauth2.client.registration.ClientRegistrationRepository;
import org.springframework.security.oauth2.client.registration.InMemoryClientRegistrationRepository;
import org.springframework.security.oauth2.client.web.DefaultOAuth2AuthorizationRequestResolver;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.header.writers.ReferrerPolicyHeaderWriter;
import org.springframework.util.StringUtils;

@Configuration
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(
            HttpSecurity http,
            JwtAuthenticationFilter jwtAuthenticationFilter,
            OAuth2AuthenticationSuccessHandler oAuth2SuccessHandler,
            @Value("${app.oauth2.google.client-id:}") String googleClientId,
            @Value("${app.oauth2.google.client-secret:}") String googleClientSecret
    ) throws Exception {
        http
                .csrf(csrf -> csrf.ignoringRequestMatchers("/api/payments/vnpay/ipn"))
                .sessionManagement(sm -> sm.sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED))
                .headers(headers -> headers
                        .frameOptions(frame -> frame.sameOrigin())
                        .contentTypeOptions(cto -> {})
                        .referrerPolicy(ref -> ref.policy(ReferrerPolicyHeaderWriter.ReferrerPolicy.STRICT_ORIGIN_WHEN_CROSS_ORIGIN))
                )
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(
                                "/", "/stores/**", "/products/**", "/compare", "/wishlist",
                                "/cart/**", "/api/cart/**", "/api/products/suggest", "/api/vouchers/preview",
                                "/api/payments/vnpay/ipn", "/payments/vnpay/return",
                                "/auth/**", "/error/**", "/health-jsp", "/api/health",
                                "/assets/**", "/WEB-INF/**", "/favicon.ico"
                        ).permitAll()
                        .requestMatchers(HttpMethod.POST, "/admin/users/**").hasRole("ADMIN")
                        .requestMatchers("/admin/stores/**", "/admin/catalog/**", "/admin/vouchers/**").hasRole("ADMIN")
                        .requestMatchers("/admin/**", "/staff/**").hasAnyRole("ADMIN", "STAFF")
                        .requestMatchers("/profile/**", "/checkout/**", "/orders/**", "/returns/**", "/chat/**").authenticated()
                        .anyRequest().permitAll()
                )
                .exceptionHandling(ex -> ex
                        .authenticationEntryPoint((request, response, authException) -> {
                            if (request.getRequestURI().startsWith("/api/")) {
                                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                                response.setContentType("application/json;charset=UTF-8");
                                response.getWriter().write("{\"status\":401,\"error\":\"Vui lòng đăng nhập\"}");
                            } else {
                                response.sendRedirect(request.getContextPath() + "/auth/login");
                            }
                        })
                        .accessDeniedHandler((request, response, accessDeniedException) -> {
                            if (request.getRequestURI().startsWith("/api/")) {
                                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                                response.setContentType("application/json;charset=UTF-8");
                                response.getWriter().write("{\"status\":403,\"error\":\"Từ chối truy cập\"}");
                            } else {
                                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                                request.getRequestDispatcher("/error/403").forward(request, response);
                            }
                        })
                )
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        if (StringUtils.hasText(googleClientId) && StringUtils.hasText(googleClientSecret)) {
            ClientRegistration googleReg = CommonOAuth2Provider.GOOGLE.getBuilder("google")
                    .clientId(googleClientId)
                    .clientSecret(googleClientSecret)
                    .scope("openid", "profile", "email")
                    .build();
            ClientRegistrationRepository repo = new InMemoryClientRegistrationRepository(googleReg);
            DefaultOAuth2AuthorizationRequestResolver authorizationRequestResolver =
                    new DefaultOAuth2AuthorizationRequestResolver(repo, "/oauth2/authorization");
            authorizationRequestResolver.setAuthorizationRequestCustomizer(
                    customizer -> customizer.additionalParameters(params -> params.put("prompt", "select_account consent"))
            );
            http.oauth2Login(oauth -> oauth
                    .clientRegistrationRepository(repo)
                    .authorizationEndpoint(authorization -> authorization
                            .authorizationRequestResolver(authorizationRequestResolver)
                    )
                    .loginPage("/auth/login")
                    .successHandler(oAuth2SuccessHandler)
            );
        }

        return http.build();
    }
}

