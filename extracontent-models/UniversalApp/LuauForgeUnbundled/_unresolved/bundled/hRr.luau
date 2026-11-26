local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local v5 = pcall(function()
	return Enum.AppShellActionType.TapCampaignPageTab, Enum.AppShellActionType.CampaignPageLoaded
end)

return game:DefineFastFlag("AppIaHomeCampaignTabAnalytics", false)
	and SharedFlags.FFlagAppIaHomeShowCampaignTab
	and SharedFlags.FFlagAppIaHomeSubTabAnalytics
	and v5
	and game:GetEngineFeature("AppShellCampaignPageLoadTime")
