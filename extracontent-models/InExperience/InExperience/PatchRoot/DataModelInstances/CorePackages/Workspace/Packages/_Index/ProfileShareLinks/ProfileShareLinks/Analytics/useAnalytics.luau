local parent = script:FindFirstAncestor("ProfileShareLinks").Parent
local React = require(parent.React)

local initializeProfileShareLinksAnalytics = require(script.Parent.initializeProfileShareLinksAnalytics)

return function()
	return React.useMemo(function()
		return initializeProfileShareLinksAnalytics()
	end, {})
end
