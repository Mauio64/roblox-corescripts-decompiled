local parent = script:FindFirstAncestor("ProfileCard").Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)
local SharedExperimentDefinition = require(parent.SharedExperimentDefinition)
local FlyoutAccountSwitcherIXP = SharedExperimentDefinition.FlyoutAccountSwitcherIXP
local SharedFlags = require(parent.SharedFlags)
local UIBlox = require(parent.UIBlox)
local UniversalAppPolicy = require(parent.UniversalAppPolicy)
local UserLib = require(parent.UserLib)
local getStandardSizeAvatarHeadShotRbxthumb = UserLib.Utils.getStandardSizeAvatarHeadShotRbxthumb

local Badge = Foundation.Badge
local BadgeVariant = Foundation.Enums.BadgeVariant
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local LoadableImage = UIBlox.App.Loading.LoadableImage
local Text = Foundation.Text
local View = Foundation.View
local useAppPolicy = UniversalAppPolicy.useAppPolicy
local useLocalization = Localization.Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens

local FFlagEnableFlyoutUncheckedBadge = SharedFlags.FFlagEnableFlyoutUncheckedBadge
local FFlagEnableDrawerFocusNav = SharedFlags.FFlagEnableDrawerFocusNav
local FFlagHidePremiumIconography = SharedFlags.FFlagHidePremiumIconography
local FFlagEnableBlackbirdCheck = SharedFlags.FFlagEnableBlackbirdCheck

