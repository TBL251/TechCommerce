package com.techcommerce.auth;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface UserAddressRepository extends JpaRepository<UserAddress, Long> {

    List<UserAddress> findByUserIdOrderByDefaultAddressDescIdDesc(Long userId);

    Optional<UserAddress> findByIdAndUserId(Long id, Long userId);

    @Modifying(clearAutomatically = true, flushAutomatically = true)
    @Query("UPDATE UserAddress a SET a.defaultAddress = false WHERE a.userId = :userId AND a.defaultAddress = true")
    int clearDefaultForUser(@Param("userId") Long userId);
}
