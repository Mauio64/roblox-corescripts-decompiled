local AbuseVector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UniversalFeatureRestrictions/AbuseVector")
local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local partyChatTimeoutReceivedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/InterventionShared").Signals.partyChatTimeoutReceivedSignal
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local showFeatureRestriction = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UniversalFeatureRestrictions/showFeatureRestriction")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch

local ChatModerationStatusRefreshCoordinator = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/ChatModerationStatusRefreshCoordinator")
local getResponseBody = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/Ingestion/getResponseBody")
local serializeChatTimeoutRange = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/serializeChatTimeoutRange")

local fFlagAppChatReactiveFeatureRestrictions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatReactiveFeatureRestrictions

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("usePartyChatReactiveFeatureRestriction")

local function usePartyChatReactiveFeatureRestriction(p2)
	local v6 = useDispatch()

	React.useEffect(function()
		if not (fFlagAppChatReactiveFeatureRestrictions and p2) then
			return nil
		end

		local v7 = false

		local owner = ChatModerationStatusRefreshCoordinator.createOwner()
		local v8 = ChatModerationStatusRefreshCoordinator.enqueue(owner, function()
			return v6(AppChatNetworking.rodux.GetChatModerationStatuses.API())
		end)

		v8.promise:andThen(function(p3)
			local v9 = getResponseBody(p3)
			local user_timeout_range = if v9 then v9.user_timeout_range else nil
			local v10 = if user_timeout_range then serializeChatTimeoutRange(user_timeout_range) else nil

			if
				not v7
				and ChatModerationStatusRefreshCoordinator.isLatestGeneration(v8.generation)
				and v10 ~= nil
				and v10.requiresAcknowledgement == true
			then
				showFeatureRestriction(AbuseVector.PartyChat, {
					onAcknowledgementSuccess = function()
						partyChatTimeoutReceivedSignal:fire(nil)
					end
				})
			end
		end):catch(function()
			v5:warning("Failed to refresh Party Chat moderation status on entry")
		end)

		return function()
			v7 = true
			ChatModerationStatusRefreshCoordinator.cancelOwner(owner)
		end
	end, { v6, p2 })
end

return usePartyChatReactiveFeatureRestriction
