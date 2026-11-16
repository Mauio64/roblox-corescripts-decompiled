local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local parent = script.Parent.Parent
local SetView = require(parent.Actions.SetView)
local Constants = require(parent.Constants)

return Rodux.createReducer(Constants.View.Wide, {
	[SetView.name] = function(_, p)
		return p.view
	end
})
