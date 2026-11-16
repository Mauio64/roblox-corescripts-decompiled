local parent = script:FindFirstAncestor("SettingReactView").Parent

require(parent.SettingsService)
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Button = Foundation.Button
local Enums = Foundation.Enums
local ButtonVariant = Enums.ButtonVariant
local ButtonSize = Enums.ButtonSize

return function(p)
	local state

	if p.text and type(p.text) == "table" then
		local setState
		state, setState = React.useState(p.text:get())
		p.text:connect(setState)
	else
		state = p.text
	end

	local isDisabled = not p.onActivated
	local onActivated = React.useCallback(function()
		if p.onActivated then
			p.onActivated:signal():fire()
		end
	end, { p.onActivated })

	return React.createElement(Button, {
		onActivated = onActivated,
		text = state,
		isDisabled = isDisabled,
		variant = ButtonVariant.Standard,
		size = ButtonSize.Medium
	})
end
