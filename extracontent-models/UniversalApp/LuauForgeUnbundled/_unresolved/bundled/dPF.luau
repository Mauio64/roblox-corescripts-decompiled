return {
	All = "All",
	Collectibles = "Collectibles",
	Premium = "Premium",
	TimedOptions = not require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXTimedOptionsSalesTypeFilter and "TimedOptions" or nil
}
