package com.techcommerce.config;

import jakarta.servlet.DispatcherType;
import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.Ordered;

import java.util.EnumSet;

@Configuration
public class SiteMeshConfig {

    @Bean(name = "sitemeshFilter")
    public FilterRegistrationBean<ConfigurableSiteMeshFilter> sitemeshFilter() {
        FilterRegistrationBean<ConfigurableSiteMeshFilter> registration = new FilterRegistrationBean<>();
        registration.setFilter(new ConfigurableSiteMeshFilter() {
            @Override
            protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
                builder
                        .setDecoratorPrefix("")
                        .setIncludeErrorPages(true)
                        .addDecoratorPath("/*", "/WEB-INF/decorators/web.jsp")
                        .addDecoratorPath("/admin/*", "/WEB-INF/decorators/admin.jsp")
                        .addDecoratorPath("/staff/*", "/WEB-INF/decorators/admin.jsp")
                        .addDecoratorPath("/auth/*", "/WEB-INF/decorators/auth.jsp")
                        .addExcludedPath("/api/*")
                        .addExcludedPath("/ws/*")
                        .addExcludedPath("/assets/*")
                        .addExcludedPath("/health-jsp")
                        .addExcludedPath("/favicon.ico");
            }
        });
        registration.addUrlPatterns("/*");
        registration.setDispatcherTypes(EnumSet.of(DispatcherType.REQUEST, DispatcherType.ERROR));
        registration.setOrder(Ordered.LOWEST_PRECEDENCE - 10);
        return registration;
    }
}
