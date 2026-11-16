local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local UserInputService = game:GetService("UserInputService")
local platform = UserInputService:GetPlatform()
local fStringLuaAppEphemeralCounterPrefix = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FStringLuaAppEphemeralCounterPrefix

return function(value, value2)
	pcall(function()
		assert(type(value) == "string", "Expected counterName to be a string")

		value = value or ""
		value2 = value2 or 1

		if platform == Enum.Platform.Android then
			value = "Android-" .. tostring(value)
		elseif platform == Enum.Platform.IOS then
			value = "iOS-" .. tostring(value)
		elseif platform == Enum.Platform.Windows then
			value = "Win32-" .. tostring(value)
		elseif platform == Enum.Platform.UWP then
			value = "UWP-" .. tostring(value)
		elseif platform == Enum.Platform.OSX then
			value = "Mac-" .. tostring(value)
		elseif fStringLuaAppEphemeralCounterPrefix ~= "" then
			value = fStringLuaAppEphemeralCounterPrefix .. tostring(value)
		end

		RbxAnalyticsService:ReportCounter(value, value2)
	end)
end
