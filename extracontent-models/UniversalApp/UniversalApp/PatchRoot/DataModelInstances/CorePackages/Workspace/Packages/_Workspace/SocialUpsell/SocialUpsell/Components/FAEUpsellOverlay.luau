local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local SocialUpsellParent = SocialUpsell.Parent
local React = require(SocialUpsellParent.React)
local SharedFlags = require(SocialUpsellParent.SharedFlags)
local useDispatch = require(SocialUpsellParent.RoactUtils).Hooks.RoactRodux.useDispatch
local FoundationCloudAssets = require(SocialUpsellParent.FoundationCloudAssets)
local FIntCommsFAELockTimestamp = require(SocialUpsell.Flag.FIntCommsFAELockTimestamp)
local UpsellOverlay = require(SocialUpsell.Components.UpsellOverlay)
local createCommonOverlayProps = require(SocialUpsell.Utils.createCommonOverlayProps)
local startFacialAgeEstimation = require(SocialUpsell.Thunks.startFacialAgeEstimation)
local UpsellEntrySurfaceType = require(SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType)
local SocialUpsellType = require(SocialUpsell.Enum.SocialUpsellType)
local UpsellComponent = require(SocialUpsell.Analytics.Enum.UpsellComponent)
local FFlagEnableCountdownBadge = require(SocialUpsell.Flag.FFlagEnableCountdownBadge)
local FFlagSupportVPC = require(SocialUpsell.Flag.FFlagSupportVPC)
local Assets = FoundationCloudAssets.Assets
local preloadAsset = FoundationCloudAssets.preloadAsset
local AmpUpsell = require(SocialUpsellParent.AmpUpsell)
local OpenAmpWizardContainer = AmpUpsell.OpenAmpWizardContainer
local AccessResponseEnum = AmpUpsell.AmpEnums.AccessResponseEnum
local FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature = SharedFlags.FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature
local FStringCoreContentAmpNameSpace = SharedFlags.FStringCoreContentAmpNameSpace

preloadAsset("pictograms/chat_security")

local v23 = Assets["pictograms/chat_security"]
local v24 = v23 and v23.assetId or nil
local FFlagAddFriendsPageFAEUpsell = SharedFlags.FFlagAddFriendsPageFAEUpsell
local FFlagAddFriendsPageUpdateAmpRules = SharedFlags.FFlagAddFriendsPageUpdateAmpRules
local FFlagMakeVPCFAECheckMoreGeneric = SharedFlags.FFlagMakeVPCFAECheckMoreGeneric
local u28 = nil

if FFlagAddFriendsPageFAEUpsell then
	preloadAsset("pictograms/lock_closed")

	local v29 = Assets["pictograms/lock_closed"]

	u28 = v29 and v29.assetId or nil
end

local useSocialUpsellOverlayController = require(SocialUpsell.Hooks.useSocialUpsellOverlayController)
local useLocalization = require(SocialUpsellParent.Localization).Hooks.useLocalization
local FFlagEnableAEGIS2CommsFAEUpsell = SharedFlags.FFlagEnableAEGIS2CommsFAEUpsell
local v33 = game:DefineFastFlag("AEGISPhase2ShowImageOnFAEOverlay", false)
local v34 = game:DefineFastFlag("ForceAegisPhase2Modal", false)
local FFlagTFWithActionsCheck = require(SocialUpsellParent.SharedFlags).FFlagTFWithActionsCheck

