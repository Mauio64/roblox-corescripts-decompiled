local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local Actions = ParentParent.Actions
local SetLayout = require(Actions.SetLayout)
local Constants = require(ParentParent.Constants)

return Rodux.createReducer(Constants.Layout.Large, {
	[SetLayout.name] = function(_, p2) -- line: 14
		return p2.layout
	end
})
