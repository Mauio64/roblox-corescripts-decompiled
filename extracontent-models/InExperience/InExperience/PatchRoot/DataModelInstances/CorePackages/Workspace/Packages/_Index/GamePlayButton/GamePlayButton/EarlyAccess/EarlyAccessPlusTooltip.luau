local parent = script:FindFirstAncestor("GamePlayButton").Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local EducationalTooltip = Foundation.EducationalTooltip
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign

local RobloxSubscriptionPurchaseApp = require(parent.RobloxSubscriptionPurchaseApp)
local SignalsReact = require(parent.SignalsReact)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local function EarlyAccessPlusTooltip(props)
	local v = useLocalization({
		title = "Feature.RobloxSubscription.ToolTip.EarlyAccess.Title",
		body = "Feature.RobloxSubscription.ToolTip.EarlyAccess.Body"
	})

	local v2 = RobloxSubscriptionPurchaseApp.RobloxSubscriptionSignals.get()

	if SignalsReact.useSignalState(v2.getHasRobloxSubscription) then
		return React.createElement(EducationalTooltip, {
			isOpen = props.isOpen,
			onClose = props.onRequestClose,
			onPressedOutside = props.onRequestClose,
			anchorRef = props.anchorRef,
			title = v.title,
			text = v.body,
			side = PopoverSide.Top,
			align = PopoverAlign.Center
		})
	end

	return nil
end

return React.memo(EarlyAccessPlusTooltip)
