local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local parent = script.Parent.Parent
local SetDetailsInformation = require(parent.Actions.SetDetailsInformation)

return Rodux.createReducer({ viewingDetails = false, assetId = nil }, {
	[SetDetailsInformation.name] = function(_, p)
		return { viewingDetails = p.viewingDetails, assetId = p.assetId }
	end
})
