local AddFriends = script:FindFirstAncestor("AddFriends")
local AddFriendsParent = AddFriends.Parent
local React = require(AddFriendsParent.React)
local useFireAnalyticsEvent = require(AddFriends.Analytics.useFireAnalyticsEvent)
local EventNames = require(AddFriends.Analytics.EventNames)
local SharedFlags = require(AddFriendsParent.SharedFlags)
local FFlagAddFriendsPageUpdateAmpRules = SharedFlags.FFlagAddFriendsPageUpdateAmpRules
local FFlagMakeVPCFAECheckMoreGeneric = SharedFlags.FFlagMakeVPCFAECheckMoreGeneric
local FStringEligibleToAgeVerifyAmpFeature = SharedFlags.FStringEligibleToAgeVerifyAmpFeature
local FStringEligibleForFacialAgeEstimationAmpFeature = SharedFlags.FStringEligibleForFacialAgeEstimationAmpFeature
local FStringAgeCheckAmpNameSpace = SharedFlags.FStringAgeCheckAmpNameSpace
local AmpUpsell = require(AddFriendsParent.AmpUpsell)
local AmpApiProvider = AmpUpsell.AmpApiProvider
local AmpEnums = AmpUpsell.AmpEnums
local autoPromptStatus = require(AddFriendsParent.ContactImporter).Signals.autoPromptStatus
local SocialUpsell = require(AddFriendsParent.SocialUpsell)
local useSocialUpsellOverlayController = SocialUpsell.Hooks.useSocialUpsellOverlayController
local SocialUpsellType = SocialUpsell.Enums.SocialUpsellType
local UpsellEntrySurfaceType = SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType
local UpsellComponent = SocialUpsell.Analytics.Enum.UpsellComponent
local FAEUpsellOnAfpImpressionCache = require(script.Parent.FAEUpsellOnAfpImpressionCache)
local v22 = game:DefineFastInt("FAEUpsellOnAfpImpressionCap", 1)

local function isAlreadyShownInitState() -- line: 38
	-- upvalues: FAEUpsellOnAfpImpressionCache (copy), v22 (copy)
	local v25 = FAEUpsellOnAfpImpressionCache.getValue()

	return v25 < 0 or v25 >= v22
end
local function useFAEUpsellOnAfp() -- line: 43
	-- upvalues: useFireAnalyticsEvent (copy), React (copy), isAlreadyShownInitState (copy), useSocialUpsellOverlayController (copy), FAEUpsellOnAfpImpressionCache (copy), EventNames (copy), SocialUpsellType (copy), UpsellEntrySurfaceType (copy), UpsellComponent (copy), FFlagMakeVPCFAECheckMoreGeneric (copy), FFlagAddFriendsPageUpdateAmpRules (copy), AmpApiProvider (copy), FStringEligibleToAgeVerifyAmpFeature (copy), FStringEligibleForFacialAgeEstimationAmpFeature (copy), FStringAgeCheckAmpNameSpace (copy), AmpEnums (copy), autoPromptStatus (copy)
	local v26 = useFireAnalyticsEvent()
	local v27, v28 = React.useState(isAlreadyShownInitState)
	local v29 = useSocialUpsellOverlayController(false)
	local v30 = React.useCallback(function() -- line: 49
		-- upvalues: v28 (copy), FAEUpsellOnAfpImpressionCache (copy), v26 (copy), EventNames (copy), v29 (copy), SocialUpsellType (copy), UpsellEntrySurfaceType (copy), UpsellComponent (copy), FFlagMakeVPCFAECheckMoreGeneric (copy), FFlagAddFriendsPageUpdateAmpRules (copy)
		v28(true)
		FAEUpsellOnAfpImpressionCache.incrementValue()
		v26(EventNames.FAEModalImpression)
		v29.openSocialOverlay(SocialUpsellType.FacialAgeEstimation, {
			upsellEntrySurface = UpsellEntrySurfaceType.AddFriendsPage,
			upsellEntryComponent = UpsellComponent.Modal,
			entryPointEventCtx = SocialUpsellType.FacialAgeEstimation .. UpsellEntrySurfaceType.AddFriendsPage,
			shouldIncludeVPC = FFlagMakeVPCFAECheckMoreGeneric and not not FFlagAddFriendsPageUpdateAmpRules or nil
		})
	end, {
		v26,
		v29.openSocialOverlay
	})

	React.useEffect(function() -- line: 64
		-- upvalues: v27 (copy), AmpApiProvider (copy), FFlagAddFriendsPageUpdateAmpRules (copy), FStringEligibleToAgeVerifyAmpFeature (copy), FStringEligibleForFacialAgeEstimationAmpFeature (copy), FStringAgeCheckAmpNameSpace (copy), AmpEnums (copy), v30 (copy), autoPromptStatus (copy)
		if v27 then
			return
		end

		local u31 = false

		local function tryDispatchFAEUpsell(b1: boolean?) -- line: 71
			-- upvalues: u31 (ref), AmpApiProvider (copy), FFlagAddFriendsPageUpdateAmpRules (copy), FStringEligibleToAgeVerifyAmpFeature (copy), FStringEligibleForFacialAgeEstimationAmpFeature (copy), FStringAgeCheckAmpNameSpace (copy), AmpEnums (copy), v30 (copy)
			if u31 then
				return
			end

			if b1 == nil or b1 then
				return
			end

			if AmpApiProvider.upsellFeatureAccess((if not FFlagAddFriendsPageUpdateAmpRules then FStringEligibleForFacialAgeEstimationAmpFeature else FStringEligibleToAgeVerifyAmpFeature), {}, FStringAgeCheckAmpNameSpace).access ~= AmpEnums.AccessResponseEnum.Granted then
				return
			end

			u31 = true
			v30()
		end

		local v33 = autoPromptStatus.statusChanged:connect(tryDispatchFAEUpsell)

		tryDispatchFAEUpsell(autoPromptStatus.getStatus())

		return function() -- line: 99
			-- upvalues: v33 (copy)
			v33:disconnect()
		end
	end, {
		v27,
		v28,
		v30
	})
end

return useFAEUpsellOnAfp
