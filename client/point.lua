    RegisterKeyMapping("point", "Point", "keyboard", "B")

    function Pointing(state)
        local ped = PlayerPedId()
        if state then
            RequestAnimDict("anim@mp_point")
            while not HasAnimDictLoaded("anim@mp_point") do Wait(0) end
            TaskMoveNetworkByName(ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
            RemoveAnimDict("anim@mp_point")
        else
            RequestTaskMoveNetworkStateTransition(ped, "Stop")
            ClearPedSecondaryTask(ped)
        end
        if not IsPedInAnyVehicle(ped, 1) then
            SetPedCurrentWeaponVisible(ped, not state, 1, 1, 1)
        end
        SetPedConfigFlag(ped, 36, state)
    end
    
    RegisterCommand("point", function(source, args, rawCommand)
        local ped = PlayerPedId()
        if IsPedOnFoot(ped) then
            mp_pointing = not mp_pointing
            Pointing(true)
            while mp_pointing do Wait(0)
                if IsTaskMoveNetworkActive(ped) then
                    local camPitch = GetGameplayCamRelativePitch()
                    if camPitch < -70.0 then
                        camPitch = -70.0
                    elseif camPitch > 42.0 then
                        camPitch = 42.0
                    end
    
                    camPitch = (camPitch + 70.0) / 112.0
    
                    local camHeading = GetGameplayCamRelativeHeading()
                    local cosCamHeading = Cos(camHeading)
                    local sinCamHeading = Sin(camHeading)
                            
                    if camHeading < -180.0 then
                        camHeading = -180.0
                    elseif camHeading > 180.0 then
                        camHeading = 180.0
                    end			
                    
                    camHeading = (camHeading + 180.0) / 360.0
                    
                    local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                    local ray = StartShapeTestCapsule(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7)
                    local blocked = GetShapeTestResult(ray)
                    
                    SetTaskMoveNetworkSignalFloat(ped, "Pitch", camPitch)
                    SetTaskMoveNetworkSignalFloat(ped, "Heading", camHeading * -1.0 + 1.0)
                    SetTaskMoveNetworkSignalBool(ped, "isBlocked", blocked)
                    SetTaskMoveNetworkSignalBool(ped, "isFirstPerson", GetCamViewModeForContext(GetCamActiveViewModeContext()) == 4)
                end
                
                if IsControlJustReleased(0,29) then
                    Pointing(false)
                    mp_pointing = false
                end
            end
        end
    end)
