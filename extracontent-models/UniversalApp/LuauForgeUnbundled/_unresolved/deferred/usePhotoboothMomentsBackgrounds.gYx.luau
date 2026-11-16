local CorePackages = game:GetService("CorePackages")
local MemStorageService = game:GetService("MemStorageService")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local performFetch = require("@game/CorePackages/Workspace/Packages/Http").PerformFetch
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module3 = require("@luauforge/bundled/dMd")

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useStore = RoactUtils.Hooks.RoactRodux.useStore
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local useNetworking = AvatarExperienceCommon.Hooks.useNetworking
local avatarEditorCategories = module3.Enums.AvatarEditorCategories

local getStaleInventoryGrantStore = require("@luauforge/bundled/fuM").Stores.getStaleInventoryGrantStore

local module4 = require("@luauforge/deferred/gOP")
local module5 = require("@luauforge/bundled/dPa")
local module6 = require("@luauforge/bundled/dOj")

local module7 = require("@luauforge/bundled/dOv")
local module8 = require("@luauforge/bundled/dxy")

local fFlagAXPhotoboothMomentsBugFixes = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXPhotoboothMomentsBugFixes

local function getBackgroundsCategory()
	for k, v5 in module6() do
		if v5.Id == avatarEditorCategories.Backgrounds then
			return v5
		end
	end

	return nil
end

local function usePhotoboothMomentsBackgrounds()
	local v5 = useDispatch()
	local v6 = useStore()
	local v7 = useNetworking()

	local useMemo = React.useMemo
	local v8 = if fFlagAXPhotoboothMomentsBugFixes then module7 else getBackgroundsCategory
	local v9 = useMemo(v8, {})

	local searchUuid = if v9 then v9.SearchUuid else nil

	local v10 = React.useCallback(function(p2)
		if not searchUuid then
			return {}
		end

		local ownedItemId = p2.AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[searchUuid]

		if not ownedItemId then
			return {}
		end

		local assetInfos = p2.AvatarExperience.Common.AssetInfos
		local result = {}

		for k, v11 in ownedItemId do
			local assetInfo = assetInfos[v11]

			if assetInfo and assetInfo.name then
				table.insert(result, { assetId = v11, name = assetInfo.name })
			end
		end

		return result
	end, { searchUuid })

	local v11 = React.useCallback(function(p2): boolean
		if searchUuid then
			return not p2.AvatarExperience.AvatarEditor.PageFinished[searchUuid]
		end

		return false
	end, { searchUuid })

	local v12 = useSelector(v10, getUseSelectorDeepEquals())
	local v13 = useSelector(v11)

	local v14 = React.useCallback(function()
		if not (v9 and searchUuid) then
			return
		end

		local state = v6:getState()

		if
			state.AvatarExperience.AvatarEditor.PageFinished[searchUuid]
			or performFetch.GetStatus(state, searchUuid) == module8.Fetching
		then
			return
		end

		v5(module4(v7, v9, searchUuid))
	end, { v9, searchUuid, v6, v5, v7 })

	if fFlagAXPhotoboothMomentsBugFixes then
		local staleInventoryGrantStore = getStaleInventoryGrantStore()
		local v15 = useSignalState(staleInventoryGrantStore.getStaleSearchUuids)
		local v16 = not (searchUuid == nil) and v15[searchUuid] == true
		local v17 = useSelector((React.useCallback(function(p2): boolean
			return searchUuid ~= nil and performFetch.GetStatus(p2, searchUuid) == module8.Fetching
		end, { searchUuid })))

		React.useEffect(function()
			if not v16 or v17 or not (v9 and searchUuid) then
				return
			end

			staleInventoryGrantStore.clearSearchUuidStale(searchUuid)
			MemStorageService:SetItem(searchUuid, "")
			v5(module5(searchUuid, false))

			if v6:getState().AvatarExperience.AvatarEditor.Character.OwnedItemIdsBySubtype[searchUuid] then
				v5(module4(v7, v9, searchUuid))
			end
		end, { v16, v17, v9, searchUuid, staleInventoryGrantStore, v6, v5, v7 })
	end

	return { backgrounds = v12, hasMore = v13, loadMore = v14 }
end

return usePhotoboothMomentsBackgrounds
