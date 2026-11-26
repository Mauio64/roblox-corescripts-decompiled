local module = require("@luauforge/bundled/icF")
local module2 = require("@luauforge/bundled/icH")
local module3 = require("@luauforge/bundled/icJ")
local module4 = require("@luauforge/bundled/icK")
require("@luauforge/bundled/icL")
local module5 = require("@luauforge/bundled/icM")
local module6 = require("@luauforge/bundled/icN")
local module7 = require("@luauforge/bundled/icO")
local module8 = require("@luauforge/bundled/icP")

require("@luauforge/bundled/icD")
local module9 = require("@luauforge/bundled/icQ")
local module10 = require("@luauforge/bundled/icT")
local module11 = require("@luauforge/bundled/icV")
local module12 = require("@luauforge/bundled/icW")
local module13 = require("@luauforge/bundled/icX")

require("@luauforge/bundled/icG")

local getRbxThumb = module2.Utility.getRbxThumb
local iconName = module2.Enums.IconName
local thumbnailType = module2.Enums.ThumbnailType
local thumbnailSize = module2.Enums.ThumbnailSize
local useFocusRoot = module3.useFocusRoot
local focusNavigableSurfaceIdentifierEnum = module3.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = module3.FocusNavigationEventNameEnum
local useSignalState = module5.useSignalState
local useLocalUserId = module6.useLocalUserId
local useUserAvatarConfigurations = module7.useUserAvatarConfigurations
local useProfileFrames = module7.useProfileFrames
local useProfileFramesGating = module7.useProfileFramesGating
local saveEditProfileImage = module7.saveEditProfileImage

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local v5 = {
	title = "Feature.RobloxSubscription.Heading.OnboardingLook",
	body = "Feature.RobloxSubscription.Description.OnboardingLook",
	appThemes = "Feature.RobloxSubscription.Label.AppThemes",
	profileFrames = "Feature.RobloxSubscription.Label.ProfileFrames",
	noProfileFrame = "Feature.RobloxSubscription.Label.NoProfileFrame",
	shuffle = "Feature.RobloxSubscription.Action.TryAnotherLook",
	reset = "Feature.RobloxSubscription.Action.ResetLook"
}

local random = Random.new()

local function findFrameItem(items, p2)
	if p2 == nil then
		return nil
	end

	for k, item in items do
		if item.id == p2 then
			return item
		end
	end

	return nil
end

