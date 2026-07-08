local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local SetDetailsInformation = require(ParentParent.Actions.SetDetailsInformation)
local t1 = {
	viewingDetails = false,
	assetId = nil
}

return Rodux.createReducer(t1, {
	[SetDetailsInformation.name] = function(_, p2) -- line: 12
		return {
			viewingDetails = p2.viewingDetails,
			assetId = p2.assetId
		}
	end
})
