local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local Rodux = require(CorePackages.Packages.Rodux)
local Actions = script.Parent.Parent.Actions
local ShowMenu = require(Actions.ShowMenu)
local HideMenu = require(Actions.HideMenu)
local ShowError = require(Actions.ShowError)
local HideError = require(Actions.HideError)
local SetGuiInset = require(Actions.SetGuiInset)
local t1 = {
	menuVisible = false,
	guiInset = 0,
	errorVisible = false,
	errorText = ""
}

return Rodux.createReducer(t1, {
	[ShowMenu.name] = function(p1, _) -- line: 30
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			menuVisible = true
		})
	end,
	[HideMenu.name] = function(p3, _) -- line: 36
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			menuVisible = false
		})
	end,
	[ShowError.name] = function(p5, p6) -- line: 42
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p5, {
			errorVisible = true,
			errorText = p6.errorText
		})
	end,
	[HideError.name] = function(p7, _) -- line: 49
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p7, {
			errorVisible = false
		})
	end,
	[SetGuiInset.name] = function(p9, p10) -- line: 55
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p9, {
			guiInset = p10.guiInset
		})
	end
})
