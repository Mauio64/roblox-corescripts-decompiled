local Parent = script:FindFirstAncestor("UserProfiles").Parent

return require(Parent.Analytics).Analytics.new(game:GetService("RbxAnalyticsService"))
