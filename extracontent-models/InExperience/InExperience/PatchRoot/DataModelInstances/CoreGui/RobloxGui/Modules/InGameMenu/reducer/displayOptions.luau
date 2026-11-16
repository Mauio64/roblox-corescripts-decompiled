local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Rodux = InGameMenuDependencies.Rodux

local parent = script.Parent.Parent

local Constants = require(parent.Resources.Constants)

local SetInspectMenuEnabled = require(parent.Actions.SetInspectMenuEnabled)
local SetInputType = require(parent.Actions.SetInputType)

local InputType = Constants.InputType

return Rodux.createReducer({ inspectMenuEnabled = true, inputType = InputType.MouseAndKeyboard }, {
	[SetInspectMenuEnabled.name] = function(p, p2)
		return { inspectMenuEnabled = p2.enabled, inputType = p.inputType }
	end,
	[SetInputType.name] = function(p, p2)
		return { inspectMenuEnabled = p.inspectMenuEnabled, inputType = p2.inputType }
	end
})
