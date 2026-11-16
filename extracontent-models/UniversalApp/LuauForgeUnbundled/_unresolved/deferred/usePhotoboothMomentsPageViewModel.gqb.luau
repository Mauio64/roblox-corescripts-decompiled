local module = require("@luauforge/deferred/gpo")
local module2 = require("@luauforge/deferred/gpq")
require("@luauforge/deferred/gpD")
local module3 = require("@luauforge/deferred/gpF")
local useLocalization = require("@luauforge/deferred/gpA").Hooks.useLocalization

local fIntAXPhotoboothMomentsSnackbarDismissMs = require("@luauforge/deferred/gps").FIntAXPhotoboothMomentsSnackbarDismissMs

local fFlagAXPhotoboothMomentsCurrentAvatarTile = require("@luauforge/deferred/gps").FFlagAXPhotoboothMomentsCurrentAvatarTile
local fFlagAXPhotoboothMomentsLogging = require("@luauforge/deferred/gps").FFlagAXPhotoboothMomentsLogging
local useNavigation = require("@luauforge/deferred/gpu").useNavigation
local module4 = require("@luauforge/deferred/gqc")
local useDeviceInsets = module4.useDeviceInsets
local useOrientation = module4.useOrientation

local module5 = require("@luauforge/deferred/gpN")
local module6 = require("@luauforge/deferred/gpG")
local module7 = require("@luauforge/deferred/gpX")
require("@luauforge/deferred/gpC")

require("@luauforge/deferred/gpL")

require("@luauforge/deferred/gpR")

require("@luauforge/deferred/gpT")

local iconName = module2.Enums.IconName

local v5 = {
	{
		type = "icon",
		id = module3.PhotoboothMoments.MyAvatars,
		icon = iconName.CirclePerson
	},
	{
		type = "icon",
		id = module3.PhotoboothMoments.Emotes,
		icon = iconName.SquareFaceWavingHand
	},
	{
		type = "icon",
		id = module3.PhotoboothMoments.Backgrounds,
		icon = iconName.DiagonalLinePattern
	}
}

local function usePhotoboothMomentsPageViewModel(data)
	local v6 = useNavigation()
	local top = useDeviceInsets().top

	local v7 = useOrientation() == module4.Keys.Landscape

	local state, setState = module.useState("")

	local v8 = useLocalization({
		emotesNeedR15 = "Feature.Avatar.Label.LayeredClothingR15Warning",
		tryOnsReset = "Feature.Avatar.Label.ResetTryOn"
	})

	local state2, setState2 = module.useState("")

	local state3, setState3 = module.useState(false)

	local v9 = module5(false)
	local isEmotesDisabled = data.isEmotesDisabled

	local ref = module.useRef(nil)

	local v10 = module.useCallback(function()
		if ref.current then
			task.cancel(ref.current)
			ref.current = nil
		end

		setState2("")
	end, {})

	local v11 = module.useCallback(function(p2, p3)
		if ref.current then
			task.cancel(ref.current)
		end

		setState2(p2)
		setState3(p3)
		ref.current = task.delay(fIntAXPhotoboothMomentsSnackbarDismissMs / 1000, function()
			ref.current = nil
			setState2("")
		end)
	end, {})

	module.useEffect(function()
		return function()
			if ref.current then
				task.cancel(ref.current)
			end
		end
	end, {})

	local didResetTryOns = data.didResetTryOns
	module.useEffect(function()
		if didResetTryOns then
			v11(v8.tryOnsReset, false)
		end
	end, { didResetTryOns, v8.tryOnsReset, v11 })

	module.useEffect(function()
		local activeEmoteId = v9.getActiveEmoteId(false)

		if isEmotesDisabled then
			if activeEmoteId ~= module6.R6WaveEmoteId then
				if activeEmoteId ~= "" and activeEmoteId ~= module6.R15WaveEmoteId then
					v11(v8.emotesNeedR15, true)
				end

				v9.setActiveEmote(module6.R6WaveEmoteId)
			end
		elseif activeEmoteId == "" or activeEmoteId == module6.R6WaveEmoteId then
			v9.setActiveEmote(module6.R15WaveEmoteId)
		end
	end, { isEmotesDisabled, v9, v8.emotesNeedR15, v11 })

	local v12 = module.useCallback(function()
		v11(v8.emotesNeedR15, true)
	end, { v8.emotesNeedR15, v11 })
	local v13 = state ~= ""
	local v14 = v13 and not v7
	local onPanelCoversSceneChanged = data.onPanelCoversSceneChanged
	module.useEffect(function()
		if onPanelCoversSceneChanged then
			onPanelCoversSceneChanged(v14)
		end
	end, { v14, onPanelCoversSceneChanged })
	local ref2

	if fFlagAXPhotoboothMomentsLogging then
		ref2 = module.useRef(state)
		ref2.current = state
	else
		ref2 = nil
	end

	local v15 = {
		topInset = top,
		isLandscape = v7,
		onBackButtonPressed = module.useCallback(function()
			if fFlagAXPhotoboothMomentsLogging then
				module7.sendBackClick(ref2.current)
			end

			v6.goBack()
		end, { v6 }),
		menuItems = v5,
		activeMenuItemId = state,
		onMenuItemActivated = module.useCallback(function(p2)
			if fFlagAXPhotoboothMomentsLogging then
				local current = ref2.current
				local sendMenuItemClick = module7.sendMenuItemClick

				local v16 = if current == p2 then module7.MenuState.Close else module7.MenuState.Open
				sendMenuItemClick(p2, v16, current)
			end

			setState(function(p3)
				if p3 == p2 then
					return ""
				end

				return p2
			end)
		end, {}),
		isPanelVisible = v13,
		onPanelClosed = module.useCallback(function()
			setState("")
		end, {}),
		onOutsideActivated = module.useCallback(function()
			if fFlagAXPhotoboothMomentsLogging then
				module7.sendPanelDismissClick(ref2.current)
			end

			setState("")
		end, {}),
		avatars = data.avatars,
		hasMoreAvatars = data.hasMoreAvatars,
		onAvatarsEndReached = data.onAvatarsEndReached,
		currentAvatarThumbnailUrl = 0,
		emotes = 0,
		hasMoreEmotes = 0,
		onEmotesEndReached = 0,
		backgrounds = 0,
		hasMoreBackgrounds = 0,
		onBackgroundsEndReached = 0,
		isEmotesDisabled = 0,
		onContinue = 0,
		onEmoteBlocked = 0,
		snackbarText = 0,
		onSnackbarClosed = 0
	}

	local v16 = if fFlagAXPhotoboothMomentsCurrentAvatarTile then data.currentAvatarThumbnailUrl else nil
	v15.currentAvatarThumbnailUrl = v16

	v15.emotes = data.emotes
	v15.hasMoreEmotes = data.hasMoreEmotes
	v15.onEmotesEndReached = data.onEmotesEndReached
	v15.backgrounds = data.backgrounds
	v15.hasMoreBackgrounds = data.hasMoreBackgrounds
	v15.onBackgroundsEndReached = data.onBackgroundsEndReached
	v15.isEmotesDisabled = isEmotesDisabled
	v15.onContinue = data.onContinue
	v15.onEmoteBlocked = v12
	v15.snackbarText = state2

	if not state3 then
		v10 = nil
	end

	v15.onSnackbarClosed = v10
	return v15
end

return usePhotoboothMomentsPageViewModel
