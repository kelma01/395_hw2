# Farklı Dillerde Hesap Makinesi İmplementasyonu

5 farklı dilde aritmetik hesap makinesi programının implementasyonu yapılmıştır:

## Ruby

Bu hesap makinesi programı, Rust dilinde yazılmış bir hesap makinesidir. Temel aritmetik işlemlerde bulunur, değişken atayabilir, değişkeni ifadelerde kullanabilir, parantezli işlemleri destekler yanısıra işlem önceliği sunar. Hata yönetimi mevcuttur.

Kullanıcının girdiği ifade değerlendirilmesinin kolaylaşması için (2 + 3) formatından (+ 2 3) formatına dönüştürülür ve bu ifade stack yardımı ile işlenir. Değişkenler programın çalıştırılması esnasında HashMap ile tutulur ve değişkenlerin değerleri saklanıp kullanılır.

Nasıl Çalıştırılır:
```bash
1. #Proje bilgisayara klonlanır.
2. cd calculator_rust #ile hedef dizine gidilir.
3. cargo build #ile compile ve build işlemleri yapılır.
4. cargo run #dedikten sonra da program çalışmaktadır.
```

## ADA

Yoktur

## Perl

Bu hesap makinesi programı, Perl dilinde yazılmış bir hesap makinesidir. Temel aritmetik işlemlerde bulunur, değişken atayabilir, değişkeni ifadelerde kullanabilir, parantezli işlemleri destekler yanısıra işlem önceliği sunar. Hata yönetimi mevcuttur.

Kullanıcının girdiği ifade değerlendirilmesinin kolaylaşması için (2 + 3) formatından (+ 2 3) formatına dönüştürülür ve bu ifade stack yardımı ile işlenir. Değişkenler programın çalıştırılması esnasında HashMap ile tutulur ve değişkenlerin değerleri saklanıp kullanılır.

Nasıl Çalıştırılır:
```bash
1. #Proje bilgisayara klonlanır.
2. cd calculator_perl #ile hedef dizine gidilir
3. perl main.pl #ile dosya çalıştırılır
```

## Scheme

Bu hesap makinesi programı, Scheme dilinde yazılmış bir hesap makinesidir. Temel aritmetik işlemlerde bulunur, değişken atayabilir, değişkeni ifadelerde kullanabilir, iç içe parantezli işlemleri yürütür, işlem önceliği sunar. Hata yönetimi mevcuttur.

Giriş ifadeleri, kullanıcıdan Postfix Expression formatında alınır ve o şekilde değiştirilmeden değerlendirilir. Değişkenler dinamik olarak saklanır ve tanımsız değişkenler veya sıfıra bölme gibi durumlarda hata mesajları gösterilir, hata yönetimi mevcuttur. Program, kullanıcıdan sürekli giriş alır ve "Ctrl + D" komutuyla sonlandırılır.

Nasıl Çalıştırılır:
```bash
1. #Proje bilgisayara klonlanır.
2. cd calculator_scheme #ile hedef dizine gidilir
3. raco exe -o calculator main.scm #ile compile edilir
4. ./calculator #ile progrma çalıştırılır.
```

## Prolog

Bu hesap makinesi programı, Prolog dilinde yazılmış bir hesap makinesidir. Temel aritmetik işlemlerde bulunur, değişken atayabilir, değişkeni ifadelerde kullanabilir, işlem önceliği sunar. Hata yönetimi mevcuttur.

Giriş ifadeleri, infix'ten postfix'e dönüştürülerek değerlendirilir. Değişkenler dinamik olarak saklanır ve tanımsız değişkenler veya sıfıra bölme gibi durumlarda hata mesajları gösterilir, hata yönetimi mevcuttur. Program, kullanıcıdan sürekli giriş alır ve exit komutuyla sonlandırılır.

Nasıl Çalıştırılır:
```bash
1. #Proje bilgisayara klonlanır.
2. cd calculator_prolog #ile hedef dizine gidilir
3. swipl -q -f main.pl -g "main" -t halt. #ile çalıştırılır.
```