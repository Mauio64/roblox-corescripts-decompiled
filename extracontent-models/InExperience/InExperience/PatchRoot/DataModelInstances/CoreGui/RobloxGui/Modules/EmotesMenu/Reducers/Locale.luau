local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local Actions = ParentParent.Actions
local SetLocale = require(Actions.SetLocale)
local Constants = require(ParentParent.Constants)

return Rodux.createReducer(Constants.FallbackLocale, {
	[SetLocale.name] = function(_, p2) -- line: 14
		return p2.locale
	end
})
