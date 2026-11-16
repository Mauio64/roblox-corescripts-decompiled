local CloudClientOffer = script:FindFirstAncestor("CloudClientOffer")
local parent = CloudClientOffer.Parent

local Signals = require(parent.Signals)
local createCloudClientOffer = require(CloudClientOffer.createCloudClientOffer)

local getDefaultCloudClientOfferDependencies = require(CloudClientOffer.getDefaultCloudClientOfferDependencies)
local getDefaultCloudClientOfferDependencies2 = getDefaultCloudClientOfferDependencies.getDefaultCloudClientOfferDependencies

return Signals.createComputed(function()
	return createCloudClientOffer(getDefaultCloudClientOfferDependencies2())
end)
