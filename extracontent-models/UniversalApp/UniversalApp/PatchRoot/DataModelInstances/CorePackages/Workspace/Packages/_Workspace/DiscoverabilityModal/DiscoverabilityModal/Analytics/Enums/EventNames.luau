local ParentParent = script.Parent.Parent.Parent

return require(ParentParent.dependencies).enumerate(script.Name, {
	DiscoverabilityModalLoad = "discoverabilityModalLoad",
	DiscoverabilityModalContinue = "discoverabilityModalDiscoverableContinue",
	DiscoverabilityModalClose = "discoverabilityModalDiscoverableClose",
	DiscoverabilityModalRadioButtonClick = "discoverabilityModalRadioButtonClick"
})
