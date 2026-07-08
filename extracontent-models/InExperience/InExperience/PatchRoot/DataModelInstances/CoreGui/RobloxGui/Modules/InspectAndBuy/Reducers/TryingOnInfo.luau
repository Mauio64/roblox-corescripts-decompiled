local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local SetTryingOnInfo = require(ParentParent.Actions.SetTryingOnInfo)
local t1 = {
	tryingOn = false,
	assetId = nil,
	assetTypeId = nil
}

return Rodux.createReducer(t1, {
	[SetTryingOnInfo.name] = function(_, p2) -- line: 13
		return {
			tryingOn = p2.tryingOn,
			assetId = p2.assetId,
			assetTypeId = p2.assetTypeId
		}
	end
})
