package com.utm.md.orders.controller;

import com.utm.md.orders.service.orders.OrderService;
import com.utm.md.orders.dto.OrdeerDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Collection;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
@Slf4j
@RequestMapping(path = "/order")
public class OrdersController {
    private final OrderService orderService;

    @RequestMapping(
            method = {RequestMethod.POST},
            path = ""
    )
    public ResponseEntity<String> createOrder(@RequestBody OrdeerDto ordeerDto) {
        orderService.createOrder(ordeerDto);
        log.info("Creating order " + ordeerDto);
        return new ResponseEntity<>("Created", HttpStatus.CREATED);
    }

    @RequestMapping(
            path = "",
            method = RequestMethod.GET
    )
    public ResponseEntity<Collection<OrdeerDto>> getAllOrders() {
        log.info("Get all orders");
        Collection<OrdeerDto> ordeerDtos = orderService.getAllOrders();
        return new ResponseEntity<>(ordeerDtos, HttpStatus.OK);
    }

    @RequestMapping(
            path = "{orderID}",
            method = RequestMethod.DELETE
    )
    public ResponseEntity<OrdeerDto> deleteOrder(@PathVariable("orderID") UUID orderID) {
        log.info("Delete order: " + orderID);
        OrdeerDto deletedOrder = orderService.deleteOrder(orderID);
        return new ResponseEntity<>(deletedOrder, HttpStatus.OK);
    }
}
