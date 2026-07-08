local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)
local ParentParent = script.Parent.Parent
local CloseOpenPrompt = require(ParentParent.Actions.CloseOpenPrompt)
local AddAnalyticsInfo = require(ParentParent.Actions.AddAnalyticsInfo)
local t1 = {
	addedAssets = nil,
	removedAssets = nil
}

return (Rodux.createReducer(t1, {
	[AddAnalyticsInfo.name] = function(p1, p2) -- line: 18
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, p2.info)
	end,
	[CloseOpenPrompt.name] = function(_, _) -- line: 22
		return {}
	end
}))
