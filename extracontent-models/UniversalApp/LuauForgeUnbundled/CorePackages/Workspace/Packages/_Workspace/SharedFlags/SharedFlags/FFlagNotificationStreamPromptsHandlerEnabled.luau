local FFlagPromptsHandlerEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPromptsHandlerEnabled")

return game:DefineFastFlag("NotificationStreamPromptsHandlerEnabled", false) and FFlagPromptsHandlerEnabled
