local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local module2 = require("@luauforge/deferred/gTO")
local getPhotoboothMomentsStore = module2.Stores.GetPhotoboothMomentsStore
local r6WaveEmoteId = module2.Constants.R6WaveEmoteId
local defaultBackgroundAssetId = module2.Constants.DefaultBackgroundAssetId
local playPhotoboothMomentsR6Wave = module2.Utils.playPhotoboothMomentsR6Wave

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useStore = RoactUtils.Hooks.RoactRodux.useStore

local module3 = require("@luauforge/bundled/dKU")
local clearTryOns = module3.Actions.ClearTryOns
local navigatedToNonTryOnPage = module3.Actions.NavigatedToNonTryOnPage
local removeFromTryOn = module3.Actions.RemoveFromTryOn
local toggleTryOn = module3.Actions.ToggleTryOn

local fFlagAXPhotoboothMomentsCurrentAvatarTile = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXPhotoboothMomentsCurrentAvatarTile

local fFlagAXPhotoboothMomentsResetOnReentry = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXPhotoboothMomentsResetOnReentry

local fFlagSignalsNavP3gAvatarExperience = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3gAvatarExperience
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local selectActiveBackground = AvatarExperienceCommon.Backgrounds.selectActiveBackground
local selectTryOnBackgroundId = AvatarExperienceCommon.Backgrounds.selectTryOnBackgroundId

local module5 = require("@luauforge/bundled/dPN")
local module6 = require("@luauforge/deferred/hkM")
local module7 = require("@luauforge/bundled/fCe")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local module8 = require("@luauforge/bundled/gUW")
require("@luauforge/bundled/dKT")

local emoteAnimation = module5.AssetTypeIdStrings.EmoteAnimation

local avatarBackground = module5.AssetTypeIdStrings.AvatarBackground

local function selectCurrentCharacter(p2)
	local character = p2.AvatarExperience.AvatarScene.Character

	if character then
		return character.CurrentCharacter
	end

	return nil
end

local function selectShownBackgroundId(p2)
	local v5 = selectActiveBackground(p2)

	if v5 then
		return (tostring(v5))
	end

	return ""
end

local function selectIsTryOnCleared(p2)
	local outfitTryOn = p2.AvatarExperience.AvatarScene.OutfitTryOn
	local isTryOnCleared = outfitTryOn.OutfitId == nil and next(outfitTryOn.TryOnItems or {}) == nil
	return isTryOnCleared
end

local function selectOpaqueScreen(p2)
	local avatarRoute = p2.AvatarExperience.AvatarScene.AvatarRoute

	if avatarRoute and avatarRoute.opaque then
		return avatarRoute.opaque.name
	end

	return nil
end

local function selectIsPhotoboothOnTop(p2): boolean
	local avatarRoute = p2.AvatarExperience.AvatarScene.AvatarRoute
	return (if avatarRoute and avatarRoute.opaque then avatarRoute.opaque.name else nil) == avatarScreen.PhotoboothMomentsPage
end

local function selectIsPhotoboothCovered(p2)
	local avatarRoute = p2.AvatarExperience.AvatarScene.AvatarRoute
	local name = if avatarRoute and avatarRoute.opaque then avatarRoute.opaque.name else nil
	local isPhotoboothCovered

	if name == nil or name == avatarScreen.None then
		isPhotoboothCovered = false
	else
		local avatarRoute2 = p2.AvatarExperience.AvatarScene.AvatarRoute
		isPhotoboothCovered = (if avatarRoute2 and avatarRoute2.opaque then avatarRoute2.opaque.name else nil) ~= avatarScreen.PhotoboothMomentsPage
	end

	return isPhotoboothCovered
end

local function selectIsPreviewR6(p2)
	return function(p3): boolean
		local outfitInfo = p3.AvatarExperience.AvatarEditor.OutfitInfos[p2]

		if p2 == "" or not outfitInfo then
			return p3.AvatarExperience.AvatarEditor.Character.AvatarType == module5.AvatarType.R6
		end

		return outfitInfo.avatarType == module5.AvatarType.R6
	end
end

