local module = require("@luauforge/deferred/gNS")
require("@luauforge/deferred/gNI")
local mutedError = require("@luauforge/deferred/gNT").mutedError

require("@luauforge/deferred/gND")
local LoadingState = require("@game/CorePackages/Packages/_Index/MomentsCommon/MomentsCommon/Enums/LoadingState")

local module3 = require("@luauforge/deferred/gNG")
local module4 = require("@luauforge/deferred/gNM")
local module5 = require("@luauforge/deferred/gNN")
local module6 = require("@luauforge/deferred/gNO")
local module7 = require("@luauforge/deferred/gNP")
local module8 = require("@luauforge/deferred/gNQ")

local frozen = table.freeze({})

local function sameFolderList(list, list2): boolean
	if #list ~= #list2 then
		return false
	end

	for k, item in list do
		if item ~= list2[k] then
			return false
		end
	end

	return true
end

local function toOldestFirst(list)
	local oldestFirst = table.create(#list)

	for i = #list, 1, -1 do
		table.insert(oldestFirst, list[i])
	end

	return oldestFirst
end

local function createFoldersStore()
	local signal, v5 = module.createSignal({})
	local signal2, v6 = module.createSignal(LoadingState.Idle)

	local signal3, v7 = module.createSignal(nil)

	local v8 = nil

	local v9 = nil

	local count = 0

	local v10 = {}
	local v11 = {}

	local computed = module.createComputed(function(p2)
		local result = {}

		for k, v12 in signal(p2) do
			result[v12.id] = v12
		end

		return result
	end)

	local computed2 = module.createComputed(function(p2)
		local v12 = signal3(p2)

		if v12 == nil then
			return nil
		end

		return computed(p2)[v12]
	end)

	local signal4, v12 = module.createSignal({})

	local function buildOutfitToFolders(items)
		local outfitToFolders = {}

		for k, item in items do
			for k2, itemId in item.itemIds do
				local v13 = tostring(itemId)

				if outfitToFolders[v13] == nil then
					outfitToFolders[v13] = {}
				end

				table.insert(outfitToFolders[v13], item.id)
			end
		end

		return outfitToFolders
	end

	local function syncOutfitToFolders(clone, p2, p3)
		local id = if p3 then p3.id elseif p2 then p2.id else nil

		if id == nil then
			return
		end

		if p2 ~= nil then
			for k, itemId in p2.itemIds do
				local v13 = tostring(itemId)
				local v14 = clone[v13]

				if v14 == nil then
					continue
				end

				local v15 = {}

				for k2, v16 in v14 do
					if v16 ~= id then
						table.insert(v15, v16)
					end
				end

				if #v15 > 0 then
					clone[v13] = v15
				else
					clone[v13] = nil
				end
			end
		end

		if p3 ~= nil then
			for k, itemId in p3.itemIds do
				local v13 = tostring(itemId)
				local v14 = clone[v13]
				local ids = v14 == nil and {} or table.clone(v14)
				table.insert(ids, id)
				clone[v13] = ids
			end
		end
	end

	local function syncFolder(p2)
		count += 1

		local clone = table.clone(signal(false))
		local v13 = false
		local v14 = nil

		for k, v16 in clone do
			if v16.id == p2.id then
				clone[k] = p2
				v14 = v16
				v13 = true
				break
			end
		end

		if not v13 then
			table.insert(clone, p2)
		end

		v5(clone)

		local clone2 = table.clone(signal4(false))
		syncOutfitToFolders(clone2, v14, p2)
		v12(clone2)
	end

	local function removeFolderLocal(p2)
		count += 1

		local v13 = {}
		local v14 = nil

		for k, v15 in signal(false) do
			if v15.id == p2 then
				v14 = v15
			else
				table.insert(v13, v15)
			end
		end

		v5(v13)

		if v14 ~= nil then
			local clone = table.clone(signal4(false))
			syncOutfitToFolders(clone, v14, nil)
			v12(clone)
		end

		if signal3(false) == p2 then
			v7(nil)
		end
	end

	local function applyFetchedFolders(list)
		local result = table.create(#list)

		for i = #list, 1, -1 do
			table.insert(result, list[i])
		end

		v5(result)
		v12(buildOutfitToFolders(result))

		local v13 = signal3(false)

		if v13 == nil then
			return result
		end

		local v14 = false

		for k, v16 in result do
			if v16.id == v13 then
				v14 = true
				break
			end
		end

		if not v14 then
			v7(nil)
		end

		return result
	end

	local function loadFolders()
		if v8 ~= nil then
			return v8
		end

		v6(LoadingState.Loading)

		local v13 = module3():andThen(function(p2)
			local v14 = applyFetchedFolders(p2)
			v6(LoadingState.Success)
			return v14
		end):catch(function(p2)
			v6(LoadingState.Failed)
			mutedError(`[AvatarExperienceAvatarFolders] loadFolders failed: {tostring(p2)}`)
			return {}
		end)

		v8 = v13

		local function dropCacheIfFailed()
			if signal2(false) == LoadingState.Failed then
				v8 = nil
			end
		end
		v13:andThen(dropCacheIfFailed, dropCacheIfFailed)

		return v13
	end

	return {
		getFolders = signal,
		getStatus = signal2,
		getFolderById = function(p2)
			if v10[p2] == nil then
				v10[p2] = module.createComputed(function(p3)
					return computed(p3)[p2]
				end)
			end

			return v10[p2]
		end,
		getFoldersForOutfit = function(p2)
			if v11[p2] == nil then
				v11[p2] = module.createComputed(function(p3)
					local v13 = signal4(p3)[p2]

					if v13 == nil then
						return frozen
					end

					local v14 = computed(p3)
					local result = table.create(#v13)

					for k, v15 in v13 do
						local v16 = v14[v15]

						if v16 ~= nil then
							table.insert(result, v16)
						end
					end

					return result
				end, sameFolderList)
			end

			return v11[p2]
		end,
		getSelectedFolderId = signal3,
		getSelectedFolder = computed2,
		setSelectedFolderId = v7,
		clearSelection = function()
			v7(nil)
		end,
		loadFolders = loadFolders,
		refreshFolders = function()
			if signal2(false) ~= LoadingState.Success then
				return loadFolders()
			end

			if v9 ~= nil then
				return v9
			end

			local v13 = count
			local v14 = module3():andThen(function(p2)
				if count == v13 then
					return applyFetchedFolders(p2)
				end

				return signal(false)
			end):catch(function(p2)
				mutedError(`[AvatarExperienceAvatarFolders] refreshFolders failed: {tostring(p2)}`)
				return signal(false)
			end)

			v9 = v14

			local function clearRefreshPromise()
				v9 = nil
			end
			v14:andThen(clearRefreshPromise, clearRefreshPromise)

			return v14
		end,
		createFolder = function(p2)
			return module4(p2):andThen(function(p3)
				syncFolder(p3)
				return p3
			end)
		end,
		renameFolder = function(p2, p3)
			return module5(p2, p3):andThen(function(p4)
				syncFolder(p4)
				return p4
			end)
		end,
		deleteFolder = function(p2)
			return module6(p2):andThen(function(p3)
				removeFolderLocal(p2)
				return p3
			end)
		end,
		addItemsToFolder = function(p2, p3)
			return module7(p2, p3):andThen(function(p4)
				syncFolder(p4)
				return p4
			end)
		end,
		removeItemsFromFolder = function(p2, p3)
			return module8(p2, p3):andThen(function(p4)
				syncFolder(p4)
				return p4
			end)
		end,
		removeOutfitFromAllFolders = function(p2)
			local v13 = signal4(false)[p2]

			if v13 == nil or #v13 == 0 then
				return
			end

			count += 1

			local v14 = computed(false)

			local v15 = {}

			for k, v16 in v13 do
				local v17 = v14[v16]

				if v17 == nil then
					continue
				end

				local itemIds = {}

				for k2, itemId in v17.itemIds do
					if tostring(itemId) ~= p2 then
						table.insert(itemIds, itemId)
					end
				end

				v15[v16] = { id = v17.id, name = v17.name, itemIds = itemIds }
			end

			local v16 = {}

			for k, v17 in signal(false) do
				table.insert(v16, v15[v17.id] or v17)
			end

			v5(v16)

			local clone = table.clone(signal4(false))

			for k, v17 in v13 do
				syncOutfitToFolders(clone, v14[v17], v15[v17])
			end

			v12(clone)
		end,
		cleanup = function()
			v8 = nil
			v9 = nil
			count = 0
			v10 = {}
			v11 = {}
			v5({})
			v12({})
			v6(LoadingState.Idle)
			v7(nil)
		end
	}
end

return createFoldersStore
