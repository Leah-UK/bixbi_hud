ESX = nil
TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)

AddEventHandler('onResourceStart', function(resourceName)
	Citizen.CreateThread(function()
        while true do
            Citizen.Wait(10000)
            for _, playerId in ipairs(GetPlayers()) do
                local radioChannel = Player(playerId).state.radioChannel
                if (radioChannel ~= 0) then
                    local players = {}
                    for source, _ in pairs(exports['pma-voice']:getPlayersInRadioChannel(radioChannel)) do
                        local xPlayer = ESX.GetPlayerFromId(source)
                        if (xPlayer ~= nil) then
                            table.insert(players, '[' .. source .. '] ' .. xPlayer.name)
                        end
                    end
                    TriggerClientEvent('bixbi_hud:UpdateRadioUsers', playerId, players)
                end
            end
        end
    end)
end)

