local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local parent = SocialUpsell.Parent

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local FoundationCloudAssets = require(parent.FoundationCloudAssets)
local FIntCommsFAELockTimestamp = require(SocialUpsell.Flag.FIntCommsFAELockTimestamp)
local UpsellOverlay = require(SocialUpsell.Components.UpsellOverlay)
local createCommonOverlayProps = require(SocialUpsell.Utils.createCommonOverlayProps)
local startFacialAgeEstimation = require(SocialUpsell.Thunks.startFacialAgeEstimation)
local UpsellEntrySurfaceType = require(SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType)
local SocialUpsellType = require(SocialUpsell.Enum.SocialUpsellType)
local UpsellComponent = require(SocialUpsell.Analytics.Enum.UpsellComponent)
local FFlagEnableCountdownBadge = require(SocialUpsell.Flag.FFlagEnableCountdownBadge)
local Assets = FoundationCloudAssets.Assets
local preloadAsset = FoundationCloudAssets.preloadAsset

preloadAsset("pictograms/chat_security")
local pictogramschat_security = Assets["pictograms/chat_security"]
local assetId = pictogramschat_security and pictogramschat_security.assetId or nil

local FFlagAddFriendsPageFAEUpsell = SharedFlags.FFlagAddFriendsPageFAEUpsell
local assetId2

if FFlagAddFriendsPageFAEUpsell then
	preloadAsset("pictograms/lock_closed")
	local pictogramslock_closed = Assets["pictograms/lock_closed"]
	assetId2 = pictogramslock_closed and pictogramslock_closed.assetId or nil
else
	assetId2 = nil
end

local useSocialUpsellOverlayController = require(SocialUpsell.Hooks.useSocialUpsellOverlayController)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local FFlagEnableAEGIS2CommsFAEUpsell = SharedFlags.FFlagEnableAEGIS2CommsFAEUpsell
local defineFastFlag = game:DefineFastFlag("AEGISPhase2ShowImageOnFAEOverlay", false)
local defineFastFlag2 = game:DefineFastFlag("ForceAegisPhase2Modal", false)

