local parent = script:FindFirstAncestor("AvatarExperienceTimedOptions").Parent
local React = require(parent.React)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local Text = Foundation.Text
local Enums = Foundation.Enums

local LocalizationService = game:GetService("LocalizationService")

local function formatExpirationDateTime(expirationTime: string) -- 1 equivalent call inferred from this helper
	local dateTime = DateTime.fromIsoDate(expirationTime)

	if dateTime then
		return dateTime:FormatLocalTime("MMM DD, LT", LocalizationService.RobloxLocaleId)
	end

	return expirationTime
end

local function ItemExpirationDisplay(p)
	local v = useTokens()

	local v2 = useLocalization({ itemExpires = "Feature.Durables.Label.ItemExpires" })

	return React.createElement(
		View,
		{
			tag = "row align-y-center padding-large radius-medium flex-between size-full-0",
			backgroundStyle = v.Color.Surface.Surface_100,
			LayoutOrder = p.LayoutOrder,
			AutomaticSize = Enum.AutomaticSize.Y
		},
		{
			LeftContent = React.createElement(View, {
				tag = "row align-y-center gap-small auto-xy",
				LayoutOrder = 1
			}, {
				Icon = React.createElement(Foundation.Icon, {
					name = Enums.IconName.Clock,
					variant = Enums.IconVariant.Regular,
					size = Enums.IconSize.Small,
					LayoutOrder = 1
				}),
				Label = React.createElement(Text, {
					tag = "auto-xy text-label-medium content-emphasis",
					Text = v2.itemExpires,
					LayoutOrder = 2
				})
			}),
			RightContent = React.createElement(View, { tag = "auto-xy", LayoutOrder = 2 }, {
				ExpirationText = React.createElement(Text, {
					tag = "auto-xy text-body-medium content-emphasis",
					Text = formatExpirationDateTime(p.expirationTime) -- inferred equivalent call
				})
			})
		}
	)
end

return ItemExpirationDisplay
