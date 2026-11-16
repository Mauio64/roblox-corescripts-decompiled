local GamePlayButton = script:FindFirstAncestor("GamePlayButton")
local parent = GamePlayButton.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize

local RoactServiceTags = require(parent.RoactServiceTags)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local usePlayButtonState = require(GamePlayButton.usePlayButtonState)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local function PlusEarlyAccessUpsellBanner(p)
	local v = useLocalization({
		subscribe = "Feature.RobloxSubscription.Action.Subscribe",
		joinEarly = "Feature.RobloxSubscription.Description.JoinEarly"
	})

	local earlyAccess = usePlayButtonState(useRoactService(RoactServiceTags.RoactNetworking), p.universeId).earlyAccess

	if earlyAccess == nil or not earlyAccess.showPlusUpsell then
		return nil
	end

	return React.createElement(
		View,
		{
			tag = "row align-y-center gap-small size-full-1100 padding-medium stroke-default radius-medium clip",
			LayoutOrder = p.LayoutOrder,
			onActivated = earlyAccess.openUpsell,
			testId = "--early-access-plus-upsell"
		},
		{
			PlusIcon = React.createElement(Icon, {
				name = IconName.RobloxPlus,
				size = IconSize.Medium,
				LayoutOrder = 1
			}),
			Label = React.createElement(Text, {
				tag = "fill auto-y text-body-medium text-align-x-left text-truncate-end content-emphasis",
				Text = v.joinEarly,
				LayoutOrder = 2
			}),
			Subscribe = React.createElement(Text, {
				tag = "auto-xy text-body-medium content-emphasis",
				Text = `<u>{v.subscribe}</u>`,
				RichText = true,
				LayoutOrder = 3,
				testId = "--early-access-subscribe"
			})
		}
	)
end

return React.memo(PlusEarlyAccessUpsellBanner)
