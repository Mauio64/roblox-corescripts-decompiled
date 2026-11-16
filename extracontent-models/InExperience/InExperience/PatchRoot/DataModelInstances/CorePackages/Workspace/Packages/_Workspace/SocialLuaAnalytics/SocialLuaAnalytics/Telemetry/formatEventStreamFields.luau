local HttpService = game:GetService("HttpService")
local parent = script:FindFirstAncestor("SocialLuaAnalytics").Parent
local Cryo = require(parent.Cryo)

local function formatEventStreamFields(p)
	return Cryo.Dictionary.map(p, function(p2, p3)
		if type(p2) ~= "table" then
			return tostring(p2), p3
		end

		local success, result = pcall(function()
			return HttpService:JSONEncode(p2)
		end)

		if success then
			return result, p3
		end

		return "", p3
	end)
end

return formatEventStreamFields
