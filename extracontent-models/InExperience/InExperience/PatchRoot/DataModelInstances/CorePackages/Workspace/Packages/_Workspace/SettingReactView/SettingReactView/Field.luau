local parent = script.Parent
local parent2 = parent.Parent

local SettingsService = require(parent2.SettingsService)
local SettingEnum = SettingsService.SettingEnum
local React = require(parent2.React)
local fields = parent.Fields
local Toggle = require(fields.Toggle)
local TextButton = require(fields.TextButton)

return function(p)
	local v = {}

	if p.field_type == SettingEnum.Toggle then
		return (React.createElement(Toggle, p))
	end

	if p.field_type == SettingEnum.TextButton then
		return (React.createElement(TextButton, p))
	end

	return v
end
