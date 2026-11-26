local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Foundation")
local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/BuilderIcons")
local getStandardSizeAvatarHeadShotRbxthumb = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/UserLib").Utils.getStandardSizeAvatarHeadShotRbxthumb
local badge = Foundation.Badge
local badgeVariant = Foundation.Enums.BadgeVariant
local icon = Foundation.Icon
local iconSize = Foundation.Enums.IconSize
local iconName = Foundation.Enums.IconName
local text = Foundation.Text
local useTokens = Foundation.Hooks.useTokens
local loadableImage = UIBlox.App.Loading.LoadableImage
local FlyoutAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Analytics/FlyoutAnalytics")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RobloxAppHooks").useRoactService
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RoactServiceTags").AppEventIngestService
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/UniversalAppPolicy").useAppPolicy
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/Localization").Hooks.useLocalization

local ChevronSmallDownButton = require("@game/CorePackages/Workspace/Packages/_Index/FlyoutSidePanel/FlyoutSidePanel/Components/ChevronSmallDownButton")

local getTestId = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/RoactUtils").getTestId
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/FlyoutSidePanel/SharedFlags")

local fFlagLuaAppAddTestIdsForArrow = SharedFlags.FFlagLuaAppAddTestIdsForArrow
local fFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck
local fFlagHidePremiumIconography = SharedFlags.FFlagHidePremiumIconography
local fFlagEnableFlyoutUncheckedBadge = SharedFlags.FFlagEnableFlyoutUncheckedBadge
local fFlagEnableDrawerFocusNav = SharedFlags.FFlagEnableDrawerFocusNav
local fFlagFlyoutSidePanelUseProfileFrameThumbnail = SharedFlags.FFlagFlyoutSidePanelUseProfileFrameThumbnail

