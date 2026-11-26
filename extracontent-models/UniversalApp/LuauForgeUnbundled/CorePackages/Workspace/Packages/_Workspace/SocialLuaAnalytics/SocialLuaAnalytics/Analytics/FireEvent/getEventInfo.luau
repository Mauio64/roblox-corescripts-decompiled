require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Types")

return function(p2)
	return function(p3, p4)
		local v5 = p2[p3]
		assert(v5, "Invalid eventName used: " .. tostring(p3) .. " called")

		return v5, p4
	end
end
