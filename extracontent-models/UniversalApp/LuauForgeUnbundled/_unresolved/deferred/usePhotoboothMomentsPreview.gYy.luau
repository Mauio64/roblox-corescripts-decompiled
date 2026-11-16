local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local module2 = require("@luauforge/deferred/gpl")
local getPhotoboothMomentsStore = module2.Stores.GetPhotoboothMomentsStore
local r6WaveEmoteId = module2.Constants.R6WaveEmoteId
local defaultBackgroundAssetId = module2.Constants.DefaultBackgroundAssetId
local playPhotoboothMomentsR6Wave = module2.Utils.playPhotoboothMomentsR6Wave

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useStore = RoactUtils.Hooks.RoactRodux.useStore

local module3 = require("@luauforge/bundled/dHL")
local clearTryOns = module3.Actions.ClearTryOns
local navigatedToNonTryOnPage = module3.Actions.NavigatedToNonTryOnPage
local removeFromTryOn = module3.Actions.RemoveFromTryOn
local toggleTryOn = module3.Actions.ToggleTryOn

local fFlagAXPhotoboothMomentsCurrentAvatarTile = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXPhotoboothMomentsCurrentAvatarTile
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local selectActiveBackground = AvatarExperienceCommon.Backgrounds.selectActiveBackground
local selectTryOnBackgroundId = AvatarExperienceCommon.Backgrounds.selectTryOnBackgroundId

local module5 = require("@luauforge/bundled/dMx")
local module6 = require("@luauforge/deferred/gYz")

local module7 = require("@luauforge/bundled/gqv")

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
	local v10 = useSelector((React.useCallback(function(p2): boolean
		local outfitInfo = p2.AvatarExperience.AvatarEditor.OutfitInfos[v7]

		if v7 == "" or not outfitInfo then
			return p2.AvatarExperience.AvatarEditor.Character.AvatarType == module5.AvatarType.R6
		end

		return outfitInfo.avatarType == module5.AvatarType.R6
	end, { v7 })))
	local v11 = useSelector(selectShownBackgroundId)

	React.useEffect(function()
		if not (v9 == "" and selectTryOnBackgroundId(v6:getState()) == nil) then
			return
		end

		if v11 ~= "" then
			photoboothMomentsStore.setActiveBackground(v11)
		elseif avatarBackground then
			photoboothMomentsStore.setActiveBackground(defaultBackgroundAssetId)
		end
	end, { v9, v11, photoboothMomentsStore, v6 })

	React.useEffect(function()
		local outfitId = v6:getState().AvatarExperience.AvatarScene.OutfitTryOn.OutfitId

		if v7 ~= "" and outfitId ~= v7 then
			v5(module6(v7))
		end

		if fFlagAXPhotoboothMomentsCurrentAvatarTile and v7 == "" and outfitId ~= nil then
			v5(clearTryOns())
		end

		local v12 = module7(v6:getState())
		local v13 = v8 == r6WaveEmoteId

		if v8 == "" or v10 or v13 then
			if v12 ~= nil then
				v5(removeFromTryOn(v12, module5.ItemType.Asset))
			end
		elseif v12 ~= v8 then
			v5(toggleTryOn(module5.ItemType.Asset, emoteAnimation, v8, true))
		end

		if avatarBackground then
			local state = v6:getState()
			local v14 = selectTryOnBackgroundId(state)
			local v15 = if v14 then tostring(v14) else nil

			if v9 == "" then
				if v15 ~= nil then
					v5(removeFromTryOn(v15, module5.ItemType.Asset))
				end
			else
				local v16

				if v15 then
					v16 = v15 == v9
				else
					local v17 = selectActiveBackground(state)
					v16 = (not v17 and "" or tostring(v17)) == v9
				end

				if not v16 then
					v5(toggleTryOn(module5.ItemType.Asset, avatarBackground, v9, true))
				end
			end
		end
	end, { v7, v8, v9, v10, v5, v6 })

	local v12 = useSelector(selectCurrentCharacter)
	React.useEffect(function()
		if v8 ~= r6WaveEmoteId or not v10 or v12 == nil then
			return
		end

		local v13 = playPhotoboothMomentsR6Wave.play(v12)
		return function()
			playPhotoboothMomentsR6Wave.stop(v13)
		end
	end, { v8, v10, v12 })

	React.useEffect(function()
		return function()
			v5(navigatedToNonTryOnPage())
			photoboothMomentsStore.reset()
		end
	end, { v5, photoboothMomentsStore })

	return { isEmotesDisabled = v10 }
end

return usePhotoboothMomentsPreview
