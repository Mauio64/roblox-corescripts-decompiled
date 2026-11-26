local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SharedFlags")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/RoactUtils").Hooks.RoactRodux.useDispatch

local FoundationCloudAssets = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/FoundationCloudAssets")
local FIntCommsFAELockTimestamp = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Flag/FIntCommsFAELockTimestamp")
local UpsellOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Components/UpsellOverlay")
local createCommonOverlayProps = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Utils/createCommonOverlayProps")
local startFacialAgeEstimation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Thunks/startFacialAgeEstimation")
local UpsellEntrySurfaceType = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Analytics/Enum/UpsellEntrySurfaceType")
local SocialUpsellType = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Enum/SocialUpsellType")
local UpsellComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Analytics/Enum/UpsellComponent")
local FFlagEnableCountdownBadge = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Flag/FFlagEnableCountdownBadge")
local assets = FoundationCloudAssets.Assets
local preloadAsset = FoundationCloudAssets.preloadAsset

preloadAsset("pictograms/chat_security")
local pictogramschat_security = assets["pictograms/chat_security"]
local assetId = pictogramschat_security and pictogramschat_security.assetId or nil

local fFlagAddFriendsPageFAEUpsell = SharedFlags.FFlagAddFriendsPageFAEUpsell
local assetId2

if fFlagAddFriendsPageFAEUpsell then
	preloadAsset("pictograms/lock_closed")
	local pictogramslock_closed = assets["pictograms/lock_closed"]
	assetId2 = pictogramslock_closed and pictogramslock_closed.assetId or nil
else
	assetId2 = nil
end

local useSocialUpsellOverlayController = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Hooks/useSocialUpsellOverlayController")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/Localization").Hooks.useLocalization
local fFlagEnableAEGIS2CommsFAEUpsell = SharedFlags.FFlagEnableAEGIS2CommsFAEUpsell
local defineFastFlag = game:DefineFastFlag("AEGISPhase2ShowImageOnFAEOverlay", false)
local defineFastFlag2 = game:DefineFastFlag("ForceAegisPhase2Modal", false)

