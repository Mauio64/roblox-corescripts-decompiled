local parent = script:FindFirstAncestor("UserProfiles").Parent

local Analytics = require(parent.Analytics)
return Analytics.Analytics.new(game:GetService("RbxAnalyticsService"))
