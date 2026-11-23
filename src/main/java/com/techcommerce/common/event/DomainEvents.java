package com.techcommerce.common.event;

public final class DomainEvents {

    private DomainEvents() {
    }

    public record OrderCreatedEvent(
            Long orderId,
            String orderCode,
            Long storeId,
            Long userId,
            String customerEmail
    ) {
    }

    public record OrderStatusChangedEvent(
            Long orderId,
            String orderCode,
            Long storeId,
            Long userId,
            String oldStatus,
            String newStatus
    ) {
    }

    public record ReturnRequestEvent(
            Long returnRequestId,
            Long orderId,
            String orderCode,
            Long storeId,
            Long userId,
            String customerEmail,
            String status
    ) {
    }

    public record StockRestockedEvent(
            Long storeId,
            Long variantId,
            int newQuantity
    ) {
    }
}
