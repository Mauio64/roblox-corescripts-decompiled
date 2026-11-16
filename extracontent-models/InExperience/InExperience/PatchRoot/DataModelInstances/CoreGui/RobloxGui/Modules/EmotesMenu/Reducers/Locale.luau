local CorePackages = game:GetService("CorePackages")

local Rodux = require(CorePackages.Packages.Rodux)

local parent = script.Parent.Parent

local actions = parent.Actions

local SetLocale = require(actions.SetLocale)
local Constants = require(parent.Constants)

return Rodux.createReducer(Constants.FallbackLocale, {
	[SetLocale.name] = function(_, p)
		return p.locale
	end
})
