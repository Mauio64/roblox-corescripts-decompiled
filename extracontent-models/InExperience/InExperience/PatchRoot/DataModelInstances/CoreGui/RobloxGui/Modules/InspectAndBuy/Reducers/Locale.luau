local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local parent = script.Parent.Parent
local SetLocale = require(parent.Actions.SetLocale)

return Rodux.createReducer("en-us", {
	[SetLocale.name] = function(_, p)
		return p.locale
	end
})
