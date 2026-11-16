local parent = script.Parent.Parent

local UrlMatcher = require(script.Parent.UrlMatcher)
local UrlValidation = require(script.Parent.UrlValidation)
require(script.Parent.Types)
local Cryo = require(parent.Cryo)

local UrlProcessor = {}
UrlProcessor.__index = UrlProcessor

function UrlProcessor.new(options, urlMap)
	local union = Cryo.Dictionary.union(options or {}, {
		pathPatterns = Cryo.Dictionary.keys(urlMap)
	})
	local v = { _urlMatcher = UrlMatcher.new(union), _urlMap = urlMap }

	setmetatable(v, UrlProcessor)
	return v
end

function UrlProcessor:process(p: string)
	local match = self._urlMatcher:match(p)
	return Cryo.List.filterMap(match, function(p2)
		local v, v2 = UrlValidation.validateUrlMatch(p2, self._urlMap)

		if v then
			return { startIndex = p2.startIndex, endIndex = p2.endIndex, result = v2 }
		end

		return nil
	end)
end

return UrlProcessor
