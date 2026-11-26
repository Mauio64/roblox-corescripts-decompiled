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
		_universeVotes = {},
		_requestImpl = p2 or config
	}, class))
end

function class:upVotes(p2)
	return self:_getVotes(p2, "upVotes")
end

function class:downVotes(p2)
	return self:_getVotes(p2, "downVotes")
end

function class:rating(p2)
	return self:_getVotes(p2, "rating")
end

function class:_fetchUniversesVotes(p3)
	local queryString = url:makeQueryString({ universeIds = p3 })

	local v5 = string.format("%sv1/games/votes?%s", url.GAME_URL, queryString)

	return self._requestImpl(v5, "GET")
end

function class:getUniversesVotes(items)
	local v5 = Promise.new(function(callback, callback2)
		self:_fetchUniversesVotes(items):andThen(function(p2)
			if not (p2 and p2.responseBody) then
				callback(nil)
				return
			end

			local v6 = {}

			for k, v7 in p2.responseBody.data do
				local v8 = v7.upVotes + v7.downVotes == 0 and 0 or v7.upVotes / (v7.upVotes + v7.downVotes)

				local v9 = {
					universeId = v7.id,
					upVotes = v7.upVotes,
					downVotes = v7.downVotes,
					rating = v8
				}

				v6[v7.id] = v9

				self._universeVotes[v7.id] = v9
			end

			callback(v6)
		end):catch(function(p2)
			callback2(p2)
		end)
	end)

	local universesVotes = {}

	for k, item in items do
		if self._universeVotes[item] then
			universesVotes[item] = Promise.resolve(self._universeVotes[item])
		else
			self._universeVotes[item] = v5:andThen(function(p2)
				return p2[item]
			end)

			universesVotes[item] = self._universeVotes[item]
		end
	end

	return universesVotes
end

function class:_getVotes(p2, p3)
	if self._universeVotes[p2] and self._universeVotes[p2][p3] then
		return Promise.resolve(self._universeVotes[p2][p3])
	end

	if self._universeVotes[p2] then
		return self._universeVotes[p2]:andThen(function(p4)
			return self._universeVotes[p2][p3]
		end)
	end

	return self:getUniversesVotes({ p2 })[p2]:andThen(function(p4)
		return p4[p3]
	end)
end

class.default = class.new()

return class
