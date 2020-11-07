package com.utm.md.orders.config;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.HashMap;

@Configuration
public class ServiceDiscoveryConfig {
    @Value("${server.port}")
    private String serverPort;
    @Value("${service.name}")
    private String serviceName;

    @Value("${gateway.port}")
    private String gatewayPort;
    @Value("${gateway.address}")
    private String gatewayAddress;

    @Bean
    public Gateway gateway(HttpClient httpClient, ObjectMapper objectMapper) {
        try {
            HashMap<String, String> map = new HashMap<>();
            map.put("address", serviceName + ":" + serverPort);
            map.put("service", serviceName);

            String requestBody = objectMapper
                    .writerWithDefaultPrettyPrinter()
                    .writeValueAsString(map);

            HttpRequest request = HttpRequest
                    .newBuilder()
                    .uri(URI.create("http://" + gatewayAddress + ":" + gatewayPort + "/register"))
                    .timeout(Duration.ofMinutes(1))
                    .header("Content-Type", "application/json")
                    .version(HttpClient.Version.HTTP_1_1)
                    .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                    .build();

            httpClient.sendAsync(request, HttpResponse.BodyHandlers.ofString())
                    .thenApply(HttpResponse::body)
                    .thenAccept(System.out::println)
                    .join();
        } catch (RuntimeException | JsonProcessingException exception) {
            exception.printStackTrace();
        }

        return new Gateway(gatewayAddress + ":" + gatewayPort);
    }
}
