package com.techcommerce.common;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.Map;

@Controller
public class HealthController {

    @GetMapping({"/", "/health-jsp"})
    public String healthJsp(Model model) {
        model.addAttribute("appName", "TechCommerce");
        return "health";
    }

    @GetMapping("/api/health")
    @ResponseBody
    public ResponseEntity<Map<String, String>> apiHealth() {
        return ResponseEntity.ok(Map.of("status", "UP"));
    }
}
