local Euphoria = {}

function Euphoria.SetBoneProperties(ped, bone, strength, damping, inertia, elasticity, dampingFree)
    SetPedRagdollOnCollision(ped, true)
    SetPedRagdollForceFall(ped)

    SetRagdollDamping(ped, damping)
    SetRagdollForce(ped, 1.0)
    SetRagdollInertia(ped, inertia)
    SetRagdollElasticity(ped, elasticity)
    SetRagdollDampingFree(ped, dampingFree)
end

RegisterNetEvent("realistic_ragdoll:applyRagdollToPed")
AddEventHandler("realistic_ragdoll:applyRagdollToPed", function(pedNetID)
    local ped = NetToPed(pedNetID)
    if IsPedRagdoll(ped) then
        Euphoria.SetBoneProperties(ped, "SKEL_Head", 6.5, 0.35, 6.5, 0.6, 0.6)
        Euphoria.SetBoneProperties(ped, "SKEL_Spine0", 6.5, 0.35, 6.5, 0.6, 0.6)
        Euphoria.SetBoneProperties(ped, "SKEL_Spine1", 6.5, 0.35, 6.5, 0.6, 0.6)
        Euphoria.SetBoneProperties(ped, "SKEL_Spine2", 6.5, 0.35, 6.5, 0.6, 0.6)
        Euphoria.SetBoneProperties(ped, "SKEL_Spine3", 6.5, 0.35, 6.5, 0.6, 0.6)
    end
end)

function EnumeratePeds()
    return coroutine.wrap(function()
        local handle, ped = FindFirstPed()
        local success

        repeat
            coroutine.yield(ped)
            success, ped = FindNextPed(handle)
        until not success

        EndFindPed(handle)
    end)
end

function IsPedHitByVehicle(ped)
    local veh = GetVehiclePedIsIn(ped, true)
    return (veh ~= 0) and (veh ~= nil)
end

function MakePedGrabVehicle(ped, vehicle)
    local animDict = "nm@on_foot@action@vehicle@context@dispatch@180@2h@base"
    local animName = "grab_on_vehicle"

    RequestAnimDict(animDict)

    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(100) -- Too many players getting 'Reliable network overflow'? Increase the wait time to fix this.
    end

    TaskPlayAnim(ped, animDict, animName, 4.0, -4.0, -1, 33, 0, false, false, false)
end

local grabStartTime = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100) -- Too many players getting 'Reliable network overflow'? Increase the wait time to fix this.
        local playerPed = GetPlayerPed(-1)
        local pedTable = {}

        for ped in EnumeratePeds() do
            if not IsPedAPlayer(ped) then
                table.insert(pedTable, ped)
            end
        end

        for _, ped in ipairs(pedTable) do
            if IsPedR
            Citizen.CreateThread(function()
                while true do
                Citizen.Wait(100) -- Too many players getting 'Reliable network overflow'? Increase the wait time to fix this.
                local playerPed = GetPlayerPed(-1)
                local pedTable = {}
                for ped in EnumeratePeds() do
                    if not IsPedAPlayer(ped) then
                        table.insert(pedTable, ped)
                    end
                end
            
                for _, ped in ipairs(pedTable) do
                    if IsPedRagdoll(ped) then
                        local netID = PedToNet(ped)
                        TriggerServerEvent("realistic_ragdoll:applyRagdoll", netID)
                    elseif IsPedHitByVehicle(ped) then
                        local vehicle = GetVehiclePedIsIn(ped, true)
                        if not IsEntityPlayingAnim(ped, animDict, animName, 3) then
                            MakePedGrabVehicle(ped, vehicle)
                            grabStartTime = GetGameTimer()
                        end
                    end
                end
            
                for i = 0, 255 do
                    if NetworkIsPlayerActive(i) then
                        local player = GetPlayerPed(i)
                        if IsPedRagdoll(player) then
                            local netID = PedToNet(player)
                            TriggerServerEvent("realistic_ragdoll:applyRagdoll", netID)
                        elseif IsPedHitByVehicle(player) then
                            local vehicle = GetVehiclePedIsIn(player, true)
                            if not IsEntityPlayingAnim(player, animDict, animName, 3) then
                                MakePedGrabVehicle(player, vehicle)
                                grabStartTime = GetGameTimer()
                            end
                        end
                    end
                end
            
                if grabStartTime ~= nil then
                    local elapsedTime = GetGameTimer() - grabStartTime
                    local ped = GetPlayerPed(-1)
                    local vehicle = GetVehiclePedIsIn(ped, false)
            
                    if vehicle ~= 0 and vehicle ~= nil then
                        local speed = GetEntitySpeed(vehicle) * 3.6
            
                        if elapsedTime > 5000 or speed < 2.0 then
                            ClearPedTasks(ped)
                            grabStartTime = nil
                        end
                    end
                end
            end
        end)