local function ProfileCard(props)
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

	local localUserModel = props.localUserModel
	local image = React.useMemo(function()
		if localUserModel and localUserModel.id then
			return getStandardSizeAvatarHeadShotRbxthumb(localUserModel.id, props.useProfileFrameThumbnail == true)
		end

		return nil
	end, { localUserModel, props.useProfileFrameThumbnail })
	local v4 = React.useMemo(function()
		return localUserModel and localUserModel.membership == Enum.MembershipType.Premium
	end, { localUserModel })
	local v5

	if props.isCompact then
		v5 = v.Size.Size_1000
	else
		v5 = v.Size.Size_1600
	end

	local name = localUserModel and localUserModel.name or ""
	local displayName = localUserModel and localUserModel.displayName or ""
	local v6

	if FFlagEnableBlackbirdCheck then
		v6 = props.isRobloxSubscriber == true
	else
		v6 = false
	end

	local v7

	if FFlagHidePremiumIconography then
		v7 = false
	else
		v7 = v4 and not v6
	end

	local onProfileActivated = props.onProfileActivated
	local v8 = React.useCallback(function()
		if onProfileActivated then
			onProfileActivated()
		end
	end, { onProfileActivated })
	local size0500autox

	if props.onSwitchAccountActivated == nil then
		size0500autox = false
	else
		size0500autox = FlyoutAccountSwitcherIXP.isProfileHandleEnabled()
	end

	local v9

	if props.onSwitchAccountActivated == nil then
		v9 = false
	else
		v9 = FlyoutAccountSwitcherIXP.isProfileIconButtonEnabled()
	end

	local v10 = React.createElement(LoadableImage, {
		Size = UDim2.fromOffset(v5, v5),
		BackgroundColor3 = v.Color.Common.Shimmer.Color3,
		BackgroundTransparency = v.Color.Common.Shimmer.Transparency,
		Image = image,
		useShimmerAnimationWhileLoading = true,
		cornerRadius = UDim.new(0.5, 0),
		shouldHandleReloads = true,
		LayoutOrder = 1
	})

	local createElement = React.createElement
	local v11 = {
		tag = {
			["size-full-0 auto-y"] = true,
			["row align-y-center gap-small"] = FFlagEnableFlyoutUncheckedBadge or v9,
			["padding-y-medium"] = props.isCompact == true
		},
		LayoutOrder = props.layoutOrder
	}

	local createElement2 = React.createElement
	local v12 = {
		["AutoButtonColor"] = nil,
		["AutoButtonColor"] = nil,
		["AutoButtonColor"] = nil,
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		Active = not size0500autox and onProfileActivated ~= nil,
		Selectable = not size0500autox and onProfileActivated ~= nil
	}
	local automaticSize

	if FFlagEnableFlyoutUncheckedBadge then
		automaticSize = Enum.AutomaticSize.Y
	else
		automaticSize = Enum.AutomaticSize.XY
	end

	v12.AutomaticSize = automaticSize
	v12.LayoutOrder = (FFlagEnableFlyoutUncheckedBadge or v9) and 1 or nil
	local activated = React.Event.Activated

	if size0500autox then
		v8 = nil
	end

	v12[activated] = v8
	local tag = React.Tag
	local v13

	if props.testId then
		v13 = `data-testid={props.testId}`
	end

	v12[tag] = v13
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
		UserAvatar = 0,
		UserInfoContainer = 0
	}

	if size0500autox then
		v10 = React.createElement(View, {
			tag = "auto-xy radius-circle",
			LayoutOrder = 1,
			onActivated = onProfileActivated,
			testId = "profile-card-avatar",
			selection = { Selectable = false }
		}, { Image = v10 })
	end

	children.UserAvatar = v10

	local createElement3 = React.createElement
	local v15 = {
		tag = {
			col = true,
			["gap-xsmall"] = props.isCompact == true,
			["fill auto-y"] = FFlagEnableFlyoutUncheckedBadge,
			["position-center-left anchor-center-left auto-xy"] = not FFlagEnableFlyoutUncheckedBadge
		},
		LayoutOrder = 2
	}

	local createElement4 = React.createElement
	local v16 = {
		tag = {
			["row gap-xsmall"] = true,
			["size-full-0 auto-y"] = FFlagEnableFlyoutUncheckedBadge and not size0500autox,
			["shrink auto-xy"] = FFlagEnableFlyoutUncheckedBadge and size0500autox,
			["position-center-left anchor-center-left auto-xy"] = not FFlagEnableFlyoutUncheckedBadge
		},
		LayoutOrder = 1,
		onActivated = 0,
		testId = "profile-card-display-name"
	}
	local onActivated

	if size0500autox then
		onActivated = onProfileActivated
	end

	v16.onActivated = onActivated

	local v17 = {
		DisplayNameText = React.createElement(Text, {
			tag = {
				["text-title-medium text-align-x-left content-emphasis"] = true,
				["auto-xy"] = not size0500autox,
				["size-0-500 auto-x"] = size0500autox,
				["shrink text-truncate-split"] = FFlagEnableFlyoutUncheckedBadge
			},
			Text = displayName,
			LayoutOrder = 1
		}),
		PremiumIcon = 0,
		SubscriberBadge = 0
	}
	local premiumIcon

	if v7 then
		premiumIcon = React.createElement(Icon, {
			style = v.Color.Content.Emphasis,
			name = BuilderIcons.Icon.Premium,
			size = IconSize.Small,
			LayoutOrder = 2,
			testId = "profile-card-premium-icon"
		})
	end

	v17.PremiumIcon = premiumIcon
	local subscriberBadge

	if v6 then
		subscriberBadge = React.createElement(Icon, {
			style = v.Color.Content.Emphasis,
			name = IconName.RobloxPlus,
			size = IconSize.Small,
			LayoutOrder = 3,
			testId = "profile-card-subscriber-icon"
		})
	end

	v17.SubscriberBadge = subscriberBadge
	local v18 = { UsernameContainer = createElement4(View, v16, v17), UserName = 0, HandleRow = 0 }
	local userName

	if not size0500autox then
		userName = React.createElement(Text, {
			tag = {
				["text-body-medium text-align-x-left content-default"] = true,
				["size-full-0 auto-y text-truncate-split"] = FFlagEnableFlyoutUncheckedBadge,
				["auto-xy"] = not FFlagEnableFlyoutUncheckedBadge
			},
			Text = "@" .. name,
			LayoutOrder = 2
		})
	end

	v18.UserName = userName
	local handleRow

	if size0500autox then
		local createElement5 = React.createElement
		local v14 = {
			tag = "row align-y-center shrink gap-xsmall auto-xy",
			LayoutOrder = 2,
			onActivated = props.onSwitchAccountActivated,
			testId = "profile-card-switch-account-handle"
		}

		local v19 = {
			UserName = React.createElement(Text, {
				tag = "shrink size-0-500 auto-x text-body-medium text-align-x-left text-truncate-split content-default",
				Text = "@" .. name,
				LayoutOrder = 1
			}),
			SwitchAccountChevron = 0
		}
		local switchAccountChevron

		if props.onSwitchAccountActivated then
			switchAccountChevron = React.createElement(Icon, {
				tag = "auto-xy content-emphasis padding-medium",
				name = BuilderIcons.Icon.ChevronLargeDown,
				size = IconSize.Small,
				LayoutOrder = 2,
				testId = "profile-card-switch-account-chevron",
				ref = props.switchAccountAnchorRef
			})
		end

		v19.SwitchAccountChevron = switchAccountChevron
		handleRow = createElement5(View, v14, v19)
	end

	v18.HandleRow = handleRow
	children.UserInfoContainer = createElement3(View, v15, v18)
	local v14 = {
		ProfileCardButton = createElement2("TextButton", v12, children),
		UncheckedBadge = 0,
		SwitchAccountChevron = 0
	}
	local uncheckedBadge

	if FFlagEnableFlyoutUncheckedBadge and v3 then
		uncheckedBadge = React.createElement(Badge, {
			text = v2.Unchecked,
			variant = BadgeVariant.Neutral,
			LayoutOrder = 2
		})
	end

	v14.UncheckedBadge = uncheckedBadge
	local switchAccountChevron

	if v9 then
		switchAccountChevron = React.createElement(View, {
			tag = "auto-xy padding-small radius-circle",
			LayoutOrder = 3,
			onActivated = props.onSwitchAccountActivated,
			testId = "profile-card-switch-account-chevron",
			ref = props.switchAccountAnchorRef
		}, {
			Icon = React.createElement(Icon, {
				tag = "auto-xy content-emphasis",
				name = BuilderIcons.Icon.ChevronLargeDown,
				size = IconSize.Large
			})
		})
	end

	v14.SwitchAccountChevron = switchAccountChevron
	return createElement(View, v11, v14)
end

return React.memo(ProfileCard)
