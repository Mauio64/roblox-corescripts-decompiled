local ParentParent = script.Parent.Parent
local UrlMatcher = require(script.Parent.UrlMatcher)
local UrlValidation = require(script.Parent.UrlValidation)

require(script.Parent.Types)

local Cryo = require(ParentParent.Cryo)
local t1 = {}

t1.__index = t1

function t1.new(p1, p2) -- line: 32
	-- upvalues: Cryo (copy), UrlMatcher (copy), t1 (copy)
	local v8 = Cryo.Dictionary.union(p1 or {}, {
		pathPatterns = Cryo.Dictionary.keys(p2)
	})
	local t2 = {
		_urlMatcher = UrlMatcher.new(v8),
		_urlMap = p2
	}

	setmetatable(t2, t1)

	return t2
end
function t1.process(t3: {[any]: any}, s1: string) -- line: 48
	-- upvalues: Cryo (copy), UrlValidation (copy)
	local v12 = t3._urlMatcher:match(s1)

	return Cryo.List.filterMap(v12, function(p3) -- line: 50
		-- upvalues: UrlValidation (copy), t3 (copy)
		local v14, v15 = UrlValidation.validateUrlMatch(p3, t3._urlMap)

		if v14 then
			return {
				startIndex = p3.startIndex,
				endIndex = p3.endIndex,
				result = v15
			}
		end

		return nil
	end)
end

return t1
