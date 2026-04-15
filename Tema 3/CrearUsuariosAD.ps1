# Crear Unidades Organizativas
New-ADOrganizationalUnit -Name "Contabilidad" -Path "DC=DOMINIO12,DC=com"
New-ADOrganizationalUnit -Name "Mantenimiento" -Path "DC=DOMINIO12,DC=com"
New-ADOrganizationalUnit -Name "Almacen" -Path "DC=DOMINIO12,DC=com"
New-ADOrganizationalUnit -Name "Direccion" -Path "DC=DOMINIO12,DC=com"

# Crear Grupos en cada OU
New-ADGroup -Name "contabilidad" -GroupScope "DomainLocal" -GroupCategory "Security" -Path "OU=Contabilidad,DC=DOMINIO12,DC=com"
New-ADGroup -Name "mantenimiento" -GroupScope "DomainLocal" -GroupCategory "Security" -Path "OU=Mantenimiento,DC=DOMINIO12,DC=com"
New-ADGroup -Name "almacen" -GroupScope "DomainLocal" -GroupCategory "Security" -Path "OU=Almacen,DC=DOMINIO12,DC=com"
New-ADGroup -Name "direccion" -GroupScope "Global" -GroupCategory "Security" -Path "OU=Direccion,DC=DOMINIO12,DC=com"

# Crear Equipos
# Equipos de Contabilidad
For ($i=1; $i -le 15; $i++) {
    $equipName = "equipoconta" + "{0:D2}" -f $i
    New-ADComputer -Name $equipName -Path "OU=Contabilidad,DC=DOMINIO12,DC=com"
}

# Equipos de Almacen
For ($i=1; $i -le 15; $i++) {
    $equipName = "equipoalma" + "{0:D2}" -f $i
    New-ADComputer -Name $equipName -Path "OU=Almacen,DC=DOMINIO12,DC=com"
}

# Equipos de Mantenimiento
For ($i=1; $i -le 15; $i++) {
    $equipName = "equipomante" + "{0:D2}" -f $i
    New-ADComputer -Name $equipName -Path "OU=Mantenimiento,DC=DOMINIO12,DC=com"
}

# Equipos de Dirección
For ($i=1; $i -le 2; $i++) {
    $equipName = "equipodirec" + "{0:D2}" -f $i
    New-ADComputer -Name $equipName -Path "OU=Direccion,DC=DOMINIO12,DC=com"
}

# Crear Usuarios y Asignar Grupos
# Usuarios de Contabilidad
For ($i=1; $i -le 30; $i++) {
    $userName = "userconta" + "{0:D2}" -f $i
    $ouPath = "OU=Contabilidad,DC=DOMINIO12,DC=com"
    
    # Contraseña será igual al nombre de usuario
    $password = (ConvertTo-SecureString $userName -AsPlainText -Force)

    New-ADUser -Name $userName -SamAccountName $userName -AccountPassword $password -Path $ouPath -Enabled $true -ChangePasswordAtLogon $true

    # Agregar al grupo contabilidad
    Add-ADGroupMember -Identity "contabilidad" -Members $userName
}

# Usuarios de Almacen
For ($i=1; $i -le 45; $i++) {
    $userName = "useralma" + "{0:D2}" -f $i
    $ouPath = "OU=Almacen,DC=DOMINIO12,DC=com"

    # Contraseña será igual al nombre de usuario
    $password = (ConvertTo-SecureString $userName -AsPlainText -Force)

    New-ADUser -Name $userName -SamAccountName $userName -AccountPassword $password -Path $ouPath -Enabled $true -ChangePasswordAtLogon $true

    # Agregar al grupo almacen
    Add-ADGroupMember -Identity "almacen" -Members $userName
}

# Usuarios de Mantenimiento
For ($i=1; $i -le 15; $i++) {
    $userName = "usermante" + "{0:D2}" -f $i
    $ouPath = "OU=Mantenimiento,DC=DOMINIO12,DC=com"

    # Contraseña será igual al nombre de usuario
    $password = (ConvertTo-SecureString $userName -AsPlainText -Force)

    New-ADUser -Name $userName -SamAccountName $userName -AccountPassword $password -Path $ouPath -Enabled $true -ChangePasswordAtLogon $true

    # Agregar al grupo mantenimiento
    Add-ADGroupMember -Identity "mantenimiento" -Members $userName
}

# Usuarios de Dirección
For ($i=1; $i -le 5; $i++) {
    $userName = "userdire" + "{0:D2}" -f $i
    $ouPath = "OU=Direccion,DC=DOMINIO12,DC=com"

    # Contraseña será igual al nombre de usuario
    $password = (ConvertTo-SecureString $userName -AsPlainText -Force)

    New-ADUser -Name $userName -SamAccountName $userName -AccountPassword $password -Path $ouPath -Enabled $true -ChangePasswordAtLogon $true

    # Agregar a los cuatro grupos (contabilidad, mantenimiento, almacen y direccion)
    Add-ADGroupMember -Identity "contabilidad" -Members $userName
    Add-ADGroupMember -Identity "mantenimiento" -Members $userName
    Add-ADGroupMember -Identity "almacen" -Members $userName
    Add-ADGroupMember -Identity "direccion" -Members $userName
}

# Configurar Restricciones de Inicio de Sesión
# Turnos: Mañana (8:00 - 15:00), Tarde (15:00 - 23:00), Noche (23:00 - 8:00)

# Restricción de inicio de sesión para Contabilidad - Mañana
For ($i=1; $i -le 15; $i++) {
    $userName = "userconta" + "{0:D2}" -f $i
    Set-ADUser -Identity $userName -LogonHours @{
        Sunday=0; Monday=255; Tuesday=255; Wednesday=255; Thursday=255; Friday=255; Saturday=0
    }
}

# Restricción de inicio de sesión para Contabilidad - Tarde
For ($i=16; $i -le 30; $i++) {
    $userName = "userconta" + "{0:D2}" -f $i
    Set-ADUser -Identity $userName -LogonHours @{
        Sunday=0; Monday=65280; Tuesday=65280; Wednesday=65280; Thursday=65280; Friday=65280; Saturday=0
    }
}

# Restricción de inicio de sesión para Almacen - Mañana
For ($i=1; $i -le 15; $i++) {
    $userName = "useralma" + "{0:D2}" -f $i
    Set-ADUser -Identity $userName -LogonHours @{
        Sunday=0; Monday=255; Tuesday=255; Wednesday=255; Thursday=255; Friday=255; Saturday=0
    }
}

# Restricción de inicio de sesión para Almacen - Tarde
For ($i=16; $i -le 30; $i++) {
    $userName = "useralma" + "{0:D2}" -f $i
    Set-ADUser -Identity $userName -LogonHours @{
        Sunday=0; Monday=65280; Tuesday=65280; Wednesday=65280; Thursday=65280; Friday=65280; Saturday=0
    }
}

# Restricción de inicio de sesión para Almacen - Noche
For ($i=31; $i -le 45; $i++) {
    $userName = "useralma" + "{0:D2}" -f $i
    Set-ADUser -Identity $userName -LogonHours @{
        Sunday=0; Monday=16711680; Tuesday=16711680; Wednesday=16711680; Thursday=16711680; Friday=16711680; Saturday=0
    }
}

# Mensaje de finalización
Write-Host "Usuarios creados satisfactoriamente" -ForegroundColor Green