local function useRobloxSubscriptionOnboardingSheetViewModel(data)
	local theme = data.theme
	local onClose = data.onClose
	local onAppThemesActivated = data.onAppThemesActivated
	local onProfileFramesActivated = data.onProfileFramesActivated

	local v6 = module13(v5)
	local v7 = useLocalUserId()

	local v8 = useSignalState(module8.RobloxSubscriptionSignals.get().getHasRobloxSubscription)

	local v9, v10, v11, v12 = useUserAvatarConfigurations(v7)
	local v13 = useProfileFrames()
	local v14 = useProfileFramesGating()
	local v15 = module9.get()
	local v16 = useSignalState(v15.getOriginalLook)

	local ref = module.useRef(nil)

	local state, setState = module.useState(nil)

	local ref2 = module.useRef(theme.currentKey)
	local ref3 = module.useRef(nil)

	module.useEffect(function()
		module11(module10.RobloxSubscriptionOnboardingSheetImpressedCounter)

		return function()
			local current = ref3.current

			if current then
				current()
			end
		end
	end, {})

	local v17 = if state then state.frameAssetId else v10
	local currentKey = theme.currentKey

	local v18 = v8 and not (v11 or v12 or v13.isLoading or v14.isAmpLoading) and not theme.isSaving

	local v19 = v14.shouldShowFrames and not v12
	local canEquipFrame = v19 and v14.canEquipFrame

	module.useEffect(function()
		function ref3.current()
			if theme.showsThemes and currentKey ~= ref2.current then
				theme.equipTheme(currentKey, ref2.current)
			end

			if state == nil or not canEquipFrame or state.frameAssetId == v10 then
				return
			end

			local frameAssetId = state.frameAssetId
			task.spawn(function()
				if not saveEditProfileImage({
					emoteAssetId = v9.emoteAssetId,
					profileFrameAssetId = not frameAssetId and 0 or tonumber(frameAssetId),
					cameraDistanceScale = v9.distanceScale,
					cameraYRotDeg = v9.yRotDeg,
					fieldOfViewDeg = v9.fieldOfViewDeg,
					localUserId = v7
				}) then
					module11(module10.RobloxSubscriptionOnboardingSheetFrameSaveFailedCounter)
				end
			end)
		end
	end, { theme, currentKey, state, canEquipFrame, v10, v9, v7 })

	local v20 = module.useCallback(function(p2)
		if theme.showsThemes and p2.themeKey ~= currentKey then
			theme.previewTheme(p2.themeKey)
		end

		if canEquipFrame and p2.frameAssetId ~= v17 then
			setState({ frameAssetId = p2.frameAssetId })
		end
	end, { theme, currentKey, v17, canEquipFrame })

	local frameItems = v13.frameItems
	local v21 = module.useCallback(function()
		local ids = {}

		if canEquipFrame then
			for k, frameItem in frameItems do
				table.insert(ids, frameItem.id)
			end
		end

		v20(module12({ themeKey = currentKey, frameAssetId = v17 }, {
			themeKeys = not theme.showsThemes and {} or theme.shuffleKeys,
			frameAssetIds = ids
		}, random))
	end, { v20, frameItems, canEquipFrame, theme, currentKey, v17 })

	module.useEffect(function()
		if not v18 or v15.getOriginalLook(false) ~= nil then
			return
		end

		v15.setOriginalLook({ themeKey = currentKey, frameAssetId = v17 })
		v21()
	end, { v18, currentKey, v17, v21, v15.getOriginalLook, v15.setOriginalLook })

	local v22 = module.useCallback(function()
		local current = ref.current

		if current then
			current.close()
		else
			onClose()
		end
	end, { onClose })

	local v23 = module.useCallback(function()
		module11(module10.RobloxSubscriptionOnboardingSheetShuffleClickedCounter)

		v21()
	end, { v21 })

	local v24 = module.useCallback(function()
		if v16 == nil then
			return
		end

		module11(module10.RobloxSubscriptionOnboardingSheetResetClickedCounter)

		v20(v16)
	end, { v16, v20 })

	local v25 = module.useCallback(function()
		module11(module10.RobloxSubscriptionOnboardingSheetAppThemesClickedCounter)

		onAppThemesActivated()
	end, { onAppThemesActivated })

	local v26 = module.useCallback(function()
		module11(module10.RobloxSubscriptionOnboardingSheetProfileFramesClickedCounter)

		onProfileFramesActivated(v17)
	end, { onProfileFramesActivated, v17 })

	local v27 = module.useMemo(function()
		local v28 = {}
		v28[focusNavigationEventNameEnum.NavigateBack] = {
			handler = module4.onRelease(function(object)
				object:cancel()
				v22()
			end)
		}

		return v28
	end, { v22 })

	local v28 = useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		eventMap = navigateBacks,
		eventHandlers = v27,
		isAutoFocusRoot = true,
		isFocusable = true
	})
	local v29

	if v17 ~= nil then
		for k, frameItem in frameItems do
			if frameItem.id == v17 then
				v29 = frameItem
				break
			end
		end
	end

	local v30 = iconName.CircleSlash
	local previewImage

	if v19 and v17 then
		previewImage = v29 and (v29.previewImage or v29.image)
			or getRbxThumb(thumbnailType.Asset, v17, thumbnailSize.Large)
		v30 = v29 and v29.image or getRbxThumb(thumbnailType.Asset, v17, thumbnailSize.Medium)
	end

	local v31 = not (v16 == nil or v16.themeKey ~= currentKey) and v16.frameAssetId == v17

	local v32 = {
		sheetRef = ref,
		focusRootRef = v28,
		onClose = onClose,
		titleText = v6.title,
		bodyText = v6.body,
		headshotImage = getRbxThumb(thumbnailType.AvatarHeadShot, v7, thumbnailSize.Large),
		frameImage = previewImage,
		themeRow = theme.showsThemes and {
			title = v6.appThemes,
			metadata = theme.getLabel(currentKey),
			swatchColor = theme.getSwatchColor(currentKey),
			onActivated = v25
		} or nil,
		frameRow = 0,
		shuffleText = 0,
		resetText = 0,
		isShuffleDisabled = 0,
		isResetDisabled = 0,
		onShuffle = 0,
		onReset = 0
	}
	local v33

	if v19 then
		v33 = { title = v6.profileFrames, metadata = 0, leading = 0, onActivated = 0 }
		local v34 = if v17 == nil then v6.noProfileFrame elseif v29 then v29.label else nil
		v33.metadata = v34

		v33.leading = v30
		v33.onActivated = v26
	end

	v32.frameRow = v33

	v32.shuffleText = v6.shuffle
	v32.resetText = v6.reset
	v32.isShuffleDisabled = not v18
	v32.isResetDisabled = not v18 or v16 == nil or v31
	v32.onShuffle = v23
	v32.onReset = v24
	return v32
end

return useRobloxSubscriptionOnboardingSheetViewModel
