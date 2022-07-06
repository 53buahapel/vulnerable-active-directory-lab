# vulnerable active directory lab

Hi, kali ini saya akan memberikan lab untuk belajar tentang active directory.

`dificulity : easy `

## cara setup

1. [Download](https://www.mediafire.com/file/qf43sahemb31pbm/victim.vdi/file) image virtualbox
2. Pastikan anda memiliki virtualbox
3. Install image windows server tersebut
4. Login dengan password `P@ssw0rd`
5. Masukan angka 8 lalu setting network
    ![](https://xpertstec.com/wp-content/uploads/2022/03/Welcome-to-window-core-server.png?ezimgfmt=ng:webp/ngcb3)
6. Ketik 1 untuk memilih 
    ![](https://xpertstec.com/wp-content/uploads/2022/03/Available-adapter-core-server-1.png?ezimgfmt=ng:webp/ngcb3)
7. Ketik 1 lalu, Ganti ip menggunakan ip static ***sesuaikan dengan network anda***
    ![](https://xpertstec.com/wp-content/uploads/2022/03/Network-adapter-settings-core-server.png?ezimgfmt=ng:webp/ngcb3)
8. Setelah itu, ketik 2 dan masukan ip anda sebagai dns
   ![](https://xpertstec.com/wp-content/uploads/2022/03/DNS-settings-core-server.png?ezimgfmt=ng:webp/ngcb3)
9.  Masuk ke menu utama dan ketik 15 untuk masuk ke powershell
10. Masukan perintah ini
```
C:\Windows\Task\setup.ps1
```
## kerentanan

- celah ada pada password yang lemah 

## writeup & reference

- [Medium]() belom buat :D
- [John Hammond youtube](https://www.youtube.com/watch?v=WPnFnPkOWIg&t=10s)
------------------

*note : mungkin lab ini tidak sama seperti di real life karena lab ini untuk pemula dengan tingkat kesulitan rendah*

### **Selamat belajar!**