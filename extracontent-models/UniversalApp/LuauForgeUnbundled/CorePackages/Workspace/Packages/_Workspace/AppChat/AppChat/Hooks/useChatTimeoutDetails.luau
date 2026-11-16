local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/installReducer/ChatTimeouts")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local getDeepValue2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue2")
local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LuauPolyfill")
local clearTimeout = LuauPolyfill.clearTimeout
local setTimeout = LuauPolyfill.setTimeout
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local CurrentConversationTimeoutEnded = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/CurrentConversationTimeoutEnded")
local getEffectiveChatTimeoutDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getEffectiveChatTimeoutDetails")

local fFlagAppChatReactiveFeatureRestrictions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatReactiveFeatureRestrictions

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("useChatTimeoutDetails")

local function useChatTimeoutDetails(p2)
	local conversationId = p2.conversationId
	local v6 = useDispatch()
	local v7 = useSelector(function(p3)
		return {
			userTimeout = getDeepValue2(p3, "ChatAppReducer.ChatTimeouts.userTimeout"),
			conversationTimeout = getDeepValue2(
				p3,
				`ChatAppReducer.ChatTimeouts.byConversationId.{conversationId}`
			)
		}
	end)

	local v8 = getEffectiveChatTimeoutDetails(
		v7.userTimeout,
		v7.conversationTimeout,
		p2.conversationModerationType,
		DateTime.now().UnixTimestamp
	)

	React.useEffect(function()
		local v9 = nil

		if v8.isTimedOut then
			local unixTimestamp = DateTime.now().UnixTimestamp

			if not fFlagAppChatReactiveFeatureRestrictions or unixTimestamp < v8.timeoutEndTimestamp then
				v9 = setTimeout(function()
					if fFlagAppChatReactiveFeatureRestrictions then
						v6(AppChatNetworking.rodux.GetChatModerationStatuses.API(conversationId and { conversationId } or nil)):catch(function()
							v5:warning("Failed to refresh expired Party Chat restriction")
						end)
					else
						v6(CurrentConversationTimeoutEnded(conversationId))
					end
				end, (v8.timeoutEndTimestamp - unixTimestamp + 1) * 1000)
			end
		end

		return function()
			if v9 then
				clearTimeout(v9)
			end
		end
	end, { v8.isTimedOut, v8.timeoutEndTimestamp, conversationId, v6 })

	return v8
end

return useChatTimeoutDetails
