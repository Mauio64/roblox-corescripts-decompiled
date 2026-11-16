local SocialLuaAnalytics = script:FindFirstAncestor("SocialLuaAnalytics")

local Enums = require(SocialLuaAnalytics.Analytics.Enums)
local DiagEventTypes = Enums.DiagEventTypes

require(script.Parent.Parent.Types)

local function formatValue(callback, p) -- 3 equivalent calls inferred from this helper
	if type(callback) == "function" then
		return (callback(p))
	end

	return callback
end

local function getFormattedDiagEventInfo()
	return function(data, p)
		local name = formatValue(data.name, p) -- inferred equivalent call
		local kind = data.type or DiagEventTypes.Counter
		local v

		if kind == DiagEventTypes.Stats then
			v = formatValue(data.stats, p) or 0 -- inferred equivalent call
		else
			v = formatValue(data.count, p) or 1 -- inferred equivalent call
		end

		return {
			type = kind,
			name = name,
			value = v,
			platformSpecificity = data.platformSpecificity
		}
	end
end

return getFormattedDiagEventInfo
