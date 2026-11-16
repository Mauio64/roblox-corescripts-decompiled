local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local VerifiedBadges = require(parent.VerifiedBadges)

local UIBlox = require(parent.UIBlox)
local HorizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Images = UIBlox.App.ImageSet.Images
local Tooltip = UIBlox.App.Dialog.Tooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local OpenTypeSupport = UIBlox.Utility.OpenTypeSupport
local Foundation = require(parent.Foundation)
local View = Foundation.View
local Text = Foundation.Text
local Icon = Foundation.Icon
local useTokens = Foundation.Hooks.useTokens
local Enums = Foundation.Enums
local StateLayerAffordance = Enums.StateLayerAffordance
local iconSize = Enums.IconSize

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)

local ExternalContentSharingProtocol = require(parent.ExternalContentSharingProtocol)
local default = ExternalContentSharingProtocol.ExternalContentSharingProtocol.default
local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage

local TextKeys = require(ProfilePlatform.Common.TextKeys)

local FFlagProfilePlatformEnableClickToCopyUsername = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableClickToCopyUsername)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableFontStylisticAlternativesOnSocialScreens = SharedFlags.FFlagEnableFontStylisticAlternativesOnSocialScreens
local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagLuaAppEnableOpenTypeSupport = SharedFlags2.GetFFlagLuaAppEnableOpenTypeSupport

local FFlagProfilePlatformEnableRobloxAdminBadge = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableRobloxAdminBadge)
local SharedFlags3 = require(parent.SharedFlags)
local FFlagEnableBlackbirdCheck = SharedFlags3.FFlagEnableBlackbirdCheck
local SharedFlags4 = require(parent.SharedFlags)
local FFlagHidePremiumIconography = SharedFlags4.FFlagHidePremiumIconography
local SharedFlags5 = require(parent.SharedFlags)
local FFlagAddPlatformNameToProfileHeader = SharedFlags5.FFlagAddPlatformNameToProfileHeader
local SharedFlags6 = require(parent.SharedFlags)
local FFlagDisableCopyUsernameOnConsole = SharedFlags6.FFlagDisableCopyUsernameOnConsole
local Responsive = require(parent.Responsive)
local getBuilderIconForCurrentPlatform = Foundation.Utility.getBuilderIconForCurrentPlatform

local FFlagProfilePlatformTruncateLongCustomFriendNames = require(ProfilePlatform.Flags.FFlagProfilePlatformTruncateLongCustomFriendNames)
local iconsactionseditcopy

if FFlagProfilePlatformEnableClickToCopyUsername then
	iconsactionseditcopy = Images["icons/actions/edit/copy"]
else
	iconsactionseditcopy = nil
end

