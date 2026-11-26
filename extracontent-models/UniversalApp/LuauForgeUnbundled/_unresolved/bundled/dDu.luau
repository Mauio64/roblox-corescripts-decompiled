local module = require("@luauforge/bundled/dDv")
local performFetch = require("@luauforge/bundled/dDl").PerformFetch
local module2 = require("@luauforge/bundled/dDm")
local module3 = require("@luauforge/bundled/dDw")

local module4 = require("@luauforge/bundled/dDo")
local expirationTimeNamespace = module4.ExpirationTimeNamespace
local nextDataExpirationTimeReducer = module4.NextDataExpirationTimeReducer
local setNextDataExpirationTime = module4.SetNextDataExpirationTime

local module5 = require("@luauforge/bundled/dDr")
local fFlagEnableTopSongsSort = module5.FFlagEnableTopSongsSort
local fIntSongDetailsRefreshIntervalSeconds = module5.FIntSongDetailsRefreshIntervalSeconds

local module6 = require("@luauforge/bundled/dDb")
local module7 = require("@luauforge/bundled/dDx")
local module8 = require("@luauforge/bundled/dDy")
local module9 = require("@luauforge/bundled/dDa")

local v6 = fFlagEnableTopSongsSort and tonumber(fIntSongDetailsRefreshIntervalSeconds) or 0

local function fn(p2)
	return `luaapp.musicdiscovery.songdetails.{p2}`
end

return {
	["KeyMapper"] = fn,
	GetFetchingStatus = function(p2, p3)
		return performFetch.GetStatus(p2, `luaapp.musicdiscovery.songdetails.{p3}`)
	end,
	Fetch = function(p2, items)
		module.isType(items, "table", "ApiFetchSongDetail: inputSongIds")

		local v7 = {}

		for k, item in items do
			if not (item ~= nil and item ~= "" and (type(item) == "string" or type(item) == "number")) then
				continue
			end

			table.insert(v7, (tostring(item)))
		end

		if #v7 == 0 then
			warn("ApiFetchSongDetail: No songIds provided")
		end

		return performFetch.Batch(v7, fn, function(object, items2)
			local v8 = {}
			local now = tick()

			local state = object:getState()
			local songDetailPage = expirationTimeNamespace.SongDetailPage
			local v9 = state.Personalization[nextDataExpirationTimeReducer.key][songDetailPage] or {}
			local v10 = state.Personalization[module9.key] or {}
			local v11 = {}

			for k, item in items2 do
				local v12 = v9[item]

				if v10[item] == nil or v12 == nil or v12 < now then
					table.insert(v11, item)
				else
					v8[`luaapp.musicdiscovery.songdetails.{item}`] = module3.new(true, nil)
				end
			end

			if #v11 == 0 then
				return module2.resolve(v8)
			end

			return module7(p2, v11):andThen(function(p3)
				local v12 = {}

				local songDetails = p3 and p3.responseBody and p3.responseBody.songDetails or nil

				if songDetails ~= nil then
					now = tick()

					for k, songDetail in songDetails do
						module8.fromJsonData(songDetail):match(function(p4)
							local assetId = p4.assetId
							v8[`luaapp.musicdiscovery.songdetails.{assetId}`] = module3.new(true, nil)
							v12[assetId] = p4
							object:dispatch(setNextDataExpirationTime(
								assetId,
								math.floor(now + v6),
								songDetailPage
							))
						end):matchError(function(p4)
							warn(`ApiFetchSongDetail could not parse songDetail: {p4}`)
						end)
					end

					if next(v12) then
						object:dispatch(module6(v12))
					end
				end

				return module2.resolve(v8)
			end, function(p3)
				return module2.resolve({})
			end)
		end)
	end
}
