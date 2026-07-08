local Parent = script:FindFirstAncestor("AuthCommon").Parent
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Platform = game:GetService("UserInputService"):GetPlatform()
local FStringLuaAppEphemeralCounterPrefix = require(Parent.SharedFlags).FStringLuaAppEphemeralCounterPrefix

return function(p1, p2) -- line: 13
	-- upvalues: Platform (copy), FStringLuaAppEphemeralCounterPrefix (copy), RbxAnalyticsService (copy)
	pcall(function() -- line: 14
		-- upvalues: p1 (ref), p2 (ref), Platform (copy), FStringLuaAppEphemeralCounterPrefix (copy), RbxAnalyticsService (copy)
		assert(type(p1) == "string", "Expected counterName to be a string")
		p1 = p1 or ""
		p2 = p2 or 1

		if Platform == Enum.Platform.Android then
			p1 = "Android-" .. tostring(p1)
		elseif Platform == Enum.Platform.IOS then
			p1 = "iOS-" .. tostring(p1)
		elseif Platform == Enum.Platform.Windows then
			p1 = "Win32-" .. tostring(p1)
		elseif Platform == Enum.Platform.UWP then
			p1 = "UWP-" .. tostring(p1)
		elseif Platform == Enum.Platform.OSX then
			p1 = "Mac-" .. tostring(p1)
		elseif FStringLuaAppEphemeralCounterPrefix ~= "" then
			p1 = FStringLuaAppEphemeralCounterPrefix .. tostring(p1)
		end

		RbxAnalyticsService:ReportCounter(p1, p2)
	end)
end
