local HttpService = game:GetService("HttpService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/React")
local fFlagEditProfileFramesEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/SharedFlags").FFlagEditProfileFramesEnabled
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/RobloxAppHooks").useLocalUserId
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/Localization")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/RoactUtils")

local useProfileFrames = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Hooks/useProfileFrames")
local useUserAvatarConfigurations = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Hooks/useUserAvatarConfigurations")
local useProfileFramesGating = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Hooks/useProfileFramesGating")
local useEditProfileImageDraft = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Hooks/useEditProfileImageDraft")
local useEditProfileImageEmotes = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Hooks/useEditProfileImageEmotes")
local useEditProfileImageNavigation = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Hooks/useEditProfileImageNavigation")
local useEditProfileImageSave = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Hooks/useEditProfileImageSave")
local useFocusOnMountEffect = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/AvatarExperienceCommon").Hooks.useFocusOnMountEffect

local openProfileFramesSubscriptionUpsell = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/openProfileFramesSubscriptionUpsell")
local editProfileImageHelpers = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/editProfileImageHelpers")
local buildEditProfileImageAssetItems = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Utils/buildEditProfileImageAssetItems")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Components/AssetPicker/AssetPickerTile")
local EditProfileImageAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Analytics/EditProfileImageAnalytics")
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/Enums")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Constants")
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/TextKeys")

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalization = Localization.Hooks.useLocalization

