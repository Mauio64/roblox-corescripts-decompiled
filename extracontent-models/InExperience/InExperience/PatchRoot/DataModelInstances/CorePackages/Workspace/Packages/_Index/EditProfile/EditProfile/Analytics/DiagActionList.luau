local EventNames = require(script.Parent.Enums.EventNames)

return {
	[EventNames.UsernameSaved] = {
		name = game:DefineFastString("UsernameSaved", "UsernameSaved")
	}
}