local function SocialIdentity(props)
	local v = useTokens()
	local name = React.useMemo(function()
		if FFlagAddPlatformNameToProfileHeader then
			return (getBuilderIconForCurrentPlatform())
		end

		return nil
	end, {})
	local icon

	if props.isEdited then
		icon = Images["icons/actions/edit/editOn_small"]
	else
		icon = Images["icons/actions/edit/edit_small"]
	end

	local v2

	if FFlagProfilePlatformEnableClickToCopyUsername then
		v2 = useDispatch()
	else
		v2 = nil
	end

	local v3

	if FFlagProfilePlatformEnableClickToCopyUsername then
		v3 = useProfileAnalyticsContext()
	else
		v3 = nil
	end

	local v4

	if FFlagDisableCopyUsernameOnConsole then
		v4 = Responsive.usePreferredInput() == Responsive.Input.Directional
	else
		v4 = false
	end

	local text = (props.primaryName .. ((FFlagHidePremiumIconography or not props.isPremium or FFlagEnableBlackbirdCheck and props.isRobloxSubscriber == true) and "" or VerifiedBadges.emoji.premium)) .. (not props.isVerified and "" or VerifiedBadges.emoji.verified)

	local formatted = `@{props.username}`
	local tooltipTitle

	if not props.isLocalUser then
		tooltipTitle = TextKeys.AliasTooltipHeader
	end

	local tooltipBody

	if props.isLocalUser then
		tooltipBody = TextKeys.DisplayNameTooltipBody
	else
		tooltipBody = TextKeys.AliasTooltipBody
	end

	local usernameCopied

	if FFlagProfilePlatformEnableClickToCopyUsername then
		usernameCopied = TextKeys.UsernameCopied
	end

	local v5 = useLocalization({
		tooltipTitle = tooltipTitle,
		tooltipBody = tooltipBody,
		usernameCopied = usernameCopied,
		trustedLabel = TextKeys.TrustedLabel
	})
	local onActivated

	if FFlagProfilePlatformEnableClickToCopyUsername then
		onActivated = React.useCallback(function()
			default:setClipboardText({ context = Contexts.ProfileCard, text = props.username })

			v3.fireAnalyticsEvent(EventNames.UsernameCopied)
			v2(SetCurrentToastMessage({
				toastMessage = v5.usernameCopied,
				isLocalized = true,
				toastIcon = iconsactionseditcopy
			}))
		end, { props.username, v3, v5.usernameCopied })
	end

	local v6 = not props.isTrustedConnection and "" or ` • {v5.trustedLabel}`

	local onActivated2 = React.useCallback(function()
		if props.openEditName then
			props.openEditName()
		end

		props.dismissTooltip()
	end)

	local createElement = React.createElement
	local v7 = {
		size = props.size,
		layoutOrder = props.layoutOrder,
		useAutomaticSizing = true,
		backgroundTransparency = 1
	}

	local v8 = {
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
	local primaryNameFrame

	if FFlagProfilePlatformTruncateLongCustomFriendNames then
		local createElement2 = React.createElement

		local createElement3 = React.createElement
		local editNameButton

		if props.openEditName then
			local createElement4 = React.createElement
			local v9 = {
				icon = icon,
				iconSize = IconSize.Small,
				size = UDim2.fromOffset(26, 26),
				layoutOrder = 1,
				onActivated = onActivated2
			}
			local tooltip

			if props.isTooltipActive then
				tooltip = React.createElement(Tooltip, {
					triggerPosition = Vector2.new(16, 0),
					triggerSize = Vector2.new(0, 0),
					headerText = v5.tooltipTitle,
					bodyText = v5.tooltipBody,
					orientation = TooltipOrientation.Top,
					forceClickTriggerPoint = true,
					isDirectChild = true
				})
			end

			editNameButton = createElement4(IconButton, v9, { tooltip = tooltip })
		end

		local v9 = {
			EditNameButton = editNameButton,
			PrimaryName = React.createElement(Text, {
				Text = text,
				tag = "auto-xy text-align-x-left text-align-y-bottom content-emphasis text-truncate-end shrink",
				fontStyle = v.Typography.HeadingSmall,
				LayoutOrder = 2
			}),
			AdminTiltIcon = 0,
			SubscriptionBadge = 0
		}
		local adminTiltIcon

		if FFlagProfilePlatformEnableRobloxAdminBadge and props.isRobloxAdmin then
			adminTiltIcon = React.createElement(Foundation.Icon, {
				name = Foundation.Enums.IconName.Tilt,
				size = Foundation.Enums.IconSize.Large,
				LayoutOrder = 3
			})
		end

		v9.AdminTiltIcon = adminTiltIcon
		local subscriptionBadge

		if FFlagEnableBlackbirdCheck and props.isRobloxSubscriber == true then
			subscriptionBadge = React.createElement(View, {
				tag = "auto-xy padding-top-xxsmall",
				LayoutOrder = 4
			}, {
				Icon = React.createElement(Foundation.Icon, {
					name = Foundation.Enums.IconName.RobloxPlus,
					size = Foundation.Enums.IconSize.Small
				})
			})
		end

		v9.SubscriptionBadge = subscriptionBadge
		primaryNameFrame = createElement2(View, {
			tag = "row align-y-center auto-y size-full-0",
			LayoutOrder = 1
		}, {
			PrimaryNameFrameTouchable = createElement3(
				View,
				{
					tag = "row align-x-left align-y-center auto-xy gap-xxsmall",
					LayoutOrder = 1,
					onActivated = onActivated2
				},
				v9
			)
		})
	else
		local createElement2 = React.createElement
		local v9 = {
			Size = UDim2.fromScale(1, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.Y
		}

		local createElement3 = React.createElement
		local v10 = {
			AutomaticSize = Enum.AutomaticSize.XY,
			Text = "",
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			[React.Event.Activated] = onActivated2,
			Selectable = false
		}

		local createElement4 = React.createElement
		local v11 = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = 0,
			SortOrder = 0
		}
		local verticalAlignment

		if FFlagProfilePlatformEnableRobloxAdminBadge and props.isRobloxAdmin then
			verticalAlignment = Enum.VerticalAlignment.Center
		else
			verticalAlignment = Enum.VerticalAlignment.Bottom
		end

		v11.VerticalAlignment = verticalAlignment

		v11.SortOrder = Enum.SortOrder.LayoutOrder
		local children = {
			UIListLayout = createElement4("UIListLayout", v11),
			EditNameButton = 0,
			PrimaryName = 0,
			AdminTiltIcon = 0,
			SubscriptionBadge = 0
		}
		local editNameButton

		if props.openEditName then
			local createElement5 = React.createElement
			local v12 = {
				icon = icon,
				iconSize = IconSize.Small,
				size = UDim2.fromOffset(26, 26),
				layoutOrder = 1,
				onActivated = onActivated2
			}
			local tooltip

			if props.isTooltipActive then
				tooltip = React.createElement(Tooltip, {
					triggerPosition = Vector2.new(16, 0),
					triggerSize = Vector2.new(0, 0),
					headerText = v5.tooltipTitle,
					bodyText = v5.tooltipBody,
					orientation = TooltipOrientation.Top,
					forceClickTriggerPoint = true,
					isDirectChild = true
				})
			end

			editNameButton = createElement5(IconButton, v12, { tooltip = tooltip })
		end

		children.EditNameButton = editNameButton

		children.PrimaryName = React.createElement(Text, {
			Text = text,
			tag = "auto-xy text-align-x-left text-align-y-bottom content-emphasis",
			fontStyle = v.Typography.HeadingSmall,
			LayoutOrder = 2
		})
		local adminTiltIcon

		if FFlagProfilePlatformEnableRobloxAdminBadge and props.isRobloxAdmin then
			adminTiltIcon = React.createElement(
				"Frame",
				{
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1,
					LayoutOrder = 3
				},
				{
					UIPadding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v.Gap.XXSmall),
						PaddingBottom = UDim.new(0, v.Gap.XXSmall)
					}),
					Icon = React.createElement(Foundation.Icon, {
						name = Foundation.Enums.IconName.Tilt,
						size = Foundation.Enums.IconSize.Large
					})
				}
			)
		end

		children.AdminTiltIcon = adminTiltIcon
		local subscriptionBadge

		if FFlagEnableBlackbirdCheck and props.isRobloxSubscriber == true then
			subscriptionBadge = React.createElement(
				"Frame",
				{
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1,
					LayoutOrder = 4
				},
				{
					UIPadding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v.Gap.XXSmall),
						PaddingBottom = UDim.new(0, v.Gap.XXSmall)
					}),
					Icon = React.createElement(Foundation.Icon, {
						name = Foundation.Enums.IconName.RobloxPlus,
						size = Foundation.Enums.IconSize.Small
					})
				}
			)
		end

		children.SubscriptionBadge = subscriptionBadge
		primaryNameFrame = createElement2("Frame", v9, {
			PrimaryNameFrameTouchable = createElement3("TextButton", v10, children)
		})
	end

	v8.PrimaryNameFrame = primaryNameFrame

	local createElement2 = React.createElement
	local v9 = {
		RichText = FFlagEnableFontStylisticAlternativesOnSocialScreens and true or nil,
		Text = 0,
		tag = "auto-xy text-align-x-left text-align-y-top",
		fontStyle = 0,
		OpenTypeFeatures = 0,
		LayoutOrder = 2,
		onActivated = 0,
		stateLayer = 0
	}
	local text2

	if FFlagEnableFontStylisticAlternativesOnSocialScreens then
		text2 = `<font features="zero, ss03">{formatted}</font>` .. v6
	else
		text2 = formatted .. v6
	end

	v9.Text = text2

	v9.fontStyle = v.Typography.CaptionMedium
	local openTypeFeatures

	if not (FFlagEnableFontStylisticAlternativesOnSocialScreens or not GetFFlagLuaAppEnableOpenTypeSupport()) then
		openTypeFeatures = OpenTypeSupport:getUserNameStylisticAlternative()
	end

	v9.OpenTypeFeatures = openTypeFeatures

	if v4 then
		onActivated = nil
	end

	v9.onActivated = onActivated
	local stateLayer

	if not v4 then
		stateLayer = FFlagProfilePlatformEnableClickToCopyUsername and {
			affordance = StateLayerAffordance.None
		} or nil
	end

	v9.stateLayer = stateLayer
	v8.Username = createElement2(Text, v9)
	local platformName

	if FFlagAddPlatformNameToProfileHeader and props.platformName then
		local createElement3 = React.createElement
		local platformIcon

		if name then
			platformIcon = React.createElement(Icon, {
				name = name,
				size = iconSize.XSmall,
				LayoutOrder = 1
			})
		end

		platformName = createElement3(View, {
			tag = "row align-y-center gap-xsmall auto-xy",
			LayoutOrder = 3
		}, {
			PlatformIcon = platformIcon,
			PlatformNameLabel = React.createElement(Text, {
				Text = props.platformName,
				tag = "shrink auto-xy text-align-x-left text-align-y-top",
				fontStyle = v.Typography.CaptionMedium,
				LayoutOrder = 2
			})
		})
	end

	v8.PlatformName = platformName
	return createElement(HorizontalPageMargin, v7, v8)
end

return SocialIdentity
