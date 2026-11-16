local parent = script:FindFirstAncestor("SettingReactView").Parent

require(parent.SettingsService)
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local toggle = Foundation.Toggle

return function(p)
	local state, setState = React.useState(p.onChanged:get())
	p.onChanged:connect(function(flag: boolean)
		setState(flag)
	end)
	local onActivated = React.useCallback(function()
		p.onChanged:set(not state)
	end, { state })

	return React.createElement(toggle, {
		label = "",
		isDisabled = false,
		isChecked = state,
		onActivated = onActivated
	})
end
