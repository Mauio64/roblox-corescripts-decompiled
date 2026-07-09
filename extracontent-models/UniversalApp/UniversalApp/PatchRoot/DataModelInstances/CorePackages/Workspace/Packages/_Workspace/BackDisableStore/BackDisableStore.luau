local BackDisableStore = require(script.BackDisableStore)

return {
	getCount = BackDisableStore.getCount,
	getIsDisabled = BackDisableStore.getIsDisabled,
	setDisabled = BackDisableStore.setDisabled,
	["jest.config"] = script["jest.config"]
}
