package com.utm.md.orders.task;

import com.utm.md.orders.service.orders.OrderService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.util.UUID;
import java.util.concurrent.TimeUnit;

@RequiredArgsConstructor
@Slf4j
public class ProcessOrderTask extends Thread {
    private final OrderService orderService;
    private final UUID ordeerID;

    @Override
    public void run() {
        try {
            TimeUnit.SECONDS.sleep(10);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        log.info("Order " + ordeerID + " has been prepared.");
        orderService.setPrepared(ordeerID);
    }
}


