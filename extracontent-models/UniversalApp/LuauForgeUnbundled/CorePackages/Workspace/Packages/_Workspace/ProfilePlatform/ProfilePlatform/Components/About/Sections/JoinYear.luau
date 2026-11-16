local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization")
local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/BuilderIcons")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")

local text = Foundation.Text
local view = Foundation.View
local icon = Foundation.Icon
local inputSize = Foundation.Enums.InputSize
local iconVariant = Foundation.Enums.IconVariant
local circleI = BuilderIcons.Icon.CircleI

local useLocalization = Localization.Hooks.useLocalization

local function JoinYear(p2)
	if not p2.joinDateTime or p2.joinDateTime == "" then
		return nil
	end

	local v5 = string.match(p2.joinDateTime, "^(%d%d%d%d)")

	if not v5 then
		return nil
	end

	local v6 = useLocalization({
		statistics = TextKeys.Statistics,
		joinedInYear = {
			TextKeys.JoinedInYear,
			year = v5
		}
	})

	return React.createElement(
		view,
		{
			LayoutOrder = p2.layoutOrder,
			tag = "col size-full-0 auto-y gap-small align-x-left"
		},
		{
			Title = React.createElement(text, {
				LayoutOrder = 1,
				tag = "auto-y size-full-0 text-align-x-left text-heading-small",
				Text = v6.statistics
			}),
			Content = React.createElement(
				view,
				{
					LayoutOrder = p2.layoutOrder,
					tag = "auto-xy size-0 row align-y-center gap-xsmall"
				},
				{
					Icon = React.createElement(icon, {
						LayoutOrder = 1,
						name = circleI,
						size = inputSize.XSmall,
						variant = iconVariant.Filled
					}),
					Text = React.createElement(text, {
						LayoutOrder = 2,
						tag = "auto-xy size-0 text-align-x-left text-body-medium",
						Text = v6.joinedInYear
					})
				}
			)
		}
	)
end

return JoinYear
