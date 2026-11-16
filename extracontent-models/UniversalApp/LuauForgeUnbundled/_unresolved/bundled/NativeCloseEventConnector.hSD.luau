local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local notificationTypeList = GuiService:GetNotificationTypeList()

local function NativeCloseEventConnector(p2)
	local v5 = useDispatch()

	local v6 = React.useCallback(function()
		if not v5(p2.onNativeCloseEvent()) then
			GuiService:BroadcastNotification("", notificationTypeList.NATIVE_EXIT)
		end
	end, { v5, p2.onNativeCloseEvent })

	React.useEffect(function()
		local nativeCloseConnection = GuiService.NativeClose:Connect(v6)

		return function()
			nativeCloseConnection:Disconnect()
		end
	end, { p2.onNativeCloseEvent })
end

return NativeCloseEventConnector
