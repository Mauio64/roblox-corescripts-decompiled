local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local SetLocale = require(ParentParent.Actions.SetLocale)

return Rodux.createReducer("en-us", {
	[SetLocale.name] = function(_, p2) -- line: 9
		return p2.locale
	end
})
