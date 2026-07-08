local EventNames = require(script.Parent.Enums.EventNames)

return {
	[EventNames.CustomizeNameModalOpened] = {
		name = game:DefineFastString("CustomizeNameModalOpened", "CustomizeNameModalOpened")
	},
	[EventNames.CustomizeNameClearedInput] = {
		name = game:DefineFastString("CustomizeNameClearedInput", "CustomizeNameClearedInput")
	},
	[EventNames.CustomizeNameMaximumCharLimitTyped] = {
		name = game:DefineFastString("CustomizeNameMaximumCharLimitTyped", "CustomizeNameMaximumCharLimitTyped")
	},
	[EventNames.CustomizeNameModalClosed] = {
		name = game:DefineFastString("CustomizeNameModalClosed", "CustomizeNameModalClosed")
	},
	[EventNames.CustomizeNameSaved] = {
		name = game:DefineFastString("CustomizeNameSaved", "CustomizeNameSaved")
	},
	[EventNames.CustomizeNameSaveAttemptInvalidInput] = {
		name = game:DefineFastString("CustomizeNameSaveAttemptInvalidInput", "CustomizeNameSaveAttemptInvalidInput")
	}
}
