local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module3 = require("@luauforge/deferred/gpl")

local fFlagAXPhotoboothMomentsCurrentAvatarTile = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXPhotoboothMomentsCurrentAvatarTile

local fFlagAXAvatarMomentsCreation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXAvatarMomentsCreation

local fFlagMomentsRenderCreatePostStatus = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagMomentsRenderCreatePostStatus

local module4 = require("@luauforge/deferred/gpj")
local module5 = require("@luauforge/deferred/gYv")
local module6 = require("@luauforge/deferred/gYw")
local module7 = require("@luauforge/deferred/gYx")
local module8 = require("@luauforge/deferred/gYy")
local module9 = require("@luauforge/deferred/gYA")
local fullView = AvatarExperienceCommon.Enums.FullView
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useStore = RoactUtils.Hooks.RoactRodux.useStore
local module10 = require("@luauforge/bundled/dCh")
local module11 = require("@luauforge/bundled/dwB")

local photoboothMomentsPage = module3.Components.PhotoboothMomentsPage
local module12 = require("@luauforge/deferred/gmV")

local function PhotoboothMomentsScreen()
	local v5, v6 = module4()
	local v7 = if fFlagMomentsRenderCreatePostStatus then useDispatch() else nil
	local v8 = useStore()
	local state, setState

	if fFlagAXAvatarMomentsCreation then
		state, setState = React.useState(nil)
	else
		setState = nil
	end

	local v9

	if fFlagMomentsRenderCreatePostStatus then
		v9 = useLocalization({
			publishedTitle = "Feature.Moments.Label.MomentPublishedTitle",
			publishedBody = "Feature.Moments.Label.MomentPublishedBody",
			failedTitle = "Feature.Moments.Label.MomentFailedToPostTitle",
			failedBody = "Feature.Moments.Label.MomentFailedToPostBody"
		})
	else
		v9 = nil
	end

	local v10 = React.useState(function(): boolean
		return next(v8:getState().AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems or {}) ~= nil
	end)

	local v11 = module5()
	local v12 = module6()
	local v13 = module7()

	local v14 = module8()
	local v15 = if fFlagAXAvatarMomentsCreation then module9() else nil

	local v16 = React.useCallback(function(p2)
		local v18 = if p2 then fullView.None else fullView.SceneFullView
		v6(v18)
	end, { v6 })
	local v17

	if fFlagAXAvatarMomentsCreation then
		v17 = React.useCallback(function()
			setState(v15)
		end, { v15 })
	end

	local v18

	if fFlagAXAvatarMomentsCreation then
		v18 = React.useCallback(function()
			local module13 = require("@luauforge/deferred/gYB")
			setState(nil)
			module13.resetCreationFlow(module13.Enums.CreationFlowState.Preview)
		end, {})
	end

	if fFlagAXAvatarMomentsCreation then
		local v19 = state ~= nil
		React.useEffect(function()
			if v19 then
				return function()
					local module13 = require("@luauforge/deferred/gYB")

					module13.resetCreationFlow(module13.Enums.CreationFlowState.Preview)
				end
			end
		end, { v19 })
	end

	local v19

	if fFlagMomentsRenderCreatePostStatus then
		v19 = React.useCallback(function(p2)
			local v23 = if p2 then v9.publishedTitle else v9.failedTitle
			local v24 = if p2 then v9.publishedBody else v9.failedBody

			local v25 = if p2 then module11.SuccessConfirmation else module11.NetworkingError
			v7(module10({
				toastMessage = v23,
				toastSubMessage = v24,
				isLocalized = true,
				toastType = v25
			}))
		end, { v7, v9 })
	end

	local createElement = React.createElement
	local v21 = {
		onPanelCoversSceneChanged = v16,
		avatars = v11.avatars,
		hasMoreAvatars = v11.hasMore,
		onAvatarsEndReached = v11.loadMore,
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

	local v22 = if fFlagAXPhotoboothMomentsCurrentAvatarTile then v11.currentAvatarThumbnailUrl else nil
	v21.currentAvatarThumbnailUrl = v22

	v21.emotes = v12.emotes
	v21.hasMoreEmotes = v12.hasMore
	v21.onEmotesEndReached = v12.loadMore
	v21.backgrounds = v13.backgrounds
	v21.hasMoreBackgrounds = v13.hasMore
	v21.onBackgroundsEndReached = v13.loadMore
	v21.isEmotesDisabled = v14.isEmotesDisabled
	v21.didResetTryOns = v10
	v21.onContinue = v17
	local element = createElement(photoboothMomentsPage, v21)

	if not fFlagAXAvatarMomentsCreation then
		return element
	end

	local module13 = require("@luauforge/deferred/gYB")

	local createElement2 = React.createElement
	local fragment = React.Fragment
	local v25

	if state ~= nil then
		local createElement3 = React.createElement
		local view = Foundation.View

		local createElement4 = React.createElement
		local creationFlowScreen = module13.CreationFlowScreen

		if not fFlagMomentsRenderCreatePostStatus then
			v19 = nil
		end

		v25 = createElement3(view, { tag = "size-full", ZIndex = 400 }, {
			Screen = createElement4(creationFlowScreen, {
				excludeGallery = true,
				initialAvatarMoment = state,
				onExit = v18,
				onPublishFinished = v19
			})
		})
	end

	return createElement2(fragment, nil, { Page = element, CreationFlow = v25 })
end

return module12(PhotoboothMomentsScreen)
