local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/DiscoverabilityModal/DiscoverabilityModal/Analytics/Enums/EventNames")

return {
	[EventNames.DiscoverabilityModalLoad] = {
		name = game:DefineFastString("DiscoverabilityModalLoadCounter", "DiscoverabilityModalLoad")
	},
	[EventNames.DiscoverabilityModalContinue] = {
		name = game:DefineFastString("DiscoverabilityModalContinueCounter", "DiscoverabilityModalContinue")
	},
	[EventNames.DiscoverabilityModalClose] = {
		name = game:DefineFastString("DiscoverabilityModalCloseCounter", "DiscoverabilityModalClose")
	},
	[EventNames.DiscoverabilityModalRadioButtonClick] = {
		name = game:DefineFastString(
			"DiscoverabilityModalRadioButtonClickCounter",
			"DiscoverabilityModalRadioButtonClick"
		)
	}
}
