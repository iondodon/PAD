package com.utm.md.orders.service.orders;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.utm.md.orders.dto.OrdeerDto;
import com.utm.md.orders.model.Ordeer;
import com.utm.md.orders.repository.OrderRepository;
import com.utm.md.orders.task.ProcessOrderTask;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import java.util.UUID;

@Service
@RequiredArgsConstructor
public class OrderServiceImpl implements OrderService {
    private final OrderRepository orderRepository;
    private final ObjectMapper objectMapper;

    @Override
    public void createOrder(OrdeerDto ordeerDto) {
        Ordeer ordeer = objectMapper.convertValue(ordeerDto, Ordeer.class);
        Ordeer createdOrdeer = orderRepository.save(ordeer);
        UUID uuid = objectMapper.convertValue(createdOrdeer.getId(), UUID.class);
        new ProcessOrderTask(this, uuid).start();
    }

    @Override
    public void setPrepared(UUID orderID) {
        Ordeer persistedOrder = orderRepository.getOne(orderID);
        Assert.notNull(persistedOrder, "Order not found.");
        persistedOrder.setIsPrepared(true);
        orderRepository.save(persistedOrder);
    }
}
