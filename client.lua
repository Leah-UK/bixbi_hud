local playerPed = PlayerPedId()
local inVehicle = false
local playersInChannel = {}
function LoopFunc()
  -- Map Graphics: https://forum.cfx.re/t/release-server-sided-dlk-pause-maps-working-minimap-radar/2269552
  SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0) -- Level 0
  SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0) -- Level 1
  SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0) -- Level 2
  SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0) -- Level 3
  SetMapZoomDataLevel(4, 24.3, 0.9, 0.08, 0.0, 0.0) -- Level 4
  SetMapZoomDataLevel(5, 55.0, 0.0, 0.1, 2.0, 1.0) -- ZOOM_LEVEL_GOLF_COURSE
  SetMapZoomDataLevel(6, 450.0, 0.0, 0.1, 1.0, 1.0) -- ZOOM_LEVEL_INTERIOR
  SetMapZoomDataLevel(7, 4.5, 0.0, 0.0, 0.0, 0.0) -- ZOOM_LEVEL_GALLERY
  SetMapZoomDataLevel(8, 11.0, 0.0, 0.0, 2.0, 3.0) -- ZOOM_LEVEL_GALLERY_MAXIMIZE
  
  -- local x = -0.035
  -- local y = -0.0025 
  -- local w = 0.28
  -- local h = 0.28

  local minimap = RequestScaleformMovie("minimap")
  local mapPosition = getMapPosition()
  local leftX, Y, width, height = -mapPosition.leftX, -(mapPosition.Y / 30), mapPosition.width, mapPosition.height
  -- SetMinimapComponentPosition('minimap', 'L', 'B', x + 0.02, y - 0.02, w - 0.115, h - 0.04)
  -- SetMinimapComponentPosition('minimap_mask', 'L', 'B', x, y, w, h)
  -- SetMinimapComponentPosition('minimap_blur', 'L', 'B', x, y, w, h)
  if (exports['bixbi_core']:isWidescreenAspectRatio()) then
    SetMinimapComponentPosition('minimap', 'L', 'B', leftX + 0.127, -(mapPosition.Y / 30) + 0.01, mapPosition.width + 0.03, mapPosition.height)
    SetMinimapComponentPosition('minimap_mask', 'L', 'B', leftX + 0.105, Y + 0.03, width + 0.135, height + 0.034)
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', leftX + 0.105, Y + 0.03, width + 0.136, height + 0.044)
  else
    SetMinimapComponentPosition('minimap', 'L', 'B', -mapPosition.leftX + 0.0065, -(mapPosition.Y / 30) + 0.01, mapPosition.width, mapPosition.height)
    SetMinimapComponentPosition('minimap_mask', 'L', 'B', leftX - 0.0155, Y + 0.03, width + 0.105, height + 0.03)
    SetMinimapComponentPosition('minimap_blur', 'L', 'B', leftX - 0.0155, Y + 0.03, width + 0.106, height + 0.04)
  end
  
  Citizen.Wait(1000)
  SetRadarBigmapEnabled(true, false)
  Citizen.Wait(0)
  SetRadarBigmapEnabled(false, false)
  
  local hunger, thirst = 0, 0
  SendNUIMessage({action = "show_ui", type = "ui", enable = true})
  SendNUIMessage({action = "show_ui", type = "voice", enable = Config.EnableVoiceBox})
  SendNUIMessage({action = "vehicle_hud"})

  Citizen.CreateThread(function()
    while (ESX.PlayerLoaded) do
      Citizen.Wait(1500)
      playerPed = PlayerPedId()
      BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
      ScaleformMovieMethodAddParamInt(3)
      EndScaleformMovieMethod()
      
      if (IsPedOnFoot(playerPed)) then 
        SetRadarZoom(1200)
        if (not Config.ShowMapOnFoot) then DisplayRadar(false) end
      else
        SetRadarZoom(1100)
        DisplayRadar(true)
      end

      TriggerEvent('esx_status:getStatus', 'hunger', function(status) hunger = status.val / 10000 end)
      TriggerEvent('esx_status:getStatus', 'thirst', function(status) thirst = status.val / 10000 end)
    
      -- local inVehicleCheck = IsPedInAnyVehicle(playerPed, false)
      -- if (inVehicleCheck ~= inVehicle) then
      --   SendNUIMessage({action = "vehicle_hud"})
      --   inVehicle = inVehicleCheck
      --   if (not inVehicle) then
      --     ClearInterval("vehiclehud")
      --   else
      --     VehicleHud()
      --   end
      -- end
      if (#playersInChannel > 0 and LocalPlayer.state.radioChannel == 0) then
        playersInChannel = {}
        SendNUIMessage({action = "update_radio", players = playersInChannel})
      end
    end
  end)

  local maxHealthIssue = false
  if (GetEntityMaxHealth(playerPed) ~= 200) then maxHealthIssue = true end

  Citizen.CreateThread(function()
    local playerID = PlayerId()
    while ESX.PlayerLoaded do      
      Citizen.Wait(500)

      local hpValue = GetEntityHealth(playerPed) - 100
      if (maxHealthIssue and hpValue == 75) then hpValue = 100 end
      local oxygenValue = 100
      if (Config.EnableOxygen) then oxygenValue = ((GetPlayerUnderwaterTimeRemaining(playerID) * 10) or 100) end

      SendNUIMessage({
          action = "update_hud",
          hp = hpValue,
          armour = GetPedArmour(playerPed),
          hunger = hunger or 0,
          thirst = thirst or 0,
          stamina = (100 - GetPlayerSprintStaminaRemaining(playerID)) or 100,
          oxygen = oxygenValue,
          talking = NetworkIsPlayerTalking(playerID)
      })
    end
  end)

  Citizen.CreateThread(function()
    while (ESX.PlayerLoaded) do
      if (exports['bixbi_core']:isWidescreenAspectRatio()) then
        -- local mapPosition = getMapPosition(true)
        local mapPosition = getMapPosition().leftX * 96
        SendNUIMessage({
          action = "hud_pos",
          pos = tostring(mapPosition + 0.25) .. '%'
        })
      end
      Citizen.Wait(120 * 1000)
    end
  end)

  if (Config.UseBixbiCore) then
    Citizen.CreateThread(function()
      while ESX.PlayerLoaded do      
        if (hunger < 25 and hunger ~= 0) then exports['bixbi_core']:Notify('error', 'You\'re quite hungry') end
        Citizen.Wait(60000)    
      end
    end)
  end
end

-- function VehicleHud()
--   SetInterval("vehiclehud", 500, function()
--     local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
--     local speed = math.floor(GetEntitySpeed(vehicle) * 2.236936)
--     -- local speedPercent = math.floor(speed / 2)
--     if (speed < 1) then speed = "" end
--     SendNUIMessage({
--       action = "update_vehiclehud",
--       speed = speed
--     })
--   end)
-- end

function VoiceLevel(val)
  if (val == 1) then val = 33 elseif (val == 2) then val = 66 else val = 100 end
  SendNUIMessage({action = "voice_level", voicelevel = val})
end
exports('VoiceLevel', VoiceLevel)

RegisterCommand("hud", function()  SendNUIMessage({action = "toggle_hud"}) end, false)

function getMapPosition()
  -- source: https://github.com/Dalrae1/MinimapPositionFiveM/blob/main/client.lua
	local minimap = {}
	local resX, resY = GetActiveScreenResolution()
	local aspectRatio = GetAspectRatio()
	local scaleX = 1/resX
	local scaleY = 1/resY
	local minimapRawX, minimapRawY
	SetScriptGfxAlign(string.byte('L'), string.byte('B'))
	if IsBigmapActive() then
		minimapRawX, minimapRawY = GetScriptGfxPosition(-0.003975, 0.022 + (-0.460416666))
		minimap.width = scaleX*(resX/(2.52*aspectRatio))
		minimap.height = scaleY*(resY/(2.3374))
	else
		minimapRawX, minimapRawY = GetScriptGfxPosition(-0.0045, 0.002 + (-0.188888))
		minimap.width = scaleX*(resX/(4*aspectRatio))
		minimap.height = scaleY*(resY/(5.674))
	end
	ResetScriptGfxAlign()
	minimap.leftX = minimapRawX
	minimap.rightX = minimapRawX+minimap.width
	minimap.topY = minimapRawY
	minimap.bottomY = minimapRawY+minimap.height
	minimap.X = minimapRawX+(minimap.width/2)
	minimap.Y = minimapRawY+(minimap.height/2)

	return minimap
end

RegisterNetEvent('bixbi_hud:UpdateRadioUsers')
AddEventHandler('bixbi_hud:UpdateRadioUsers', function(Players)
  -- playersInChannel = Players
  playersInChannel = {'<p><i>Radio [' .. LocalPlayer.state.radioChannel .. ']</i></p>'}
  -- SendNUIMessage({action = "update_radio", players = Players[1]})
  for _, playerName in pairs(Players) do
    table.insert(playersInChannel, '<p>' .. playerName .. '</p>')
  end
  SendNUIMessage({action = "update_radio", players = playersInChannel})
end)
--[[--------------------------------------------------
Setup
--]]--------------------------------------------------
AddEventHandler('onResourceStart', function(resourceName)
	if (resourceName == GetCurrentResourceName() and Config.Debug) then
    while (ESX == nil) do Citizen.Wait(100) end
    ESX.PlayerLoaded = true
    LoopFunc()
    SendNUIMessage({action = "toggle_hud", enable = true})
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  while (ESX == nil) do Citizen.Wait(100) end
  ESX.PlayerData = xPlayer
 	ESX.PlayerLoaded = true
  LoopFunc()
  SendNUIMessage({action = "toggle_hud", enable = true})
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
  -- SendNUIMessage({action = "show_ui", type = "ui", enable = false})
	ESX.PlayerLoaded = false
	ESX.PlayerData = {}
  SendNUIMessage({action = "toggle_hud", enable = false})
end)