local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent
local HttpService = game:GetService("HttpService")

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local FFlagEditProfileFramesEnabled = SharedFlags.FFlagEditProfileFramesEnabled
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local Localization = require(parent.Localization)
local RoactUtils = require(parent.RoactUtils)

local useProfileFrames = require(AvatarExperienceProfilePictureEditor.Hooks.useProfileFrames)
local useUserAvatarConfigurations = require(AvatarExperienceProfilePictureEditor.Hooks.useUserAvatarConfigurations)
local useProfileFramesGating = require(AvatarExperienceProfilePictureEditor.Hooks.useProfileFramesGating)
local useEditProfileImageDraft = require(AvatarExperienceProfilePictureEditor.Hooks.useEditProfileImageDraft)
local useEditProfileImageEmotes = require(AvatarExperienceProfilePictureEditor.Hooks.useEditProfileImageEmotes)
local useEditProfileImageNavigation = require(AvatarExperienceProfilePictureEditor.Hooks.useEditProfileImageNavigation)
local useEditProfileImageSave = require(AvatarExperienceProfilePictureEditor.Hooks.useEditProfileImageSave)
local AvatarExperienceCommon = require(parent.AvatarExperienceCommon)
local useFocusOnMountEffect = AvatarExperienceCommon.Hooks.useFocusOnMountEffect

local openProfileFramesSubscriptionUpsell = require(AvatarExperienceProfilePictureEditor.Utils.openProfileFramesSubscriptionUpsell)
local editProfileImageHelpers = require(AvatarExperienceProfilePictureEditor.Utils.editProfileImageHelpers)
local buildEditProfileImageAssetItems = require(AvatarExperienceProfilePictureEditor.Utils.buildEditProfileImageAssetItems)
require(AvatarExperienceProfilePictureEditor.Components.AssetPicker.AssetPickerTile)
local EditProfileImageAnalytics = require(AvatarExperienceProfilePictureEditor.Analytics.EditProfileImageAnalytics)
require(AvatarExperienceProfilePictureEditor.Common.Enums)
local Constants = require(AvatarExperienceProfilePictureEditor.Constants)
local TextKeys = require(AvatarExperienceProfilePictureEditor.Common.TextKeys)

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization

