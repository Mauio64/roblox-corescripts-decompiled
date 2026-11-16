local parent = script:FindFirstAncestor("PlaceInfoRodux").Parent

local Promise = require(parent.Promise)
local Http = require(parent.Http)
local HttpRequest = require(parent.HttpRequest)
require(parent.LuauPolyfill)

local Url = Http.Url

local PlaceInfoController = {}
PlaceInfoController.__index = PlaceInfoController

function PlaceInfoController.new(callback)
	local config = HttpRequest.config({
		requestFunction = function(p: string, p2: string, p3)
			return HttpRequest.requestFunctions.HttpRbxApi(p, p2, p3)
		end
	})
	return (setmetatable({
		_placeInfo = {},
		_requestImpl = callback or config
	}, PlaceInfoController))
end

function PlaceInfoController:name(p: number)
	return self:_getInfo(p, "name")
end

function PlaceInfoController:description(p: number)
	return self:_getInfo(p, "description")
end

function PlaceInfoController:universeId(p: number)
	return self:_getInfo(p, "universeId")
end

function PlaceInfoController:_fetchPlacesInfo(placeIds)
	local queryString = Url:makeQueryString({ placeIds = placeIds })

	local v = string.format("%sv1/games/multiget-place-details?%s", Url.GAME_URL, queryString)

	return self._requestImpl(v, "GET")
end

function PlaceInfoController:getPlacesInfo(items)
	local v = Promise.new(function(callback, callback2)
		self:_fetchPlacesInfo(items):andThen(function(p)
			if not (p and p.responseBody) then
				callback(nil)
				return
			end

			local v = {}

			for _, v2 in p.responseBody do
				local v3 = {
					universeId = v2.universeId,
					name = v2.name,
					description = v2.description
				}

				v[v2.placeId] = v3

				self._placeInfo[v2.placeId] = v3
			end

			callback(v)
		end):catch(function(p)
			callback2(p)
		end)
	end)

	local placesInfo = {}

	for _, item in items do
		if self._placeInfo[item] then
			placesInfo[item] = Promise.resolve(self._placeInfo[item])
		else
			self._placeInfo[item] = v:andThen(function(p)
				return p[item]
			end)

			placesInfo[item] = self._placeInfo[item]
		end
	end

	return placesInfo
end

function PlaceInfoController:_getInfo(p: number, p2: string)
	if self._placeInfo[p] and self._placeInfo[p][p2] then
		return Promise.resolve(self._placeInfo[p][p2])
	end

	if self._placeInfo[p] then
		return self._placeInfo[p]:andThen(function(_)
			return self._placeInfo[p][p2]
		end)
	end

	return (self:getPlacesInfo({ p })[p]:andThen(function(p3)
		return p3[p2]
	end))
end

PlaceInfoController.default = PlaceInfoController.new()

return PlaceInfoController
