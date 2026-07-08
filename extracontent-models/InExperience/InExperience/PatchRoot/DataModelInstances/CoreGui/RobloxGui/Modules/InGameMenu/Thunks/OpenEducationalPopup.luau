local ParentParent = script.Parent.Parent
local OpenNativeClosePrompt = require(ParentParent.Actions.OpenNativeClosePrompt)

return function(p1, p2, p3) -- line: 6
	-- upvalues: OpenNativeClosePrompt (copy)
	local function getDisplayCount() -- line: 7
		-- upvalues: p2 (copy)
		return tonumber(p2:GetItem("NativeCloseLuaPromptDisplayCount")) or 0
	end
	local function setDisplayCount(p4) -- line: 11
		-- upvalues: p2 (copy)
		p2:SetItem("NativeCloseLuaPromptDisplayCount", (tostring(p4)))
		p2:flush()
	end

	local NotificationTypeList = p1:GetNotificationTypeList()

	return function(p5) -- line: 18
		-- upvalues: p2 (copy), p3 (copy), p1 (copy), NotificationTypeList (copy), OpenNativeClosePrompt (copy)
		local closingApp = p5:getState().nativeClosePrompt.closingApp
		local v12 = tonumber(p2:GetItem("NativeCloseLuaPromptDisplayCount")) or 0

		if closingApp or v12 >= p3 then
			p1:BroadcastNotification("", NotificationTypeList.NATIVE_EXIT)

			return
		end

		p5:dispatch(OpenNativeClosePrompt())

		local v13 = v12 + 1

		p2:SetItem("NativeCloseLuaPromptDisplayCount", (tostring(v13)))
		p2:flush()
	end
end
