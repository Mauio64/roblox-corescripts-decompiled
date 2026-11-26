local MessageBusService = game:GetService("MessageBusService")
local messageId = MessageBusService:GetMessageId("SystemTheme", "systemThemeSetThemeOverride")

local module = require("@luauforge/bundled/fGT")

return function()
	if module() then
		MessageBusService:Publish(messageId, { ThemeOverride = "dark" })
	end
end
