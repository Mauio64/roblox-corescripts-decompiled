local UrlMatcher = require("@game/CorePackages/Workspace/Packages/_Index/UrlMatching/UrlMatching/UrlMatcher")
local UrlValidation = require("@game/CorePackages/Workspace/Packages/_Index/UrlMatching/UrlMatching/UrlValidation")
require("@game/CorePackages/Workspace/Packages/_Index/UrlMatching/UrlMatching/Types")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/UrlMatching/Cryo")

local class = {}
class.__index = class

function class.new(options, p2)
	local union = Cryo.Dictionary.union(options or {}, {
		pathPatterns = Cryo.Dictionary.keys(p2)
	})
	local v5 = { _urlMatcher = UrlMatcher.new(union), _urlMap = p2 }

	setmetatable(v5, class)
	return v5
end

function class:process(p3)
	local match = self._urlMatcher:match(p3)
	return Cryo.List.filterMap(match, function(p4)
		local v5, v6 = UrlValidation.validateUrlMatch(p4, self._urlMap)

		if v5 then
			return { startIndex = p4.startIndex, endIndex = p4.endIndex, result = v6 }
		end

		return nil
	end)
end

return class
