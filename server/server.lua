RegisterNetEvent("realistic_ragdoll:applyRagdoll")
AddEventHandler("realistic_ragdoll:applyRagdoll", function(pedNetID)
    TriggerClientEvent("realistic_ragdoll:applyRagdollToPed", -1, pedNetID)
end)
-- This does server checks to help prevent ragdoll's from glitching when players are nearby.