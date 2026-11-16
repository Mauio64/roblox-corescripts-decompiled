local parent = script:FindFirstAncestor("SocialLuaAnalytics").Parent

local ScrollIntervalTracker = require(parent.ScrollIntervalTracker)

return { createScrollIntervalTracker = ScrollIntervalTracker.createScrollIntervalTracker }
