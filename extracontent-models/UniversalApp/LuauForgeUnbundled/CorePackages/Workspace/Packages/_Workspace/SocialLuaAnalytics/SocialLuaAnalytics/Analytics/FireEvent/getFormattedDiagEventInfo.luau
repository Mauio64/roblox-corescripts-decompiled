local diagEventTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Enums").DiagEventTypes

require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Types")

local function formatValue(callback, p2)
	if type(callback) == "function" then
		return (callback(p2))
	end

	return callback
end

local function getFormattedDiagEventInfo()
	return function(data, p2)
		local v5 = data.name

		if type(v5) == "function" then
			v5 = v5(p2)
		end

		local kind = data.type or diagEventTypes.Counter
		local v6

		if kind == diagEventTypes.Stats then
			local v7 = data.stats

			if type(v7) == "function" then
				v7 = v7(p2)
			end

			v6 = v7 or 0
		else
			local v7 = data.count

			if type(v7) == "function" then
				v7 = v7(p2)
			end

			v6 = v7 or 1
		end

		return {
			type = kind,
			name = v5,
			value = v6,
			platformSpecificity = data.platformSpecificity
		}
	end
end

return getFormattedDiagEventInfo
