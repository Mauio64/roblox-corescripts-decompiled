local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
require(parent.Configs.ConfigTypes)
local KeybindContext = require(parent.Context.KeybindContext)
local useAbilities = require(script.Parent.useAbilities)
local FFlagHelpPageCCL = require(parent.Flags.FFlagHelpPageCCL)

return function()
	local v = React.useContext(KeybindContext)
	local v2

	if FFlagHelpPageCCL then
		v2 = useAbilities()
	end

	if v2 == nil or v.controls == nil then
		return v
	end

	local controls = {}

	for k, control in v.controls do
		if k ~= "Jump" then
			controls[k] = control
		end
	end

	for k, v3 in v2 do
		controls[k] = v3
	end

	return { groups = v.groups, controls = controls, abilitiesAvailable = true }
end
