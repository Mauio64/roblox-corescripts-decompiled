local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local parent = script.Parent.Parent
local ShowMenu = require(parent.Actions.ShowMenu)
local HideMenu = require(parent.Actions.HideMenu)

return Rodux.createReducer(true, {
	[ShowMenu.name] = function(_, _): boolean
		return true
	end,
	[HideMenu.name] = function(_, _): boolean
		return false
	end
})
