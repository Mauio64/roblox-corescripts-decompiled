local SongDetailRodux = script:FindFirstAncestor("SongDetailRodux")
local SongDetailRoduxParent = SongDetailRodux.Parent
local ArgCheck = require(SongDetailRoduxParent.ArgCheck)
local PerformFetch = require(SongDetailRoduxParent.Http).PerformFetch
local Promise = require(SongDetailRoduxParent.Promise)
local Result = require(SongDetailRoduxParent.Result)
local NextDataExpirationTimeRodux = require(SongDetailRoduxParent.NextDataExpirationTimeRodux)
local ExpirationTimeNamespace = NextDataExpirationTimeRodux.ExpirationTimeNamespace
local NextDataExpirationTimeReducer = NextDataExpirationTimeRodux.NextDataExpirationTimeReducer
local SetNextDataExpirationTime = NextDataExpirationTimeRodux.SetNextDataExpirationTime
local SharedFlags = require(SongDetailRoduxParent.SharedFlags)
local FFlagEnableTopSongsSort = SharedFlags.FFlagEnableTopSongsSort
local FIntSongDetailsRefreshIntervalSeconds = SharedFlags.FIntSongDetailsRefreshIntervalSeconds
local AddSongDetail = require(SongDetailRodux.Actions.AddSongDetail)
local batchGetSongDetail = require(SongDetailRodux.Requests.batchGetSongDetail)
local SongDetailModel = require(SongDetailRodux.SongDetailModel)
local SongDetailReducer = require(SongDetailRodux.Reducers.SongDetailReducer)
local t1 = {}
local n1 = 0

if FFlagEnableTopSongsSort then
	n1 = tonumber(FIntSongDetailsRefreshIntervalSeconds) or 0
end

local function v20(p1) -- line: 32
	return `luaapp.musicdiscovery.songdetails.{ p1 }`
end

t1.KeyMapper = v20

function t1.GetFetchingStatus(p2, p3) -- line: 38
	-- upvalues: PerformFetch (copy)
	return PerformFetch.GetStatus(p2, `luaapp.musicdiscovery.songdetails.{ p3 }`)
end
function t1.Fetch(p4, p5) -- line: 42
	-- upvalues: ArgCheck (copy), PerformFetch (copy), v20 (copy), ExpirationTimeNamespace (copy), NextDataExpirationTimeReducer (copy), SongDetailReducer (copy), Result (copy), Promise (copy), batchGetSongDetail (copy), SongDetailModel (copy), n1 (ref), SetNextDataExpirationTime (copy), AddSongDetail (copy)
	ArgCheck.isType(p5, "table", "ApiFetchSongDetail: inputSongIds")

	local t2 = {}

	for _, v28 in p5 do
		if v28 ~= nil and v28 ~= "" and (type(v28) == "string" or type(v28) == "number") then
			table.insert(t2, (tostring(v28)))
		end
	end

	if #t2 == 0 then
		warn("ApiFetchSongDetail: No songIds provided")
	end

	return PerformFetch.Batch(t2, v20, function(p6, p7) -- line: 56
		-- upvalues: ExpirationTimeNamespace (copy), NextDataExpirationTimeReducer (copy), SongDetailReducer (copy), Result (copy), Promise (copy), batchGetSongDetail (copy), p4 (copy), SongDetailModel (copy), n1 (ref), SetNextDataExpirationTime (copy), AddSongDetail (copy)
		local t3 = {}
		local timestamp = tick()
		local t4 = {}
		local v34 = p6:getState()
		local SongDetailPage = ExpirationTimeNamespace.SongDetailPage
		local v36 = v34.Personalization[NextDataExpirationTimeReducer.key][SongDetailPage] or {}
		local v37 = v34.Personalization[SongDetailReducer.key] or {}

		for _, v39 in p7 do
			local v40 = v36[v39]

			if v37[v39] == nil or v40 == nil or v40 < timestamp then
				table.insert(t4, v39)
			else
				t3[`luaapp.musicdiscovery.songdetails.{ v39 }`] = Result.new(true, nil)
			end
		end

		if #t4 == 0 then
			return Promise.resolve(t3)
		end

		return batchGetSongDetail(p4, t4):andThen(function(p8) -- line: 83
			-- upvalues: timestamp (ref), SongDetailModel (copy), t3 (copy), Result (copy), n1 (ref), p6 (copy), SetNextDataExpirationTime (copy), SongDetailPage (copy), AddSongDetail (copy), Promise (copy)
			local t5 = {}
			local v43 = p8 and (not not p8.responseBody and p8.responseBody.songDetails) or nil

			if v43 ~= nil then
				timestamp = tick()

				for _, v45 in v43 do
					SongDetailModel.fromJsonData(v45):match(function(p9) -- line: 92
						-- upvalues: t3 (copy), Result (copy), t5 (copy), timestamp (ref), n1 (ref), p6 (copy), SetNextDataExpirationTime (copy), SongDetailPage (copy)
						local assetId = p9.assetId

						t3[`luaapp.musicdiscovery.songdetails.{ assetId }`] = Result.new(true, nil)
						t5[assetId] = p9

						local v49 = math.floor(timestamp + n1)

						p6:dispatch(SetNextDataExpirationTime(assetId, v49, SongDetailPage))
					end):matchError(function(p10) -- line: 99
						warn(`ApiFetchSongDetail could not parse songDetail: { p10 }`)
					end)
				end

				if next(t5) then
					p6:dispatch(AddSongDetail(t5))
				end
			end

			return Promise.resolve(t3)
		end, function(_) -- line: 110
			-- upvalues: Promise (copy)
			return Promise.resolve({})
		end)
	end)
end

return t1
