local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local useLocalization = require(ProfilePlatformParent.Localization).Hooks.useLocalization
local VerifiedBadges = require(ProfilePlatformParent.VerifiedBadges)
local UIBlox = require(ProfilePlatformParent.UIBlox)
local HorizontalPageMargin = UIBlox.App.Container.HorizontalPageMargin
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Images = UIBlox.App.ImageSet.Images
local Tooltip = UIBlox.App.Dialog.Tooltip
local TooltipOrientation = UIBlox.App.Dialog.Enum.TooltipOrientation
local OpenTypeSupport = UIBlox.Utility.OpenTypeSupport
local Foundation = require(ProfilePlatformParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local Icon = Foundation.Icon
local useTokens = Foundation.Hooks.useTokens
local Enums = Foundation.Enums
local StateLayerAffordance = Enums.StateLayerAffordance
local IconSize2 = Enums.IconSize
local useDispatch = require(ProfilePlatformParent.RoactUtils).Hooks.RoactRodux.useDispatch
local Contexts = require(ProfilePlatformParent.SocialLuaAnalytics).Analytics.Enums.Contexts
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local useProfileAnalyticsContext = require(ProfilePlatform.Contexts.useProfileAnalyticsContext)
local default = require(ProfilePlatformParent.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local SetCurrentToastMessage = require(ProfilePlatformParent.ToastRodux).Actions.SetCurrentToastMessage
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local FFlagFriendRequestNicknames = require(ProfilePlatformParent.SharedFlags).FFlagFriendRequestNicknames
local FFlagProfilePlatformEnableClickToCopyUsername = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableClickToCopyUsername)
local FFlagEnableFontStylisticAlternativesOnSocialScreens = require(ProfilePlatformParent.SharedFlags).FFlagEnableFontStylisticAlternativesOnSocialScreens
local GetFFlagLuaAppEnableOpenTypeSupport = require(ProfilePlatformParent.SharedFlags).GetFFlagLuaAppEnableOpenTypeSupport
local FFlagProfilePlatformEnableRobloxAdminBadge = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableRobloxAdminBadge)
local FFlagEnableBlackbirdCheck = require(ProfilePlatformParent.SharedFlags).FFlagEnableBlackbirdCheck
local FFlagHidePremiumIconography = require(ProfilePlatformParent.SharedFlags).FFlagHidePremiumIconography
local FFlagAddPlatformNameToProfileHeader = require(ProfilePlatformParent.SharedFlags).FFlagAddPlatformNameToProfileHeader
local FFlagDisableCopyUsernameOnConsole = require(ProfilePlatformParent.SharedFlags).FFlagDisableCopyUsernameOnConsole
local Responsive = require(ProfilePlatformParent.Responsive)
local getBuilderIconForCurrentPlatform = Foundation.Utility.getBuilderIconForCurrentPlatform
local FFlagProfilePlatformTruncateLongCustomFriendNames = require(ProfilePlatform.Flags.FFlagProfilePlatformTruncateLongCustomFriendNames)
local v41 = if not FFlagProfilePlatformEnableClickToCopyUsername then nil else Images["icons/actions/edit/copy"]

