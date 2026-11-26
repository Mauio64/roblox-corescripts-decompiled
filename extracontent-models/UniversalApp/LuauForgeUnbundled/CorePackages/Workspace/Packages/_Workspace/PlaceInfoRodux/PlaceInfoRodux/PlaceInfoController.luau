local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PlaceInfoRodux/Promise")
local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/PlaceInfoRodux/Http")
local HttpRequest = require("@game/CorePackages/Workspace/Packages/_Workspace/PlaceInfoRodux/HttpRequest")
require("@game/CorePackages/Workspace/Packages/_Workspace/PlaceInfoRodux/LuauPolyfill")

local url = Http.Url

local class = {}
class.__index = class

function class.new(p2)
	local config = HttpRequest.config({
		requestFunction = function(p3, p4, p5)
			return HttpRequest.requestFunctions.HttpRbxApi(p3, p4, p5)
		end
	})
	return (setmetatable({
		_placeInfo = {},
		_requestImpl = p2 or config
	}, class))
end

function class:name(p2)
	return self:_getInfo(p2, "name")
end

function class:description(p2)
	return self:_getInfo(p2, "description")
end

function class:universeId(p2)
	return self:_getInfo(p2, "universeId")
end

function class:_fetchPlacesInfo(p3)
	local queryString = url:makeQueryString({ placeIds = p3 })

	local v5 = string.format("%sv1/games/multiget-place-details?%s", url.GAME_URL, queryString)

	return self._requestImpl(v5, "GET")
end

function class:getPlacesInfo(items)
	local v5 = Promise.new(function(callback, callback2)
		self:_fetchPlacesInfo(items):andThen(function(p2)
			if not (p2 and p2.responseBody) then
				callback(nil)
				return
			end

			local v6 = {}

			for k, v7 in p2.responseBody do
				local v8 = {
					universeId = v7.universeId,
					name = v7.name,
					description = v7.description
				}

				v6[v7.placeId] = v8

				self._placeInfo[v7.placeId] = v8
			end

			callback(v6)
		end):catch(function(p2)
			callback2(p2)
		end)
	end)

	local placesInfo = {}

	for k, item in items do
		if self._placeInfo[item] then
			placesInfo[item] = Promise.resolve(self._placeInfo[item])
		else
			self._placeInfo[item] = v5:andThen(function(p2)
				return p2[item]
			end)

			placesInfo[item] = self._placeInfo[item]
		end
	end

	return placesInfo
end

function class:_getInfo(p2, p3)
	if self._placeInfo[p2] and self._placeInfo[p2][p3] then
		return Promise.resolve(self._placeInfo[p2][p3])
	end

	if self._placeInfo[p2] then
		return self._placeInfo[p2]:andThen(function(p4)
			return self._placeInfo[p2][p3]
		end)
	end

	return self:getPlacesInfo({ p2 })[p2]:andThen(function(p4)
		return p4[p3]
	end)
end

class.default = class.new()

return class
