local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local KeybindContext = require(script.Parent.KeybindContext)
local BindingConfigs = require(ParentParent.Configs.BindingConfigs)

return React.memo(function(t1: {[any]: any}) -- line: 14
	-- upvalues: React (copy), BindingConfigs (copy), KeybindContext (copy)
	local v7, _ = React.useState(BindingConfigs.ControlGroups)
	local v9, _ = React.useState(BindingConfigs.Controls)

	return React.createElement(KeybindContext.Provider, {
		value = {
			groups = v7,
			controls = v9
		}
	}, t1.children)
end)
