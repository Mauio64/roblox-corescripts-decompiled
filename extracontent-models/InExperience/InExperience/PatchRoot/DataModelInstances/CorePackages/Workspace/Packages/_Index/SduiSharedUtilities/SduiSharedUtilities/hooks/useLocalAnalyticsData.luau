local Parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local React = require(Parent.React)

local function useLocalAnalyticsData(s1: string, s2: string, t1: {[any]: any}?) -- line: 5
	-- upvalues: React (copy)
	return React.useMemo(function() -- line: 6
		-- upvalues: t1 (copy), s1 (copy), s2 (copy)
		local v7 = if not t1 then {} else t1

		v7.configKey = s1
		v7.appPage = s2

		return v7
	end, {
		s1,
		s2,
		t1
	})
end

return useLocalAnalyticsData
