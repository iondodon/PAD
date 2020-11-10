package com.utm.md.orders.service.orders;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.utm.md.orders.dto.OrdeerDto;
import com.utm.md.orders.model.Ordeer;
import com.utm.md.orders.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.Collection;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class OrderServiceImpl implements OrderService {
    private final OrderRepository orderRepository;
    private final ObjectMapper objectMapper;
    private final OrderAsyncService orderAsyncService;

    @Override
    @Transactional
    public void createOrder(OrdeerDto ordeerDto) {
        final Ordeer ordeer = objectMapper.convertValue(ordeerDto, Ordeer.class);
        final Ordeer createdOrdeer = orderRepository.save(ordeer);
        log.info("Completing...");
        orderAsyncService.completeOrder(createdOrdeer.getId());
        log.info("Completed!");
    }

    @Override
    @Transactional
    public Collection<OrdeerDto> getAllOrders() {
        Collection<Ordeer> ordeer = orderRepository.findAll();
        return ordeer.stream().map(
                order -> objectMapper.convertValue(order, OrdeerDto.class)
        ).collect(Collectors.toList());
    }

    @Override
    public OrdeerDto deleteOrder(UUID orderID) {
        Ordeer order = orderRepository.getOne(orderID);
        orderRepository.delete(order);
        return objectMapper.convertValue(order, OrdeerDto.class);
    }
}
