package com.utm.md.orders.service.orders;

import com.utm.md.orders.dto.OrdeerDto;

import java.util.Collection;

public interface OrderService {
    void createOrder(OrdeerDto ordeerDto);
    Collection<OrdeerDto> getAllOrders();
}
