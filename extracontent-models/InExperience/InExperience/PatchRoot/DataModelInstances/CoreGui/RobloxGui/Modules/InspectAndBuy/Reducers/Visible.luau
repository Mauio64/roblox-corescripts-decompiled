local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local ParentParent = script.Parent.Parent
local ShowMenu = require(ParentParent.Actions.ShowMenu)
local HideMenu = require(ParentParent.Actions.HideMenu)

return Rodux.createReducer(true, {
	[ShowMenu.name] = function(_, _) -- line: 8
		return true
	end,
	[HideMenu.name] = function(_, _) -- line: 11
		return false
	end
})
