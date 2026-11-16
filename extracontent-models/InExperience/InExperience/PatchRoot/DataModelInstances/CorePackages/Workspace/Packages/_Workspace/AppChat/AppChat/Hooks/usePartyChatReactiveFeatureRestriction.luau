local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AbuseVector = require(parent.UniversalFeatureRestrictions.AbuseVector)
local AppChatNetworking = require(parent.AppChatNetworking)
local InterventionShared = require(parent.InterventionShared)
local partyChatTimeoutReceivedSignal = InterventionShared.Signals.partyChatTimeoutReceivedSignal
local React = require(parent.React)
local showFeatureRestriction = require(parent.UniversalFeatureRestrictions.showFeatureRestriction)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch

local ChatModerationStatusRefreshCoordinator = require(AppChat.Stores.ChatModerationStatusRefreshCoordinator)
local getResponseBody = require(AppChat.Stores.Ingestion.getResponseBody)
local serializeChatTimeoutRange = require(AppChat.Utils.serializeChatTimeoutRange)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatReactiveFeatureRestrictions = SharedFlags.FFlagAppChatReactiveFeatureRestrictions

local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

local function usePartyChatReactiveFeatureRestriction(flag: boolean)
	local v2 = useDispatch()

	React.useEffect(function()
		if not (FFlagAppChatReactiveFeatureRestrictions and flag) then
			return nil
		end

		local v3 = false

		local owner = ChatModerationStatusRefreshCoordinator.createOwner()
		local v4 = ChatModerationStatusRefreshCoordinator.enqueue(owner, function()
			return v2(AppChatNetworking.rodux.GetChatModerationStatuses.API())
		end)

		v4.promise:andThen(function(p)
			local responseBody = getResponseBody(p)
			local user_timeout_range

			if responseBody then
				user_timeout_range = responseBody.user_timeout_range
			end

			local v5

			if user_timeout_range then
				v5 = serializeChatTimeoutRange(user_timeout_range)
			end

			if
				not v3
				and ChatModerationStatusRefreshCoordinator.isLatestGeneration(v4.generation)
				and v5 ~= nil
				and v5.requiresAcknowledgement == true
			then
				showFeatureRestriction(AbuseVector.PartyChat, {
					onAcknowledgementSuccess = function()
						partyChatTimeoutReceivedSignal:fire(nil)
					end
				})
			end
		end):catch(function()
			v:warning("Failed to refresh Party Chat moderation status on entry")
		end)

		return function()
			v3 = true
			ChatModerationStatusRefreshCoordinator.cancelOwner(owner)
		end
	end, { v2, flag })
end

return usePartyChatReactiveFeatureRestriction