local function useEditProfileImageViewModel(data)
	local dispatch = useDispatch()
	local localUserId = useLocalUserId()
	local savedCloseupConfig, savedFrameAssetId, isSavedConfigLoading = useUserAvatarConfigurations(localUserId)
	local v = useProfileFrames()
	local v2 = useProfileFramesGating()
	local shouldShowFrames = v2.shouldShowFrames == true
	local isInitialFrameAvailable = React.useMemo(function(): boolean
		if data.initialFrameAssetId == nil then
			return false
		end

		for _, frameItem in v.frameItems do
			if frameItem.id == data.initialFrameAssetId then
				return true
			end
		end

		return false
	end, { data.initialFrameAssetId, v.frameItems })

	local v3 = useEditProfileImageDraft({
		savedCloseupConfig = savedCloseupConfig,
		savedFrameAssetId = savedFrameAssetId,
		isSavedConfigLoading = isSavedConfigLoading,
		showFrames = shouldShowFrames,
		initialFrameAssetId = data.initialFrameAssetId,
		initialFrameSelectionRequestId = data.initialFrameSelectionRequestId,
		isInitialFrameSelectionLoading = data.initialFrameAssetId ~= nil and v.isLoading,
		isInitialFrameAvailable = isInitialFrameAvailable
	})

	local v4 = useEditProfileImageNavigation({ mode = data.mode })

	local v5 = useEditProfileImageEmotes({ selectedEmoteId = v3.selectedEmoteId })

	local state, setState = React.useState(false)
	local canEquipFrame = v2.canEquipFrame or state
	local shouldShowUpsell = v2.shouldShowUpsell and not state
	local onGranted = React.useCallback(function()
		setState(true)
		v2.refetchAmpAccess()
	end, { v2.refetchAmpAccess })
	local onOpenSubscriptionUpsell = React.useCallback(function(source)
		local guid = HttpService:GenerateGUID(false)
		local frameAssetId

		if not (v3.selectedFrameId == nil or v3.selectedFrameId == Constants.ProfileFrameNoneId) then
			frameAssetId = tonumber(v3.selectedFrameId)
		end

		EditProfileImageAnalytics.logSubscribe({
			mode = data.mode,
			purchaseFlowUuid = guid,
			frameAssetId = frameAssetId,
			source = source
		})

		openProfileFramesSubscriptionUpsell({
			dispatch = dispatch,
			onGranted = onGranted,
			purchaseFlowUuid = guid
		})
	end, { dispatch, v3.selectedFrameId, onGranted, data.mode })

	local selectedImage = React.useMemo(function()
		if not v3.selectedFrameId or v3.selectedFrameId == Constants.ProfileFrameNoneId then
			return nil
		end

		for _, frameItem in v.frameItems do
			if frameItem.id == v3.selectedFrameId then
				return frameItem.previewImage or frameItem.image
			end
		end

		return nil
	end, { v3.selectedFrameId, v.frameItems })

	local v6 = useLocalization({
		frames = TextKeys.Frames,
		subscribe = TextKeys.Subscribe,
		save = TextKeys.Save
	})

	local v7 = React.useMemo(function()
		return buildEditProfileImageAssetItems({
			ownedEmotes = v5.ownedEmotes,
			recommendedEmotes = v5.recommendedEmotes,
			frameItems = v.frameItems,
			freeLabel = v5.freeLabel
		})
	end, { v5.ownedEmotes, v5.recommendedEmotes, v.frameItems, v5.freeLabel })

	local v8 = {
		mode = data.mode,
		activeView = v4.activeView,
		titleBackAvailable = v4.titleBackAvailable,
		selectedEmoteId = v3.selectedEmoteId,
		savedEmoteAssetId = savedCloseupConfig.emoteAssetId,
		selectedFrameId = v3.selectedFrameId,
		showFrames = shouldShowFrames,
		distanceScale = v3.distanceScale,
		yRotDeg = v3.yRotDeg,
		cutoutFieldOfViewDeg = data.cutoutFieldOfViewDeg,
		localUserId = localUserId,
		isPlusSubscriber = 0,
		dispatch = 0,
		onReturnToCombined = 0,
		onClose = 0,
		onSaveSuccess = 0
	}
	local isPlusSubscriber

	if v2.ampAccess then
		isPlusSubscriber = v2.ampAccess.granted
	else
		isPlusSubscriber = false
	end

	v8.isPlusSubscriber = isPlusSubscriber
	v8.dispatch = dispatch
	v8.onReturnToCombined = v4.onReturnToCombined
	v8.onClose = data.onClose
	v8.onSaveSuccess = data.onSaveSuccess
	local v9 = useEditProfileImageSave(v8)

	local onLeaveScreen = React.useCallback(function()
		v3.resetFromSavedConfig()
		v9.resetTransientState()
		data.onClose()
	end, { v3.resetFromSavedConfig, v9.resetTransientState, data.onClose })

	local onBack = React.useCallback(function()
		local v10, outcome

		if v4.isFramesOnlyEntry then
			v10 = onLeaveScreen
			outcome = "exit"
		elseif v4.activeView == "emotes" and not FFlagEditProfileFramesEnabled then
			if v5.isRecommendedEmoteSelected then
				v10 = v3.clearSelectedEmote
				outcome = "clear_emote"
			else
				v10 = onLeaveScreen
				outcome = "exit"
			end
		elseif v4.titleBackAvailable then
			v10 = v4.onReturnToCombined
			outcome = "return_to_combined"
		elseif v5.isRecommendedEmoteSelected then
			v10 = v3.clearSelectedEmote
			outcome = "clear_emote"
		else
			v10 = onLeaveScreen
			outcome = "exit"
		end

		EditProfileImageAnalytics.logBack({
			mode = data.mode,
			activeView = v4.activeView,
			outcome = outcome
		})

		v10()
	end, {
		data.mode,
		v4.isFramesOnlyEntry,
		v4.activeView,
		v4.titleBackAvailable,
		v4.onReturnToCombined,
		v5.isRecommendedEmoteSelected,
		onLeaveScreen,
		v3.clearSelectedEmote
	})

	local onRetry = React.useCallback(function()
		EditProfileImageAnalytics.logRetry({ mode = data.mode, assetType = "emotes" })

		v5.onRetry()
	end, { data.mode, v5.onRetry })

	local onRetry2 = React.useCallback(function()
		EditProfileImageAnalytics.logRetry({ mode = data.mode, assetType = "frames" })

		v.refetch()
	end, { data.mode, v.refetch })

	local isEquipRestrictedFrameSelected = FFlagEditProfileFramesEnabled and shouldShowFrames and not canEquipFrame

	if isEquipRestrictedFrameSelected then
		if v3.selectedFrameId == nil then
			isEquipRestrictedFrameSelected = false
		else
			isEquipRestrictedFrameSelected = v3.selectedFrameId ~= Constants.ProfileFrameNoneId
		end
	end

	local footerCta = editProfileImageHelpers.resolveFooterCta({
		isFramesOnlyEntry = v4.isFramesOnlyEntry,
		isRecommendedEmoteSelected = v5.isRecommendedEmoteSelected,
		isEquipRestrictedFrameSelected = isEquipRestrictedFrameSelected
	})

	local ref = React.useRef(nil)
	useFocusOnMountEffect(ref, 0)

	return {
		navigation = {
			activeView = v4.activeView,
			closeButtonRef = ref,
			onExpandEmotes = v4.onExpandEmotes,
			onExpandFrames = v4.onExpandFrames,
			onTitleBack = v4.onTitleBack,
			onBack = onBack,
			onLeaveScreen = onLeaveScreen,
			onDidFocus = v9.resetTransientState
		},
		emotes = {
			selectedEmoteId = v3.selectedEmoteId,
			ownedItems = v7.ownedEmoteItems,
			recommendedItems = v7.recommendedEmoteItems,
			items = v7.combinedEmoteItems,
			isLoading = v5.isLoading,
			hasError = v5.hasError,
			hasMore = v5.hasMoreEmotes,
			isLoadingMore = v5.isLoadingMoreEmotes,
			hasLoadMoreError = v5.hasLoadMoreError,
			onSelect = v3.onSelectEmote,
			onRetry = onRetry,
			onMore = v5.onMoreEmotes
		},
		frames = {
			show = shouldShowFrames,
			shouldShowUpsell = shouldShowUpsell,
			selectedFrameId = v3.selectedFrameId,
			items = v7.frameAssetItems,
			isLoading = v.isLoading,
			hasError = v.hasError,
			selectedImage = selectedImage,
			localizedTitle = v6.frames,
			onSelect = v3.onSelectFrame,
			onRetry = onRetry2,
			onOpenSubscriptionUpsell = onOpenSubscriptionUpsell
		},
		preview = {
			localUserId = localUserId,
			yRotDeg = v3.yRotDeg,
			distanceScale = v3.distanceScale,
			onYRotDegChanged = v3.onYRotDegChanged,
			onDistanceScaleChanged = v3.onDistanceScaleChanged
		},
		footer = {
			isSaving = v9.isSaving,
			cta = footerCta,
			subscribeLabel = v6.subscribe,
			saveLabel = v6.save,
			onSave = v9.onSave
		}
	}
end

return useEditProfileImageViewModel
