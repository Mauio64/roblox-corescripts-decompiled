local Parent = script:FindFirstAncestor("TrustedContacts").Parent
local React = require(Parent.React)
local AnalyticsSetup = require(script.Parent.AnalyticsSetup)

local function useTCAnalytics(t1: {[any]: any}?) -- line: 12
	-- upvalues: React (copy), AnalyticsSetup (copy)
	return (React.useMemo(function() -- line: 13
		-- upvalues: AnalyticsSetup (copy), t1 (copy)
		return AnalyticsSetup({
			infoForAllEvents = t1
		})
	end, { t1 }))
end

return useTCAnalytics
