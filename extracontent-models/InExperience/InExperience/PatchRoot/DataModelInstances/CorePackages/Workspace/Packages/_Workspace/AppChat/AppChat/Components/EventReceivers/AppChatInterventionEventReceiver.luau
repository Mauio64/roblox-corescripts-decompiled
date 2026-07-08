local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local RealtimeDelivery = require(AppChatParent.RealtimeDelivery)
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local partyChatTimeoutReceivedSignal = require(AppChatParent.InterventionShared).Signals.partyChatTimeoutReceivedSignal
local getContainsChatSetting = require(AppChat.Utils.getContainsChatSetting)
local v9 = require(AppChat.Logger):new(script.Name)

local function AppChatInterventionEventReceiver(_: {[any]: any}) -- line: 15
	-- upvalues: useDispatch (copy), RealtimeDelivery (copy), getContainsChatSetting (copy), AppChatNetworking (copy), v9 (copy), React (copy), partyChatTimeoutReceivedSignal (copy)
	local v12 = useDispatch()

	RealtimeDelivery.useRealtimeNamespace("UserSettingsChanged", function(p1) -- line: 17
		-- upvalues: getContainsChatSetting (copy), v12 (copy), AppChatNetworking (copy), v9 (copy)
		if p1.SettingsChanged and getContainsChatSetting(p1.SettingsChanged) then
			v12(AppChatNetworking.rodux.GetChatModerationStatuses.API()):catch(function(p2) -- line: 20
				-- upvalues: v9 (copy)
				v9:warning("NetworkingChat failure in UserSettingsChanged->GetChatModerationStatuses, Status: " .. tostring(p2))
			end)
		end
	end, { v12 })
	React.useEffect(function() -- line: 29
		-- upvalues: partyChatTimeoutReceivedSignal (copy), v12 (copy), AppChatNetworking (copy), v9 (copy)
		local v14 = partyChatTimeoutReceivedSignal:connect(function(p3) -- line: 30
			-- upvalues: v12 (copy), AppChatNetworking (copy), v9 (copy)
			v12(AppChatNetworking.rodux.GetChatModerationStatuses.API((if not p3 then {} else { p3 }))):catch(function(p4) -- line: 33
				-- upvalues: v9 (copy)
				v9:warning("NetworkingChat failure in partyChatTimeoutReceivedSignal->GetChatModerationStatuses, Status: " .. tostring(p4))
			end)
		end)

		return function() -- line: 40
			-- upvalues: v14 (copy)
			if v14 then
				v14:disconnect()
			end
		end
	end, { v12 })

	return nil
end

return AppChatInterventionEventReceiver
