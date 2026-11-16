local performFetch = require("@luauforge/bundled/dAg").PerformFetch
local module = require("@luauforge/bundled/dAh")

local module2 = require("@luauforge/bundled/dAj")
local expirationTimeNamespace = module2.ExpirationTimeNamespace
local nextDataExpirationTimeReducer = module2.NextDataExpirationTimeReducer
local setNextDataExpirationTime = module2.SetNextDataExpirationTime

local module3 = require("@luauforge/bundled/dAm")
local fFlagEnableTopSongsSort = module3.FFlagEnableTopSongsSort
local fIntSongDetailsRefreshIntervalSeconds = module3.FIntSongDetailsRefreshIntervalSeconds

local v5 = fFlagEnableTopSongsSort and tonumber(fIntSongDetailsRefreshIntervalSeconds) or 0

local module4 = require("@luauforge/bundled/dAw")
local addGames = module4.AddGames
local syncGameInfosToStore = module4.syncGameInfosToStore
local fFlagMigrateGameInfoToStore = module3.FFlagMigrateGameInfoToStore

local gameInfoModel = require("@luauforge/bundled/dAx").GameInfoModel

local module5 = require("@luauforge/bundled/dzZ")
local module6 = require("@luauforge/bundled/dAy")
local module7 = require("@luauforge/bundled/dzY")

return {
	KeyMapper = function(p2)
		return `luaapp.musicdiscovery.songexperiences.{p2}`
	end,
	GetFetchingStatus = function(p2, p3)
		return performFetch.GetStatus(p2, `luaapp.musicdiscovery.songexperiences.{p3}`)
	end,
	Fetch = function(p2, p3)
		return performFetch.Single(`luaapp.musicdiscovery.songexperiences.{p3}`, function(object)
			local state = object:getState()
			local formatted = `luaapp.musicdiscovery.songexperiences.{p3}`

			local songDetailPage = expirationTimeNamespace.SongDetailPage
			local v6 = (state.Personalization[nextDataExpirationTimeReducer.key][songDetailPage] or {})[formatted]
				or nil
			local v7 = state.Personalization[module7.key][p3] or nil

			if v7 and v6 and tick() < v6 then
				return module.resolve(v7)
			end

			return module6(p2, p3, 100):andThen(function(p4)
				local experiences = p4 and p4.responseBody and p4.responseBody.experiences or {}

				local v8 = {}
				local universeIds = {}

				for i, experience in ipairs(experiences) do
					gameInfoModel.fromMusicDiscoveryApi(experience):match(function(p5)
						v8[p5.universeId] = p5
						table.insert(universeIds, p5.universeId)
					end):matchError(function(p5)
						warn(`ApiFetchSongExperiences could not parse experience: {p5}`)
					end)
				end

				if next(v8) then
					object:dispatch(addGames(v8))

					if fFlagMigrateGameInfoToStore then
						syncGameInfosToStore(v8)
					end
				end

				object:dispatch(module5({ [p3] = universeIds }))
				object:dispatch(setNextDataExpirationTime(
					formatted,
					math.floor(tick() + v5),
					songDetailPage
				))
			end, function(p4) end)
		end)
	end
}
