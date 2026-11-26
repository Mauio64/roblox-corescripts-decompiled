local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Localization").Hooks.useLocalization

local VerifiedBadges = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/VerifiedBadges")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox")
local horizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin
local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local images = UIBlox.App.ImageSet.Images
local tooltip = UIBlox.App.Dialog.Tooltip
local tooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local openTypeSupport = UIBlox.Utility.OpenTypeSupport
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local view = Foundation.View
local text = Foundation.Text
local icon = Foundation.Icon
local useTokens = Foundation.Hooks.useTokens
local enums = Foundation.Enums
local stateLayerAffordance = enums.StateLayerAffordance
local iconSize2 = enums.IconSize

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils").Hooks.RoactRodux.useDispatch

local contexts = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialLuaAnalytics").Analytics.Enums.Contexts
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local useProfileAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileAnalyticsContext")

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ExternalContentSharingProtocol").ExternalContentSharingProtocol.default
local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ToastRodux").Actions.SetCurrentToastMessage

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")

local FFlagProfilePlatformEnableClickToCopyUsername = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableClickToCopyUsername")

local fFlagEnableFontStylisticAlternativesOnSocialScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnableFontStylisticAlternativesOnSocialScreens
local getFFlagLuaAppEnableOpenTypeSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").GetFFlagLuaAppEnableOpenTypeSupport

local FFlagProfilePlatformEnableRobloxAdminBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableRobloxAdminBadge")
local fFlagEnableBlackbirdCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnableBlackbirdCheck
local fFlagHidePremiumIconography = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagHidePremiumIconography
local fFlagAddPlatformNameToProfileHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAddPlatformNameToProfileHeader
local fFlagDisableCopyUsernameOnConsole = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagDisableCopyUsernameOnConsole
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Responsive")
local getBuilderIconForCurrentPlatform = Foundation.Utility.getBuilderIconForCurrentPlatform

local FFlagProfilePlatformTruncateLongCustomFriendNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformTruncateLongCustomFriendNames")

local iconsactionseditcopy = if FFlagProfilePlatformEnableClickToCopyUsername then images["icons/actions/edit/copy"] else nil

