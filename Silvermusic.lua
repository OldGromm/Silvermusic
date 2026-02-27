Silvermusic_CurrentTrack = 0
Silvermusic_Timeout = false
SilvermusicDB_Options = SilvermusicDB_Options or {}

Silvermusic_Table_MidnightRegular = {331823, 331824}
Silvermusic_Table_MidnightHorde = {335684, 335683}
Silvermusic_Table_TheBurningCrusade = {9793, 9794}




function Silvermusic_PlayNewMusicSet(input_soundkitID)
    _, Silvermusic_CurrentTrack = PlaySound(input_soundkitID, "Talking Head", true, true)
end




function Silvermusic_StopCurrentMusic()
    StopSound(Silvermusic_CurrentTrack, 2000)
end




function Silvermusic_CheckCurrentLocation()
    local Silvermusic_CurrentArea = C_Map.GetBestMapForUnit("player")
	local Silvermusic_Proceed = false
    if Silvermusic_CurrentArea == 2393 then
	    Silvermusic_Proceed = true
	end
	return Silvermusic_Proceed
end




function Silvermusic_Timeout()
    Silvermusic_Timeout = true
end




function Silvermusic_ChangeMusic(input_playerchoice)
    -- check whether to play any music at all
	if Silvermusic_CheckCurrentLocation() == true then


        -- disable music in the options menu (unless the add-on setting is using "Default)
        local Silvermusic_SoundKitID = 0
        if input_playerchoice == 1 then
    	    if Silvermusic_CurrentTrack == nil then
    	    else
    	        StopSound(Silvermusic_CurrentTrack, 2000)
			    C_Timer.After(2.1, function() SetCVar("Sound_EnableMusic", 1) end)
    	    end
        else
            SetCVar("Sound_EnableMusic", 0)


            -- determine time of day		
    		local Silvermusic_DailyReset = C_DateAndTime.GetSecondsUntilDailyReset()
    		local Silvermusic_TimeOfDay = ""
    		if Silvermusic_DailyReset > 82800 then
    		    Silvermusic_TimeOfDay = "Night"
    		elseif Silvermusic_DailyReset > 39600 then
    		    Silvermusic_TimeOfDay = "Day"
    		else
                Silvermusic_TimeOfDay = "Night"
    		end

            -- select the SoundKitID
    		if SilvermusicDB_Options["TimeOfDay"] == true then
    		    if Silvermusic_TimeOfDay == "Day" then
    				if input_playerchoice == 2 then
                        Silvermusic_SoundKitID = Silvermusic_Table_MidnightRegular[1]
                    elseif input_playerchoice == 3 then
                        Silvermusic_SoundKitID = Silvermusic_Table_MidnightHorde[1]
                    elseif input_playerchoice == 4 then
                        Silvermusic_SoundKitID = Silvermusic_Table_TheBurningCrusade[1]
                    else
                    end
    			elseif Silvermusic_TimeOfDay == "Night" then
    				if input_playerchoice == 2 then
                        Silvermusic_SoundKitID = Silvermusic_Table_MidnightRegular[2]
                    elseif input_playerchoice == 3 then
                        Silvermusic_SoundKitID = Silvermusic_Table_MidnightHorde[2]
                    elseif input_playerchoice == 4 then
                        Silvermusic_SoundKitID = Silvermusic_Table_TheBurningCrusade[2]
                    else
                    end
    			else
    			end
    		else
    		    local Silvermusic_RandomChoice = math.random(1, 2)
    		    if input_playerchoice == 2 then
                    Silvermusic_SoundKitID = Silvermusic_Table_MidnightRegular[Silvermusic_RandomChoice]
                elseif input_playerchoice == 3 then
                    Silvermusic_SoundKitID = Silvermusic_Table_MidnightHorde[Silvermusic_RandomChoice]
                elseif input_playerchoice == 4 then
                    Silvermusic_SoundKitID = Silvermusic_Table_TheBurningCrusade[Silvermusic_RandomChoice]
                else
                end
    		end


            -- play new music
            if Silvermusic_CurrentTrack == nil then
			    Silvermusic_Timeout = true
                Silvermusic_PlayNewMusicSet(Silvermusic_SoundKitID)
				C_Timer.After(4.5, function() Silvermusic_Timeout = false end)
    	    else
			    Silvermusic_Timeout = true
    	        Silvermusic_StopCurrentMusic()
                C_Timer.After(2.1, function() Silvermusic_PlayNewMusicSet(Silvermusic_SoundKitID) end)
				C_Timer.After(4.5, function() Silvermusic_Timeout = false end)
    	    end
        end
	
	else
	    
    	if Silvermusic_CurrentTrack == nil then
    	else
    	    StopSound(Silvermusic_CurrentTrack, 2000)
			C_Timer.After(2.1, function() SetCVar("Sound_EnableMusic", 1) end)
    	end
	end
end




Silvermusic_Event_SoundKitFinish = CreateFrame("Frame")
Silvermusic_Event_SoundKitFinish:RegisterEvent("SOUNDKIT_FINISHED")
Silvermusic_Event_SoundKitFinish:SetScript("OnEvent", function(_, event, soundHandle)
    if Silvermusic_Timeout == true then
	else
	    if SilvermusicDB_Options["Playerchoice"] == 1 then
	    else
	        if soundHandle == Silvermusic_CurrentTrack then
	            Silvermusic_ChangeMusic(SilvermusicDB_Options["Playerchoice"])
	        end
	    end
	end
end)