return function(options)
	local v = options or {}
	local v2 = useDispatch()
	local v3 = useSocialUpsellOverlayController(v.isInExperience)
	local v4 = useLocalization({
		ToKeepChattingLetsCheckYourAge = "Feature.FAE.Label.ToKeepChattingLetsCheckYourAge",
		ModalBodyInApp = "Feature.FAE.Label.ModalBodyInApp",
		LetsCheckYourAgeSoYouCanUseChat = "Feature.FAE.Label.LetsCheckYourAgeSoYouCanUseChat",
		ModalBodyInAppV3 = "Feature.FAE.Label.ModalBodyInAppV3",
		YourSafetyMattersLetsCheckYourAge = "Feature.FAE.Label.YourSafetyMattersLetsCheckYourAge",
		YouNeedAnAgeCheckToUseChatThisMakesChatSafer = "Feature.FAE.Label.YouNeedAnAgeCheckToUseChatThisMakesChatSafer",
		ChatWithFriends = FFlagAddFriendsPageFAEUpsell and "Feature.FAE.Label.ChatWithFriends" or nil,
		GetASecureAgeCheckToUnlockChatAndAddTrustedFriends = FFlagAddFriendsPageFAEUpsell and "Feature.FAE.Label.GetASecureAgeCheckToUnlockChatAndAddTrustedFriends" or nil,
		Unlock = FFlagAddFriendsPageFAEUpsell and "Feature.FAE.Action.Unlock" or nil,
		Continue = "Feature.FAE.Action.Continue",
		ThisAllowsYouToChatSafelyItOnlyTakesAMoment = FFlagEnableAEGIS2CommsFAEUpsell and "Feature.FAE.Label.ThisAllowsYouToChatSafelyItOnlyTakesAMoment" or nil,
		UnlockChat = FFlagEnableAEGIS2CommsFAEUpsell and "Feature.FAE.Action.UnlockChat" or nil,
		ThisHelpsYouToChatSafelyItOnlyTakesAMoment = "Feature.FAE.Label.ThisHelpsYouToChatSafelyItOnlyTakesAMoment",
		LetsCheckYourAge = "Feature.FAE.Label.LetsCheckYourAge",
		ToAddTrustedFriendDoAgeCheck = "Feature.FAE.Label.ModalBodyTFUnlock"
	})

	local ref = React.useRef(false)

	local useMemo = React.useMemo
	local function fn()
		if FFlagEnableAEGIS2CommsFAEUpsell and (defineFastFlag2 or v.isPhase2) then
			return v4.LetsCheckYourAgeSoYouCanUseChat, v4.ThisHelpsYouToChatSafelyItOnlyTakesAMoment
		end

		if
			v.upsellEntrySurface == UpsellEntrySurfaceType.Homepage and v.upsellEntryComponent == UpsellComponent.Modal
			or v.upsellEntrySurface == UpsellEntrySurfaceType.NotifPush
		then
			return v4.YourSafetyMattersLetsCheckYourAge, v4.YouNeedAnAgeCheckToUseChatThisMakesChatSafer
		end

		if FFlagAddFriendsPageFAEUpsell and v.upsellEntrySurface == UpsellEntrySurfaceType.AddFriendsPage then
			return v4.ChatWithFriends, v4.GetASecureAgeCheckToUnlockChatAndAddTrustedFriends
		end

		if
			v.upsellEntrySurface == UpsellEntrySurfaceType.TrustedFriends
			or v.upsellEntrySurface == UpsellEntrySurfaceType.TrustedFriendsInExperience
		then
			return v4.LetsCheckYourAge, v4.ToAddTrustedFriendDoAgeCheck
		end

		return v4.LetsCheckYourAgeSoYouCanUseChat, v4.ModalBodyInAppV3
	end

	local isPhase2

	if FFlagEnableAEGIS2CommsFAEUpsell then
		isPhase2 = v.isPhase2
	end

	local upsellEntrySurface = v.upsellEntrySurface
	local v5

	if FFlagAddFriendsPageFAEUpsell then
		v5 = v.upsellEntryComponent
	end

	local title, bodyText = useMemo(fn, { isPhase2, upsellEntrySurface, v4, v5 })

	local onActivated = React.useCallback(function()
		v3.closeSocialOverlay()

		if v.onAccept then
			v.onAccept()
		end

		if game.JobId ~= "" and not FFlagEnableAEGIS2CommsFAEUpsell then
			return
		end

		local entryPointEventCtx

		if v.shouldIncludeVPC then
			entryPointEventCtx = v.entryPointEventCtx
				or SocialUpsellType.FacialAgeEstimation .. (v.upsellEntrySurface or "")
		else
			entryPointEventCtx = v.entryPointEventCtx
		end

		local onSuccess = v.onSuccess
		local onFailure = v.onFailure
		local upsellEntrySurface2 = v.upsellEntrySurface
		local v6

		if FFlagEnableAEGIS2CommsFAEUpsell then
			v6 = v.isInExperience
		end

		v2(startFacialAgeEstimation(
			entryPointEventCtx,
			onSuccess,
			onFailure,
			upsellEntrySurface2,
			v6,
			v.shouldIncludeVPC
		))
	end, {
		v2,
		v3.closeSocialOverlay,
		v.upsellEntrySurface,
		v.entryPointEventCtx,
		v.onAccept,
		v.onSuccess,
		v.onFailure,
		v.isInExperience,
		v.shouldIncludeVPC
	})

	local onClose = React.useCallback(function()
		if v.onDismiss then
			v.onDismiss()
		end
	end, { v.onDismiss })

	local countDownBadge = React.useMemo(function()
		if FFlagEnableCountdownBadge and v.countDownBadgeText then
			return { text = v.countDownBadgeText, deadlineUtcTimestamp = FIntCommsFAELockTimestamp }
		end

		return nil
	end, { v.countDownBadgeText })

	local useMemo2 = React.useMemo
	local function fn2()
		local text

		if FFlagAddFriendsPageFAEUpsell and v.upsellEntrySurface == UpsellEntrySurfaceType.AddFriendsPage then
			text = v4.Unlock
		elseif FFlagEnableAEGIS2CommsFAEUpsell and (defineFastFlag2 or v.isPhase2) and not v.isInExperience then
			text = v4.UnlockChat
		else
			text = v4.Continue
		end

		return { text = text, onActivated = onActivated }
	end

	local isPhase2_2

	if FFlagEnableAEGIS2CommsFAEUpsell then
		isPhase2_2 = v.isPhase2
	end

	local isInExperience = v.isInExperience
	local v6

	if FFlagAddFriendsPageFAEUpsell then
		v6 = v.upsellEntrySurface
	end

	local primaryAction = useMemo2(fn2, { isPhase2_2, isInExperience, v4, onActivated, v6 })

	React.useEffect(function()
		if not ref.current and v.onMounted then
			v.onMounted()
		end

		ref.current = true
	end, { v.onMounted })

	local createElement = React.createElement
	local imageId

	if FFlagAddFriendsPageFAEUpsell and v.upsellEntrySurface == UpsellEntrySurfaceType.AddFriendsPage then
		imageId = assetId2
	elseif FFlagEnableAEGIS2CommsFAEUpsell and (defineFastFlag2 or v.isPhase2) then
		local v7 = not defineFastFlag and v.isInExperience

		if not v7 then
			imageId = assetId
		end
	else
		imageId = assetId
	end

	return createElement(UpsellOverlay, createCommonOverlayProps({
		onClose = onClose,
		countDownBadge = countDownBadge,
		bodyText = bodyText,
		title = title,
		imageId = imageId,
		primaryAction = primaryAction,
		impressionId = v.impressionId,
		upsellEntryComponent = v.upsellEntryComponent,
		upsellEntrySurface = v.upsellEntrySurface,
		upsellPurpose = SocialUpsellType.FacialAgeEstimation,
		containerRef = v.containerRef
	}, v))
end
