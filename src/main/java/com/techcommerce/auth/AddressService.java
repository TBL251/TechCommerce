package com.techcommerce.auth;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;
import java.util.Optional;

@Service
public class AddressService {

    private final UserAddressRepository addressRepository;

    public AddressService(UserAddressRepository addressRepository) {
        this.addressRepository = addressRepository;
    }

    @Transactional(readOnly = true)
    public List<UserAddress> listUserAddresses(Long userId) {
        return addressRepository.findByUserIdOrderByDefaultAddressDescIdDesc(userId);
    }

    @Transactional
    public UserAddress addAddress(Long userId, String recipientName, String phone,
                                  String addressLine, String city, boolean makeDefault) {
        if (userId == null || !StringUtils.hasText(recipientName) || !StringUtils.hasText(phone)
                || !StringUtils.hasText(addressLine) || !StringUtils.hasText(city)) {
            throw new IllegalArgumentException("Vui lòng nhập đầy đủ thông tin địa chỉ nhận hàng.");
        }

        List<UserAddress> current = addressRepository.findByUserIdOrderByDefaultAddressDescIdDesc(userId);
        boolean shouldBeDefault = makeDefault || current.isEmpty();
        if (shouldBeDefault) {
            addressRepository.clearDefaultForUser(userId);
        }

        UserAddress address = new UserAddress();
        address.setUserId(userId);
        address.setRecipientName(recipientName.trim());
        address.setPhone(phone.trim());
        address.setAddressLine(addressLine.trim());
        address.setCity(city.trim());
        address.setDefaultAddress(shouldBeDefault);
        return addressRepository.saveAndFlush(address);
    }

    @Transactional
    public boolean setDefaultAddress(Long userId, Long addressId) {
        Optional<UserAddress> addrOpt = addressRepository.findByIdAndUserId(addressId, userId);
        if (addrOpt.isEmpty()) {
            return false;
        }
        addressRepository.clearDefaultForUser(userId);
        UserAddress addr = addrOpt.get();
        addr.setDefaultAddress(true);
        addressRepository.saveAndFlush(addr);
        return true;
    }

    @Transactional
    public boolean deleteAddress(Long userId, Long addressId) {
        Optional<UserAddress> addrOpt = addressRepository.findByIdAndUserId(addressId, userId);
        if (addrOpt.isEmpty()) {
            return false;
        }
        UserAddress addr = addrOpt.get();
        boolean wasDefault = addr.isDefaultAddress();
        addressRepository.delete(addr);
        addressRepository.flush();

        if (wasDefault) {
            List<UserAddress> remaining = addressRepository.findByUserIdOrderByDefaultAddressDescIdDesc(userId);
            if (!remaining.isEmpty()) {
                UserAddress nextDefault = remaining.get(0);
                nextDefault.setDefaultAddress(true);
                addressRepository.saveAndFlush(nextDefault);
            }
        }
        return true;
    }
}
