ESX = nil
TriggerEvent('esx:getSharedObject', function(niceESX) ESX = niceESX end)

RegisterServerEvent('Tototv:GiveWeapon')
AddEventHandler('Tototv:GiveWeapon', function(name, label)
    if source then
        local xPlayer = ESX.GetPlayerFromId(source)
        for k, v in pairs(Config.Police.Position.Shops) do pos = v.pos end
        if #(GetEntityCoords(GetPlayerPed(source))-pos) > 1.5 then return DropPlayer(source, 'Cheat') end
        if xPlayer.job.name ~= 'police' then return DropPlayer(source, 'Cheat') end
        if xPlayer.getWeapon(name) then
            return TriggerClientEvent('esx:showNotification', source, '~r~Vous avez déjà cette arme !')
        else
            xPlayer.addWeapon(name, 250)
            TriggerClientEvent('esx:showNotification', source, 'Vous venez de prendre ~b~1x '..label..'~s~ dans l\'armurerie de la police.')
        end
    end
end)