local function usePhotoboothMomentsPreview()
	local v5 = useDispatch()
	local v6 = useStore()
	local photoboothMomentsStore = getPhotoboothMomentsStore(false)

	local v7 = useSignalState(photoboothMomentsStore.getActiveOutfitId)
	local v8 = useSignalState(photoboothMomentsStore.getActiveEmoteId)
	local v9 = useSignalState(photoboothMomentsStore.getActiveBackgroundId)
	local v11 = useSelector((React.useCallback(function(p2): boolean
		local outfitInfo = p2.AvatarExperience.AvatarEditor.OutfitInfos[v7]

		if v7 == "" or not outfitInfo then
			return p2.AvatarExperience.AvatarEditor.Character.AvatarType == module5.AvatarType.R6
		end

		return outfitInfo.avatarType == module5.AvatarType.R6
	end, { v7 })))
	local v12 = useSelector(selectShownBackgroundId)
	local v13, v14, v15

	if fFlagAXPhotoboothMomentsResetOnReentry then
		v13 = useSelector(selectIsTryOnCleared)
		v14 = useSelector(selectIsPhotoboothCovered)

		v15 = not (if fFlagSignalsNavP3gAvatarExperience then useSignalState(module7.getIsAvatarExperienceRoute()) else useSelector(module7.isAvatarExperienceRoute))
	else
		v15 = nil
		v14 = nil
	end

	React.useEffect(function()
		if not (v9 == "" and selectTryOnBackgroundId(v6:getState()) == nil) then
			return
		end

		if v12 ~= "" then
			photoboothMomentsStore.setActiveBackground(v12)
		elseif avatarBackground then
			photoboothMomentsStore.setActiveBackground(defaultBackgroundAssetId)
		end
	end, { v9, v12, photoboothMomentsStore, v6 })

	local useEffect = React.useEffect
	local function fn()
		if fFlagAXPhotoboothMomentsResetOnReentry and (v15 or v14) then
			return
		end

		local outfitId = v6:getState().AvatarExperience.AvatarScene.OutfitTryOn.OutfitId

		if v7 ~= "" and outfitId ~= v7 then
			v5(module6(v7))
		end

		if fFlagAXPhotoboothMomentsCurrentAvatarTile and v7 == "" and outfitId ~= nil then
			v5(clearTryOns())
		end

		local v16 = module8(v6:getState())
		local v17 = v8 == r6WaveEmoteId

		if v8 == "" or v11 or v17 then
			if v16 ~= nil then
				v5(removeFromTryOn(v16, module5.ItemType.Asset))
			end
		elseif v16 ~= v8 then
			v5(toggleTryOn(module5.ItemType.Asset, emoteAnimation, v8, true))
		end

		if avatarBackground then
			local state = v6:getState()
			local v18 = selectTryOnBackgroundId(state)
			local v19 = if v18 then tostring(v18) else nil

			if v9 == "" then
				if v19 ~= nil then
					v5(removeFromTryOn(v19, module5.ItemType.Asset))
				end
			else
				local v20

				if v19 then
					v20 = v19 == v9
				else
					local v21 = selectActiveBackground(state)
					v20 = (not v21 and "" or tostring(v21)) == v9
				end

				if not v20 then
					v5(toggleTryOn(module5.ItemType.Asset, avatarBackground, v9, true))
				end
			end
		end
	end

	if not fFlagAXPhotoboothMomentsResetOnReentry then
		v13 = nil
	end

	local v17 = if fFlagAXPhotoboothMomentsResetOnReentry then v15 else nil
	useEffect(fn, {
		v7,
		v8,
		v9,
		v11,
		v5,
		v6,
		v13,
		v17,
		if fFlagAXPhotoboothMomentsResetOnReentry then v14 else nil
	})

	local v19 = useSelector(selectCurrentCharacter)
	local useEffect2 = React.useEffect
	local function fn2()
		if
			v8 ~= r6WaveEmoteId
			or not v11
			or v19 == nil
			or fFlagAXPhotoboothMomentsResetOnReentry and (v15 or v14)
		then
			return
		end

		local v20 = playPhotoboothMomentsR6Wave.play(v19)
		return function()
			playPhotoboothMomentsR6Wave.stop(v20)
		end
	end

	local v21 = if fFlagAXPhotoboothMomentsResetOnReentry then v15 else nil
	useEffect2(fn2, {
		v8,
		v11,
		v19,
		v21,
		if fFlagAXPhotoboothMomentsResetOnReentry then v14 else nil
	})

	local function fn3()
		return function()
			v5(navigatedToNonTryOnPage())

			if fFlagAXPhotoboothMomentsResetOnReentry then
				local avatarRoute = v6:getState().AvatarExperience.AvatarScene.AvatarRoute
				local v23 = if avatarRoute and avatarRoute.opaque then avatarRoute.opaque.name else nil

				if v23 == avatarScreen.PhotoboothMomentsPage then
					return
				end
			end

			photoboothMomentsStore.reset()
		end
	end

	React.useEffect(fn3, {
		v5,
		photoboothMomentsStore,
		if fFlagAXPhotoboothMomentsResetOnReentry then v6 else nil
	})

	return { isEmotesDisabled = v11 }
end

return usePhotoboothMomentsPreview
