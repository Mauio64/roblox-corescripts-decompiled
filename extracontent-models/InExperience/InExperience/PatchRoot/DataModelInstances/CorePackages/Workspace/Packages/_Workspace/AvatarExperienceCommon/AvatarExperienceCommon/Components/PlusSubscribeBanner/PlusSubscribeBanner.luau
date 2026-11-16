local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local FFlagAXPlusSubscribeBannerRestyle = require(script.Parent.FFlagAXPlusSubscribeBannerRestyle)

local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local useTokens = Foundation.Hooks.useTokens

local function PlusSubscribeBanner(props)
	local v = useTokens()
	local showPlusIcon = props.showPlusIcon
	local testId = props.testId or "PlusSubscribeBanner"

	local createElement = React.createElement
	local v2 = {
		tag = {
			["size-full-0 auto-y padding-medium radius-medium bg-action-standard"] = FFlagAXPlusSubscribeBannerRestyle,
			["size-full-0 auto-y padding-medium stroke-standard stroke-position-inner stroke-default radius-medium"] = not FFlagAXPlusSubscribeBannerRestyle
		},
		LayoutOrder = props.LayoutOrder,
		testId = testId
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local plusIcon

	if showPlusIcon then
		plusIcon = React.createElement(Icon, {
			name = IconName.RobloxPlus,
			size = IconSize.Medium,
			style = v.Color.Content.Emphasis,
			LayoutOrder = 1,
			testId = `{testId}PlusIcon`
		})
	end

	return createElement(View, v2, {
		Content = createElement2(View, {
			tag = "row flex-between align-y-center gap-small size-full-0 auto-y"
		}, {
			Leading = createElement3(View, {
				tag = "row align-y-center fill gap-small auto-xy",
				LayoutOrder = 1
			}, {
				PlusIcon = plusIcon,
				Message = React.createElement(Text, {
					tag = "fill text-body-small text-align-x-left content-emphasis",
					Text = props.message,
					LayoutOrder = 2
				})
			}),
			Subscribe = React.createElement(
				View,
				{
					tag = "auto-xy",
					LayoutOrder = 2,
					onActivated = props.onActivated,
					testId = `{testId}Action`
				},
				{
					Label = React.createElement(Text, {
						tag = "auto-xy text-body-small content-default",
						Text = `<u>{props.actionText}</u>`,
						RichText = true
					})
				}
			)
		})
	})
end

return React.memo(PlusSubscribeBanner)
