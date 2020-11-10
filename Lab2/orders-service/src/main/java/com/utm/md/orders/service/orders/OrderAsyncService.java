package com.utm.md.orders.service.orders;

import com.utm.md.orders.model.Ordeer;
import com.utm.md.orders.repository.OrderRepository;
import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.util.Assert;

import javax.transaction.Transactional;
import java.util.UUID;
import java.util.concurrent.TimeUnit;

@Service
@RequiredArgsConstructor
@Slf4j
public class OrderAsyncService {
    final private OrderRepository orderRepository;

    @SneakyThrows
    @Transactional
    @Async("threadPoolTaskExecutor")
    public void completeOrder(UUID ordeerID) {
        TimeUnit.SECONDS.sleep(10);
        Ordeer persistedOrder = orderRepository.getOne(ordeerID);
        Assert.notNull(persistedOrder, "Order not found.");
        persistedOrder.setIsPrepared(true);
        orderRepository.save(persistedOrder);
        log.info("Prepared");
    }
}
