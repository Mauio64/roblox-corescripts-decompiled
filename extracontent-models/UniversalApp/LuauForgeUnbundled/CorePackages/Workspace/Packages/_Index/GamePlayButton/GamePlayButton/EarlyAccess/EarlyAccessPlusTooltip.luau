local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Foundation")
local educationalTooltip = Foundation.EducationalTooltip
local popoverSide = Foundation.Enums.PopoverSide
local popoverAlign = Foundation.Enums.PopoverAlign

local RobloxSubscriptionPurchaseApp = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RobloxSubscriptionPurchaseApp")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/SignalsReact")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Localization").Hooks.useLocalization

local function EarlyAccessPlusTooltip(props)
	local v5 = useLocalization({
		title = "Feature.RobloxSubscription.ToolTip.EarlyAccess.Title",
		body = "Feature.RobloxSubscription.ToolTip.EarlyAccess.Body"
	})

	local v6 = RobloxSubscriptionPurchaseApp.RobloxSubscriptionSignals.get()

	if SignalsReact.useSignalState(v6.getHasRobloxSubscription) then
		return React.createElement(educationalTooltip, {
			isOpen = props.isOpen,
			onClose = props.onRequestClose,
			onPressedOutside = props.onRequestClose,
			anchorRef = props.anchorRef,
			title = v5.title,
			text = v5.body,
			side = popoverSide.Top,
			align = popoverAlign.Center
		})
	end

	return nil
end

return React.memo(EarlyAccessPlusTooltip)
