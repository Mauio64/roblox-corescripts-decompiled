local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local AppCommonLib = require("@game/CorePackages/Workspace/Packages/AppCommonLib")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module4 = require("@luauforge/deferred/gTO")
local module5 = require("@luauforge/bundled/fIP")

local fFlagAXPhotoboothMomentsCurrentAvatarTile = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXPhotoboothMomentsCurrentAvatarTile

local fFlagAXAvatarMomentsCreation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXAvatarMomentsCreation
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagMomentsRenderCreatePostStatus = SharedFlags.FFlagMomentsRenderCreatePostStatus
local fFlagEnableArgusImmersiveNav = SharedFlags.FFlagEnableArgusImmersiveNav

local module7 = require("@luauforge/deferred/gTM")
local module8 = require("@luauforge/deferred/hkH")
local module9 = require("@luauforge/deferred/hkI")
local module10 = require("@luauforge/deferred/hkK")
local module11 = require("@luauforge/deferred/hkL")
local module12 = require("@luauforge/deferred/hkN")
local fullView = AvatarExperienceCommon.Enums.FullView
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useStore = RoactUtils.Hooks.RoactRodux.useStore
local module13 = require("@luauforge/bundled/dFm")
local module14 = require("@luauforge/bundled/dzE")
local module15 = require("@luauforge/bundled/dFu")

local photoboothMomentsPage = module4.Components.PhotoboothMomentsPage
local module16 = require("@luauforge/deferred/gRz")

local function getMomentsDestination(p2)
	if not module5.canRenderNativeMoments(p2) then
		return nil
	end

	if p2.isTabEnabled and not (AppCommonLib.isSpatial() or AppCommonLib.isTenFootInterface()) then
		return module15.Moments
	end

	if fFlagEnableArgusImmersiveNav then
		return module15.MomentsImmersive
	end

	return nil
end

