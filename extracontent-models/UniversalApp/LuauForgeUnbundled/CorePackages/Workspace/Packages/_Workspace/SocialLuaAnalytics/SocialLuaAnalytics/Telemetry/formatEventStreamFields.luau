local HttpService = game:GetService("HttpService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/Cryo")

local function formatEventStreamFields(p2)
	return Cryo.Dictionary.map(p2, function(p3, p4)
		if type(p3) ~= "table" then
			return tostring(p3), p4
		end

		local success, result = pcall(function()
			return HttpService:JSONEncode(p3)
		end)

		if success then
			return result, p4
		end

		return "", p4
	end)
end

return formatEventStreamFields
