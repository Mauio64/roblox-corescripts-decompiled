local SocialLuaAnalytics = script:FindFirstAncestor("SocialLuaAnalytics")
local DiagEventTypes = require(SocialLuaAnalytics.Analytics.Enums).DiagEventTypes

require(script.Parent.Parent.Types)

local function formatValue(p1, p2) -- line: 7
	if type(p1) == "function" then
		return (p1(p2))
	end

	return p1
end
local function getFormattedDiagEventInfo() -- line: 11
	-- upvalues: DiagEventTypes (copy)
	return function(p3, p4) -- line: 12
		-- upvalues: DiagEventTypes (copy)
		local name = p3.name
		local v10 = if type(name) ~= "function" then name else name(p4)
		local v11 = p3.type or DiagEventTypes.Counter
		local v13

		if v11 == DiagEventTypes.Stats then
			local stats = p3.stats

			v13 = ((if type(stats) ~= "function" then stats else stats(p4))) or 0
		else
			local count = p3.count

			v13 = ((if type(count) ~= "function" then count else count(p4))) or 1
		end

		local platformSpecificity = p3.platformSpecificity

		return {
			type = v11,
			name = v10,
			value = v13,
			platformSpecificity = platformSpecificity
		}
	end
end

return getFormattedDiagEventInfo
