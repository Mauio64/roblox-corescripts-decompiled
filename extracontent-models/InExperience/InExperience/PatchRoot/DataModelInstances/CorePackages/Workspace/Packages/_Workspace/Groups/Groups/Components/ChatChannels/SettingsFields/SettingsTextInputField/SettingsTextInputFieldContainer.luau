local parent = script:FindFirstAncestor("Groups").Parent

local React = require(parent.React)
local SettingsTextInputFieldView = require(script.Parent.SettingsTextInputFieldView)
local useSettingsTextInputFieldViewModel = require(script.Parent.useSettingsTextInputFieldViewModel)

local function SettingsTextInputFieldContainer(p)
	local v = useSettingsTextInputFieldViewModel(p)
	return React.createElement(SettingsTextInputFieldView, v)
end

return SettingsTextInputFieldContainer
