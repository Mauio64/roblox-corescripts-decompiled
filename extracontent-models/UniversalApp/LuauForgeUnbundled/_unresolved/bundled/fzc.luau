local MessageBusService = game:GetService("MessageBusService")
local messageId = MessageBusService:GetMessageId("SystemTheme", "systemThemeSetThemeOverride")

local module = require("@luauforge/bundled/fzd")

return function()
	if module() then
		MessageBusService:Publish(messageId, { ThemeOverride = nil })
	end
end
