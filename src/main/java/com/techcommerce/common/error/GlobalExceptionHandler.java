package com.techcommerce.common.error;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.NoHandlerFoundException;
import org.springframework.web.servlet.resource.NoResourceFoundException;

import java.util.LinkedHashMap;
import java.util.Map;

@Controller
@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @GetMapping("/error/403")
    public String error403Page(HttpServletResponse response, Model model) {
        response.setStatus(HttpStatus.FORBIDDEN.value());
        model.addAttribute("errorMessage", "Bạn không có quyền truy cập tài nguyên hoặc chi nhánh này.");
        return "error/403";
    }

    @GetMapping("/error/404")
    public String error404Page(HttpServletResponse response, Model model) {
        response.setStatus(HttpStatus.NOT_FOUND.value());
        model.addAttribute("errorMessage", "Không tìm thấy trang hoặc sản phẩm bạn yêu cầu.");
        return "error/404";
    }

    @GetMapping("/error/500")
    public String error500Page(HttpServletResponse response, Model model) {
        response.setStatus(HttpStatus.INTERNAL_SERVER_ERROR.value());
        model.addAttribute("errorMessage", "Hệ thống đang bận hoặc gặp sự cố tạm thời. Vui lòng thử lại.");
        return "error/500";
    }

    @ExceptionHandler({NoResourceFoundException.class, NoHandlerFoundException.class})
    public Object handleNotFound(Exception ex, HttpServletRequest request, HttpServletResponse response) {
        return respond(HttpStatus.NOT_FOUND, "Không tìm thấy tài nguyên yêu cầu", "error/404", request, response);
    }

    @ExceptionHandler(AccessDeniedException.class)
    public Object handleAccessDenied(AccessDeniedException ex, HttpServletRequest request, HttpServletResponse response) {
        return respond(HttpStatus.FORBIDDEN, "Từ chối truy cập", "error/403", request, response);
    }

    @ExceptionHandler(Exception.class)
    public Object handleGenericException(Exception ex, HttpServletRequest request, HttpServletResponse response) {
        log.error("Unhandled error on {} {}", request.getMethod(), request.getRequestURI(), ex);
        return respond(HttpStatus.INTERNAL_SERVER_ERROR, "Lỗi hệ thống nội bộ", "error/500", request, response);
    }

    private Object respond(HttpStatus status, String message, String viewName,
                           HttpServletRequest request, HttpServletResponse response) {
        String uri = request.getRequestURI();
        String accept = request.getHeader("Accept");
        boolean wantsJson = uri.startsWith("/api/")
                || (accept != null && accept.contains(MediaType.APPLICATION_JSON_VALUE) && !accept.contains(MediaType.TEXT_HTML_VALUE));

        if (wantsJson) {
            Map<String, Object> body = new LinkedHashMap<>();
            body.put("status", status.value());
            body.put("error", message);
            body.put("path", uri);
            return ResponseEntity.status(status).contentType(MediaType.APPLICATION_JSON).body(body);
        }

        response.setStatus(status.value());
        ModelAndView mav = new ModelAndView(viewName);
        mav.setStatus(status);
        mav.addObject("errorMessage", message);
        mav.addObject("requestUri", uri);
        return mav;
    }
}
