local CloudClientOffer = script:FindFirstAncestor("CloudClientOffer")

local CloudClientServiceAdapter = require(CloudClientOffer.CloudClientServiceAdapter)
local CloudClientExperiment = require(CloudClientOffer.CloudClientExperiment)
require(CloudClientOffer.createCloudClientOffer)
local GetCloudClientSessionStore = require(CloudClientOffer.Stores.GetCloudClientSessionStore)

local FStringLuaAppCloudClientPlayButtonIxpLayer = require(CloudClientOffer.Flags.FStringLuaAppCloudClientPlayButtonIxpLayer)

local candidates = {
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
		defaultCloudClientOfferDependencies.experiment = CloudClientExperiment(
			IXPService,
			FStringLuaAppCloudClientPlayButtonIxpLayer
		)

		defaultCloudClientOfferDependencies.session = GetCloudClientSessionStore(false)
		defaultCloudClientOfferDependencies.candidates = candidates
		return defaultCloudClientOfferDependencies
	end,
	OFFER_CANDIDATES = candidates
}
