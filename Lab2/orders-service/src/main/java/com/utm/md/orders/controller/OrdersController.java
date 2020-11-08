package com.utm.md.orders.controller;

import com.utm.md.orders.service.orders.OrderService;
import com.utm.md.orders.dto.OrdeerDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping(path = "/order")
public class OrdersController {
    private final OrderService orderService;

    @RequestMapping(
            method = {RequestMethod.POST},
            path = "/"
    )
    public ResponseEntity<String> createOrder(@RequestBody OrdeerDto ordeerDto) {
        orderService.createOrder(ordeerDto);
        log.debug("Creating order " + ordeerDto);
        return new ResponseEntity<>("Created", HttpStatus.CREATED);
    }
}
