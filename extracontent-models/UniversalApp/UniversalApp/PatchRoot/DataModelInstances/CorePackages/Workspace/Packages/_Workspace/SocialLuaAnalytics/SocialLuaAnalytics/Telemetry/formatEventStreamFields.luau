local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("SocialLuaAnalytics").Parent
local Cryo = require(Parent.Cryo)

local function formatEventStreamFields(p1) -- line: 6
	-- upvalues: Cryo (copy), HttpService (copy)
	return Cryo.Dictionary.map(p1, function(p2, p3) -- line: 7
		-- upvalues: HttpService (copy)
		if type(p2) == "table" then
			local ok, result = pcall(function() -- line: 9
				-- upvalues: HttpService (copy), p2 (copy)
				return HttpService:JSONEncode(p2)
			end)

			if ok then
				return result, p3
			end

			return "", p3
		end

		return tostring(p2), p3
	end)
end

return formatEventStreamFields
