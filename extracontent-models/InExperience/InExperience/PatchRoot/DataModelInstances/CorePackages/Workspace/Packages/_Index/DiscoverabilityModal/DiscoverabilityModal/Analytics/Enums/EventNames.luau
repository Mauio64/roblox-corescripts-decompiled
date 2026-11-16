local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
return dependencies.enumerate(script.Name, {
	DiscoverabilityModalLoad = "discoverabilityModalLoad",
	DiscoverabilityModalContinue = "discoverabilityModalDiscoverableContinue",
	DiscoverabilityModalClose = "discoverabilityModalDiscoverableClose",
	DiscoverabilityModalRadioButtonClick = "discoverabilityModalRadioButtonClick"
})
