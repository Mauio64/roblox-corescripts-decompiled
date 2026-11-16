local parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local BuilderIcons = require(parent.BuilderIcons)
local UserLib = require(parent.UserLib)
local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb
local Badge = Foundation.Badge
local BadgeVariant = Foundation.Enums.BadgeVariant
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local IconName = Foundation.Enums.IconName
local Text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local LoadableImage = UIBlox.App.Loading.LoadableImage
local FlyoutAnalytics = require(script.Parent.Parent.Analytics.FlyoutAnalytics)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local RoactServiceTags = require(parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local ChevronSmallDownButton = require(script.Parent.ChevronSmallDownButton)

local RoactUtils = require(parent.RoactUtils)
local getTestId = RoactUtils.getTestId
local SharedFlags = require(parent.SharedFlags)

local FFlagLuaAppAddTestIdsForArrow = SharedFlags.FFlagLuaAppAddTestIdsForArrow
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local FFlagHidePremiumIconography = SharedFlags.FFlagHidePremiumIconography
local FFlagEnableFlyoutUncheckedBadge = SharedFlags.FFlagEnableFlyoutUncheckedBadge
local FFlagEnableDrawerFocusNav = SharedFlags.FFlagEnableDrawerFocusNav
local FFlagFlyoutSidePanelUseProfileFrameThumbnail = SharedFlags.FFlagFlyoutSidePanelUseProfileFrameThumbnail

local function FlyoutProfileCard(props)
	local v = useTokens()
	local v2

	if FFlagEnableFlyoutUncheckedBadge then
		v2 = useLocalization({ Unchecked = "CommonUI.Features.Label.Unchecked" })
	end

	local v3

	if FFlagEnableFlyoutUncheckedBadge then
		v3 = useAppPolicy(function(p)
			return p.getShowUncheckedBadge()
		end)
	end

	local v4 = useRoactService(AppEventIngestService)
	local localUserModel = props.localUserModel
	local v5 = React.useCallback(function()
		props.closeDrawer()

		if props.onProfileActivated then
			props.onProfileActivated()
			local id = localUserModel and localUserModel.id or ""
			FlyoutAnalytics.sendMoreLegacyAndFlyoutItemClickEvent(v4, "Profile", id)
		end
	end, { localUserModel, props.onProfileActivated, props.closeDrawer, v4 })
	local onActivated = React.useCallback(function()
		props.closeDrawer()

		if props.onSwitchAccountActivated then
			props.onSwitchAccountActivated()
		end
	end, { props.onSwitchAccountActivated, props.closeDrawer })

	local image = React.useMemo(function()
		if localUserModel and localUserModel.id then
			return getStandardSizeAvatarHeadShotRbxthumb(
				localUserModel.id,
				FFlagFlyoutSidePanelUseProfileFrameThumbnail
			)
		end

		return nil
	end, { localUserModel })
	local v6 = React.useMemo(function()
		return localUserModel and localUserModel.membership == Enum.MembershipType.Premium
	end, { localUserModel })
	local name = localUserModel and localUserModel.name or ""
	local displayName = localUserModel and localUserModel.displayName or ""
	local v7

	if FFlagEnableBlackbirdCheck then
		v7 = props.isRobloxSubscriber == true
	else
		v7 = false
	end

	local v8

	if FFlagHidePremiumIconography then
		v8 = false
	else
		v8 = v6 and not v7
	end

	local createElement = React.createElement
	local view = Foundation.View
	local v9 = {
		tag = {
			["auto-y size-full-0"] = true,
			["row align-y-center gap-small"] = FFlagEnableFlyoutUncheckedBadge
		},
		LayoutOrder = props.layoutOrder
	}

	local createElement2 = React.createElement
	local automaticSize

	if FFlagEnableFlyoutUncheckedBadge then
		automaticSize = Enum.AutomaticSize.Y
	else
		automaticSize = Enum.AutomaticSize.XY
	end

	local v10 = {
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		AutomaticSize = automaticSize,
		LayoutOrder = FFlagEnableFlyoutUncheckedBadge and 1 or nil,
		[React.Event.Activated] = v5
	}
	local tag = React.Tag
	local v11

	if FFlagLuaAppAddTestIdsForArrow then
		v11 = getTestId("core-ui-flyout-profile-card")
	end

	v10[tag] = v11
	local uiPadding

	if FFlagEnableDrawerFocusNav then
		uiPadding = React.createElement("UIPadding", { PaddingRight = UDim.new(0, v.Padding.Small) })
	end

	local uiFlexItem

	if FFlagEnableFlyoutUncheckedBadge then
		uiFlexItem = React.createElement("UIFlexItem", { FlexMode = Enum.UIFlexMode.Fill })
	end

	local children = {
		UIPadding = uiPadding,
		UIFlexItem = uiFlexItem,
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v.Gap.Medium)
		}),
		UserAvatar = React.createElement(LoadableImage, {
			Size = UDim2.new(0, v.Size.Size_1600, 0, v.Size.Size_1600),
			BackgroundColor3 = v.Color.Common.Shimmer.Color3,
			BackgroundTransparency = v.Color.Common.Shimmer.Transparency,
			Image = image,
			useShimmerAnimationWhileLoading = true,
			cornerRadius = UDim.new(0.5, 0),
			shouldHandleReloads = true,
			LayoutOrder = 1
		}),
		UserInfoContainer = 0
	}

	local createElement3 = React.createElement
	local view2 = Foundation.View

	local createElement4 = React.createElement
	local view3 = Foundation.View

	local v13 = {
		DisplayNameText = React.createElement(Text, {
			tag = {
				["auto-xy text-title-medium content-emphasis text-align-x-left"] = true,
				["shrink text-truncate-split"] = FFlagEnableFlyoutUncheckedBadge
			},
			Text = displayName,
			LayoutOrder = 1
		}),
		PremiumIcon = 0,
		SubscriberBadge = 0
	}
	local premiumIcon

	if v8 then
		premiumIcon = React.createElement(Icon, {
			style = v.Color.Content.Emphasis,
			name = BuilderIcons.Icon.Premium,
			size = IconSize.Small,
			LayoutOrder = 2
		})
	end

	v13.PremiumIcon = premiumIcon
	local subscriberBadge

	if v7 then
		subscriberBadge = React.createElement(Icon, {
			style = v.Color.Content.Emphasis,
			name = IconName.RobloxPlus,
			size = IconSize.Small,
			LayoutOrder = 3
		})
	end

	v13.SubscriberBadge = subscriberBadge
	children.UserInfoContainer = createElement3(view2, {
		tag = {
			col = true,
			["fill auto-y"] = FFlagEnableFlyoutUncheckedBadge,
			["position-center-left anchor-center-left auto-xy"] = not FFlagEnableFlyoutUncheckedBadge
		},
		LayoutOrder = 2
	}, {
		UsernameContainer = createElement4(view3, {
			tag = {
				["row gap-xsmall"] = true,
				["size-full-0 auto-y"] = FFlagEnableFlyoutUncheckedBadge,
				["position-center-left anchor-center-left auto-xy"] = not FFlagEnableFlyoutUncheckedBadge
			},
			LayoutOrder = 1
		}, v13),
		UserName = React.createElement(Text, {
			tag = {
				["text-body-medium content-default text-align-x-left"] = true,
				["size-full-0 auto-y text-truncate-split"] = FFlagEnableFlyoutUncheckedBadge,
				["auto-xy"] = not FFlagEnableFlyoutUncheckedBadge
			},
			Text = "@" .. name,
			LayoutOrder = 2
		})
	})
	local v12 = {
		ProfileCardButton = createElement2("TextButton", v10, children),
		UncheckedBadge = 0,
		SwitchAccountButton = 0
	}
	local uncheckedBadge

	if FFlagEnableFlyoutUncheckedBadge and v3 then
		uncheckedBadge = React.createElement(Badge, {
			text = v2.Unchecked,
			variant = BadgeVariant.Neutral,
			LayoutOrder = 2
		})
	end

	v12.UncheckedBadge = uncheckedBadge
	local switchAccountButton

	if props.onSwitchAccountActivated then
		switchAccountButton = React.createElement(ChevronSmallDownButton, {
			onActivated = onActivated,
			layoutOrder = FFlagEnableFlyoutUncheckedBadge and 3 or nil
		})
	end

	v12.SwitchAccountButton = switchAccountButton
	return createElement(view, v9, v12)
end

return FlyoutProfileCard
