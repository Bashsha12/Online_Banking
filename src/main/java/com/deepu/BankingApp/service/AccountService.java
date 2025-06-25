package com.deepu.BankingApp.service;

import com.deepu.BankingApp.dto.AccountDto;

import java.util.List;


public interface AccountService {

    AccountDto createAccount(AccountDto account);
    AccountDto getAccountById(Long id);
    AccountDto depositAmount(Long id,double amount);
    AccountDto withdrawAmount(Long id,double amount);
    List<AccountDto> getAllAccounts();
    void deleteAccount(Long id);
}
