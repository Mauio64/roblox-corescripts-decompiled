local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCreation/Signals")

local createMusicSource = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Stores/createMusicSource")

local GetFFlagMomentsCreationMusicSearchStateFix = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Flags/GetFFlagMomentsCreationMusicSearchStateFix")
require("@game/CorePackages/Workspace/Packages/_Index/MomentsCreation/MomentsCreation/Types/Music")

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local function createMusicStore(p2)
	local v5 = p2 or createMusicSource()

	local signal, v6 = createSignal({})
	local signal2, v7 = createSignal({})
	local signal3, v8 = createSignal("idle")
	local signal4, v9 = createSignal(false)
	local signal5, v10 = createSignal(false)

	local count = 0

	local v11 = {}

	local v12 = ""
	local v13 = nil

	local v14 = nil

	local computed = createComputed(function(p3)
		local v15 = signal(p3)
		local result = {}

		for k, v16 in signal2(p3) do
			local v17 = v15[v16]

			if v17 ~= nil then
				table.insert(result, v17)
			end
		end

		return result
	end)

	local function mergeInfo(list)
		if #list == 0 then
			return
		end

		local clone = table.clone(signal(false))

		for k, item in list do
			clone[item.AssetId] = item
		end

		v6(clone)
	end

	local function extractIds(items)
		local assetIds = {}

		for k, item in items do
			table.insert(assetIds, item.AssetId)
		end

		return assetIds
	end

	local function setCursor(p3)
		v14 = p3
		v9(p3 ~= nil and not p3.isFinished())
		v10(false)
	end

	local function search(p3, value)
		v12 = p3
		v13 = value
		v14 = nil
		v9(false)
		v10(false)

		if not GetFFlagMomentsCreationMusicSearchStateFix() then
			task.spawn(function()
				local success, result, v15 = pcall(v5.searchMusic, p3, value or 30)

				if not success then
					return
				end

				if #result ~= 0 then
					local clone = table.clone(signal(false))

					for k, v16 in result do
						clone[v16.AssetId] = v16
					end

					v6(clone)
				end

				local assetIds = {}

				for k, v17 in result do
					table.insert(assetIds, v17.AssetId)
				end

				v7(assetIds)
				v14 = v15
				v9(v15 ~= nil and not v15.isFinished())
				v10(false)
			end)
			return
		end

		count += 1
		local v15 = count
		v8("loading")

		v7({})
		task.spawn(function()
			local success, result, v16 = pcall(v5.searchMusic, p3, value or 30)

			if v15 ~= count then
				return
			end

			if not success then
				v8("error")
				return
			end

			if #result ~= 0 then
				local clone = table.clone(signal(false))

				for k, v17 in result do
					clone[v17.AssetId] = v17
				end

				v6(clone)
			end

			local assetIds = {}

			for k, v18 in result do
				table.insert(assetIds, v18.AssetId)
			end

			v7(assetIds)
			v14 = v16
			v9(v16 ~= nil and not v16.isFinished())
			v10(false)

			v8("success")
		end)
	end

	local function fetchInfo(p3)
		if signal(false)[p3] ~= nil then
			return
		end

		if not GetFFlagMomentsCreationMusicSearchStateFix() then
			task.spawn(function()
				local success, result = pcall(v5.getMetadata, { p3 })

				if success then
					if #result == 0 then
						return
					end

					local clone = table.clone(signal(false))

					for k, v15 in result do
						clone[v15.AssetId] = v15
					end

					v6(clone)
				end
			end)
			return
		end

		if v11[p3] then
			return
		end

		v11[p3] = true
		task.spawn(function()
			local success, result = pcall(v5.getMetadata, { p3 })
			v11[p3] = nil

			if success then
				if #result == 0 then
					return
				end

				local clone = table.clone(signal(false))

				for k, v15 in result do
					clone[v15.AssetId] = v15
				end

				v6(clone)
			end
		end)
	end

	local function retry()
		search(v12, v13)
	end

	local function loadMore()
		local v15 = v14

		if v15 == nil or not signal4(false) or signal5(false) then
			return
		end

		v10(true)
		task.spawn(function()
			local success, result = pcall(v15.nextPage)

			if v14 ~= v15 then
				return
			end

			if success then
				if #result ~= 0 then
					local clone = table.clone(signal(false))

					for k, v16 in result do
						clone[v16.AssetId] = v16
					end

					v6(clone)
				end

				local clone = table.clone(signal2(false))
				local set = {}

				for k, v16 in clone do
					set[v16] = true
				end

				for k, v16 in result do
					if set[v16.AssetId] then
						continue
					end

					set[v16.AssetId] = true
					table.insert(clone, v16.AssetId)
				end

				v7(clone)
				v14 = v15
				v9(v15 ~= nil and not v15.isFinished())
				v10(false)
			else
				v14 = nil
				v9(false)
				v10(false)
			end
		end)
	end

	return {
		getInfoMap = signal,
		getResults = computed,
		getSearchStatus = signal3,
		search = search,
		retry = retry,
		getHasMore = signal4,
		getIsLoadingMore = signal5,
		loadMore = loadMore,
		fetchInfo = fetchInfo
	}
end

return createMusicStore
