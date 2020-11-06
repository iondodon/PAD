package com.utm.md.orders.Service.orders;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.utm.md.orders.dto.OrdeerDto;
import com.utm.md.orders.model.Ordeer;
import com.utm.md.orders.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class OrderServiceImpl implements OrderService {
    private final OrderRepository orderRepository;

    @Override
    public void createOrder(OrdeerDto ordeerDto) {
        ObjectMapper objectMapper = new ObjectMapper();
        Ordeer ordeer = objectMapper.convertValue(ordeerDto, Ordeer.class);
        orderRepository.save(ordeer);
    }
}
