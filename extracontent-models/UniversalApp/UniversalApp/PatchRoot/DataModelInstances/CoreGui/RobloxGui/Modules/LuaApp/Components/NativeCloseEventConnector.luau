local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local NotificationTypeList = GuiService:GetNotificationTypeList()

local function NativeCloseEventConnector(p1) -- line: 7
	-- upvalues: useDispatch (copy), React (copy), GuiService (copy), NotificationTypeList (copy)
	local v8 = useDispatch()
	local v9 = React.useCallback(function() -- line: 10
		-- upvalues: v8 (copy), p1 (copy), GuiService (copy), NotificationTypeList (copy)
		if not v8(p1.onNativeCloseEvent()) then
			GuiService:BroadcastNotification("", NotificationTypeList.NATIVE_EXIT)
		end
	end, {
		v8,
		p1.onNativeCloseEvent
	})

	React.useEffect(function() -- line: 18
		-- upvalues: GuiService (copy), v9 (copy)
		local connection = GuiService.NativeClose:Connect(v9)

		return function() -- line: 21
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { p1.onNativeCloseEvent })
end

return NativeCloseEventConnector
