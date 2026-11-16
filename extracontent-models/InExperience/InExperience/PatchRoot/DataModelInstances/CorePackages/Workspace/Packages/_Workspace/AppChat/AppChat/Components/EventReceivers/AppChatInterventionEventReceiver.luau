local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local React = require(parent.React)
local RealtimeDelivery = require(parent.RealtimeDelivery)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local AppChatNetworking = require(parent.AppChatNetworking)
local ChatModerationStatusRefreshCoordinator = require(AppChat.Stores.ChatModerationStatusRefreshCoordinator)
local getContainsChatSetting = require(AppChat.Utils.getContainsChatSetting)
local InterventionShared = require(parent.InterventionShared)
local partyChatTimeoutReceivedSignal = InterventionShared.Signals.partyChatTimeoutReceivedSignal

local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatReactiveFeatureRestrictions = SharedFlags.FFlagAppChatReactiveFeatureRestrictions

local function AppChatInterventionEventReceiver(_): nil
	local v2 = useDispatch()
	local v3

	if FFlagAppChatReactiveFeatureRestrictions then
		v3 = React.useMemo(function()
			return ChatModerationStatusRefreshCoordinator.createOwner()
		end, { v2 })
	else
		v3 = nil
	end

	local useRealtimeNamespace = RealtimeDelivery.useRealtimeNamespace

	local function fn(p)
		if p.SettingsChanged and getContainsChatSetting(p.SettingsChanged) then
			if FFlagAppChatReactiveFeatureRestrictions then
				ChatModerationStatusRefreshCoordinator.enqueue(v3, function()
					return v2(AppChatNetworking.rodux.GetChatModerationStatuses.API())
				end).promise:catch(function(p2)
					v:warning("NetworkingChat failure in UserSettingsChanged->GetChatModerationStatuses, Status: " .. tostring(p2))
				end)
			else
				v2(AppChatNetworking.rodux.GetChatModerationStatuses.API()):catch(function(p2)
					v:warning("NetworkingChat failure in UserSettingsChanged->GetChatModerationStatuses, Status: " .. tostring(p2))
				end)
			end
		end
	end

	local v4

	if FFlagAppChatReactiveFeatureRestrictions then
		v4 = v3
	else
		v4 = v2
	end

	useRealtimeNamespace("UserSettingsChanged", fn, { v4, v2 })

	local useEffect = React.useEffect
	local function fn2()
		local connection = partyChatTimeoutReceivedSignal:connect(function(p)
			if FFlagAppChatReactiveFeatureRestrictions then
				ChatModerationStatusRefreshCoordinator.enqueue(v3, function()
					return v2(AppChatNetworking.rodux.GetChatModerationStatuses.API(p and { p } or {}))
				end).promise:catch(function(p2)
					v:warning("NetworkingChat failure in partyChatTimeoutReceivedSignal->GetChatModerationStatuses, Status: " .. tostring(p2))
				end)
			else
				v2(AppChatNetworking.rodux.GetChatModerationStatuses.API(p and { p } or {})):catch(function(p2)
					v:warning("NetworkingChat failure in partyChatTimeoutReceivedSignal->GetChatModerationStatuses, Status: " .. tostring(p2))
				end)
			end
		end)

		return function()
			if connection then
				connection:disconnect()
			end

			if FFlagAppChatReactiveFeatureRestrictions then
				ChatModerationStatusRefreshCoordinator.cancelOwner(v3)
			end
		end
	end

	local v5

	if FFlagAppChatReactiveFeatureRestrictions then
		v5 = v3
	else
		v5 = v2
	end

	useEffect(fn2, { v5, v2 })

	return nil
end

return AppChatInterventionEventReceiver
