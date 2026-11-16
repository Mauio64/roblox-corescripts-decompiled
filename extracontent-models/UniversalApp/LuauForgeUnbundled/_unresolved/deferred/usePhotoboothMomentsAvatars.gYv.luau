local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module3 = require("@luauforge/bundled/fuM")

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useStore = RoactUtils.Hooks.RoactRodux.useStore
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local useNetworking = AvatarExperienceCommon.Hooks.useNetworking
local useAvatarEditorStores = module3.Context.useAvatarEditorStores

local module4 = require("@luauforge/deferred/gOO")

local module5 = require("@luauforge/bundled/ggX")
local module6 = require("@luauforge/bundled/dNQ")
local module7 = require("@luauforge/bundled/dMx")
local module8 = require("@luauforge/deferred/gOP")
local module9 = require("@luauforge/bundled/dOj")

local avatarEditorCategories = require("@luauforge/bundled/dMd").Enums.AvatarEditorCategories
local module10 = require("@luauforge/bundled/dxy")

local fFlagAXPhotoboothMomentsCurrentAvatarTile = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXPhotoboothMomentsCurrentAvatarTile

local fFlagAXMigrateOutfitsToUserInventory = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMigrateOutfitsToUserInventory

local fFlagAXRefetchInventoryOnUpdate = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXRefetchInventoryOnUpdate
local v5

if fFlagAXMigrateOutfitsToUserInventory then
	v5 = avatarEditorCategories.Avatars
else
	v5 = module6.EditableCharacterKey
end

local avatar = module7.OutfitTypes.Avatar
local v6 = if fFlagAXMigrateOutfitsToUserInventory then v5 else module7.OutfitsKey .. v5

local function selectLocalUserId(p2)
	return p2.LocalUserId
end

local function selectSavedCharacterModelVersion(p2)
	return p2.AvatarExperience.AvatarScene.Character.SavedCharacterModelVersion or 0
end

local function getAvatars(items, outfitInfos)
	if not items then
		return {}
	end

	local result = {}

	for k, item in items do
		local v7 = outfitInfos[item]

		if v7 then
			table.insert(result, {
				outfitId = item,
				name = v7.name,
				updateCounter = v7.updateCounter or 0
			})
		end
	end

	return result
end

local function selectAvatars(p2)
	return getAvatars(
		p2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[v5],
		p2.AvatarExperience.AvatarEditor.OutfitInfos
	)
end

local function selectHasMore(p2): boolean
	return not p2.AvatarExperience.AvatarEditor.PageFinished[v5]
end

local function selectIsLoading(p2): boolean
	return performFetch.GetStatus(p2, v6) == module10.Fetching
end

local function getAvatarsCategory()
	for k, v7 in module9() do
		if v7.Id == avatarEditorCategories.Avatars then
			return v7
		end
	end

	return nil
end

local function usePhotoboothMomentsAvatars()
	local v7 = useDispatch()
	local v8 = useStore()
	local v9 = useNetworking()
	local v10

	if fFlagAXMigrateOutfitsToUserInventory then
		v10 = React.useMemo(getAvatarsCategory, {})
	else
		v10 = nil
	end

	local v11

	if fFlagAXMigrateOutfitsToUserInventory then
		v11 = useAvatarEditorStores().categoryInventoryStores[v5]
	else
		v11 = nil
	end

	local v12 = if fFlagAXMigrateOutfitsToUserInventory then useSignalState(v11.getItems) else nil
	local v13

	if fFlagAXMigrateOutfitsToUserInventory then
		v13 = useSignalState(v11.getHasReachedLastPage)
	end

	local v14

	if fFlagAXMigrateOutfitsToUserInventory then
		v14 = React.useCallback(function(p2)
			local itemIds = {}

			if v12 then
				for k, v15 in v12 do
					table.insert(itemIds, v15.itemId)
				end
			end

			return getAvatars(itemIds, p2.AvatarExperience.AvatarEditor.OutfitInfos)
		end, { v12 })
	end

	if not fFlagAXMigrateOutfitsToUserInventory then
		v14 = selectAvatars
	end

	local v16 = useSelector(v14, getUseSelectorDeepEquals())

	local v17 = if fFlagAXMigrateOutfitsToUserInventory then not v13 else useSelector(selectHasMore)
	local v18 = useSelector(selectIsLoading)

	local useCallback = React.useCallback
	local function fn()
		local state = v8:getState()

		if performFetch.GetStatus(state, v6) == module10.Fetching then
			return
		end

		if fFlagAXMigrateOutfitsToUserInventory then
			if v10 and v11 and not v11.getHasReachedLastPage(false) then
				v7(module8(v9, v10, nil, v11))
			end
		else
			if state.AvatarExperience.AvatarEditor.PageFinished[v5] then
				return
			end

			v7(module5(v5, true, v5, avatar, v9))
		end
	end

	local v20 = if fFlagAXMigrateOutfitsToUserInventory then v10 else nil
	local v22 = useCallback(fn, {
		v8,
		v7,
		v9,
		v20,
		if fFlagAXMigrateOutfitsToUserInventory then v11 else nil
	})

	React.useEffect(function()
		v22()
	end, { v22 })

	if fFlagAXRefetchInventoryOnUpdate then
		module4(v5, v11, (React.useCallback(function()
			if v10 and v11 then
				v7(module8(v9, v10, nil, v11))
			end
		end, { v7, v9, v10, v11 })))
	end

	local v23

	if fFlagAXPhotoboothMomentsCurrentAvatarTile then
		local v24 = useSelector(selectLocalUserId)
		local v25 = useSelector(selectSavedCharacterModelVersion)
		v23 = React.useMemo(function()
			if v24 == nil or v24 == "" then
				return nil
			end

			return `rbxthumb://type=Avatar&id={v24}&w={420}&h={420}&filters={v25}&timestamp={os.time()}`
		end, { v24, v25 })
	end

	local v24 = {
		avatars = v16,
		isLoading = v18,
		hasMore = v17,
		loadMore = v22,
		currentAvatarThumbnailUrl = nil
	}

	if not fFlagAXPhotoboothMomentsCurrentAvatarTile then
		v23 = nil
	end

	v24.currentAvatarThumbnailUrl = v23
	return v24
end

return usePhotoboothMomentsAvatars
