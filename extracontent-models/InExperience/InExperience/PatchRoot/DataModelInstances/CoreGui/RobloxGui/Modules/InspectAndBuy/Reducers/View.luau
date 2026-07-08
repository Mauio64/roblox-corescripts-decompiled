local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local SetView = require(ParentParent.Actions.SetView)
local Constants = require(ParentParent.Constants)

return Rodux.createReducer(Constants.View.Wide, {
	[SetView.name] = function(_, p2) -- line: 8
		return p2.view
	end
})
