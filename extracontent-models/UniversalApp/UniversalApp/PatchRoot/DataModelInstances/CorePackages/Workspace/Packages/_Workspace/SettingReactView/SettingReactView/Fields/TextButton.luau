local Parent = script:FindFirstAncestor("SettingReactView").Parent

require(Parent.SettingsService)

local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Button = Foundation.Button
local Enums = Foundation.Enums
local ButtonVariant = Enums.ButtonVariant
local ButtonSize = Enums.ButtonSize

return function(p1) -- line: 19
	-- upvalues: React (copy), Button (copy), ButtonVariant (copy), ButtonSize (copy)
	local v9

	if p1.text and type(p1.text) == "table" then
		local v10

		v9, v10 = React.useState(p1.text:get())
		p1.text:connect(v10)
	else
		v9 = p1.text
	end

	local onActivated = p1.onActivated
	local v12 = React.useCallback(function() -- line: 30
		-- upvalues: p1 (copy)
		if p1.onActivated then
			p1.onActivated:signal():fire()
		end
	end, { p1.onActivated })

	return React.createElement(Button, {
		onActivated = v12,
		text = v9,
		isDisabled = not onActivated,
		variant = ButtonVariant.Standard,
		size = ButtonSize.Medium
	})
end
