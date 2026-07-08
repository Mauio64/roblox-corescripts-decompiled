local EventNames = require(script.Parent.Enums.EventNames)

return {
	[EventNames.EditProfileBackgroundOpened] = {
		name = game:DefineFastString("EditProfileBackgroundOpened", "EditProfileBackgroundOpened")
	},
	[EventNames.EditProfileBackgroundLoadingStage] = {
		name = game:DefineFastString("EditProfileBackgroundLoadingStage", "EditProfileBackgroundLoadingStage")
	},
	[EventNames.BackgroundSelected] = {
		name = game:DefineFastString("BackgroundSelected", "BackgroundSelected")
	},
	[EventNames.EditProfileBackgroundFailure] = {
		name = game:DefineFastString("EditProfileBackgroundFailure", "EditProfileBackgroundFailure")
	}
}
