local MomentsCreation = script:FindFirstAncestor("MomentsCreation")
local MomentsCreationParent = MomentsCreation.Parent
local Dash = require(MomentsCreationParent.Dash)
local Signals = require(MomentsCreationParent.Signals)
local Constants = require(MomentsCreation.Constants)
local GetFFlagMomentsCreationMusicSearchStateFix = require(MomentsCreation.Flags.GetFFlagMomentsCreationMusicSearchStateFix)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local function makeDefaultSource() -- line: 71
	-- upvalues: Dash (copy), Constants (copy)
	local function formatMusic(t1: {[any]: any}) -- line: 72
		local t2 = {}

		for _, v28 in t1 do
			local num = tonumber(v28.AssetId)

			if num ~= nil and v28.RecordingCode ~= nil then
				table.insert(t2, {
					Artist = v28.Artist,
					AssetId = num,
					AudioType = v28.AudioType,
					Duration = v28.Duration,
					RecordingCode = v28.RecordingCode,
					Title = v28.Title
				})
			end
		end

		return t2
	end

	return {
		searchMusic = function(s1: string, n1: number) -- line: 94
			-- upvalues: Dash (copy), Constants (copy), formatMusic (copy)
			local AssetService = game:GetService("AssetService")
			local AudioSearchParams = Instance.new("AudioSearchParams")

			AudioSearchParams.SearchKeyword = s1
			AudioSearchParams.AudioSubType = Enum.AudioSubType.Music
			AudioSearchParams.MinDuration = n1

			local t3 = {}

			for _, v36 in (AssetService:SearchAudio(AudioSearchParams):GetCurrentPage()) do
				if not Dash.includes(Constants.SearchMusicCreatorFilter, v36.Creator.Id) then
					table.insert(t3, v36.Id)
				end
			end

			if #t3 == 0 then
				return {}
			end

			return (formatMusic(AssetService:GetAudioMetadataAsync(t3)))
		end,
		getMetadata = function(t4: {[any]: any}) -- line: 114
			-- upvalues: formatMusic (copy)
			local AssetService = game:GetService("AssetService")

			return (formatMusic(AssetService:GetAudioMetadataAsync(t4)))
		end
	}
end
local function createMusicStore(t5: {[any]: any}?) -- line: 121
	-- upvalues: makeDefaultSource (copy), createSignal (copy), createComputed (copy), GetFFlagMomentsCreationMusicSearchStateFix (copy)
	local v13 = t5 or makeDefaultSource()
	local v14, v15 = createSignal({})
	local v16, v17 = createSignal({})
	local v18, v19 = createSignal("idle")
	local n2 = 0
	local t6 = {}
	local v22 = createComputed(function(p1) -- line: 134
		-- upvalues: v14 (copy), v16 (copy)
		local v40 = v14(p1)
		local t7 = {}

		for _, v43 in v16(p1) do
			local v44 = v40[v43]

			if v44 ~= nil then
				table.insert(t7, v44)
			end
		end

		return t7
	end)

	local function mergeInfo(t8: {[any]: any}) -- line: 146
		-- upvalues: v14 (copy), v15 (copy)
		if #t8 == 0 then
			return
		end

		local v46 = table.clone(v14(false))

		for _, v48 in t8 do
			v46[v48.AssetId] = v48
		end

		v15(v46)
	end
	local function extractIds(t9: {[any]: any}) -- line: 157
		local t10 = {}

		for _, v52 in t9 do
			table.insert(t10, v52.AssetId)
		end

		return t10
	end

	return {
		getInfoMap = v14,
		getResults = v22,
		getSearchStatus = v18,
		search = function(s2: string, n3: number?) -- line: 165
			-- upvalues: GetFFlagMomentsCreationMusicSearchStateFix (copy), v13 (copy), v14 (copy), v15 (copy), v17 (copy), n2 (ref), v19 (copy)
			if not GetFFlagMomentsCreationMusicSearchStateFix() then
				task.spawn(function() -- line: 167
					-- upvalues: v13 (copy), s2 (copy), n3 (copy), v14 (copy), v15 (copy), v17 (copy)
					local ok, result = pcall(v13.searchMusic, s2, n3 or 30)

					if not ok then
						return
					end

					if #result ~= 0 then
						local v59 = table.clone(v14(false))

						for _, v61 in result do
							v59[v61.AssetId] = v61
						end

						v15(v59)
					end

					local v62 = v17
					local t11 = {}

					for _, v65 in result do
						table.insert(t11, v65.AssetId)
					end

					v62(t11)
				end)

				return
			end

			n2 += 1

			local v55 = n2

			v19("loading")
			v17({})
			task.spawn(function() -- line: 185
				-- upvalues: v13 (copy), s2 (copy), n3 (copy), v55 (copy), n2 (ref), v19 (copy), v14 (copy), v15 (copy), v17 (copy)
				local ok, result = pcall(v13.searchMusic, s2, n3 or 30)

				if v55 ~= n2 then
					return
				end

				if not ok then
					v19("error")

					return
				end

				if #result ~= 0 then
					local v68 = table.clone(v14(false))

					for _, v70 in result do
						v68[v70.AssetId] = v70
					end

					v15(v68)
				end

				local v71 = v17
				local t12 = {}

				for _, v74 in result do
					table.insert(t12, v74.AssetId)
				end

				v71(t12)
				v19("success")
			end)
		end,
		fetchInfo = function(n4: number) -- line: 201
			-- upvalues: v14 (copy), GetFFlagMomentsCreationMusicSearchStateFix (copy), t6 (copy), v13 (copy), v15 (copy)
			if v14(false)[n4] ~= nil then
				return
			end

			if GetFFlagMomentsCreationMusicSearchStateFix() then
				if t6[n4] then
					return
				end

				t6[n4] = true
				task.spawn(function() -- line: 211
					-- upvalues: v13 (copy), n4 (copy), t6 (copy), v14 (copy), v15 (copy)
					local ok, result = pcall(v13.getMetadata, { n4 })

					t6[n4] = nil

					if ok then
						if #result == 0 then
							return
						end

						local v77 = table.clone(v14(false))

						for _, v79 in result do
							v77[v79.AssetId] = v79
						end

						v15(v77)
					end
				end)

				return
			end

			task.spawn(function() -- line: 220
				-- upvalues: v13 (copy), n4 (copy), v14 (copy), v15 (copy)
				local ok, result = pcall(v13.getMetadata, { n4 })

				if ok then
					if #result == 0 then
						return
					end

					local v82 = table.clone(v14(false))

					for _, v84 in result do
						v82[v84.AssetId] = v84
					end

					v15(v82)
				end
			end)
		end
	}
end

return createMusicStore
