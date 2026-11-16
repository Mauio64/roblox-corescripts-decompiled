return {
	DevStoreSeeAllPage = function()
		return require(script.Components.DevStoreSeeAllPage)
	end,
	SduiExperienceStoreRegister = require(script.System.SduiExperienceStoreRegister),
	SduiVirtualGameItemText = require(script.Components.SduiVirtualGameItemText),
	navigateToDevStoreSeeAll = function(...)
		local navigateToDevStoreSeeAll = require(script.Navigation.navigateToDevStoreSeeAll)
		return navigateToDevStoreSeeAll(...)
	end,
	registerExperienceStoreActions = require(script.Actions.registerExperienceStoreActions),
	registerExperienceStoreComponents = require(script.System.registerExperienceStoreComponents),
	["jest.config"] = script["jest.config"]
}
