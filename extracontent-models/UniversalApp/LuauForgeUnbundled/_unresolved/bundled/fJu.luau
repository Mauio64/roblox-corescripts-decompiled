local fFlagAppIaHomeCampaignTabNewBadge = require("@luauforge/bundled/fJv").FFlagAppIaHomeCampaignTabNewBadge
local fFlagAppIaHomeShowCampaignTab = require("@luauforge/bundled/fJv").FFlagAppIaHomeShowCampaignTab

local v5 = {
	Components = { CampaignContentEntryPoint = require("@luauforge/bundled/fJw") },
	Hooks = 0,
	CampaignEligibility = 0,
	Utils = 0
}

local v7 = if fFlagAppIaHomeCampaignTabNewBadge then require("@luauforge/bundled/fJS") else nil
v5.Hooks = { useCampaignTabNewBadge = v7 }

local v8 = if fFlagAppIaHomeShowCampaignTab then require("@luauforge/bundled/fJV") else nil
v5.CampaignEligibility = v8
v5.Utils = {
	getCampaignConfigKey = require("@luauforge/bundled/fJH"),
	getCampaignScreenSize = require("@luauforge/bundled/fKa")
}
return v5
