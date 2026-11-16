local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Rodux = InGameMenuDependencies.Rodux
local Cryo = InGameMenuDependencies.Cryo

local parent = script.Parent.Parent
local OpenNativeClosePrompt = require(parent.Actions.OpenNativeClosePrompt)
local CloseNativeClosePrompt = require(parent.Actions.CloseNativeClosePrompt)
local SetMenuIconTooltipOpen = require(parent.Actions.SetMenuIconTooltipOpen)

return Rodux.createReducer({ closingApp = false, menuIconTooltipOpen = false }, {
	[OpenNativeClosePrompt.name] = function(p, _)
		return Cryo.Dictionary.join(p, { closingApp = true })
	end,
	[CloseNativeClosePrompt.name] = function(p, _)
		return Cryo.Dictionary.join(p, { closingApp = false })
	end,
	[SetMenuIconTooltipOpen.name] = function(p, p2)
		return Cryo.Dictionary.join(p, { menuIconTooltipOpen = p2.menuIconTooltipOpen })
	end
})
