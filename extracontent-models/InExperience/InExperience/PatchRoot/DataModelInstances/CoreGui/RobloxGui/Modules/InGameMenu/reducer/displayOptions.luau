local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.InGameMenuDependencies).Rodux
local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Resources.Constants)
local SetInspectMenuEnabled = require(ParentParent.Actions.SetInspectMenuEnabled)
local SetInputType = require(ParentParent.Actions.SetInputType)
local InputType = Constants.InputType

return Rodux.createReducer({
	inspectMenuEnabled = true,
	inputType = InputType.MouseAndKeyboard
}, {
	[SetInspectMenuEnabled.name] = function(p1, p2) -- line: 20
		return {
			inspectMenuEnabled = p2.enabled,
			inputType = p1.inputType
		}
	end,
	[SetInputType.name] = function(p3, p4) -- line: 27
		return {
			inspectMenuEnabled = p3.inspectMenuEnabled,
			inputType = p4.inputType
		}
	end
})
