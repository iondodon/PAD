package com.utm.md.orders.service.orders;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.utm.md.orders.dto.OrdeerDto;
import com.utm.md.orders.model.Ordeer;
import com.utm.md.orders.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import java.util.Collection;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class OrderServiceImpl implements OrderService {
    private final OrderRepository orderRepository;
    private final ObjectMapper objectMapper;

    @Override
    public void createOrder(OrdeerDto ordeerDto) {
        Ordeer ordeer = objectMapper.convertValue(ordeerDto, Ordeer.class);
        Ordeer createdOrdeer = orderRepository.save(ordeer);
        CompletableFuture.runAsync(() -> completeOrder(createdOrdeer));
    }

    @SneakyThrows
    public void completeOrder(Ordeer ordeer) {
        log.info("Completing...");
        TimeUnit.SECONDS.sleep(10);
        Ordeer persistedOrder = orderRepository.getOne(ordeer.getId());
        Assert.notNull(persistedOrder, "Order not found.");
        persistedOrder.setIsPrepared(true);
        orderRepository.save(persistedOrder);
        log.info("Completed!");
    }
    
    @Override
    public Collection<OrdeerDto> getAllOrders() {
        Collection<Ordeer> ordeer = orderRepository.findAll();
        return ordeer.stream().map(
                order -> objectMapper.convertValue(order, OrdeerDto.class)
        ).collect(Collectors.toList());
    }
}
