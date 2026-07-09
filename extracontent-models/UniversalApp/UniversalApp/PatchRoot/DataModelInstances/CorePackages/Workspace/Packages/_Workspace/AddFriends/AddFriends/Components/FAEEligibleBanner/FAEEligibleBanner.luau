local AddFriends = script:FindFirstAncestor("AddFriends")
local AddFriendsParent = AddFriends.Parent
local React = require(AddFriendsParent.React)
local useLocalization = require(AddFriendsParent.Localization).Hooks.useLocalization
local Foundation = require(AddFriendsParent.Foundation)
local Button = Foundation.Button
local Icon = Foundation.Icon
local IconButton = Foundation.IconButton
local FoundationText = Foundation.Text
local View = Foundation.View
local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local IconVariant = Foundation.Enums.IconVariant
local InputSize = Foundation.Enums.InputSize
local useTokens = Foundation.Hooks.useTokens
local SocialUpsell = require(AddFriendsParent.SocialUpsell)
local useSocialUpsellOverlayController = SocialUpsell.Hooks.useSocialUpsellOverlayController
local SocialUpsellType = SocialUpsell.Enums.SocialUpsellType
local UpsellEntrySurfaceType = SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType
local UpsellComponent = SocialUpsell.Analytics.Enum.UpsellComponent
local EventNames = require(AddFriends.Analytics.EventNames)
local useFireAnalyticsEvent = require(AddFriends.Analytics.useFireAnalyticsEvent)
local useShowFAEEligibleBanner = require(script.Parent.useShowFAEEligibleBanner)
local SharedFlags = require(AddFriendsParent.SharedFlags)
local FFlagCreateConnectionsHub = SharedFlags.FFlagCreateConnectionsHub
local FFlagAddFriendsPageUpdateAmpRules = SharedFlags.FFlagAddFriendsPageUpdateAmpRules
local FFlagMakeVPCFAECheckMoreGeneric = SharedFlags.FFlagMakeVPCFAECheckMoreGeneric
local v29 = game:DefineFastFlag("AFPFAEBannerNoRadius", false)

local function FAEEligibleBanner(t1: {[any]: any}) -- line: 42
	-- upvalues: useSocialUpsellOverlayController (copy), useShowFAEEligibleBanner (copy), useFireAnalyticsEvent (copy), useTokens (copy), useLocalization (copy), React (copy), EventNames (copy), SocialUpsellType (copy), UpsellEntrySurfaceType (copy), UpsellComponent (copy), FFlagMakeVPCFAECheckMoreGeneric (copy), FFlagAddFriendsPageUpdateAmpRules (copy), View (copy), FFlagCreateConnectionsHub (copy), v29 (copy), Icon (copy), IconName (copy), IconSize (copy), IconVariant (copy), FoundationText (copy), Button (copy), ButtonVariant (copy), InputSize (copy), IconButton (copy)
	local v32 = useSocialUpsellOverlayController(false)
	local v33, v34 = useShowFAEEligibleBanner()
	local v35 = useFireAnalyticsEvent()
	local v36 = useTokens()
	local v37 = useLocalization({
		body = "Feature.Friends.Label.FAEEligibleBanner.Body",
		unlock = "Feature.FAE.Action.Unlock"
	})

	React.useEffect(function() -- line: 53
		-- upvalues: v33 (copy), v35 (copy), EventNames (copy)
		if v33 then
			v35(EventNames.FAEEligibleBannerImpression)
		end
	end, {
		v33,
		v35
	})

	local v38 = React.useCallback(function() -- line: 59
		-- upvalues: v35 (copy), EventNames (copy), v34 (copy), v32 (copy), SocialUpsellType (copy), UpsellEntrySurfaceType (copy), UpsellComponent (copy), FFlagMakeVPCFAECheckMoreGeneric (copy), FFlagAddFriendsPageUpdateAmpRules (copy)
		v35(EventNames.FAEEligibleBannerClick)
		v34()
		v32.openSocialOverlay(SocialUpsellType.FacialAgeEstimation, {
			upsellEntrySurface = UpsellEntrySurfaceType.AddFriendsPage,
			upsellEntryComponent = UpsellComponent.Banner,
			entryPointEventCtx = SocialUpsellType.FacialAgeEstimation .. UpsellEntrySurfaceType.AddFriendsPage,
			shouldIncludeVPC = FFlagMakeVPCFAECheckMoreGeneric and not not FFlagAddFriendsPageUpdateAmpRules or nil
		})
	end, {
		v34,
		v32.openSocialOverlay,
		v35
	})
	local v39 = React.useCallback(function() -- line: 72
		-- upvalues: v35 (copy), EventNames (copy), v34 (copy)
		v35(EventNames.FAEEligibleBannerClose)
		v34()
	end, {
		v34,
		v35
	})

	if not v33 then
		return nil
	end

	return React.createElement(View, {
		LayoutOrder = t1.layoutOrder,
		tag = {
			["col size-full-0 auto-y"] = true,
			["padding-y-xsmall"] = not FFlagCreateConnectionsHub
		}
	}, {
		Banner = React.createElement(View, {
			tag = {
				["row align-y-center gap-medium size-full-0 auto-y padding-x-medium padding-y-large bg-shift-200"] = true,
				["radius-medium"] = not v29
			}
		}, {
			LeftGroup = React.createElement(View, {
				LayoutOrder = 1,
				tag = "row align-y-center fill gap-medium auto-y"
			}, {
				InfoIcon = React.createElement(View, {
					LayoutOrder = 1,
					tag = "row align-x-center align-y-center radius-circle bg-system-emphasis",
					Size = UDim2.fromOffset(v36.Size.Size_600, v36.Size.Size_600)
				}, {
					Glyph = React.createElement(Icon, {
						name = IconName.StackableI,
						size = IconSize.Medium,
						variant = IconVariant.Filled,
						style = v36.Color.Extended.White.White_100
					})
				}),
				BodyText = React.createElement(FoundationText, {
					LayoutOrder = 2,
					tag = "fill auto-y text-body-medium text-wrap text-align-x-left content-emphasis",
					Text = v37.body
				})
			}),
			RightGroup = React.createElement(View, {
				LayoutOrder = 2,
				tag = "row align-y-center gap-small auto-xy"
			}, {
				UnlockButton = React.createElement(Button, {
					LayoutOrder = 1,
					text = v37.unlock,
					variant = ButtonVariant.Standard,
					size = InputSize.Small,
					onActivated = v38
				}),
				CloseButton = React.createElement(IconButton, {
					LayoutOrder = 2,
					icon = IconName.X,
					size = InputSize.Small,
					variant = ButtonVariant.Utility,
					onActivated = v39
				})
			})
		})
	})
end

return FAEEligibleBanner
