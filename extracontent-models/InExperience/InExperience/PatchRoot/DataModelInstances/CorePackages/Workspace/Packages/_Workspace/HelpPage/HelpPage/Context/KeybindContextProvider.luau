local parent = script.Parent.Parent
local parent2 = parent.Parent

local React = require(parent2.React)
local KeybindContext = require(script.Parent.KeybindContext)
local BindingConfigs = require(parent.Configs.BindingConfigs)

return React.memo(function(p)
	local state, _ = React.useState(BindingConfigs.ControlGroups)
	local state2, _ = React.useState(BindingConfigs.Controls)

	return React.createElement(KeybindContext.Provider, {
		value = { groups = state, controls = state2 }
	}, p.children)
end)
