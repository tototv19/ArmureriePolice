ESX = nil 

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(niceESX) ESX = niceESX end)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     ESX.PlayerData = xPlayer
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
     ESX.PlayerData.job = job
end)

-- RageUI

local openedMenu = false 
local mainMenu = RageUI.CreateMenu('Armurerie', 'Police')
local subMenu = RageUI.CreateSubMenu(mainMenu, "Armurerie", "Armes LÉtales")
local subMenu2 = RageUI.CreateSubMenu(mainMenu, "Armurerie", "Armes Non LÉtales")
mainMenu.Closed = function() openedMenu = false FreezeEntityPosition(PlayerPedId(), false) end
mainMenu:SetRectangleBanner(164, 16, 16, 255)
subMenu:SetRectangleBanner(164, 16, 16, 255)
subMenu2:SetRectangleBanner(164, 16, 16, 255)

function openMenu()
    if openedMenu then
        openedMenu = false
        return 
    else
        openedMenu = true
        FreezeEntityPosition(PlayerPedId(), true)
        RageUI.Visible(mainMenu, true)
        Citizen.CreateThread(function()
            while openedMenu do
                Wait(1.0)
                RageUI.IsVisible(mainMenu, function()
                    RageUI.Button("Armes Létales", nil, {RightLabel = "→→"}, true, {}, subMenu)
                    RageUI.Button("Armes non Létales", nil, {RightLabel = "→→"}, true, {}, subMenu2)
                end)
                RageUI.IsVisible(subMenu, function()
                    if #Config.Police.Armurerie.Weapons[1] ~= 0 then
                        RageUI.Separator('↓ Liste des armes létales ↓')
                        for k, v in pairs(Config.Police.Armurerie.Weapons[1]) do 
                            RageUI.Button(v.label, nil, {RightLabel = "~r~Prendre~s~ →→"}, true, {
                                onSelected = function()
                                    TriggerServerEvent('Tototv:GiveWeapon', v.name, v.label)
                                end,
                            })
                        end
                    else
                        RageUI.Separator('')
                        RageUI.Separator('~r~Il n\'y a pas d\'armes létales')
                        RageUI.Separator('') 
                    end
                end)
                RageUI.IsVisible(subMenu2, function()
                    if #Config.Police.Armurerie.Weapons[2] ~= 0 then
                        RageUI.Separator('↓ Liste des armes non létales ↓')
                        for k, v in pairs(Config.Police.Armurerie.Weapons[2]) do 
                            RageUI.Button(v.label, nil, {RightLabel = "~r~Prendre~s~ →→"}, true, {
                                onSelected = function()
                                    TriggerServerEvent('Tototv:GiveWeapon', v.name, v.label)
                                end,
                            })
                        end
                    else
                        RageUI.Separator('')
                        RageUI.Separator('~r~Il n\'y a pas d\'armes non létales')
                        RageUI.Separator('') 
                    end
                end)
            end
        end)
    end
end

Citizen.CreateThread(function()
    for k, v in pairs(Config.Police.Position.Shops) do 
        while not HasModelLoaded(v.pedModel) do
            RequestModel(v.pedModel)
            Wait(1)
        end
        Ped = CreatePed(2, GetHashKey(v.pedModel), v.pedPos, v.heading, 0, 0)
        FreezeEntityPosition(Ped, 1)
        TaskStartScenarioInPlace(Ped, v.pedModel, 0, false)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, 1)
    end
    while true do 
        local myCoords = GetEntityCoords(PlayerPedId())
        local nofps = false

        if not openedMenu then
            if ESX.PlayerData.job.name == 'police' then 
                for k, v in pairs(Config.Police.Position.Shops) do 
                    if #(myCoords - v.pos) < 1.0 then 
                        nofps = true
                        Visual.Subtitle("Appuyer sur ~b~[E]~s~ pour parler à L'~b~armurerier", 1) 
                        if IsControlJustPressed(0, 38) then                  
                            openMenu()
                        end 
                    end 
                end 
            end
        end
        if nofps then 
            Wait(1)
        else 
            Wait(1500)
        end 
    end
end) 

