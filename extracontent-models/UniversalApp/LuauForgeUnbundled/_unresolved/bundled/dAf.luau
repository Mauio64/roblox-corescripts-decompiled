local performFetch = require("@luauforge/bundled/dAg").PerformFetch
local module = require("@luauforge/bundled/dAh")

local addSongs = require("@luauforge/bundled/dAi").AddSongs

local module2 = require("@luauforge/bundled/dAj")
local expirationTimeNamespace = module2.ExpirationTimeNamespace
local nextDataExpirationTimeReducer = module2.NextDataExpirationTimeReducer
local setNextDataExpirationTime = module2.SetNextDataExpirationTime

local module3 = require("@luauforge/bundled/dzS")
local module4 = require("@luauforge/bundled/dzR")
local module5 = require("@luauforge/bundled/dAk")

local songInfoModel = require("@luauforge/bundled/dAl").SongInfoModel

local module6 = require("@luauforge/bundled/dAm")
local fFlagEnableTopSongsSort = module6.FFlagEnableTopSongsSort
local fIntSongDetailsRefreshIntervalSeconds = module6.FIntSongDetailsRefreshIntervalSeconds

local v5 = fFlagEnableTopSongsSort and tonumber(fIntSongDetailsRefreshIntervalSeconds) or 0

return {
	KeyMapper = function(p2)
		return `luaapp.musicdiscovery.artistsongs.{p2}`
	end,
	GetFetchingStatus = function(p2, p3)
		return performFetch.GetStatus(p2, `luaapp.musicdiscovery.artistsongs.{p3}`)
	end,
	Fetch = function(p2, p3)
		local formatted = `luaapp.musicdiscovery.artistsongs.{p3}`

		return performFetch.Single(formatted, function(object)
			local state = object:getState()
			local songDetailPage = expirationTimeNamespace.SongDetailPage
			local v6 = (state.Personalization[nextDataExpirationTimeReducer.key][songDetailPage] or {})[formatted]
			local v7 = state.Personalization[module4.key][p3] or nil

			if v7 == nil or v6 == nil or not (tick() < v6) then
				return module5(p2, p3, 100):andThen(function(p4)
					local assetIds = {}
					local v8 = {}

					for k, v9 in p4 and p4.responseBody and p4.responseBody.songs or {} do
						songInfoModel.fromBaseJson(v9):match(function(p5)
							table.insert(assetIds, p5.assetId)
							v8[p5.assetId] = p5
						end):matchError(function(p5)
							warn(`ApiFetchArtistSongs could not parse song: {p5}`)
						end)
					end

					if next(v8) then
						object:dispatch(addSongs(v8))
					end

					object:dispatch(module3({ [p3] = assetIds }))

					object:dispatch(setNextDataExpirationTime(
						formatted,
						math.floor(tick() + v5),
						songDetailPage
					))
				end, function(p4) end)
			end

			return module.resolve(v7)
		end)
	end
}
