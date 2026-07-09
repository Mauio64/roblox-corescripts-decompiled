local Parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(Parent.React)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local Foundation = require(Parent.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize

local function FlyoutSwitchAccountButton(p1) -- line: 16
	-- upvalues: React (copy), useLocalization (copy), Button (copy), ButtonVariant (copy), ButtonSize (copy)
	local v10 = React.useCallback(function() -- line: 17
		-- upvalues: p1 (copy)
		p1.closeDrawer()

		if p1.onSwitchAccountActivated then
			p1.onSwitchAccountActivated()
		end
	end, {
		p1.onSwitchAccountActivated,
		p1.closeDrawer
	})
	local v11 = useLocalization({
		title = "Authentication.AccountSwitch.Action.SwitchAccount"
	})

	return React.createElement(Button, {
		isDisabled = false,
		text = v11.title,
		variant = ButtonVariant.Standard,
		LayoutOrder = p1.layoutOrder,
		onActivated = v10,
		size = ButtonSize.Large,
		width = UDim.new(1, 0)
	})
end

return FlyoutSwitchAccountButton
