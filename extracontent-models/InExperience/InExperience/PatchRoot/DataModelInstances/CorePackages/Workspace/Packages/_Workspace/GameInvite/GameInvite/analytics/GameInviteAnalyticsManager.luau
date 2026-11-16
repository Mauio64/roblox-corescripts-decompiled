local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local GameInvite = script:FindFirstAncestor("GameInvite")
local GameInviteAnalytics = require(GameInvite.analytics.GameInviteAnalytics)
local parent = GameInvite.Parent

local Analytics = require(parent.Analytics)
local EventStream = Analytics.AnalyticsReporters.EventStream
local Analytics2 = require(parent.Analytics)
local Diag = Analytics2.AnalyticsReporters.Diag

return (GameInviteAnalytics.new():withEventStream(EventStream.new(RbxAnalyticsService)):withDiag(Diag.new(RbxAnalyticsService)))
