return {
	DevStoreSeeAllPage = function()
		return require("@game/CorePackages/Workspace/Packages/_Index/ExperienceStoreServerDrivenUi/ExperienceStoreServerDrivenUi/Components/DevStoreSeeAllPage")
	end,
	SduiExperienceStoreRegister = require("@game/CorePackages/Workspace/Packages/_Index/ExperienceStoreServerDrivenUi/ExperienceStoreServerDrivenUi/System/SduiExperienceStoreRegister"),
	SduiVirtualGameItemText = require("@game/CorePackages/Workspace/Packages/_Index/ExperienceStoreServerDrivenUi/ExperienceStoreServerDrivenUi/Components/SduiVirtualGameItemText"),
	navigateToDevStoreSeeAll = function(...)
		return require("@game/CorePackages/Workspace/Packages/_Index/ExperienceStoreServerDrivenUi/ExperienceStoreServerDrivenUi/Navigation/navigateToDevStoreSeeAll")(...)
	end,
	registerExperienceStoreActions = require("@game/CorePackages/Workspace/Packages/_Index/ExperienceStoreServerDrivenUi/ExperienceStoreServerDrivenUi/Actions/registerExperienceStoreActions"),
	registerExperienceStoreComponents = require("@game/CorePackages/Workspace/Packages/_Index/ExperienceStoreServerDrivenUi/ExperienceStoreServerDrivenUi/System/registerExperienceStoreComponents")
}