local function useEditProfileImageViewModel(data)
	local v5 = useDispatch()
	local v6 = useLocalUserId()
	local v7, v8, v9 = useUserAvatarConfigurations(v6)
	local v10 = useProfileFrames()
	local v11 = useProfileFramesGating()
	local shouldShowFrames = v11.shouldShowFrames == true
	local v12 = React.useMemo(function(): boolean
		if data.initialFrameAssetId == nil then
			return false
		end

		for k, frameItem in v10.frameItems do
			if frameItem.id == data.initialFrameAssetId then
				return true
			end
		end

		return false
	end, { data.initialFrameAssetId, v10.frameItems })

	local v16 = useEditProfileImageDraft({
		savedCloseupConfig = v7,
		savedFrameAssetId = v8,
		isSavedConfigLoading = v9,
		showFrames = shouldShowFrames,
		initialFrameAssetId = data.initialFrameAssetId,
		initialFrameSelectionRequestId = data.initialFrameSelectionRequestId,
		isInitialFrameSelectionLoading = data.initialFrameAssetId ~= nil and v10.isLoading,
		isInitialFrameAvailable = v12
	})

	local v17 = useEditProfileImageNavigation({ mode = data.mode })

	local v18 = useEditProfileImageEmotes({ selectedEmoteId = v16.selectedEmoteId })

	local state, setState = React.useState(false)
	local canEquipFrame = v11.canEquipFrame or state
	local v19 = v11.shouldShowUpsell and not state
	local v20 = React.useCallback(function()
		setState(true)
		v11.refetchAmpAccess()
	end, { v11.refetchAmpAccess })
	local v21 = React.useCallback(function(p2)
		local guid = HttpService:GenerateGUID(false)

		local v22 = if v16.selectedFrameId ~= nil and v16.selectedFrameId ~= Constants.ProfileFrameNoneId then tonumber(v16.selectedFrameId) else nil

		EditProfileImageAnalytics.logSubscribe({
			mode = data.mode,
			purchaseFlowUuid = guid,
			frameAssetId = v22,
			source = p2
		})

		openProfileFramesSubscriptionUpsell({ dispatch = v5, onGranted = v20, purchaseFlowUuid = guid })
	end, { v5, v16.selectedFrameId, v20, data.mode })

	local v22 = React.useMemo(function()
		if not v16.selectedFrameId or v16.selectedFrameId == Constants.ProfileFrameNoneId then
			return nil
		end

		for k, frameItem in v10.frameItems do
			if frameItem.id == v16.selectedFrameId then
				return frameItem.previewImage or frameItem.image
			end
		end

		return nil
	end, { v16.selectedFrameId, v10.frameItems })

	local v23 = useLocalization({
		frames = TextKeys.Frames,
		subscribe = TextKeys.Subscribe,
		save = TextKeys.Save
	})

	local v24 = React.useMemo(function()
		return buildEditProfileImageAssetItems({
			ownedEmotes = v18.ownedEmotes,
			recommendedEmotes = v18.recommendedEmotes,
			frameItems = v10.frameItems,
			freeLabel = v18.freeLabel
		})
	end, { v18.ownedEmotes, v18.recommendedEmotes, v10.frameItems, v18.freeLabel })

	local v26 = {
		mode = data.mode,
		activeView = v17.activeView,
		titleBackAvailable = v17.titleBackAvailable,
		selectedEmoteId = v16.selectedEmoteId,
		savedEmoteAssetId = v7.emoteAssetId,
		selectedFrameId = v16.selectedFrameId,
		showFrames = shouldShowFrames,
		distanceScale = v16.distanceScale,
		yRotDeg = v16.yRotDeg,
		cutoutFieldOfViewDeg = data.cutoutFieldOfViewDeg,
		localUserId = v6,
		isPlusSubscriber = 0,
		dispatch = 0,
		onReturnToCombined = 0,
		onClose = 0,
		onSaveSuccess = 0
	}

	local v27 = if v11.ampAccess then v11.ampAccess.granted else false
	v26.isPlusSubscriber = v27
	v26.dispatch = v5
	v26.onReturnToCombined = v17.onReturnToCombined
	v26.onClose = data.onClose
	v26.onSaveSuccess = data.onSaveSuccess
	local v28 = useEditProfileImageSave(v26)

	local v29 = React.useCallback(function()
		v16.resetFromSavedConfig()
		v28.resetTransientState()
		data.onClose()
	end, { v16.resetFromSavedConfig, v28.resetTransientState, data.onClose })

	local v30 = React.useCallback(function()
		local v31, v32

		if v17.isFramesOnlyEntry then
			v31 = v29
			v32 = "exit"
		elseif v17.activeView == "emotes" and not fFlagEditProfileFramesEnabled then
			if v18.isRecommendedEmoteSelected then
				v31 = v16.clearSelectedEmote
				v32 = "clear_emote"
			else
				v31 = v29
				v32 = "exit"
			end
		elseif v17.titleBackAvailable then
			v31 = v17.onReturnToCombined
			v32 = "return_to_combined"
		elseif v18.isRecommendedEmoteSelected then
			v31 = v16.clearSelectedEmote
			v32 = "clear_emote"
		else
			v31 = v29
			v32 = "exit"
		end

		EditProfileImageAnalytics.logBack({
			mode = data.mode,
			activeView = v17.activeView,
			outcome = v32
		})

		v31()
	end, {
		data.mode,
		v17.isFramesOnlyEntry,
		v17.activeView,
		v17.titleBackAvailable,
		v17.onReturnToCombined,
		v18.isRecommendedEmoteSelected,
		v29,
		v16.clearSelectedEmote
	})

	local v31 = React.useCallback(function()
		EditProfileImageAnalytics.logRetry({ mode = data.mode, assetType = "emotes" })

		v18.onRetry()
	end, { data.mode, v18.onRetry })

	local v32 = React.useCallback(function()
		EditProfileImageAnalytics.logRetry({ mode = data.mode, assetType = "frames" })

		v10.refetch()
	end, { data.mode, v10.refetch })

	local v33 = fFlagEditProfileFramesEnabled and shouldShowFrames and not canEquipFrame

	if v33 then
		v33 = not (v16.selectedFrameId == nil) and v16.selectedFrameId ~= Constants.ProfileFrameNoneId
	end

	local footerCta = editProfileImageHelpers.resolveFooterCta({
		isFramesOnlyEntry = v17.isFramesOnlyEntry,
		isRecommendedEmoteSelected = v18.isRecommendedEmoteSelected,
		isEquipRestrictedFrameSelected = v33
	})

	local ref = React.useRef(nil)
	useFocusOnMountEffect(ref, 0)

	return {
		navigation = {
			activeView = v17.activeView,
			closeButtonRef = ref,
			onExpandEmotes = v17.onExpandEmotes,
			onExpandFrames = v17.onExpandFrames,
			onTitleBack = v17.onTitleBack,
			onBack = v30,
			onLeaveScreen = v29,
			onDidFocus = v28.resetTransientState
		},
		emotes = {
			selectedEmoteId = v16.selectedEmoteId,
			ownedItems = v24.ownedEmoteItems,
			recommendedItems = v24.recommendedEmoteItems,
			items = v24.combinedEmoteItems,
			isLoading = v18.isLoading,
			hasError = v18.hasError,
			hasMore = v18.hasMoreEmotes,
			isLoadingMore = v18.isLoadingMoreEmotes,
			hasLoadMoreError = v18.hasLoadMoreError,
			onSelect = v16.onSelectEmote,
			onRetry = v31,
			onMore = v18.onMoreEmotes
		},
		frames = {
			show = shouldShowFrames,
			shouldShowUpsell = v19,
			selectedFrameId = v16.selectedFrameId,
			items = v24.frameAssetItems,
			isLoading = v10.isLoading,
			hasError = v10.hasError,
			selectedImage = v22,
			localizedTitle = v23.frames,
			onSelect = v16.onSelectFrame,
			onRetry = v32,
			onOpenSubscriptionUpsell = v21
		},
		preview = {
			localUserId = v6,
			yRotDeg = v16.yRotDeg,
			distanceScale = v16.distanceScale,
			onYRotDegChanged = v16.onYRotDegChanged,
			onDistanceScaleChanged = v16.onDistanceScaleChanged
		},
		footer = {
			isSaving = v28.isSaving,
			cta = footerCta,
			subscribeLabel = v23.subscribe,
			saveLabel = v23.save,
			onSave = v28.onSave
		}
	}
end

return useEditProfileImageViewModel
