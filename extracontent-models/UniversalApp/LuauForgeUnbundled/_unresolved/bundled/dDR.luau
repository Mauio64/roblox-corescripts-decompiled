local performFetch = require("@luauforge/bundled/dDS").PerformFetch
local module = require("@luauforge/bundled/dDT")

local addSongs = require("@luauforge/bundled/dDU").AddSongs

local module2 = require("@luauforge/bundled/dDV")
local expirationTimeNamespace = module2.ExpirationTimeNamespace
local nextDataExpirationTimeReducer = module2.NextDataExpirationTimeReducer
local setNextDataExpirationTime = module2.SetNextDataExpirationTime

local module3 = require("@luauforge/bundled/dDK")
local module4 = require("@luauforge/bundled/dDI")
local module5 = require("@luauforge/bundled/dDW")

local songInfoModel = require("@luauforge/bundled/dDX").SongInfoModel

local fVariable = tonumber(settings():GetFVariable("LuaAppGameDetailsRefreshIntervalInSeconds")) or 0

return {
	KeyMapper = function(p2)
		return `luaapp.musicdiscovery.experiencesongs.{p2}`
	end,
	Fetch = function(p2, p3)
		return performFetch.Single(`luaapp.musicdiscovery.experiencesongs.{p3}`, function(object)
			local state = object:getState()
			local gameDetailPage = expirationTimeNamespace.GameDetailPage
			local v5 = (state.Personalization[nextDataExpirationTimeReducer.key][gameDetailPage] or {})[p3]
			local v6 = state.Personalization[module4.key][p3] or nil

			if v6 == nil or v5 == nil or not (tick() < v5) then
				return module5(p2, p3, 100):andThen(function(p4)
					local assetIds = {}
					local v7 = {}

					for k, v8 in p4 and p4.responseBody and p4.responseBody.songs or {} do
						songInfoModel.fromBaseJson(v8):match(function(p5)
							table.insert(assetIds, p5.assetId)
							v7[p5.assetId] = p5
						end):matchError(function(p5)
							warn(`ApiFetchExperienceSongs could not parse song: {p5}`)
						end)
					end

					if next(v7) then
						object:dispatch(addSongs(v7))
					end

					object:dispatch(module3({ [p3] = assetIds }))

					object:dispatch(setNextDataExpirationTime(
						p3,
						math.floor(tick() + fVariable),
						gameDetailPage
					))
				end, function(p4) end)
			end

			return module.resolve(v6)
		end)
	end
}
