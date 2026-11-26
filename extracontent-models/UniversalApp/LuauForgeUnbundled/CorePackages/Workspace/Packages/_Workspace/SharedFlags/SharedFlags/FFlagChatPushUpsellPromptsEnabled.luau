local FFlagPromptsHandlerEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/FFlagPromptsHandlerEnabled")

return game:DefineFastFlag("ChatPushUpsellPromptsEnabled", false) and FFlagPromptsHandlerEnabled
