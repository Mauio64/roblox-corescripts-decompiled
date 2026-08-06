local Parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(Parent.React)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local Foundation = require(Parent.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local FFlagCTAChangeMorePageFlyoutButtonText = require(Parent.SharedFlags).FFlagCTAChangeMorePageFlyoutButtonText

local function FlyoutSwitchAccountButton(p1) -- line: 19
	-- upvalues: React (copy), useLocalization (copy), FFlagCTAChangeMorePageFlyoutButtonText (copy), Button (copy), ButtonVariant (copy), ButtonSize (copy)
	local v11 = React.useCallback(function() -- line: 20
		-- upvalues: p1 (copy)
		p1.closeDrawer()

		if p1.onSwitchAccountActivated then
			p1.onSwitchAccountActivated()
		end
	end, {
		p1.onSwitchAccountActivated,
		p1.closeDrawer
	})
	local v12 = useLocalization({
		title = not FFlagCTAChangeMorePageFlyoutButtonText and "Authentication.AccountSwitch.Action.SwitchAccount" or "Authentication.AccountSwitch.Header.SwitchAccountSentenceCase"
	})

	return React.createElement(Button, {
		isDisabled = false,
		text = v12.title,
		variant = ButtonVariant.Standard,
		LayoutOrder = p1.layoutOrder,
		onActivated = v11,
		size = ButtonSize.Large,
		width = UDim.new(1, 0)
	})
end

return FlyoutSwitchAccountButton
