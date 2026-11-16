local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local parent = script.Parent.Parent
local SetTryingOnInfo = require(parent.Actions.SetTryingOnInfo)

return Rodux.createReducer({ tryingOn = false, assetId = nil, assetTypeId = nil }, {
	[SetTryingOnInfo.name] = function(_, data)
		return { tryingOn = data.tryingOn, assetId = data.assetId, assetTypeId = data.assetTypeId }
	end
})
