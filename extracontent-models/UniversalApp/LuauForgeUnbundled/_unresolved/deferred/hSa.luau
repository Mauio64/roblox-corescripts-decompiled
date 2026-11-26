local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)

local badge = Foundation.Badge
local image = Foundation.Image
local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local badgeVariant = Foundation.Enums.BadgeVariant
local useTokens = Foundation.Hooks.useTokens

local useAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").useAppPolicy

local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local getStandardSizeAvatarHeadShotRbxthumb = require("@luauforge/bundled/ciE").Utils.getStandardSizeAvatarHeadShotRbxthumb

local fFlagEnableNonFlyoutUncheckedBadge = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableNonFlyoutUncheckedBadge

local function ThirdPartyLinkedUserInfoWidget(props)
	local v5 = useTokens()
	local v6

	if fFlagEnableNonFlyoutUncheckedBadge then
		v6 = useAppPolicy(function(p2)
			return p2.getShowUncheckedBadge()
		end)
	end

	local v7

	if fFlagEnableNonFlyoutUncheckedBadge then
		v7 = useLocalization({ Unchecked = "CommonUI.Features.Label.Unchecked" })
	end

	local createElement = React.createElement
	local v9 = {
		LayoutOrder = props.layoutOrder,
		tag = "size-full-0 gap-small auto-y align-x-left align-y-center row"
	}

	local v10 = {
		UserIcon = React.createElement(image, {
			Image = getStandardSizeAvatarHeadShotRbxthumb(props.userId),
			Size = UDim2.fromOffset(v5.Size.Size_900, v5.Size.Size_900),
			tag = "radius-circle",
			LayoutOrder = 0,
			backgroundStyle = v5.Color.Common.Shimmer
		}),
		UserInfoView = 0,
		UncheckedBadge = 0
	}

	local createElement2 = React.createElement

	local createElement3 = React.createElement

	local v16 = {
		UserNameText = React.createElement(text, {
			tag = "auto-xy text-title-large text-align-y-center text-align-x-left",
			Text = props.userName,
			LayoutOrder = 0
		}),
		BadgeText = React.createElement(text, {
			tag = "auto-xy text-align-y-center text-align-x-left",
			Text = props.userBadgeEmoji,
			textStyle = v5.Color.Content.Emphasis,
			fontStyle = v5.Typography.TitleLarge,
			LayoutOrder = 1
		}),
		MembershipIcon = 0
	}

	local v17 = if props.showRobloxPlusBadge then React.createElement(icon, {
		name = iconName.RobloxPlus,
		size = iconSize.Medium,
		style = v5.Color.Content.Emphasis,
		LayoutOrder = 2
	}) else nil
	v16.MembershipIcon = v17
	local v13 = {
		UserNameAndBadge = createElement3(
			view,
			{ tag = "size-full-0 gap-xsmall auto-y align-x-left align-y-center row" },
			v16
		),
		ThirdPartyUserInfo = 0
	}

	local v18 = if props.thirdPartyUserName and props.thirdPartyPlatformIcon then React.createElement(
		view,
		{ tag = "size-full-0 gap-xsmall auto-y align-x-left align-y-center row" },
		{
			PlatformIcon = React.createElement(image, {
				Image = props.thirdPartyPlatformIcon,
				Size = UDim2.fromOffset(v5.Size.Size_400, v5.Size.Size_400),
				tag = "align-x-center align-x-left align-y-center",
				LayoutOrder = 0
			}),
			ThirdPartyUserName = React.createElement(text, {
				tag = "auto-xy text-body-small text-align-y-center text-align-x-left",
				Text = props.thirdPartyUserName,
				LayoutOrder = 1
			})
		}
	) else nil
	v13.ThirdPartyUserInfo = v18
	v10.UserInfoView = createElement2(view, {
		LayoutOrder = 1,
		tag = {
			["gap-xsmall align-x-left align-y-center col"] = true,
			["size-full-0 auto-y"] = not fFlagEnableNonFlyoutUncheckedBadge,
			["auto-xy"] = fFlagEnableNonFlyoutUncheckedBadge
		}
	}, v13)

	local v19 = if fFlagEnableNonFlyoutUncheckedBadge and v6 then React.createElement(badge, {
		text = v7.Unchecked,
		variant = badgeVariant.Neutral,
		LayoutOrder = 2
	}) else nil
	v10.UncheckedBadge = v19
	return createElement(view, v9, v10)
end

return React.memo(ThirdPartyLinkedUserInfoWidget)