local function PhotoboothMomentsScreen()
	local v5, v6 = module7()
	local v7 = if fFlagMomentsRenderCreatePostStatus then useDispatch() else nil
	local v8 = if fFlagAXAvatarMomentsCreation then useNavigation() else nil
	local v9 = if fFlagAXAvatarMomentsCreation then module5.Hooks.useMomentsGating() else nil
	local ref = if fFlagAXAvatarMomentsCreation then React.useRef(0) else nil
	local v10 = useStore()
	local state, setState, state2, setState2

	if fFlagAXAvatarMomentsCreation then
		state, setState = React.useState(nil)
		state2, setState2 = React.useState(nil)
	else
		setState2 = nil
		setState = nil
		state2 = nil
	end

	local v11

	if fFlagMomentsRenderCreatePostStatus then
		v11 = useLocalization({
			publishedTitle = "Feature.Moments.Title.MomentPosting",
			publishedBody = "Feature.Moments.Body.MomentPosting",
			failedTitle = "Feature.Moments.Label.MomentFailedToPostTitle",
			failedBody = "Feature.Moments.Label.MomentFailedToPostBody"
		})
	else
		v11 = nil
	end

	local v12 = React.useState(function(): boolean
		return next(v10:getState().AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems or {}) ~= nil
	end)

	local v13 = module8()
	local v14 = module9()
	local v15 = module10()

	local v16 = module11()
	local v17 = if fFlagAXAvatarMomentsCreation then module12() else nil

	local v18 = React.useCallback(function(p2)
		local v20 = if p2 then fullView.None else fullView.SceneFullView
		v6(v20)
	end, { v6 })
	local v19

	if fFlagAXAvatarMomentsCreation then
		v19 = React.useCallback(function()
			ref.current += 1
			setState2(ref.current)
			setState(v17)
		end, { v17 })
	end

	local v20

	if fFlagAXAvatarMomentsCreation then
		v20 = React.useCallback(function(): boolean
			return state2 == ref.current
		end, { state2 })
	else
		v20 = nil
	end

	local v21

	if fFlagAXAvatarMomentsCreation then
		local useCallback = React.useCallback
		local function fn()
			if not v20() then
				return
			end

			local module17 = require("@luauforge/deferred/hkO")
			ref.current += 1
			setState2(nil)
			setState(nil)
			module17.resetCreationFlow(module17.Enums.CreationFlowState.Preview)
		end

		v21 = useCallback(fn, { if fFlagAXAvatarMomentsCreation then v20 else nil })
	end

	if fFlagAXAvatarMomentsCreation then
		local v22 = state ~= nil
		React.useEffect(function()
			if v22 then
				return function()
					local module17 = require("@luauforge/deferred/hkO")
					ref.current += 1

					module17.resetCreationFlow(module17.Enums.CreationFlowState.Preview)
				end
			end
		end, { v22 })
	end

	local v22

	if fFlagMomentsRenderCreatePostStatus then
		local useCallback = React.useCallback
		local function fn(p2)
			local v26 = if p2 then v11.publishedTitle else v11.failedTitle
			local v27 = if p2 then v11.publishedBody else v11.failedBody

			local v28 = if p2 then module14.SuccessConfirmation else module14.NetworkingError
			v7(module13({
				toastMessage = v26,
				toastSubMessage = v27,
				isLocalized = true,
				toastType = v28
			}))

			if fFlagAXAvatarMomentsCreation and p2 and state2 == ref.current and v8.isFocused() then
				local v29 = v9
				local v30

				if module5.canRenderNativeMoments(v29) then
					if v29.isTabEnabled and not (AppCommonLib.isSpatial() or AppCommonLib.isTenFootInterface()) then
						v30 = module15.Moments
					elseif fFlagEnableArgusImmersiveNav then
						v30 = module15.MomentsImmersive
					end
				end

				if v30 ~= nil then
					v8.navigate(v30, { source = "watch_tab" })
				end
			end
		end

		local v24 = if fFlagAXAvatarMomentsCreation then v8 else nil
		local v25 = if fFlagAXAvatarMomentsCreation then v9 else nil
		v22 = useCallback(fn, {
			v7,
			v11,
			v24,
			v25,
			if fFlagAXAvatarMomentsCreation then state2 else nil
		})
	end

	local createElement = React.createElement
	local v24 = {
		onPanelCoversSceneChanged = v18,
		avatars = v13.avatars,
		hasMoreAvatars = v13.hasMore,
		onAvatarsEndReached = v13.loadMore,
		currentAvatarThumbnailUrl = 0,
		emotes = 0,
		hasMoreEmotes = 0,
		onEmotesEndReached = 0,
		backgrounds = 0,
		hasMoreBackgrounds = 0,
		onBackgroundsEndReached = 0,
		isEmotesDisabled = 0,
		didResetTryOns = 0,
		onContinue = 0
	}

	local v25 = if fFlagAXPhotoboothMomentsCurrentAvatarTile then v13.currentAvatarThumbnailUrl else nil
	v24.currentAvatarThumbnailUrl = v25

	v24.emotes = v14.emotes
	v24.hasMoreEmotes = v14.hasMore
	v24.onEmotesEndReached = v14.loadMore
	v24.backgrounds = v15.backgrounds
	v24.hasMoreBackgrounds = v15.hasMore
	v24.onBackgroundsEndReached = v15.loadMore
	v24.isEmotesDisabled = v16.isEmotesDisabled
	v24.didResetTryOns = v12
	v24.onContinue = v19
	local element = createElement(photoboothMomentsPage, v24)

	if not fFlagAXAvatarMomentsCreation then
		return element
	end

	local module17 = require("@luauforge/deferred/hkO")

	local createElement2 = React.createElement
	local fragment = React.Fragment
	local v28

	if state ~= nil then
		local createElement3 = React.createElement
		local view = Foundation.View

		local createElement4 = React.createElement
		local creationFlowScreen = module17.CreationFlowScreen
		local v31 = {
			excludeGallery = true,
			initialAvatarMoment = state,
			canDismissCreationFlow = v20,
			onExit = v21,
			onPublishFinished = nil
		}

		if not fFlagMomentsRenderCreatePostStatus then
			v22 = nil
		end

		v31.onPublishFinished = v22
		v28 = createElement3(view, { tag = "size-full", ZIndex = 400 }, {
			Screen = createElement4(creationFlowScreen, v31)
		})
	end

	return createElement2(fragment, nil, { Page = element, CreationFlow = v28 })
end

return module16(PhotoboothMomentsScreen)
