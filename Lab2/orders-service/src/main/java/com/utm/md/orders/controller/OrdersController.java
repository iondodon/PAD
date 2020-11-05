package com.utm.md.orders.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class OrdersController {

    @RequestMapping(
            method = {RequestMethod.GET},
            path = "/hello"
            )
    public String hello() {
        return "ion";
    }

}
