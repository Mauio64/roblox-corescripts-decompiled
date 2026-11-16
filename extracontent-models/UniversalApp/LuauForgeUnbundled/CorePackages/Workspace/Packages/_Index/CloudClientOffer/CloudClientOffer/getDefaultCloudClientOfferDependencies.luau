local CloudClientServiceAdapter = require("@game/CorePackages/Workspace/Packages/_Index/CloudClientOffer/CloudClientOffer/CloudClientServiceAdapter")
local CloudClientExperiment = require("@game/CorePackages/Workspace/Packages/_Index/CloudClientOffer/CloudClientOffer/CloudClientExperiment")
require("@game/CorePackages/Workspace/Packages/_Index/CloudClientOffer/CloudClientOffer/createCloudClientOffer")
local GetCloudClientSessionStore = require("@game/CorePackages/Workspace/Packages/_Index/CloudClientOffer/CloudClientOffer/Stores/GetCloudClientSessionStore")

local FStringLuaAppCloudClientPlayButtonIxpLayer = require("@game/CorePackages/Workspace/Packages/_Index/CloudClientOffer/CloudClientOffer/Flags/FStringLuaAppCloudClientPlayButtonIxpLayer")

local v5 = {
	{ kind = "RobloxReality" },
	{ kind = "CloudPlay" }
}

return {
	getDefaultCloudClientOfferDependencies = function()
		local defaultCloudClientOfferDependencies = {
			service = CloudClientServiceAdapter.getCloudClientServiceAdapter(),
			experiment = 0,
			session = 0,
			candidates = 0
		}

		local IXPService = game:GetService("IXPService")
		defaultCloudClientOfferDependencies.experiment = CloudClientExperiment(IXPService, FStringLuaAppCloudClientPlayButtonIxpLayer)

		defaultCloudClientOfferDependencies.session = GetCloudClientSessionStore(false)
		defaultCloudClientOfferDependencies.candidates = v5
		return defaultCloudClientOfferDependencies
	end,
	OFFER_CANDIDATES = v5
}
