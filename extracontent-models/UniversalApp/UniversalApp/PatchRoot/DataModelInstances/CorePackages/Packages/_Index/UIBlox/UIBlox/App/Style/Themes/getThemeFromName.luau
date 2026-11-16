local parent = script.Parent
local parent2 = parent.Parent

local Constants = require(parent2.Constants)
local validateTheme = require(parent2.Validator.validateTheme)

local v = {}
local dark = Constants.ThemeName.Dark:lower()
local DarkTheme = require(parent.DarkTheme)
v[dark] = DarkTheme
local light = Constants.ThemeName.Light:lower()
local LightTheme = require(parent.LightTheme)
v[light] = LightTheme

return function(value: string)
	local selected

	if not (value == nil or not (#value > 0)) then
		selected = v[value:lower()]
	end

	if selected == nil then
		selected = v[Constants.DefaultThemeName:lower()]
	end

	assert(validateTheme(selected))
	return selected
end
