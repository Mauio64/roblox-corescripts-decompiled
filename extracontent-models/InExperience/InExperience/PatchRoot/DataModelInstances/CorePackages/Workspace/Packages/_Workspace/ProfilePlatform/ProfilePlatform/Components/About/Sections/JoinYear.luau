local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local BuilderIcons = require(parent.BuilderIcons)
local TextKeys = require(ProfilePlatform.Common.TextKeys)

local Text = Foundation.Text
local View = Foundation.View
local Icon = Foundation.Icon
local InputSize = Foundation.Enums.InputSize
local IconVariant = Foundation.Enums.IconVariant
local CircleI = BuilderIcons.Icon.CircleI

local useLocalization = Localization.Hooks.useLocalization

local function JoinYear(p)
	if not p.joinDateTime or p.joinDateTime == "" then
		return nil
	end

	local year = string.match(p.joinDateTime, "^(%d%d%d%d)")

	if not year then
		return nil
	end

	local v = useLocalization({
		statistics = TextKeys.Statistics,
		joinedInYear = {
			TextKeys.JoinedInYear,
			year = year
		}
	})

	return React.createElement(
		View,
		{ LayoutOrder = p.layoutOrder, tag = "col size-full-0 auto-y gap-small align-x-left" },
		{
			Title = React.createElement(Text, {
				LayoutOrder = 1,
				tag = "auto-y size-full-0 text-align-x-left text-heading-small",
				Text = v.statistics
			}),
			Content = React.createElement(
				View,
				{
					LayoutOrder = p.layoutOrder,
					tag = "auto-xy size-0 row align-y-center gap-xsmall"
				},
				{
					Icon = React.createElement(Icon, {
						LayoutOrder = 1,
						name = CircleI,
						size = InputSize.XSmall,
						variant = IconVariant.Filled
					}),
					Text = React.createElement(Text, {
						LayoutOrder = 2,
						tag = "auto-xy size-0 text-align-x-left text-body-medium",
						Text = v.joinedInYear
					})
				}
			)
		}
	)
end

return JoinYear
