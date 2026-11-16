local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Foundation")
local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize

local RoactServiceTags = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RoactServiceTags")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/RobloxAppHooks").useRoactService
local usePlayButtonState = require("@game/CorePackages/Workspace/Packages/_Index/GamePlayButton/GamePlayButton/usePlayButtonState")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Localization").Hooks.useLocalization

local function PlusEarlyAccessUpsellBanner(p2)
	local v5 = useLocalization({
		subscribe = "Feature.RobloxSubscription.Action.Subscribe",
		joinEarly = "Feature.RobloxSubscription.Description.JoinEarly"
	})

	local earlyAccess = usePlayButtonState(useRoactService(RoactServiceTags.RoactNetworking), p2.universeId).earlyAccess

	if earlyAccess == nil or not earlyAccess.showPlusUpsell then
		return nil
	end

	return React.createElement(
		view,
		{
			tag = "row align-y-center gap-small size-full-1100 padding-medium stroke-default radius-medium clip",
			LayoutOrder = p2.LayoutOrder,
			onActivated = earlyAccess.openUpsell,
			testId = "--early-access-plus-upsell"
		},
		{
			PlusIcon = React.createElement(icon, {
				name = iconName.RobloxPlus,
				size = iconSize.Medium,
				LayoutOrder = 1
			}),
			Label = React.createElement(text, {
				tag = "fill auto-y text-body-medium text-align-x-left text-truncate-end content-emphasis",
				Text = v5.joinEarly,
				LayoutOrder = 2
			}),
			Subscribe = React.createElement(text, {
				tag = "auto-xy text-body-medium content-emphasis",
				Text = `<u>{v5.subscribe}</u>`,
				RichText = true,
				LayoutOrder = 3,
				testId = "--early-access-subscribe"
			})
		}
	)
end

return React.memo(PlusEarlyAccessUpsellBanner)
