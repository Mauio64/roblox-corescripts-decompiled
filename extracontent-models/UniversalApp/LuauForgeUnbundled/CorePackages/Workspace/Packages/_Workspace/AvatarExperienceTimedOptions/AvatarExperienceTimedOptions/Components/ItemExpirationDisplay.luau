local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/React")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/Localization").Hooks.useLocalization
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceTimedOptions/Foundation")
local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View
local text = Foundation.Text
local enums = Foundation.Enums

local LocalizationService = game:GetService("LocalizationService")

local function formatExpirationDateTime(p2)
	local dateTime = DateTime.fromIsoDate(p2)

	if dateTime then
		return dateTime:FormatLocalTime("MMM DD, LT", LocalizationService.RobloxLocaleId)
	end

	return p2
end

local function ItemExpirationDisplay(p2)
	local v5 = useTokens()

	local v6 = useLocalization({ itemExpires = "Feature.Durables.Label.ItemExpires" })

	local createElement = React.createElement
	local v8 = {
		tag = "row align-y-center padding-large radius-medium flex-between size-full-0",
		backgroundStyle = v5.Color.Surface.Surface_100,
		LayoutOrder = p2.LayoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local v9 = {
		LeftContent = React.createElement(
			view,
			{ tag = "row align-y-center gap-small auto-xy", LayoutOrder = 1 },
			{
				Icon = React.createElement(Foundation.Icon, {
					name = enums.IconName.Clock,
					variant = enums.IconVariant.Regular,
					size = enums.IconSize.Small,
					LayoutOrder = 1
				}),
				Label = React.createElement(text, {
					tag = "auto-xy text-label-medium content-emphasis",
					Text = v6.itemExpires,
					LayoutOrder = 2
				})
			}
		),
		RightContent = 0
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement

	local v15 = p2.expirationTime
	local dateTime = DateTime.fromIsoDate(v15)

	if dateTime then
		v15 = dateTime:FormatLocalTime("MMM DD, LT", LocalizationService.RobloxLocaleId)
	end

	v9.RightContent = createElement2(view, { tag = "auto-xy", LayoutOrder = 2 }, {
		ExpirationText = createElement3(text, {
			tag = "auto-xy text-body-medium content-emphasis",
			Text = v15
		})
	})
	return createElement(view, v8, v9)
end

return ItemExpirationDisplay
