local category = Settings.RegisterVerticalLayoutCategory("Silvermusic")




local function OnSettingChanged(setting, value)
    Silvermusic_ChangeMusic(value)
end




local function OnSettingChanged_TimeOfDay(setting, value)

end




do
    local name = "Change Silvermoon City Music"
    local variable = "Silvermusic_Options_Playerchoice"
	local variableKey = "Playerchoice" 
    local tooltip = ""

    local function GetOptions()
        local container = Settings.CreateControlTextContainer()
        container:Add(1, "Default" )
		container:Add(2, "Silvermoon Regular (Midnight)" )
        container:Add(3, "Silvermoon Horde (Midnight)" )
        container:Add(4, "Silvermoon (The Burning Crusade)" )
        return container:GetData()
    end

	local setting = Settings.RegisterAddOnSetting(category, variable, variableKey, SilvermusicDB_Options, Settings.VarType.Number, name, 1)
	setting:SetValueChangedCallback(OnSettingChanged)

    Settings.CreateDropdown(category, setting, GetOptions, tooltip)
end




do
    local name = "Use Current Time of Day"
    local variable = "Silvermusic_Options_TimeOfDay"
	local variableKey = "TimeOfDay" 
    local tooltip = "The add-on will play daytime/nighttime versions of the music tracks depending on the current hour. Uncheck this option to alternate between both versions."

	local setting = Settings.RegisterAddOnSetting(category, variable, variableKey, SilvermusicDB_Options, Settings.VarType.Boolean, name, Settings.Default.True)
	setting:SetValueChangedCallback(OnSettingChanged_TimeOfDay)

	Settings.CreateCheckbox(category, setting, tooltip)
end




Settings.RegisterAddOnCategory(category)