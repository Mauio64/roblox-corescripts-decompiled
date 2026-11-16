local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)

local Actions = script.Parent.Parent.Actions

local ShowMenu = require(Actions.ShowMenu)
local HideMenu = require(Actions.HideMenu)

local ShowError = require(Actions.ShowError)
local HideError = require(Actions.HideError)

local SetGuiInset = require(Actions.SetGuiInset)

return Rodux.createReducer({
	menuVisible = false,
	guiInset = 0,
	errorVisible = false,
	errorText = ""
}, {
	[ShowMenu.name] = function(p, _)
		return Cryo.Dictionary.join(p, { menuVisible = true })
	end,
	[HideMenu.name] = function(p, _)
		return Cryo.Dictionary.join(p, { menuVisible = false })
	end,
	[ShowError.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { errorVisible = true, errorText = p2.errorText })
	end,
	[HideError.name] = function(p, _)
		return Cryo.Dictionary.join(p, { errorVisible = false })
	end,
	[SetGuiInset.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { guiInset = p2.guiInset })
	end
})
