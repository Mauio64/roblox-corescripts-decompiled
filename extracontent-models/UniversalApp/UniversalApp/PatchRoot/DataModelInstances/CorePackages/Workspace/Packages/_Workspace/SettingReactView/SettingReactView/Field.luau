local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local SettingEnum = require(scriptParentParent.SettingsService).SettingEnum
local React = require(scriptParentParent.React)
local Fields = scriptParent.Fields
local Toggle = require(Fields.Toggle)
local TextButton = require(Fields.TextButton)

return function(p1) -- line: 19
	-- upvalues: SettingEnum (copy), React (copy), Toggle (copy), TextButton (copy)
	local t1 = {}

	if p1.field_type == SettingEnum.Toggle then
		return (React.createElement(Toggle, p1))
	end

	if p1.field_type == SettingEnum.TextButton then
		t1 = React.createElement(TextButton, p1)
	end

	return t1
end
