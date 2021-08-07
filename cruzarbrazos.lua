--##############################
--#                            #
--# CONFIG. BY -AGUS. AP LEAKS #
--#                            #
--##############################
--# Agacharse
--# Dudas al privado: -Agus#8423
--# Mi servidor de Discord -> https://discord.gg/JXCdVPcDG4

Citizen.CreateThread(function()
    local dict = "amb@world_human_hang_out_street@female_arms_crossed@base"
    
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(100)
	end
    local opa = false
	while true do
		Citizen.Wait(0)
		if IsControlJustPressed(1, 20) then
            if not opa then
                TaskPlayAnim(GetPlayerPed(-1), dict, "base", 8.0, 8.0, -1, 50, 0, false, false, false)
                opa = true
            else
                opa = false
                ClearPedTasks(GetPlayerPed(-1))
            end
        end
    end
end)