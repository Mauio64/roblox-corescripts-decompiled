local parent = script.Parent.Parent
local OpenNativeClosePrompt = require(parent.Actions.OpenNativeClosePrompt)

return function(object, object2, p)
	local function getDisplayCount() -- 1 equivalent call inferred from this helper
		return tonumber(object2:GetItem("NativeCloseLuaPromptDisplayCount")) or 0
	end

	local function setDisplayCount(p2) -- 1 equivalent call inferred from this helper
		object2:SetItem("NativeCloseLuaPromptDisplayCount", (tostring(p2)))
		object2:flush()
	end

	local notificationTypeList = object:GetNotificationTypeList()

	return function(object3)
		local closingApp = object3:getState().nativeClosePrompt.closingApp
		local displayCount = getDisplayCount() -- inferred equivalent call

		if closingApp or p <= displayCount then
			object:BroadcastNotification("", notificationTypeList.NATIVE_EXIT)
			return
		end

		object3:dispatch(OpenNativeClosePrompt())
		setDisplayCount(displayCount + 1) -- inferred equivalent call
	end
end
