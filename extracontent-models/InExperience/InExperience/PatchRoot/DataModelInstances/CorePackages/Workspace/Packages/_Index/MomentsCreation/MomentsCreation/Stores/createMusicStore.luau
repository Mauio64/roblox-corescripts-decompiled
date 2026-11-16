local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local parent = MomentsCreation.Parent

local Signals = require(parent.Signals)

local createMusicSource = require(MomentsCreation.Stores.createMusicSource)

local GetFFlagMomentsCreationMusicSearchStateFix = require(MomentsCreation.Flags.GetFFlagMomentsCreationMusicSearchStateFix)
require(MomentsCreation.Types.Music)

local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local function createMusicStore(p)
	local v = p or createMusicSource()

	local signal, v2 = createSignal({})
	local signal2, v3 = createSignal({})
	local signal3, v4 = createSignal("idle")
	local signal4, v5 = createSignal(false)
	local signal5, v6 = createSignal(false)

	local count = 0

	local v7 = {}

	local v8 = ""
	local v9 = nil

	local v10 = nil

	local getResults = createComputed(function(p2)
		local v11 = signal(p2)
		local result = {}

		for _, v12 in signal2(p2) do
			local v13 = v11[v12]

			if v13 ~= nil then
				table.insert(result, v13)
			end
		end

		return result
	end)

	local function mergeInfo(result) -- 5 equivalent calls inferred from this helper
		if #result == 0 then
			return
		end

		local clone = table.clone(signal(false))

		for _, item in result do
			clone[item.AssetId] = item
		end

		v2(clone)
	end

	local function extractIds(result) -- 2 equivalent calls inferred from this helper
		local assetIds = {}

		for _, item in result do
			table.insert(assetIds, item.AssetId)
		end

		return assetIds
	end

	local function setCursor(p2) -- 3 equivalent calls inferred from this helper
		v10 = p2
		v5(p2 ~= nil and not p2.isFinished())
		v6(false)
	end

	local function search(p2: string, value: number?)
		v8 = p2
		v9 = value
		v10 = nil
		v5(false)
		v6(false)

		if not GetFFlagMomentsCreationMusicSearchStateFix() then
			task.spawn(function()
				local success, result, v11 = pcall(v.searchMusic, p2, value or 30)

				if not success then
					return
				end

				mergeInfo(result) -- inferred equivalent call
				v3(extractIds(result)) -- inferred equivalent call
				setCursor(v11) -- inferred equivalent call
			end)
			return
		end

		count += 1
		local v11 = count
		v4("loading")

		v3({})
		task.spawn(function()
			local success, result, v12 = pcall(v.searchMusic, p2, value or 30)

			if v11 ~= count then
				return
			end

			if not success then
				v4("error")
				return
			end

			mergeInfo(result) -- inferred equivalent call
			v3(extractIds(result)) -- inferred equivalent call
			setCursor(v12) -- inferred equivalent call
			v4("success")
		end)
	end

	local function fetchInfo(p2: number)
		if signal(false)[p2] ~= nil then
			return
		end

		if not GetFFlagMomentsCreationMusicSearchStateFix() then
			task.spawn(function()
				local success, result = pcall(v.getMetadata, { p2 })

				if success then
					mergeInfo(result) -- inferred equivalent call
				end
			end)
			return
		end

		if v7[p2] then
			return
		end

		v7[p2] = true
		task.spawn(function()
			local success, result = pcall(v.getMetadata, { p2 })
			v7[p2] = nil

			if success then
				mergeInfo(result) -- inferred equivalent call
			end
		end)
	end

	local function retry()
		search(v8, v9)
	end

	local function loadMore()
		local v11 = v10

		if v11 == nil or not signal4(false) or signal5(false) then
			return
		end

		v6(true)
		task.spawn(function()
			local success, result = pcall(v11.nextPage)

			if v10 ~= v11 then
				return
			end

			if success then
				mergeInfo(result) -- inferred equivalent call
				local clone = table.clone(signal2(false))
				local set = {}

				for _, v12 in clone do
					set[v12] = true
				end

				for _, v12 in result do
					if set[v12.AssetId] then
						continue
					end

					set[v12.AssetId] = true
					table.insert(clone, v12.AssetId)
				end

				v3(clone)
				setCursor(v11) -- inferred equivalent call
			else
				v10 = nil
				v5(false)
				v6(false)
			end
		end)
	end

	return {
		getInfoMap = signal,
		getResults = getResults,
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
