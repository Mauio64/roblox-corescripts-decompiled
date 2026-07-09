local Parent = script:FindFirstAncestor("SettingReactView").Parent

require(Parent.SettingsService)

local React = require(Parent.React)
local Toggle = require(Parent.Foundation).Toggle

return function(p1) -- line: 16
	-- upvalues: React (copy), Toggle (copy)
	local v5, v6 = React.useState(p1.onChanged:get())

	p1.onChanged:connect(function(b1: boolean) -- line: 18
		-- upvalues: v6 (copy)
		v6(b1)
	end)

	local v7 = React.useCallback(function() -- line: 21
		-- upvalues: p1 (copy), v5 (copy)
		p1.onChanged:set(not v5)
	end, { v5 })

	return React.createElement(Toggle, {
		label = "",
		isDisabled = false,
		isChecked = v5,
		onActivated = v7
	})
end
