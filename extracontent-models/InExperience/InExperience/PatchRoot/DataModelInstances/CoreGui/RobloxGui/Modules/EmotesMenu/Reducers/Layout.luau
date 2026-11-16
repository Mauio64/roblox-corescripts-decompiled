local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local parent = script.Parent.Parent

local actions = parent.Actions

local SetLayout = require(actions.SetLayout)
local Constants = require(parent.Constants)

return Rodux.createReducer(Constants.Layout.Large, {
	[SetLayout.name] = function(_, p)
		return p.layout
	end
})
