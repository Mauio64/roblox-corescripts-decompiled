local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local RealtimeDelivery = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RealtimeDelivery")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch

local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local ChatModerationStatusRefreshCoordinator = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/ChatModerationStatusRefreshCoordinator")
local getContainsChatSetting = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getContainsChatSetting")
local partyChatTimeoutReceivedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/InterventionShared").Signals.partyChatTimeoutReceivedSignal

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("AppChatInterventionEventReceiver")

local fFlagAppChatReactiveFeatureRestrictions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatReactiveFeatureRestrictions

local function AppChatInterventionEventReceiver(p2): nil
	local v6 = useDispatch()
	local v7

	if fFlagAppChatReactiveFeatureRestrictions then
		v7 = React.useMemo(function()
			return ChatModerationStatusRefreshCoordinator.createOwner()
		end, { v6 })
	else
		v7 = nil
	end

	local function fn(p3)
		if p3.SettingsChanged and getContainsChatSetting(p3.SettingsChanged) then
			if fFlagAppChatReactiveFeatureRestrictions then
				ChatModerationStatusRefreshCoordinator.enqueue(v7, function()
					return v6(AppChatNetworking.rodux.GetChatModerationStatuses.API())
				end).promise:catch(function(p4)
					v5:warning("NetworkingChat failure in UserSettingsChanged->GetChatModerationStatuses, Status: " .. tostring(p4))
				end)
			else
				v6(AppChatNetworking.rodux.GetChatModerationStatuses.API()):catch(function(p4)
					v5:warning("NetworkingChat failure in UserSettingsChanged->GetChatModerationStatuses, Status: " .. tostring(p4))
				end)
			end
		end
	end

	RealtimeDelivery.useRealtimeNamespace("UserSettingsChanged", fn, {
		if fFlagAppChatReactiveFeatureRestrictions then v7 else v6,
		v6
	})

	local function fn2()
		local connection = partyChatTimeoutReceivedSignal:connect(function(p3)
			if fFlagAppChatReactiveFeatureRestrictions then
				ChatModerationStatusRefreshCoordinator.enqueue(v7, function()
					return v6(AppChatNetworking.rodux.GetChatModerationStatuses.API(p3 and { p3 } or {}))
				end).promise:catch(function(p4)
					v5:warning("NetworkingChat failure in partyChatTimeoutReceivedSignal->GetChatModerationStatuses, Status: " .. tostring(p4))
				end)
			else
				v6(AppChatNetworking.rodux.GetChatModerationStatuses.API(p3 and { p3 } or {})):catch(function(p4)
					v5:warning("NetworkingChat failure in partyChatTimeoutReceivedSignal->GetChatModerationStatuses, Status: " .. tostring(p4))
				end)
			end
		end)

		return function()
			if connection then
				connection:disconnect()
			end

			if fFlagAppChatReactiveFeatureRestrictions then
				ChatModerationStatusRefreshCoordinator.cancelOwner(v7)
			end
		end
	end

	React.useEffect(fn2, { if fFlagAppChatReactiveFeatureRestrictions then v7 else v6, v6 })

	return nil
end

return AppChatInterventionEventReceiver
