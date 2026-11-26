local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileCard/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileCard/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileCard/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileCard/React")
local flyoutAccountSwitcherIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileCard/SharedExperimentDefinition").FlyoutAccountSwitcherIXP
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileCard/SharedFlags")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileCard/UIBlox")
local UniversalAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileCard/UniversalAppPolicy")
local getStandardSizeAvatarHeadShotRbxthumb = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileCard/UserLib").Utils.getStandardSizeAvatarHeadShotRbxthumb

local badge = Foundation.Badge
local badgeVariant = Foundation.Enums.BadgeVariant
local icon = Foundation.Icon
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local loadableImage = UIBlox.App.Loading.LoadableImage
local text = Foundation.Text
local view = Foundation.View
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens

local fFlagEnableFlyoutUncheckedBadge = SharedFlags.FFlagEnableFlyoutUncheckedBadge
local fFlagEnableDrawerFocusNav = SharedFlags.FFlagEnableDrawerFocusNav
local fFlagHidePremiumIconography = SharedFlags.FFlagHidePremiumIconography
local fFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck

local function ProfileCard(props)
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

	local localUserModel = props.localUserModel
	local v8 = React.useMemo(function()
		if localUserModel and localUserModel.id then
			return getStandardSizeAvatarHeadShotRbxthumb(
				localUserModel.id,
				props.useProfileFrameThumbnail == true
			)
		end

		return nil
	end, { localUserModel, props.useProfileFrameThumbnail })
	local v9 = React.useMemo(function()
		return localUserModel and localUserModel.membership == Enum.MembershipType.Premium
	end, { localUserModel })
	local v10 = if props.isCompact then v5.Size.Size_1000 else v5.Size.Size_1600
	local name = localUserModel and localUserModel.name or ""
	local displayName = localUserModel and localUserModel.displayName or ""
	local v11 = if fFlagEnableBlackbirdCheck then props.isRobloxSubscriber == true else false
	local v12 = not fFlagHidePremiumIconography and (v9 and not v11)
	local onProfileActivated = props.onProfileActivated
	local v13 = React.useCallback(function()
		if onProfileActivated then
			onProfileActivated()
		end
	end, { onProfileActivated })
	local v14

	if props.onSwitchAccountActivated == nil then
		v14 = false
	else
		v14 = flyoutAccountSwitcherIXP.isProfileHandleEnabled()
	end

	local v15

	if props.onSwitchAccountActivated == nil then
		v15 = false
	else
		v15 = flyoutAccountSwitcherIXP.isProfileIconButtonEnabled()
	end

	local v16 = React.createElement(loadableImage, {
		Size = UDim2.fromOffset(v10, v10),
		BackgroundColor3 = v5.Color.Common.Shimmer.Color3,
		BackgroundTransparency = v5.Color.Common.Shimmer.Transparency,
		Image = v8,
		useShimmerAnimationWhileLoading = true,
		cornerRadius = UDim.new(0.5, 0),
		shouldHandleReloads = true,
		LayoutOrder = 1
	})

	local createElement = React.createElement
	local v18 = {
		tag = {
			["size-full-0 auto-y"] = true,
			["row align-y-center gap-small"] = fFlagEnableFlyoutUncheckedBadge or v15,
			["padding-y-medium"] = props.isCompact == true
		},
		LayoutOrder = props.layoutOrder
	}

	local createElement2 = React.createElement
	local v21 = {
		["AutoButtonColor"] = nil,
		["AutoButtonColor"] = nil,
		["AutoButtonColor"] = nil,
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		Active = not v14 and onProfileActivated ~= nil,
		Selectable = not v14 and onProfileActivated ~= nil
	}

	local v24 = if fFlagEnableFlyoutUncheckedBadge then Enum.AutomaticSize.Y else Enum.AutomaticSize.XY
	v21.AutomaticSize = v24
	v21.LayoutOrder = (fFlagEnableFlyoutUncheckedBadge or v15) and 1 or nil
	local activated = React.Event.Activated

	if v14 then
		v13 = nil
	end

	v21[activated] = v13
	local tag = React.Tag
	local v25 = if props.testId then `data-testid={props.testId}` else nil
	v21[tag] = v25

	local v26 = if fFlagEnableDrawerFocusNav then React.createElement("UIPadding", {
		PaddingRight = UDim.new(0, v5.Padding.Small)
	}) else nil

	local v27 = if fFlagEnableFlyoutUncheckedBadge then React.createElement("UIFlexItem", {
		FlexMode = Enum.UIFlexMode.Fill
	}) else nil
	local children = {
		UIPadding = v26,
		UIFlexItem = v27,
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v5.Gap.Medium)
		}),
		UserAvatar = 0,
		UserInfoContainer = 0
	}

	if v14 then
		v16 = React.createElement(view, {
			tag = "auto-xy radius-circle",
			LayoutOrder = 1,
			onActivated = onProfileActivated,
			testId = "profile-card-avatar",
			selection = { Selectable = false }
		}, { Image = v16 })
	end

	children.UserAvatar = v16

	local createElement3 = React.createElement
	local v29 = {
		tag = {
			col = true,
			["gap-xsmall"] = props.isCompact == true,
			["fill auto-y"] = fFlagEnableFlyoutUncheckedBadge,
			["position-center-left anchor-center-left auto-xy"] = not fFlagEnableFlyoutUncheckedBadge
		},
		LayoutOrder = 2
	}

	local createElement4 = React.createElement

	local v34 = {
		DisplayNameText = React.createElement(text, {
			tag = {
				["text-title-medium text-align-x-left content-emphasis"] = true,
				["auto-xy"] = not v14,
				["size-0-500 auto-x"] = v14,
				["shrink text-truncate-split"] = fFlagEnableFlyoutUncheckedBadge
			},
			Text = displayName,
			LayoutOrder = 1
		}),
		PremiumIcon = 0,
		SubscriberBadge = 0
	}

	local v35 = if v12 then React.createElement(icon, {
		style = v5.Color.Content.Emphasis,
		name = BuilderIcons.Icon.Premium,
		size = iconSize.Small,
		LayoutOrder = 2,
		testId = "profile-card-premium-icon"
	}) else nil
	v34.PremiumIcon = v35

	local v36 = if v11 then React.createElement(icon, {
		style = v5.Color.Content.Emphasis,
		name = iconName.RobloxPlus,
		size = iconSize.Small,
		LayoutOrder = 3,
		testId = "profile-card-subscriber-icon"
	}) else nil
	v34.SubscriberBadge = v36
	local v30 = {
		UsernameContainer = createElement4(view, {
			tag = {
				["row gap-xsmall"] = true,
				["size-full-0 auto-y"] = fFlagEnableFlyoutUncheckedBadge and not v14,
				["shrink auto-xy"] = fFlagEnableFlyoutUncheckedBadge and v14,
				["position-center-left anchor-center-left auto-xy"] = not fFlagEnableFlyoutUncheckedBadge
			},
			LayoutOrder = 1,
			onActivated = if v14 then onProfileActivated else nil,
			testId = "profile-card-display-name"
		}, v34),
		UserName = 0,
		HandleRow = 0
	}

	local v37 = if not v14 then React.createElement(text, {
		tag = {
			["text-body-medium text-align-x-left content-default"] = true,
			["size-full-0 auto-y text-truncate-split"] = fFlagEnableFlyoutUncheckedBadge,
			["auto-xy"] = not fFlagEnableFlyoutUncheckedBadge
		},
		Text = "@" .. name,
		LayoutOrder = 2
	}) else nil
	v30.UserName = v37
	local v38

	if v14 then
		local createElement5 = React.createElement
		local v40 = {
			tag = "row align-y-center shrink gap-xsmall auto-xy",
			LayoutOrder = 2,
			onActivated = props.onSwitchAccountActivated,
			testId = "profile-card-switch-account-handle"
		}

		local v41 = {
			UserName = React.createElement(text, {
				tag = "shrink size-0-500 auto-x text-body-medium text-align-x-left text-truncate-split content-default",
				Text = "@" .. name,
				LayoutOrder = 1
			}),
			SwitchAccountChevron = 0
		}

		local v42 = if props.onSwitchAccountActivated then React.createElement(icon, {
			tag = "auto-xy content-emphasis padding-medium",
			name = BuilderIcons.Icon.ChevronLargeDown,
			size = iconSize.Small,
			LayoutOrder = 2,
			testId = "profile-card-switch-account-chevron",
			ref = props.switchAccountAnchorRef
		}) else nil
		v41.SwitchAccountChevron = v42
		v38 = createElement5(view, v40, v41)
	end

	v30.HandleRow = v38
	children.UserInfoContainer = createElement3(view, v29, v30)
	local v19 = {
		ProfileCardButton = createElement2("TextButton", v21, children),
		UncheckedBadge = 0,
		SwitchAccountChevron = 0
	}

	local v39 = if fFlagEnableFlyoutUncheckedBadge and v7 then React.createElement(badge, {
		text = v6.Unchecked,
		variant = badgeVariant.Neutral,
		LayoutOrder = 2
	}) else nil
	v19.UncheckedBadge = v39

	local v40 = if v15 then React.createElement(view, {
		tag = "auto-xy padding-small radius-circle",
		LayoutOrder = 3,
		onActivated = props.onSwitchAccountActivated,
		testId = "profile-card-switch-account-chevron",
		ref = props.switchAccountAnchorRef
	}, {
		Icon = React.createElement(icon, {
			tag = "auto-xy content-emphasis",
			name = BuilderIcons.Icon.ChevronLargeDown,
			size = iconSize.Large
		})
	}) else nil
	v19.SwitchAccountChevron = v40
	return createElement(view, v18, v19)
end

return React.memo(ProfileCard)
