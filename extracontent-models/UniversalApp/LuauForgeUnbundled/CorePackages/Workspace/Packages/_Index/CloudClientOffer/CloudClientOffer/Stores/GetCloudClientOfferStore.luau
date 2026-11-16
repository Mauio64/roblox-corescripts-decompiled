local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CloudClientOffer/Signals")
local createCloudClientOffer = require("@game/CorePackages/Workspace/Packages/_Index/CloudClientOffer/CloudClientOffer/createCloudClientOffer")

local getDefaultCloudClientOfferDependencies = require("@game/CorePackages/Workspace/Packages/_Index/CloudClientOffer/CloudClientOffer/getDefaultCloudClientOfferDependencies").getDefaultCloudClientOfferDependencies

return Signals.createComputed(function()
	return createCloudClientOffer(getDefaultCloudClientOfferDependencies())
end)
