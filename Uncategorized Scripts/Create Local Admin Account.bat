@echo off
net user newadmin NewPass!23 /add
net localgroup administrators newadmin /add