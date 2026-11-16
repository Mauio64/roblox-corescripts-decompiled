local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Foundation")

local FFlagAXPlusSubscribeBannerRestyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/AvatarExperienceCommon/Components/PlusSubscribeBanner/FFlagAXPlusSubscribeBannerRestyle")

local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local function PlusSubscribeBanner(props)
	local v5 = useTokens()
	local showPlusIcon = props.showPlusIcon
	local testId = props.testId or "PlusSubscribeBanner"

	local createElement = React.createElement
	local v7 = {
		tag = {
			["size-full-0 auto-y padding-medium radius-medium bg-action-standard"] = FFlagAXPlusSubscribeBannerRestyle,
			["size-full-0 auto-y padding-medium stroke-standard stroke-position-inner stroke-default radius-medium"] = not FFlagAXPlusSubscribeBannerRestyle
		},
		LayoutOrder = props.LayoutOrder,
		testId = testId
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement

	local v14 = if showPlusIcon then React.createElement(icon, {
		name = iconName.RobloxPlus,
		size = iconSize.Medium,
		style = v5.Color.Content.Emphasis,
		LayoutOrder = 1,
		testId = `{testId}PlusIcon`
	}) else nil
	return createElement(view, v7, {
		Content = createElement2(
			view,
			{ tag = "row flex-between align-y-center gap-small size-full-0 auto-y" },
			{
				Leading = createElement3(
					view,
					{
						tag = "row align-y-center fill gap-small auto-xy",
						LayoutOrder = 1
					},
					{
						PlusIcon = v14,
						Message = React.createElement(text, {
							tag = "fill text-body-small text-align-x-left content-emphasis",
							Text = props.message,
							LayoutOrder = 2
						})
					}
				),
				Subscribe = React.createElement(
					view,
					{
						tag = "auto-xy",
						LayoutOrder = 2,
						onActivated = props.onActivated,
						testId = `{testId}Action`
					},
					{
						Label = React.createElement(text, {
							tag = "auto-xy text-body-small content-default",
							Text = `<u>{props.actionText}</u>`,
							RichText = true
						})
					}
				)
			}
		)
	})
end

return React.memo(PlusSubscribeBanner)