local function SocialIdentity(props)
	local v5 = useTokens()
	local v6 = React.useMemo(function()
		if fFlagAddPlatformNameToProfileHeader then
			return (getBuilderIconForCurrentPlatform())
		end

		return nil
	end, {})
	local v7

	if props.isEdited then
		v7 = images["icons/actions/edit/editOn_small"]
	else
		v7 = images["icons/actions/edit/edit_small"]
	end

	local v8 = if FFlagProfilePlatformEnableClickToCopyUsername then useDispatch() else nil

	local v9 = if FFlagProfilePlatformEnableClickToCopyUsername then useProfileAnalyticsContext() else nil
	local v10

	if fFlagDisableCopyUsernameOnConsole then
		v10 = Responsive.usePreferredInput() == Responsive.Input.Directional
	else
		v10 = false
	end

	local v11 = (props.primaryName .. ((fFlagHidePremiumIconography or not props.isPremium or fFlagEnableBlackbirdCheck and props.isRobloxSubscriber == true) and "" or VerifiedBadges.emoji.premium)) .. (not props.isVerified and "" or VerifiedBadges.emoji.verified)

	local formatted = `@{props.username}`

	local v14 = if not props.isLocalUser then TextKeys.AliasTooltipHeader else nil
	local v15 = if props.isLocalUser then TextKeys.DisplayNameTooltipBody else TextKeys.AliasTooltipBody
	local v16 = if FFlagProfilePlatformEnableClickToCopyUsername then TextKeys.UsernameCopied else nil
	local v17 = useLocalization({
		tooltipTitle = v14,
		tooltipBody = v15,
		usernameCopied = v16,
		trustedLabel = TextKeys.TrustedLabel
	})
	local v18

	if FFlagProfilePlatformEnableClickToCopyUsername then
		v18 = React.useCallback(function()
			default:setClipboardText({
				context = contexts.ProfileCard,
				text = props.username
			})

			v9.fireAnalyticsEvent(EventNames.UsernameCopied)
			v8(setCurrentToastMessage({
				toastMessage = v17.usernameCopied,
				isLocalized = true,
				toastIcon = iconsactionseditcopy
			}))
		end, { props.username, v9, v17.usernameCopied })
	end

	local v19 = not props.isTrustedConnection and "" or ` • {v17.trustedLabel}`

	local v20 = React.useCallback(function()
		if props.openEditName then
			props.openEditName()
		end

		props.dismissTooltip()
	end)

	local createElement = React.createElement
	local v22 = {
		size = props.size,
		layoutOrder = props.layoutOrder,
		useAutomaticSizing = true,
		backgroundTransparency = 1
	}

	local v23 = {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		PrimaryNameFrame = 0,
		Username = 0,
		PlatformName = 0
	}
	local v24

	if FFlagProfilePlatformTruncateLongCustomFriendNames then
		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local v31

		if props.openEditName then
			local createElement4 = React.createElement
			local v33 = {
				icon = v7,
				iconSize = iconSize.Small,
				size = UDim2.fromOffset(26, 26),
				layoutOrder = 1,
				onActivated = v20
			}

			local v35 = if props.isTooltipActive then React.createElement(tooltip, {
				triggerPosition = Vector2.new(16, 0),
				triggerSize = Vector2.new(0, 0),
				headerText = v17.tooltipTitle,
				bodyText = v17.tooltipBody,
				orientation = tooltipOrientation.Top,
				forceClickTriggerPoint = true,
				isDirectChild = true
			}) else nil
			v31 = createElement4(iconButton, v33, { tooltip = v35 })
		end

		local v30 = {
			EditNameButton = v31,
			PrimaryName = React.createElement(text, {
				Text = v11,
				tag = "auto-xy text-align-x-left text-align-y-bottom content-emphasis text-truncate-end shrink",
				fontStyle = v5.Typography.HeadingSmall,
				LayoutOrder = 2
			}),
			AdminTiltIcon = 0,
			SubscriptionBadge = 0
		}

		local v32 = if FFlagProfilePlatformEnableRobloxAdminBadge and props.isRobloxAdmin then React.createElement(Foundation.Icon, {
			name = Foundation.Enums.IconName.Tilt,
			size = Foundation.Enums.IconSize.Large,
			LayoutOrder = 3
		}) else nil
		v30.AdminTiltIcon = v32

		local v33 = if fFlagEnableBlackbirdCheck and props.isRobloxSubscriber == true then React.createElement(
			view,
			{ tag = "auto-xy padding-top-xxsmall", LayoutOrder = 4 },
			{
				Icon = React.createElement(Foundation.Icon, {
					name = Foundation.Enums.IconName.RobloxPlus,
					size = Foundation.Enums.IconSize.Small
				})
			}
		) else nil
		v30.SubscriptionBadge = v33
		v24 = createElement2(view, {
			tag = "row align-y-center auto-y size-full-0",
			LayoutOrder = 1
		}, {
			PrimaryNameFrameTouchable = createElement3(
				view,
				{
					tag = "row align-x-left align-y-center auto-xy gap-xxsmall",
					LayoutOrder = 1,
					onActivated = v20
				},
				v30
			)
		})
	else
		local createElement2 = React.createElement
		local v26 = {
			Size = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.Y
		}

		local createElement3 = React.createElement
		local v29 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			Text = "",
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			[React.Event.Activated] = v20,
			Selectable = false
		}

		local createElement4 = React.createElement
		local v31 = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = 0,
			SortOrder = 0
		}
		local v32 = if FFlagProfilePlatformEnableRobloxAdminBadge and props.isRobloxAdmin then Enum.VerticalAlignment.Center else Enum.VerticalAlignment.Bottom
		v31.VerticalAlignment = v32

		v31.SortOrder = Enum.SortOrder.LayoutOrder
		local children = {
			UIListLayout = createElement4("UIListLayout", v31),
			EditNameButton = 0,
			PrimaryName = 0,
			AdminTiltIcon = 0,
			SubscriptionBadge = 0
		}
		local v33

		if props.openEditName then
			local createElement5 = React.createElement
			local v35 = {
				icon = v7,
				iconSize = iconSize.Small,
				size = UDim2.fromOffset(26, 26),
				layoutOrder = 1,
				onActivated = v20
			}

			local v37 = if props.isTooltipActive then React.createElement(tooltip, {
				triggerPosition = Vector2.new(16, 0),
				triggerSize = Vector2.new(0, 0),
				headerText = v17.tooltipTitle,
				bodyText = v17.tooltipBody,
				orientation = tooltipOrientation.Top,
				forceClickTriggerPoint = true,
				isDirectChild = true
			}) else nil
			v33 = createElement5(iconButton, v35, { tooltip = v37 })
		end

		children.EditNameButton = v33

		children.PrimaryName = React.createElement(text, {
			Text = v11,
			tag = "auto-xy text-align-x-left text-align-y-bottom content-emphasis",
			fontStyle = v5.Typography.HeadingSmall,
			LayoutOrder = 2
		})

		local v34 = if FFlagProfilePlatformEnableRobloxAdminBadge and props.isRobloxAdmin then React.createElement(
			"Frame",
			{
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				LayoutOrder = 3
			},
			{
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v5.Gap.XXSmall),
					PaddingBottom = UDim.new(0, v5.Gap.XXSmall)
				}),
				Icon = React.createElement(Foundation.Icon, {
					name = Foundation.Enums.IconName.Tilt,
					size = Foundation.Enums.IconSize.Large
				})
			}
		) else nil
		children.AdminTiltIcon = v34

		local v35 = if fFlagEnableBlackbirdCheck and props.isRobloxSubscriber == true then React.createElement(
			"Frame",
			{
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				LayoutOrder = 4
			},
			{
				UIPadding = React.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, v5.Gap.XXSmall),
					PaddingBottom = UDim.new(0, v5.Gap.XXSmall)
				}),
				Icon = React.createElement(Foundation.Icon, {
					name = Foundation.Enums.IconName.RobloxPlus,
					size = Foundation.Enums.IconSize.Small
				})
			}
		) else nil
		children.SubscriptionBadge = v35
		v24 = createElement2("Frame", v26, {
			PrimaryNameFrameTouchable = createElement3("TextButton", v29, children)
		})
	end

	v23.PrimaryNameFrame = v24

	local createElement2 = React.createElement
	local v26 = {
		RichText = fFlagEnableFontStylisticAlternativesOnSocialScreens and true or nil,
		Text = 0,
		tag = "auto-xy text-align-x-left text-align-y-top",
		fontStyle = 0,
		OpenTypeFeatures = 0,
		LayoutOrder = 2,
		onActivated = 0,
		stateLayer = 0
	}

	local v27 = if fFlagEnableFontStylisticAlternativesOnSocialScreens then `<font features="zero, ss03">{formatted}</font>` .. v19 else formatted .. v19
	v26.Text = v27

	v26.fontStyle = v5.Typography.CaptionMedium

	local v28 = if not (fFlagEnableFontStylisticAlternativesOnSocialScreens or not getFFlagLuaAppEnableOpenTypeSupport()) then openTypeSupport:getUserNameStylisticAlternative() else nil
	v26.OpenTypeFeatures = v28

	if v10 then
		v18 = nil
	end

	v26.onActivated = v18

	local v29 = if not v10 then FFlagProfilePlatformEnableClickToCopyUsername and { affordance = stateLayerAffordance.None } or nil else nil
	v26.stateLayer = v29
	v23.Username = createElement2(text, v26)
	local v30

	if fFlagAddPlatformNameToProfileHeader and props.platformName then
		local createElement3 = React.createElement

		local v34 = if v6 then React.createElement(icon, {
			name = v6,
			size = iconSize2.XSmall,
			LayoutOrder = 1
		}) else nil
		v30 = createElement3(view, {
			tag = "row align-y-center gap-xsmall auto-xy",
			LayoutOrder = 3
		}, {
			PlatformIcon = v34,
			PlatformNameLabel = React.createElement(text, {
				Text = props.platformName,
				tag = "shrink auto-xy text-align-x-left text-align-y-top",
				fontStyle = v5.Typography.CaptionMedium,
				LayoutOrder = 2
			})
		})
	end

	v23.PlatformName = v30
	return createElement(horizontalPageMargin, v22, v23)
end

return SocialIdentity
