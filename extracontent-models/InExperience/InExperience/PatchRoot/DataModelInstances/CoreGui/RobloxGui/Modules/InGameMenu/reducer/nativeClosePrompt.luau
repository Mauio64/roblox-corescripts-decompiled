local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Rodux = InGameMenuDependencies.Rodux
local Cryo = InGameMenuDependencies.Cryo
local ParentParent = script.Parent.Parent
local OpenNativeClosePrompt = require(ParentParent.Actions.OpenNativeClosePrompt)
local CloseNativeClosePrompt = require(ParentParent.Actions.CloseNativeClosePrompt)
local SetMenuIconTooltipOpen = require(ParentParent.Actions.SetMenuIconTooltipOpen)

return Rodux.createReducer({
	closingApp = false,
	menuIconTooltipOpen = false
}, {
	[OpenNativeClosePrompt.name] = function(p1, _) -- line: 17
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p1, {
			closingApp = true
		})
	end,
	[CloseNativeClosePrompt.name] = function(p3, _) -- line: 22
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p3, {
			closingApp = false
		})
	end,
	[SetMenuIconTooltipOpen.name] = function(p5, p6) -- line: 27
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(p5, {
			menuIconTooltipOpen = p6.menuIconTooltipOpen
		})
	end
})