return function(p1) -- line: 76
	-- upvalues: useDispatch (copy), useSocialUpsellOverlayController (copy), useLocalization (copy), FFlagAddFriendsPageFAEUpsell (copy), FFlagEnableAEGIS2CommsFAEUpsell (copy), FFlagTFWithActionsCheck (copy), React (copy), v34 (copy), UpsellEntrySurfaceType (copy), UpsellComponent (copy), FFlagSupportVPC (copy), FFlagMakeVPCFAECheckMoreGeneric (copy), FFlagAddFriendsPageUpdateAmpRules (copy), SocialUpsellType (copy), OpenAmpWizardContainer (copy), FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature (copy), AccessResponseEnum (copy), FStringCoreContentAmpNameSpace (copy), startFacialAgeEstimation (copy), FFlagEnableCountdownBadge (copy), FIntCommsFAELockTimestamp (copy), UpsellOverlay (copy), createCommonOverlayProps (copy), u28 (ref), v33 (copy), v24 (copy)
	local v37 = p1 or {}
	local v38 = useDispatch()
	local v39 = useSocialUpsellOverlayController(v37.isInExperience)
	local v40 = useLocalization({
		ToKeepChattingLetsCheckYourAge = "Feature.FAE.Label.ToKeepChattingLetsCheckYourAge",
		ModalBodyInApp = "Feature.FAE.Label.ModalBodyInApp",
		LetsCheckYourAgeSoYouCanUseChat = "Feature.FAE.Label.LetsCheckYourAgeSoYouCanUseChat",
		ModalBodyInAppV3 = "Feature.FAE.Label.ModalBodyInAppV3",
		YourSafetyMattersLetsCheckYourAge = "Feature.FAE.Label.YourSafetyMattersLetsCheckYourAge",
		YouNeedAnAgeCheckToUseChatThisMakesChatSafer = "Feature.FAE.Label.YouNeedAnAgeCheckToUseChatThisMakesChatSafer",
		Continue = "Feature.FAE.Action.Continue",
		ThisHelpsYouToChatSafelyItOnlyTakesAMoment = "Feature.FAE.Label.ThisHelpsYouToChatSafelyItOnlyTakesAMoment",
		ChatWithFriends = if not FFlagAddFriendsPageFAEUpsell then nil else "Feature.FAE.Label.ChatWithFriends",
		GetASecureAgeCheckToUnlockChatAndAddTrustedFriends = if not FFlagAddFriendsPageFAEUpsell then nil else "Feature.FAE.Label.GetASecureAgeCheckToUnlockChatAndAddTrustedFriends",
		Unlock = if not FFlagAddFriendsPageFAEUpsell then nil else "Feature.FAE.Action.Unlock",
		ThisAllowsYouToChatSafelyItOnlyTakesAMoment = if not FFlagEnableAEGIS2CommsFAEUpsell then nil else "Feature.FAE.Label.ThisAllowsYouToChatSafelyItOnlyTakesAMoment",
		UnlockChat = if not FFlagEnableAEGIS2CommsFAEUpsell then nil else "Feature.FAE.Action.UnlockChat",
		LetsCheckYourAge = if not FFlagTFWithActionsCheck then nil else "Feature.FAE.Label.LetsCheckYourAge",
		ToAddTrustedFriendDoAgeCheck = if not FFlagTFWithActionsCheck then nil else "Feature.FAE.Label.ModalBodyTFUnlock"
	})
	local v41 = React.useRef(false)
	local v42, v43 = React.useMemo(function() -- line: 105
		-- upvalues: FFlagEnableAEGIS2CommsFAEUpsell (copy), v34 (copy), v37 (copy), v40 (copy), UpsellEntrySurfaceType (copy), UpsellComponent (copy), FFlagAddFriendsPageFAEUpsell (copy), FFlagTFWithActionsCheck (copy)
		if FFlagEnableAEGIS2CommsFAEUpsell and (v34 or v37.isPhase2) then
			return v40.LetsCheckYourAgeSoYouCanUseChat, v40.ThisHelpsYouToChatSafelyItOnlyTakesAMoment
		end

		if v37.upsellEntrySurface == UpsellEntrySurfaceType.Homepage and v37.upsellEntryComponent == UpsellComponent.Modal or v37.upsellEntrySurface == UpsellEntrySurfaceType.NotifPush then
			return v40.YourSafetyMattersLetsCheckYourAge, v40.YouNeedAnAgeCheckToUseChatThisMakesChatSafer
		end

		if FFlagAddFriendsPageFAEUpsell and v37.upsellEntrySurface == UpsellEntrySurfaceType.AddFriendsPage then
			return v40.ChatWithFriends, v40.GetASecureAgeCheckToUnlockChatAndAddTrustedFriends
		end

		if FFlagTFWithActionsCheck and (v37.upsellEntrySurface == UpsellEntrySurfaceType.TrustedFriends or v37.upsellEntrySurface == UpsellEntrySurfaceType.TrustedFriendsInExperience) then
			return v40.LetsCheckYourAge, v40.ToAddTrustedFriendDoAgeCheck
		end

		return v40.LetsCheckYourAgeSoYouCanUseChat, v40.ModalBodyInAppV3
	end, {
		if not FFlagEnableAEGIS2CommsFAEUpsell then nil else v37.isPhase2,
		v37.upsellEntrySurface,
		v40,
		if not FFlagAddFriendsPageFAEUpsell then nil else v37.upsellEntryComponent
	})
	local v44 = React.useCallback(function() -- line: 144
		-- upvalues: v39 (copy), v37 (copy), FFlagSupportVPC (copy), FFlagMakeVPCFAECheckMoreGeneric (copy), FFlagAddFriendsPageUpdateAmpRules (copy), SocialUpsellType (copy), v38 (copy), OpenAmpWizardContainer (copy), FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature (copy), AccessResponseEnum (copy), FStringCoreContentAmpNameSpace (copy), UpsellEntrySurfaceType (copy), FFlagEnableAEGIS2CommsFAEUpsell (copy), startFacialAgeEstimation (copy)
		v39.closeSocialOverlay()

		if v37.onAccept then
			v37.onAccept()
		end

		if not FFlagSupportVPC then
			if FFlagMakeVPCFAECheckMoreGeneric then
				if FFlagAddFriendsPageUpdateAmpRules and v37.shouldIncludeVPC then
					local v48 = v37.entryPointEventCtx or SocialUpsellType.FacialAgeEstimation .. (v37.upsellEntrySurface or "")

					v38(OpenAmpWizardContainer(FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature, function(p2, _) -- line: 162
						-- upvalues: AccessResponseEnum (copy), v37 (copy)
						if p2 == AccessResponseEnum.Granted then
							if v37.onSuccess then
								v37.onSuccess()

								return
							end
						elseif v37.onFailure then
							v37.onFailure()
						end
					end, nil, v48, nil, FStringCoreContentAmpNameSpace))

					return
				end
			elseif FFlagAddFriendsPageUpdateAmpRules and v37.upsellEntrySurface == UpsellEntrySurfaceType.AddFriendsPage then
				local v49 = v37.entryPointEventCtx or SocialUpsellType.FacialAgeEstimation .. UpsellEntrySurfaceType.AddFriendsPage

				v38(OpenAmpWizardContainer(FStringTriggerAgeCheckUpsellIncludingVPCAmpFeature, function(p4, _) -- line: 193
					-- upvalues: AccessResponseEnum (copy), v37 (copy)
					if p4 == AccessResponseEnum.Granted then
						if v37.onSuccess then
							v37.onSuccess()

							return
						end
					elseif v37.onFailure then
						v37.onFailure()
					end
				end, nil, v49, nil, FStringCoreContentAmpNameSpace, nil, nil, nil, true))

				return
			end
		end

		if game.JobId ~= "" and not FFlagEnableAEGIS2CommsFAEUpsell then
			return
		end

		v38(startFacialAgeEstimation(if not FFlagSupportVPC or not v37.shouldIncludeVPC then v37.entryPointEventCtx else v37.entryPointEventCtx or SocialUpsellType.FacialAgeEstimation .. (v37.upsellEntrySurface or ""), v37.onSuccess, v37.onFailure, v37.upsellEntrySurface, if not FFlagEnableAEGIS2CommsFAEUpsell then nil else v37.isInExperience, if not FFlagSupportVPC then nil else v37.shouldIncludeVPC))
	end, {
		v38,
		v39.closeSocialOverlay,
		v37.upsellEntrySurface,
		v37.entryPointEventCtx,
		v37.onAccept,
		v37.onSuccess,
		v37.onFailure,
		v37.isInExperience,
		if not FFlagSupportVPC and not FFlagMakeVPCFAECheckMoreGeneric then nil else v37.shouldIncludeVPC
	})
	local v45 = React.useCallback(function() -- line: 252
		-- upvalues: v37 (copy)
		if v37.onDismiss then
			v37.onDismiss()
		end
	end, { v37.onDismiss })
	local v46 = React.useMemo(function() -- line: 258
		-- upvalues: FFlagEnableCountdownBadge (copy), v37 (copy), FIntCommsFAELockTimestamp (copy)
		if FFlagEnableCountdownBadge and v37.countDownBadgeText then
			return {
				text = v37.countDownBadgeText,
				deadlineUtcTimestamp = FIntCommsFAELockTimestamp
			}
		end

		return nil
	end, { v37.countDownBadgeText })
	local v47 = React.useMemo(function() -- line: 268
		-- upvalues: FFlagAddFriendsPageFAEUpsell (copy), v37 (copy), UpsellEntrySurfaceType (copy), v40 (copy), FFlagEnableAEGIS2CommsFAEUpsell (copy), v34 (copy), v44 (copy)
		return {
			text = if not FFlagAddFriendsPageFAEUpsell or v37.upsellEntrySurface ~= UpsellEntrySurfaceType.AddFriendsPage then if not FFlagEnableAEGIS2CommsFAEUpsell or (not v34 and not v37.isPhase2 or v37.isInExperience) then v40.Continue else v40.UnlockChat else v40.Unlock,
			onActivated = v44
		}
	end, {
		if not FFlagEnableAEGIS2CommsFAEUpsell then nil else v37.isPhase2,
		v37.isInExperience,
		v40,
		v44,
		if not FFlagAddFriendsPageFAEUpsell then nil else v37.upsellEntrySurface
	})

	React.useEffect(function() -- line: 292
		-- upvalues: v41 (copy), v37 (copy)
		if not v41.current and v37.onMounted then
			v37.onMounted()
		end

		v41.current = true
	end, { v37.onMounted })

	return React.createElement(UpsellOverlay, createCommonOverlayProps({
		onClose = v45,
		countDownBadge = v46,
		bodyText = v43,
		title = v42,
		imageId = if not FFlagAddFriendsPageFAEUpsell or v37.upsellEntrySurface ~= UpsellEntrySurfaceType.AddFriendsPage then if not FFlagEnableAEGIS2CommsFAEUpsell or (not v34 and not v37.isPhase2 or not (not v33 and v37.isInExperience)) then v24 else nil else u28,
		primaryAction = v47,
		impressionId = v37.impressionId,
		upsellEntryComponent = v37.upsellEntryComponent,
		upsellEntrySurface = v37.upsellEntrySurface,
		upsellPurpose = SocialUpsellType.FacialAgeEstimation,
		containerRef = v37.containerRef
	}, v37))
end
