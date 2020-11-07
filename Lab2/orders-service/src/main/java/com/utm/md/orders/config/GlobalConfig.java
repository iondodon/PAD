package com.utm.md.orders.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.net.http.HttpClient;

@Configuration
public class GlobalConfig {
    private final ObjectMapper objectMapper = new ObjectMapper();
    private final HttpClient httpClient = HttpClient.newHttpClient();

    @Bean
    public ObjectMapper objectMapper() {
        return objectMapper;
    }

    @Bean
    public HttpClient httpClient() { return httpClient; }
}
