local InExperienceTopBar = script:FindFirstAncestor("InExperienceTopBar")

return {
	GetTopBarStore = if not require(InExperienceTopBar.Flags).FFlagTopBarSignalizeSetCores then nil else require(script.GetTopBarStore)
}
