local Parent = script:FindFirstAncestor("AvatarExperienceTimedOptions").Parent
local React = require(Parent.React)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local FoundationText = Foundation.Text
local Enums = Foundation.Enums
local LocalizationService = game:GetService("LocalizationService")

local function formatExpirationDateTime(s1: string) -- line: 23
	-- upvalues: LocalizationService (copy)
	local dateTime = DateTime.fromIsoDate(s1)

	if not dateTime then
		return s1
	end

	return dateTime:FormatLocalTime("MMM DD, LT", LocalizationService.RobloxLocaleId)
end
local function ItemExpirationDisplay(t1: {[any]: any}) -- line: 34
	-- upvalues: useTokens (copy), useLocalization (copy), React (copy), View (copy), Foundation (copy), Enums (copy), FoundationText (copy), LocalizationService (copy)
	local v15 = useTokens()
	local v16 = useLocalization({
		itemExpires = "Feature.Durables.Label.ItemExpires"
	})
	local createElement = React.createElement
	local v18 = View
	local t2 = {
		tag = "row align-y-center padding-large radius-medium flex-between size-full-0",
		backgroundStyle = v15.Color.Surface.Surface_100,
		LayoutOrder = t1.LayoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y
	}
	local t3 = {
		LeftContent = React.createElement(View, {
			tag = "row align-y-center gap-small auto-xy",
			LayoutOrder = 1
		}, {
			Icon = React.createElement(Foundation.Icon, {
				LayoutOrder = 1,
				name = Enums.IconName.Clock,
				variant = Enums.IconVariant.Regular,
				size = Enums.IconSize.Small
			}),
			Label = React.createElement(FoundationText, {
				tag = "auto-xy text-label-medium content-emphasis",
				LayoutOrder = 2,
				Text = v16.itemExpires
			})
		})
	}
	local createElement2 = React.createElement
	local v22 = View
	local t4 = {
		tag = "auto-xy",
		LayoutOrder = 2
	}
	local t5 = {}
	local createElement3 = React.createElement
	local v26 = FoundationText
	local t6 = {
		tag = "auto-xy text-body-medium content-emphasis"
	}
	local expirationTime = t1.expirationTime
	local dateTime = DateTime.fromIsoDate(expirationTime)

	t6.Text = if dateTime then dateTime:FormatLocalTime("MMM DD, LT", LocalizationService.RobloxLocaleId) else expirationTime
	t5.ExpirationText = createElement3(v26, t6)
	t3.RightContent = createElement2(v22, t4, t5)

	return createElement(v18, t2, t3)
end

return ItemExpirationDisplay
