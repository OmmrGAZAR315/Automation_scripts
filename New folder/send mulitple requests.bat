@echo off
set TOKEN=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIyNSIsImp0aSI6IjI3MGQ3YmE5OWYxNjI3NDI2NmFjMTExZmFmZTA3Y2EyYjJhNjI3MmMwNzhjMmQ4ZjViMmRjNGRjZTUyNDljMTQxNjM5ZjI3NjRhMjg3OTgwIiwiaWF0IjoxNzQ1Njg5NjEwLjYwNDEzNCwibmJmIjoxNzQ1Njg5NjEwLjYwNDEzNywiZXhwIjoxNzc3MjI1NjEwLjU4MTk3NSwic3ViIjoiMSIsInNjb3BlcyI6W119.pytN_KydSrFMuZuVclC52Y5SCaRRrVHGKi_ZfQp36OkM05D4kwZc-bmnKrSxnEVuLi1x6sPI9HJLtEYB7lD-QTDdJzBWPhx5U9lz6_6LcPAxCAxGyvyFXIU5CT1gpOPd_LIONrad32ptA79ns9_F-nZX0tLg2PKi9spAh2gex9ewtbA89Z6gEG4RmHkLfnUUWCPgtd8IJ0U4RsRLHkg8PPui8Ypf1TKVWXgVJPfldKnrHfJbRc4lCijoHvSnd7Sh2wDKjaIlvzfdjLnSrmL_mx6KIl905J0ukZV3COjX4En2hfZWhS3PALk0KPIsNOvkADNhXQt6dcZXEq1bbaG0EObRQ7McBz5UbNtl8wDhPn_iMLp0klrIBvwaRoXYgf3n4i_81lZtnx53lS-qKiPyNtWQrsk_yxFze1YBxEQf2d5qgJOTpIWwcfyEznjjKI9_U6PbZqZKCrfspvgWlyiYtxGFVlbfXHtAUx46rpLFTiUxZAoF97mbR5x4YDzJwVSz69PwFZlEWGKtRsi4gGu0TrkAnkHBw7wxhCGQPFZFmVI1jzyVpNiPutgEquLQyFimioK8oEdvrni1zvcFdGxM3qSHRcFXfSBMIcesI7FubH17FEM5HKEGF2Xk8tG0rPWCT5S_9EP_ZkM-dDllT1OWlWvL_-OoMVUHwQSiC3bhoW8

echo Launching requests…

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/products?page=1&per_page=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > products1.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/offers?paginate=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > offers1.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/users" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > users1.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/carts" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > carts1.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/wishlists" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > wishlists1.json




start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/products?page=1&per_page=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > products2.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/offers?paginate=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > offers2.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/users" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > users2.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/carts" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > carts2.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/wishlists" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > wishlists2.json




start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/products?page=1&per_page=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > products3.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/offers?paginate=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > offers3.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/users" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > users3.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/carts" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > carts3.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/wishlists" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > wishlists3.json





start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/products?page=1&per_page=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > products4.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/offers?paginate=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > offers4.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/users" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > users4.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/carts" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > carts4.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/wishlists" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > wishlists4.json





start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/products?page=1&per_page=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > products5.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/offers?paginate=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > offers5.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/users" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > users5.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/carts" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > carts5.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/wishlists" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > wishlists5.json




start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/products?page=1&per_page=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > products6.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/offers?paginate=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > offers6.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/users" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > users6.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/carts" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > carts6.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/wishlists" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > wishlists6.json




start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/products?page=1&per_page=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > products7.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/offers?paginate=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > offers7.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/users" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > users7.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/carts" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > carts7.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/wishlists" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > wishlists7.json



start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/products?page=1&per_page=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > products8.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/offers?paginate=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > offers8.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/users" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > users8.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/carts" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > carts8.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/wishlists" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > wishlists8.json




start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/products?page=1&per_page=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > products9.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/offers?paginate=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > offers9.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/users" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > users9.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/carts" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > carts9.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/wishlists" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > wishlists9.json




start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/products?page=1&per_page=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > products10.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/offers?paginate=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > offers10.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/users" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > users10.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/carts" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > carts10.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/wishlists" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > wishlists10.json




start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/products?page=1&per_page=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > products11.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/offers?paginate=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > offers11.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/users" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > users11.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/carts" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > carts11.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/wishlists" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > wishlists11.json




start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/products?page=1&per_page=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > products12.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/offers?paginate=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > offers12.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/users" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > users12.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/carts" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > carts12.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/wishlists" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > wishlists12.json




start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/products?page=1&per_page=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > products13.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/offers?paginate=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > offers13.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/users" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > users13.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/carts" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > carts13.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/wishlists" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > wishlists13.json



start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/products?page=1&per_page=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > products14.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/offers?paginate=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > offers14.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/users" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > users14.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/carts" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > carts14.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/wishlists" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > wishlists14.json



start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/products?page=1&per_page=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > products15.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/offers?paginate=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > offers15.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/users" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > users15.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/carts" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > carts15.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/wishlists" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > wishlists15.json




start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/offers?paginate=100" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > offers16.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/users" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > users16.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/carts" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > carts16.json

start "" /B curl -s -X GET "https://furnisique.servehttp.com/api/wishlists" ^
    -H "Accept: application/json" ^
    -H "Authorization: Bearer %TOKEN%" > wishlists16.json


echo Waiting for all to complete…
timeout /T 5 >nul

echo All requests complete.
