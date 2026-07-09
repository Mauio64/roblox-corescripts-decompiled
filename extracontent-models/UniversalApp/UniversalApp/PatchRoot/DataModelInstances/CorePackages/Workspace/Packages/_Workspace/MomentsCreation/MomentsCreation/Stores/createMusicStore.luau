local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Dash = require(MomentsCreationParent.Dash)
local Signals = require(MomentsCreationParent.Signals)
local Constants = require(MomentsCreation.Constants)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local function makeDefaultSource() -- line: 65
	-- upvalues: Dash (copy), Constants (copy)
	local function formatMusic(t1: {[any]: any}) -- line: 66
		local t2 = {}

		for _, v22 in t1 do
			local num = tonumber(v22.AssetId)

			if num ~= nil and v22.RecordingCode ~= nil then
				table.insert(t2, {
					Artist = v22.Artist,
					AssetId = num,
					AudioType = v22.AudioType,
					Duration = v22.Duration,
					RecordingCode = v22.RecordingCode,
					Title = v22.Title
				})
			end
		end

		return t2
	end

	return {
		searchMusic = function(s1: string, n1: number) -- line: 88
			-- upvalues: Dash (copy), Constants (copy), formatMusic (copy)
			local AssetService = game:GetService("AssetService")
			local AudioSearchParams = Instance.new("AudioSearchParams")

			AudioSearchParams.SearchKeyword = s1
			AudioSearchParams.AudioSubType = Enum.AudioSubType.Music
			AudioSearchParams.MinDuration = n1

			local t3 = {}

			for _, v30 in (AssetService:SearchAudio(AudioSearchParams):GetCurrentPage()) do
				if not Dash.includes(Constants.SearchMusicCreatorFilter, v30.Creator.Id) then
					table.insert(t3, v30.Id)
				end
			end

			if #t3 == 0 then
				return {}
			end

			return (formatMusic(AssetService:GetAudioMetadataAsync(t3)))
		end,
		getMetadata = function(t4: {[any]: any}) -- line: 108
			-- upvalues: formatMusic (copy)
			local AssetService = game:GetService("AssetService")

			return (formatMusic(AssetService:GetAudioMetadataAsync(t4)))
		end
	}
end
local function createMusicStore(t5: {[any]: any}?) -- line: 115
	-- upvalues: makeDefaultSource (copy), createSignal (copy), createComputed (copy)
	local v12 = t5 or makeDefaultSource()
	local v13, v14 = createSignal({})
	local v15, v16 = createSignal({})
	local v17 = createComputed(function(p1) -- line: 122
		-- upvalues: v13 (copy), v15 (copy)
		local v34 = v13(p1)
		local t6 = {}

		for _, v37 in v15(p1) do
			local v38 = v34[v37]

			if v38 ~= nil then
				table.insert(t6, v38)
			end
		end

		return t6
	end)

	local function mergeInfo(t7: {[any]: any}) -- line: 134
		-- upvalues: v13 (copy), v14 (copy)
		if #t7 == 0 then
			return
		end

		local v40 = table.clone(v13(false))

		for _, v42 in t7 do
			v40[v42.AssetId] = v42
		end

		v14(v40)
	end

	return {
		getInfoMap = v13,
		getResults = v17,
		search = function(s2: string, n2: number?) -- line: 145
			-- upvalues: v12 (copy), v13 (copy), v14 (copy), v16 (copy)
			task.spawn(function() -- line: 146
				-- upvalues: v12 (copy), s2 (copy), n2 (copy), v13 (copy), v14 (copy), v16 (copy)
				local ok, result = pcall(v12.searchMusic, s2, n2 or 30)

				if not ok then
					return
				end

				if #result ~= 0 then
					local v48 = table.clone(v13(false))

					for _, v50 in result do
						v48[v50.AssetId] = v50
					end

					v14(v48)
				end

				local t8 = {}

				for _, v53 in result do
					table.insert(t8, v53.AssetId)
				end

				v16(t8)
			end)
		end,
		fetchInfo = function(n3: number) -- line: 162
			-- upvalues: v13 (copy), v12 (copy), v14 (copy)
			if v13(false)[n3] ~= nil then
				return
			end

			task.spawn(function() -- line: 166
				-- upvalues: v12 (copy), n3 (copy), v13 (copy), v14 (copy)
				local ok, result = pcall(v12.getMetadata, { n3 })

				if ok then
					if #result == 0 then
						return
					end

					local v56 = table.clone(v13(false))

					for _, v58 in result do
						v56[v58.AssetId] = v58
					end

					v14(v56)
				end
			end)
		end
	}
end

return createMusicStore
