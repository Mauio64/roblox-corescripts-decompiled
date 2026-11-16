local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local GameInviteAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/analytics/GameInviteAnalytics")

local eventStream = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Analytics").AnalyticsReporters.EventStream
local diag = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/Analytics").AnalyticsReporters.Diag

return (GameInviteAnalytics.new():withEventStream(eventStream.new(RbxAnalyticsService)):withDiag(diag.new(RbxAnalyticsService)))
