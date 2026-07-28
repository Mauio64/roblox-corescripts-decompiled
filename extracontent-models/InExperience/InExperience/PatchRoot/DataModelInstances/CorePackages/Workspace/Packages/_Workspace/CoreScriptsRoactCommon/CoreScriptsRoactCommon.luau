local createSignalMap = require(script.Utilities.createSignalMap)

return {
	CoreScriptsRootProvider = require(script.CoreScriptsRootProvider),
	Scrim = require(script.Scrim),
	Traversal = require(script.Traversal),
	["jest.config"] = script["jest.config"],
	["jest.main.config"] = script["jest.main.config"],
	["jest.mockDataModel.config"] = script["jest.mockDataModel.config"],
	useScreenSize = require(script.useScreenSize),
	Utilities = {
		createSignalMap = createSignalMap,
		sortTableByValue = require(script.Utilities.sortTableByValue)
	}
}