local function FlyoutProfileCard(props)
	local v5 = useTokens()
	local v6

	if fFlagEnableFlyoutUncheckedBadge then
		v6 = useLocalization({ Unchecked = "CommonUI.Features.Label.Unchecked" })
	end

	local v7

	if fFlagEnableFlyoutUncheckedBadge then
		v7 = useAppPolicy(function(p2)
			return p2.getShowUncheckedBadge()
		end)
	end

	local v8 = useRoactService(appEventIngestService)
	local localUserModel = props.localUserModel
	local v9 = React.useCallback(function()
		props.closeDrawer()

		if props.onProfileActivated then
			props.onProfileActivated()
			local id = localUserModel and localUserModel.id or ""
			FlyoutAnalytics.sendMoreLegacyAndFlyoutItemClickEvent(v8, "Profile", id)
		end
	end, { localUserModel, props.onProfileActivated, props.closeDrawer, v8 })
	local v10 = React.useCallback(function()
		props.closeDrawer()

		if props.onSwitchAccountActivated then
			props.onSwitchAccountActivated()
		end
	end, { props.onSwitchAccountActivated, props.closeDrawer })

	local v11 = React.useMemo(function()
		if localUserModel and localUserModel.id then
			return getStandardSizeAvatarHeadShotRbxthumb(
				localUserModel.id,
				fFlagFlyoutSidePanelUseProfileFrameThumbnail
			)
		end

		return nil
	end, { localUserModel })
	local v12 = React.useMemo(function()
		return localUserModel and localUserModel.membership == Enum.MembershipType.Premium
	end, { localUserModel })
	local name = localUserModel and localUserModel.name or ""
	local displayName = localUserModel and localUserModel.displayName or ""
	local v13 = if fFlagEnableBlackbirdCheck then props.isRobloxSubscriber == true else false
	local v14 = not fFlagHidePremiumIconography and (v12 and not v13)
	local createElement = React.createElement
	local view = Foundation.View
	local v15 = {
		tag = {
			["auto-y size-full-0"] = true,
			["row align-y-center gap-small"] = fFlagEnableFlyoutUncheckedBadge
		},
		LayoutOrder = props.layoutOrder
	}

	local createElement2 = React.createElement

	local v19 = if fFlagEnableFlyoutUncheckedBadge then Enum.AutomaticSize.Y else Enum.AutomaticSize.XY
	local v18 = {
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		AutomaticSize = v19,
		LayoutOrder = fFlagEnableFlyoutUncheckedBadge and 1 or nil,
		[React.Event.Activated] = v9
	}
	local tag = React.Tag
	local v20 = if fFlagLuaAppAddTestIdsForArrow then getTestId("core-ui-flyout-profile-card") else nil
	v18[tag] = v20

	local v21 = if fFlagEnableDrawerFocusNav then React.createElement("UIPadding", {
		PaddingRight = UDim.new(0, v5.Padding.Small)
	}) else nil

	local v22 = if fFlagEnableFlyoutUncheckedBadge then React.createElement("UIFlexItem", {
		FlexMode = Enum.UIFlexMode.Fill
	}) else nil
	local children = {
		UIPadding = v21,
		UIFlexItem = v22,
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v5.Gap.Medium)
		}),
		UserAvatar = React.createElement(loadableImage, {
			Size = UDim2.new(0, v5.Size.Size_1600, 0, v5.Size.Size_1600),
			BackgroundColor3 = v5.Color.Common.Shimmer.Color3,
			BackgroundTransparency = v5.Color.Common.Shimmer.Transparency,
			Image = v11,
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

	local v25 = {
		DisplayNameText = React.createElement(text, {
			tag = {
				["auto-xy text-title-medium content-emphasis text-align-x-left"] = true,
				["shrink text-truncate-split"] = fFlagEnableFlyoutUncheckedBadge
			},
			Text = displayName,
			LayoutOrder = 1
		}),
		PremiumIcon = 0,
		SubscriberBadge = 0
	}

	local v26 = if v14 then React.createElement(icon, {
		style = v5.Color.Content.Emphasis,
		name = BuilderIcons.Icon.Premium,
		size = iconSize.Small,
		LayoutOrder = 2
	}) else nil
	v25.PremiumIcon = v26

	local v27 = if v13 then React.createElement(icon, {
		style = v5.Color.Content.Emphasis,
		name = iconName.RobloxPlus,
		size = iconSize.Small,
		LayoutOrder = 3
	}) else nil
	v25.SubscriberBadge = v27
	children.UserInfoContainer = createElement3(view2, {
		tag = {
			col = true,
			["fill auto-y"] = fFlagEnableFlyoutUncheckedBadge,
			["position-center-left anchor-center-left auto-xy"] = not fFlagEnableFlyoutUncheckedBadge
		},
		LayoutOrder = 2
	}, {
		UsernameContainer = createElement4(view3, {
			tag = {
				["row gap-xsmall"] = true,
				["size-full-0 auto-y"] = fFlagEnableFlyoutUncheckedBadge,
				["position-center-left anchor-center-left auto-xy"] = not fFlagEnableFlyoutUncheckedBadge
			},
			LayoutOrder = 1
		}, v25),
		UserName = React.createElement(text, {
			tag = {
				["text-body-medium content-default text-align-x-left"] = true,
				["size-full-0 auto-y text-truncate-split"] = fFlagEnableFlyoutUncheckedBadge,
				["auto-xy"] = not fFlagEnableFlyoutUncheckedBadge
			},
			Text = "@" .. name,
			LayoutOrder = 2
		})
	})
	local v16 = {
		ProfileCardButton = createElement2("TextButton", v18, children),
		UncheckedBadge = 0,
		SwitchAccountButton = 0
	}

	local v28 = if fFlagEnableFlyoutUncheckedBadge and v7 then React.createElement(badge, {
		text = v6.Unchecked,
		variant = badgeVariant.Neutral,
		LayoutOrder = 2
	}) else nil
	v16.UncheckedBadge = v28

	local v29 = if props.onSwitchAccountActivated then React.createElement(ChevronSmallDownButton, {
		onActivated = v10,
		layoutOrder = fFlagEnableFlyoutUncheckedBadge and 3 or nil
	}) else nil
	v16.SwitchAccountButton = v29
	return createElement(view, v15, v16)
end

return FlyoutProfileCard