return function(options)
	local v5 = options or {}
	local v6 = useDispatch()
	local v7 = useSocialUpsellOverlayController(v5.isInExperience)
	local v8 = useLocalization({
		ToKeepChattingLetsCheckYourAge = "Feature.FAE.Label.ToKeepChattingLetsCheckYourAge",
		ModalBodyInApp = "Feature.FAE.Label.ModalBodyInApp",
		LetsCheckYourAgeSoYouCanUseChat = "Feature.FAE.Label.LetsCheckYourAgeSoYouCanUseChat",
		ModalBodyInAppV3 = "Feature.FAE.Label.ModalBodyInAppV3",
		YourSafetyMattersLetsCheckYourAge = "Feature.FAE.Label.YourSafetyMattersLetsCheckYourAge",
		YouNeedAnAgeCheckToUseChatThisMakesChatSafer = "Feature.FAE.Label.YouNeedAnAgeCheckToUseChatThisMakesChatSafer",
		ChatWithFriends = fFlagAddFriendsPageFAEUpsell and "Feature.FAE.Label.ChatWithFriends" or nil,
		GetASecureAgeCheckToUnlockChatAndAddTrustedFriends = fFlagAddFriendsPageFAEUpsell and "Feature.FAE.Label.GetASecureAgeCheckToUnlockChatAndAddTrustedFriends" or nil,
		Unlock = fFlagAddFriendsPageFAEUpsell and "Feature.FAE.Action.Unlock" or nil,
		Continue = "Feature.FAE.Action.Continue",
		ThisAllowsYouToChatSafelyItOnlyTakesAMoment = fFlagEnableAEGIS2CommsFAEUpsell and "Feature.FAE.Label.ThisAllowsYouToChatSafelyItOnlyTakesAMoment" or nil,
		UnlockChat = fFlagEnableAEGIS2CommsFAEUpsell and "Feature.FAE.Action.UnlockChat" or nil,
		ThisHelpsYouToChatSafelyItOnlyTakesAMoment = "Feature.FAE.Label.ThisHelpsYouToChatSafelyItOnlyTakesAMoment",
		LetsCheckYourAge = "Feature.FAE.Label.LetsCheckYourAge",
		ToAddTrustedFriendDoAgeCheck = "Feature.FAE.Label.ModalBodyTFUnlock"
	})

	local ref = React.useRef(false)

	local useMemo = React.useMemo
	local function fn()
		if fFlagEnableAEGIS2CommsFAEUpsell and (defineFastFlag2 or v5.isPhase2) then
			return v8.LetsCheckYourAgeSoYouCanUseChat, v8.ThisHelpsYouToChatSafelyItOnlyTakesAMoment
		end

		if
			v5.upsellEntrySurface == UpsellEntrySurfaceType.Homepage and v5.upsellEntryComponent == UpsellComponent.Modal
			or v5.upsellEntrySurface == UpsellEntrySurfaceType.NotifPush
		then
			return v8.YourSafetyMattersLetsCheckYourAge, v8.YouNeedAnAgeCheckToUseChatThisMakesChatSafer
		end

		if fFlagAddFriendsPageFAEUpsell and v5.upsellEntrySurface == UpsellEntrySurfaceType.AddFriendsPage then
			return v8.ChatWithFriends, v8.GetASecureAgeCheckToUnlockChatAndAddTrustedFriends
		end

		if
			v5.upsellEntrySurface == UpsellEntrySurfaceType.TrustedFriends
			or v5.upsellEntrySurface == UpsellEntrySurfaceType.TrustedFriendsInExperience
		then
			return v8.LetsCheckYourAge, v8.ToAddTrustedFriendDoAgeCheck
		end

		return v8.LetsCheckYourAgeSoYouCanUseChat, v8.ModalBodyInAppV3
	end

	local isPhase2 = if fFlagEnableAEGIS2CommsFAEUpsell then v5.isPhase2 else nil
	local upsellEntrySurface = v5.upsellEntrySurface

	local v10 = if fFlagAddFriendsPageFAEUpsell then v5.upsellEntryComponent else nil
	local v11, v12 = useMemo(fn, { isPhase2, upsellEntrySurface, v8, v10 })

	local v13 = React.useCallback(function()
		v7.closeSocialOverlay()

		if v5.onAccept then
			v5.onAccept()
		end

		if game.JobId ~= "" and not fFlagEnableAEGIS2CommsFAEUpsell then
			return
		end

		local entryPointEventCtx

		if v5.shouldIncludeVPC then
			entryPointEventCtx = v5.entryPointEventCtx
				or SocialUpsellType.FacialAgeEstimation .. (v5.upsellEntrySurface or "")
		else
			entryPointEventCtx = v5.entryPointEventCtx
		end

		local onSuccess = v5.onSuccess
		local onFailure = v5.onFailure
		local upsellEntrySurface2 = v5.upsellEntrySurface
		local v16 = if fFlagEnableAEGIS2CommsFAEUpsell then v5.isInExperience else nil
		v6(startFacialAgeEstimation(entryPointEventCtx, onSuccess, onFailure, upsellEntrySurface2, v16, v5.shouldIncludeVPC))
	end, {
		v6,
		v7.closeSocialOverlay,
		v5.upsellEntrySurface,
		v5.entryPointEventCtx,
		v5.onAccept,
		v5.onSuccess,
		v5.onFailure,
		v5.isInExperience,
		v5.shouldIncludeVPC
	})

	local v14 = React.useCallback(function()
		if v5.onDismiss then
			v5.onDismiss()
		end
	end, { v5.onDismiss })

	local v15 = React.useMemo(function()
		if FFlagEnableCountdownBadge and v5.countDownBadgeText then
			return { text = v5.countDownBadgeText, deadlineUtcTimestamp = FIntCommsFAELockTimestamp }
		end

		return nil
	end, { v5.countDownBadgeText })

	local useMemo2 = React.useMemo
	local function fn2()
		local v16

		if fFlagAddFriendsPageFAEUpsell and v5.upsellEntrySurface == UpsellEntrySurfaceType.AddFriendsPage then
			v16 = v8.Unlock
		elseif
			fFlagEnableAEGIS2CommsFAEUpsell
			and (defineFastFlag2 or v5.isPhase2)
			and not v5.isInExperience
		then
			v16 = v8.UnlockChat
		else
			v16 = v8.Continue
		end

		return { text = v16, onActivated = v13 }
	end

	local isPhase2_2 = if fFlagEnableAEGIS2CommsFAEUpsell then v5.isPhase2 else nil
	local isInExperience = v5.isInExperience

	local v17 = if fFlagAddFriendsPageFAEUpsell then v5.upsellEntrySurface else nil
	local v18 = useMemo2(fn2, { isPhase2_2, isInExperience, v8, v13, v17 })

	React.useEffect(function()
		if not ref.current and v5.onMounted then
			v5.onMounted()
		end

		ref.current = true
	end, { v5.onMounted })

	local createElement = React.createElement
	local v22

	if fFlagAddFriendsPageFAEUpsell and v5.upsellEntrySurface == UpsellEntrySurfaceType.AddFriendsPage then
		v22 = assetId2
	elseif fFlagEnableAEGIS2CommsFAEUpsell and (defineFastFlag2 or v5.isPhase2) then
		local v23 = not defineFastFlag and v5.isInExperience

		if not v23 then
			v22 = assetId
		end
	else
		v22 = assetId
	end

	return createElement(UpsellOverlay, createCommonOverlayProps({
		onClose = v14,
		countDownBadge = v15,
		bodyText = v12,
		title = v11,
		imageId = v22,
		primaryAction = v18,
		impressionId = v5.impressionId,
		upsellEntryComponent = v5.upsellEntryComponent,
		upsellEntrySurface = v5.upsellEntrySurface,
		upsellPurpose = SocialUpsellType.FacialAgeEstimation,
		containerRef = v5.containerRef
	}, v5))
end
