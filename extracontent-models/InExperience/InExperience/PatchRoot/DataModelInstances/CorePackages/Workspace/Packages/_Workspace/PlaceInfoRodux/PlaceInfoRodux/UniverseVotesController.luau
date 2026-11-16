local parent = script:FindFirstAncestor("PlaceInfoRodux").Parent

local Promise = require(parent.Promise)
local Http = require(parent.Http)
local HttpRequest = require(parent.HttpRequest)
require(parent.LuauPolyfill)

local Url = Http.Url

local UniverseVotesController = {}
UniverseVotesController.__index = UniverseVotesController

function UniverseVotesController.new(callback)
	local config = HttpRequest.config({
		requestFunction = function(p: string, p2: string, p3)
			return HttpRequest.requestFunctions.HttpRbxApi(p, p2, p3)
		end
	})
	return (setmetatable({
		_universeVotes = {},
		_requestImpl = callback or config
	}, UniverseVotesController))
end

function UniverseVotesController:upVotes(p: number)
	return self:_getVotes(p, "upVotes")
end

function UniverseVotesController:downVotes(p: number)
	return self:_getVotes(p, "downVotes")
end

function UniverseVotesController:rating(p: number)
	return self:_getVotes(p, "rating")
end

function UniverseVotesController:_fetchUniversesVotes(universeIds)
	local queryString = Url:makeQueryString({ universeIds = universeIds })

	local v = string.format("%sv1/games/votes?%s", Url.GAME_URL, queryString)

	return self._requestImpl(v, "GET")
end

function UniverseVotesController:getUniversesVotes(items)
	local v = Promise.new(function(callback, callback2)
		self:_fetchUniversesVotes(items):andThen(function(p)
			if not (p and p.responseBody) then
				callback(nil)
				return
			end

			local v = {}

			for _, v2 in p.responseBody.data do
				local rating = v2.upVotes + v2.downVotes == 0 and 0 or v2.upVotes / (v2.upVotes + v2.downVotes)

				local v3 = {
					universeId = v2.id,
					upVotes = v2.upVotes,
					downVotes = v2.downVotes,
					rating = rating
				}

				v[v2.id] = v3

				self._universeVotes[v2.id] = v3
			end

			callback(v)
		end):catch(function(p)
			callback2(p)
		end)
	end)

	local universesVotes = {}

	for _, item in items do
		if self._universeVotes[item] then
			universesVotes[item] = Promise.resolve(self._universeVotes[item])
		else
			self._universeVotes[item] = v:andThen(function(p)
				return p[item]
			end)

			universesVotes[item] = self._universeVotes[item]
		end
	end

	return universesVotes
end

function UniverseVotesController:_getVotes(p: number, p2: string)
	if self._universeVotes[p] and self._universeVotes[p][p2] then
		return Promise.resolve(self._universeVotes[p][p2])
	end

	if self._universeVotes[p] then
		return self._universeVotes[p]:andThen(function(_)
			return self._universeVotes[p][p2]
		end)
	end

	return (self:getUniversesVotes({ p })[p]:andThen(function(p3)
		return p3[p2]
	end))
end

UniverseVotesController.default = UniverseVotesController.new()

return UniverseVotesController
