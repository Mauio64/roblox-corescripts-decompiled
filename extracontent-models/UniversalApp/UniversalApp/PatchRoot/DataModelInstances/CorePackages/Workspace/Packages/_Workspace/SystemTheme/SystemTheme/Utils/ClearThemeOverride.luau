local MessageBusService = game:GetService("MessageBusService")
local MessageId = MessageBusService:GetMessageId("SystemTheme", "systemThemeSetThemeOverride")
local SystemTheme = script:FindFirstAncestor("SystemTheme")
local GetSystemThemeEnabled = require(SystemTheme.Utils.GetSystemThemeEnabled)

return function() -- line: 9
	-- upvalues: GetSystemThemeEnabled (copy), MessageBusService (copy), MessageId (copy)
	if GetSystemThemeEnabled() then
		MessageBusService:Publish(MessageId, {
			ThemeOverride = nil
		})
	end
end
