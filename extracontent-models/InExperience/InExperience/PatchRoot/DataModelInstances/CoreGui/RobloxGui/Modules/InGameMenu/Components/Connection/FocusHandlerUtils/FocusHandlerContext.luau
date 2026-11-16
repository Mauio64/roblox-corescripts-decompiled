local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
return InGameMenuDependencies.Roact.createContext({
	currentHandlerId = nil,
	candidateHandlerId = nil,
	previousSelections = {},
	requestFocusForHandlerId = function() end,
	forgetLastSelectionForHandlerId = function() end,
	blurCurrentFocusHandler = function() end
})