local function SocialIdentity(t1: {[any]: any}) -- line: 81
	-- upvalues: useTokens (copy), React (copy), FFlagAddPlatformNameToProfileHeader (copy), getBuilderIconForCurrentPlatform (copy), Images (copy), FFlagProfilePlatformEnableClickToCopyUsername (copy), useDispatch (copy), useProfileAnalyticsContext (copy), FFlagDisableCopyUsernameOnConsole (copy), Responsive (copy), FFlagHidePremiumIconography (copy), FFlagEnableBlackbirdCheck (copy), VerifiedBadges (copy), useLocalization (copy), TextKeys (copy), default (copy), Contexts (copy), EventNames (copy), SetCurrentToastMessage (copy), v41 (copy), HorizontalPageMargin (copy), FFlagProfilePlatformTruncateLongCustomFriendNames (copy), View (copy), IconButton (copy), IconSize (copy), Tooltip (copy), TooltipOrientation (copy), FoundationText (copy), FFlagFriendRequestNicknames (copy), FFlagProfilePlatformEnableRobloxAdminBadge (copy), Foundation (copy), FFlagEnableFontStylisticAlternativesOnSocialScreens (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), OpenTypeSupport (copy), StateLayerAffordance (copy), Icon (copy), IconSize2 (copy)
	local v44 = useTokens()
	local v45 = React.useMemo(function() -- line: 83
		-- upvalues: FFlagAddPlatformNameToProfileHeader (copy), getBuilderIconForCurrentPlatform (copy)
		if FFlagAddPlatformNameToProfileHeader then
			return (getBuilderIconForCurrentPlatform())
		end

		return nil
	end, {})
	local v46 = if not t1.isEdited then Images["icons/actions/edit/edit_small"] else Images["icons/actions/edit/editOn_small"]
	local v47 = if not FFlagProfilePlatformEnableClickToCopyUsername then nil else useDispatch()
	local v48 = if not FFlagProfilePlatformEnableClickToCopyUsername then nil else useProfileAnalyticsContext()
	local v49 = not not FFlagDisableCopyUsernameOnConsole and Responsive.usePreferredInput() == Responsive.Input.Directional
	local v50 = (t1.primaryName .. (if not FFlagHidePremiumIconography then (not t1.isPremium or not not FFlagEnableBlackbirdCheck and t1.isRobloxSubscriber == true) and "" or VerifiedBadges.emoji.premium else "")) .. (not t1.isVerified and "" or VerifiedBadges.emoji.verified)
	local v51 = `@{ t1.username }`
	local v52 = useLocalization({
		tooltipTitle = if not t1.isLocalUser then TextKeys.AliasTooltipHeader else nil,
		tooltipBody = if not t1.isLocalUser then TextKeys.AliasTooltipBody else TextKeys.DisplayNameTooltipBody,
		usernameCopied = if not FFlagProfilePlatformEnableClickToCopyUsername then nil else TextKeys.UsernameCopied,
		trustedLabel = TextKeys.TrustedLabel
	})
	local v53 = if not FFlagProfilePlatformEnableClickToCopyUsername then nil else React.useCallback(function() -- line: 119
		-- upvalues: default (copy), Contexts (copy), t1 (copy), v48 (copy), EventNames (copy), v47 (copy), SetCurrentToastMessage (copy), v52 (copy), v41 (copy)
		default:setClipboardText({
			context = Contexts.ProfileCard,
			text = t1.username
		})
		v48.fireAnalyticsEvent(EventNames.UsernameCopied)
		v47(SetCurrentToastMessage({
			isLocalized = true,
			toastMessage = v52.usernameCopied,
			toastIcon = v41
		}))
	end, {
		t1.username,
		v48,
		v52.usernameCopied
	})
	local v54 = not t1.isTrustedConnection and "" or ` • { v52.trustedLabel }`
	local v55 = React.useCallback(function() -- line: 135
		-- upvalues: t1 (copy)
		if t1.openEditName then
			t1.openEditName()
		end

		t1.dismissTooltip()
	end)

	return React.createElement(HorizontalPageMargin, {
		useAutomaticSizing = true,
		backgroundTransparency = 1,
		size = t1.size,
		layoutOrder = t1.layoutOrder
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		PrimaryNameFrame = if not FFlagProfilePlatformTruncateLongCustomFriendNames then React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			PrimaryNameFrameTouchable = React.createElement("TextButton", {
				AutomaticSize = Enum.AutomaticSize.XY,
				Text = "",
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				[React.Event.Activated] = v55,
				Selectable = false
			}, {
				UIListLayout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = if not FFlagProfilePlatformEnableRobloxAdminBadge or not t1.isRobloxAdmin then Enum.VerticalAlignment.Bottom else Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				EditNameButton = if not t1.openEditName then nil else React.createElement(IconButton, {
					layoutOrder = 1,
					icon = v46,
					iconSize = IconSize.Small,
					size = UDim2.fromOffset(26, 26),
					onActivated = v55
				}, {
					tooltip = if not t1.isTooltipActive then nil else React.createElement(Tooltip, {
						forceClickTriggerPoint = true,
						isDirectChild = true,
						triggerPosition = Vector2.new(16, 0),
						triggerSize = Vector2.new(0, 0),
						headerText = v52.tooltipTitle,
						bodyText = v52.tooltipBody,
						orientation = TooltipOrientation.Top
					})
				}),
				PrimaryName = React.createElement(FoundationText, {
					tag = "auto-xy text-align-x-left text-align-y-bottom content-emphasis",
					LayoutOrder = 2,
					Text = v50,
					fontStyle = v44.Typography.HeadingSmall,
					Size = if not FFlagFriendRequestNicknames then nil else UDim2.new(1, 0, 1, 0),
					TextWrapped = not not FFlagFriendRequestNicknames or nil,
					FluidSizing = not FFlagFriendRequestNicknames and nil,
					LineHeight = if not FFlagFriendRequestNicknames then nil else 1
				}),
				AdminTiltIcon = if not FFlagProfilePlatformEnableRobloxAdminBadge or not t1.isRobloxAdmin then nil else React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 3,
					AutomaticSize = Enum.AutomaticSize.XY
				}, {
					UIPadding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v44.Gap.XXSmall),
						PaddingBottom = UDim.new(0, v44.Gap.XXSmall)
					}),
					Icon = React.createElement(Foundation.Icon, {
						name = Foundation.Enums.IconName.Tilt,
						size = Foundation.Enums.IconSize.Large
					})
				}),
				SubscriptionBadge = if not FFlagEnableBlackbirdCheck or t1.isRobloxSubscriber ~= true then nil else React.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 4,
					AutomaticSize = Enum.AutomaticSize.XY
				}, {
					UIPadding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, v44.Gap.XXSmall),
						PaddingBottom = UDim.new(0, v44.Gap.XXSmall)
					}),
					Icon = React.createElement(Foundation.Icon, {
						name = Foundation.Enums.IconName.RobloxPlus,
						size = Foundation.Enums.IconSize.Small
					})
				})
			})
		}) else React.createElement(View, {
			tag = "row align-y-center auto-y size-full-0",
			LayoutOrder = 1
		}, {
			PrimaryNameFrameTouchable = React.createElement(View, {
				tag = "row align-x-left align-y-center auto-xy gap-xxsmall",
				LayoutOrder = 1,
				onActivated = v55
			}, {
				EditNameButton = if not t1.openEditName then nil else React.createElement(IconButton, {
					layoutOrder = 1,
					icon = v46,
					iconSize = IconSize.Small,
					size = UDim2.fromOffset(26, 26),
					onActivated = v55
				}, {
					tooltip = if not t1.isTooltipActive then nil else React.createElement(Tooltip, {
						forceClickTriggerPoint = true,
						isDirectChild = true,
						triggerPosition = Vector2.new(16, 0),
						triggerSize = Vector2.new(0, 0),
						headerText = v52.tooltipTitle,
						bodyText = v52.tooltipBody,
						orientation = TooltipOrientation.Top
					})
				}),
				PrimaryName = React.createElement(FoundationText, {
					tag = "auto-xy text-align-x-left text-align-y-bottom content-emphasis text-truncate-end shrink",
					LayoutOrder = 2,
					Text = v50,
					fontStyle = v44.Typography.HeadingSmall,
					Size = if not FFlagFriendRequestNicknames then nil else UDim2.new(1, 0, 1, 0),
					TextWrapped = not not FFlagFriendRequestNicknames or nil,
					FluidSizing = not FFlagFriendRequestNicknames and nil,
					LineHeight = if not FFlagFriendRequestNicknames then nil else 1
				}),
				AdminTiltIcon = if not FFlagProfilePlatformEnableRobloxAdminBadge or not t1.isRobloxAdmin then nil else React.createElement(Foundation.Icon, {
					LayoutOrder = 3,
					name = Foundation.Enums.IconName.Tilt,
					size = Foundation.Enums.IconSize.Large
				}),
				SubscriptionBadge = if not FFlagEnableBlackbirdCheck or t1.isRobloxSubscriber ~= true then nil else React.createElement(View, {
					tag = "auto-xy padding-top-xxsmall",
					LayoutOrder = 4
				}, {
					Icon = React.createElement(Foundation.Icon, {
						name = Foundation.Enums.IconName.RobloxPlus,
						size = Foundation.Enums.IconSize.Small
					})
				})
			})
		}),
		Username = React.createElement(FoundationText, {
			tag = "auto-xy text-align-x-left text-align-y-top",
			LayoutOrder = 2,
			RichText = not not FFlagEnableFontStylisticAlternativesOnSocialScreens or nil,
			Text = if not FFlagEnableFontStylisticAlternativesOnSocialScreens then v51 .. v54 else `<font features="zero, ss03">{ v51 }</font>` .. v54,
			fontStyle = v44.Typography.CaptionMedium,
			Size = if not FFlagFriendRequestNicknames then nil else UDim2.new(1, 0, 1, 0),
			OpenTypeFeatures = if not FFlagEnableFontStylisticAlternativesOnSocialScreens then if not GetFFlagLuaAppEnableOpenTypeSupport() then nil else OpenTypeSupport:getUserNameStylisticAlternative() else nil,
			onActivated = if not v49 then v53 else nil,
			stateLayer = if not v49 then if not FFlagProfilePlatformEnableClickToCopyUsername then nil else {
				affordance = StateLayerAffordance.None
			} else nil
		}),
		PlatformName = if not FFlagAddPlatformNameToProfileHeader or not t1.platformName then nil else React.createElement(View, {
			tag = "row align-y-center gap-xsmall auto-xy",
			LayoutOrder = 3
		}, {
			PlatformIcon = if not v45 then nil else React.createElement(Icon, {
				LayoutOrder = 1,
				name = v45,
				size = IconSize2.XSmall
			}),
			PlatformNameLabel = React.createElement(FoundationText, {
				tag = "shrink auto-xy text-align-x-left text-align-y-top",
				LayoutOrder = 2,
				Text = t1.platformName,
				fontStyle = v44.Typography.CaptionMedium
			})
		})
	})
end

return SocialIdentity
