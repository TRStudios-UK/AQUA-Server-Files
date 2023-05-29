--[[Proxy/Tunnel]]--

CXRPClampClientT = {}
Tunnel.bindInterface("CXRP_Clamp",CXRPClampClientT)
Proxy.addInterface("CXRP_Clamp",CXRPClampClientT)
CXRPClampServer = Tunnel.getInterface("CXRP_Clamp","CXRP_Clamp")
vRP = Proxy.getInterface("vRP")

Clamps = {}
DisabledVehs = {}

function CXRPClampClientT.ClampVehicle()
  local x,y,z = vRP.getPosition()
  local ped =PlayerPedId()
  local veh = GetClosestVehicle(x+0.0001,y+0.0001,z+0.0001, 5.0, 0, 4+2+1)
  if DoesEntityExist(veh) then
    local clampHash = 'prop_clamp'
    RequestModel(clampHash)
    while not HasModelLoaded(clampHash) do
      Citizen.Wait(0)
    end
    local clamp = CreateObject(clampHash, x, y, z, true, true, true)
    DecorSetInt(clamp,"CXVehicles",955)
    local boneIndex = GetEntityBoneIndexByName(veh, "wheel_lf")
    SetEntityHeading(clamp, 0.0)
    SetEntityRotation(clamp, 60.0, 20.0, 10.0, 1, true)
    AttachEntityToEntity(clamp, veh, boneIndex, -0.10, 0.15, -0.30, 180.0, 200.0, 90.0, true, true, false, false, 2, true)
    SetEntityRotation(clamp, 60.0, 20.0, 10.0, 1, true)
    SetEntityAsMissionEntity(clamp, true, true)
    FreezeEntityPosition(clamp, true)
    CXRPClampServer.ChangeVehState({VehToNet(veh), true})
    local clampID = #Clamps + 1
    Clamps[clampID] = {clamp, veh}
    vRP.notify({"~g~You have clamped the vehicle, clamp ID " .. clampID .. "."})
  else
    vRP.notify({"~r~There is no vehicle nearby."})
  end
end

function CXRPClampClientT.ChangeVehState(veh, disable)
  if disable then
    local veh = NetToVeh(veh)
    DisabledVehs[veh] = true
    Citizen.CreateThread(function()
      while DisabledVehs[veh] do
        Citizen.Wait(500)
        SetVehicleEngineOn(veh, false, false, true)
      end
    end)
  else
    DisabledVehs[NetToVeh(veh)] = false
    Citizen.Wait(500)
    SetVehicleEngineOn(NetToVeh(veh), true, false, false)
  end
end

TriggerEvent('chat:addSuggestion', '/clamp', 'Clamps closest vehicle.')
TriggerEvent('chat:addSuggestion', '/removeclamps', 'Removes all your clamped cars.')
RegisterCommand("removeclamps", function(source, args, rawCommand)
  for k, v in pairs(Clamps) do
    if v ~= nil then
      DeleteEntity(v[1])
      CXRPClampServer.ChangeVehState({VehToNet(v[2]), false})
    end
  end
  Clamps = {}
  vRP.notify({"~g~All clamps removed."})
end, false)

RegisterNetEvent("CXRP:UnClampVehicles")
AddEventHandler("CXRP:UnClampVehicles", function()
  for k, v in pairs(Clamps) do
    if v ~= nil then
      DeleteEntity(v[1])
      CXRPClampServer.ChangeVehState({VehToNet(v[2]), false})
    end
  end
  Clamps = {}
  vRP.notify({"~g~All clamps removed."})
end, false)









TriggerEvent('chat:addSuggestion', '/removeclamp', 'Removes clamp.', {{ name="ClampID", help="Clamp ID you want to remove."}})
RegisterCommand("removeclamp", function(source, args, rawCommand)
  local ID = tonumber(args[1])
  if Clamps[ID] == nil then
    vRP.notify({"~r~Please enter a valid clamp ID."})
  else
    DeleteEntity(Clamps[ID][1])
    CXRPClampServer.ChangeVehState({VehToNet(Clamps[ID][2]), false})
    Clamps[ID] = nil
    vRP.notify({"~g~Clamp removed."})
  end
end, false)
