local Modules = game:GetService("CoreGui").RobloxGui.Modules
local HttpService = game:GetService("HttpService")
local Roact = require(Modules.Common.Roact)
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local NativePageWrapper = require(Modules.LuaApp.Components.NativePageWrapper)

return function(p1) -- line: 8
	-- upvalues: HttpService (copy), Roact (copy), NativePageWrapper (copy), NotificationType (copy)
	local isVisible = p1.isVisible
	local DisplayOrder = p1.DisplayOrder
	local json = HttpService:JSONEncode(p1.data)

	return Roact.createElement(NativePageWrapper, {
		isVisible = isVisible,
		DisplayOrder = DisplayOrder,
		notificationData = json,
		notificationType = NotificationType.NATIVE_SHARE
	})
end
