local Ragdoll = false
ragdol = true

RegisterCommand('ragdoll', function()
    TriggerEvent("Ragdoll", source)
end, false)
TriggerEvent( "chat:addSuggestion", "/ragdoll", "Enable and disable ragdoll")


RegisterNetEvent("Ragdoll")
AddEventHandler("Ragdoll", function()
    if (ragdol) then
        setRagdoll(true)
        ragdol = false
    else
        setRagdoll(false)
        ragdol = true
    end
end)

function setRagdoll(rag)
	Ragdoll = rag
	if Ragdoll then
		Citizen.CreateThread(function()
			while Ragdoll do 
				Citizen.Wait(0)

				vehCheck() -- Stops player from ragdolling while in any vehicle. Comment out if you'd like them to have the ability to ragdoll inside a vehicle. (Doesn't really do anything in a vehicle anyways)

				if Ragdoll then
					SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
					if ragdol then
						Ragdoll = false
					end
				end
			end
		end)
	end
end

function vehCheck()
    if Ragdoll then
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            Ragdoll = false
            exports["esx_notify"]:Notify("error", 3000, "You cant ragdoll in a vehicle")
        end
    end
end

function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(true, true)
end
