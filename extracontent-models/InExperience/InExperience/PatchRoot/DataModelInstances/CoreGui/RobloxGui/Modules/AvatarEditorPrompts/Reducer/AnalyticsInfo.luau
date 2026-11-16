local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)
local Cryo = require(CorePackages.Packages.Cryo)

local parent = script.Parent.Parent

local CloseOpenPrompt = require(parent.Actions.CloseOpenPrompt)
local AddAnalyticsInfo = require(parent.Actions.AddAnalyticsInfo)

return (Rodux.createReducer({ addedAssets = nil, removedAssets = nil }, {
	[AddAnalyticsInfo.name] = function(p, p2)
		return Cryo.Dictionary.join(p, p2.info)
	end,
	[CloseOpenPrompt.name] = function(_, _)
		return {}
	end
}))
