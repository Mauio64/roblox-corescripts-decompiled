local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.InGameMenuDependencies).Roact.createContext({
	currentHandlerId = nil,
	candidateHandlerId = nil,
	previousSelections = {},
	requestFocusForHandlerId = function() -- line: 9
	end,
	forgetLastSelectionForHandlerId = function() -- line: 10
	end,
	blurCurrentFocusHandler = function() -- line: 11
	end
})
