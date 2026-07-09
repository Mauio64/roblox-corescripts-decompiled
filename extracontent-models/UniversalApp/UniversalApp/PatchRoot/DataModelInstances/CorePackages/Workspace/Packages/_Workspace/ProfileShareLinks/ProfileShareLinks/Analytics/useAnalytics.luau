local Parent = script:FindFirstAncestor("ProfileShareLinks").Parent
local React = require(Parent.React)
local initializeProfileShareLinksAnalytics = require(script.Parent.initializeProfileShareLinksAnalytics)

return function() -- line: 7
	-- upvalues: React (copy), initializeProfileShareLinksAnalytics (copy)
	return React.useMemo(function() -- line: 8
		-- upvalues: initializeProfileShareLinksAnalytics (copy)
		return initializeProfileShareLinksAnalytics()
	end, {})
end
