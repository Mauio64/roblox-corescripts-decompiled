local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local AppChatNetworking = require(parent.AppChatNetworking)
require(AppChat.installReducer.ChatTimeouts)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local RoactUtils2 = require(parent.RoactUtils)
local useDispatch = RoactUtils2.Hooks.RoactRodux.useDispatch
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
local LuauPolyfill = require(parent.LuauPolyfill)
local clearTimeout = LuauPolyfill.clearTimeout
local setTimeout = LuauPolyfill.setTimeout
require(AppChat.Models.ConversationChannels)
local CurrentConversationTimeoutEnded = require(AppChat.Conversations.Actions.CurrentConversationTimeoutEnded)
local getEffectiveChatTimeoutDetails = require(AppChat.Utils.getEffectiveChatTimeoutDetails)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatReactiveFeatureRestrictions = SharedFlags.FFlagAppChatReactiveFeatureRestrictions

local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

local function useChatTimeoutDetails(p)
	local conversationId = p.conversationId
	local v2 = useDispatch()
	local v3 = useSelector(function(p2)
		return {
			userTimeout = getDeepValue2(p2, "ChatAppReducer.ChatTimeouts.userTimeout"),
			conversationTimeout = getDeepValue2(p2, `ChatAppReducer.ChatTimeouts.byConversationId.{conversationId}`)
		}
	end)

	local effectiveChatTimeoutDetails = getEffectiveChatTimeoutDetails(
		v3.userTimeout,
		v3.conversationTimeout,
		p.conversationModerationType,
		DateTime.now().UnixTimestamp
	)

	React.useEffect(function()
		local v4 = nil

		if effectiveChatTimeoutDetails.isTimedOut then
			local unixTimestamp = DateTime.now().UnixTimestamp

			if
				not FFlagAppChatReactiveFeatureRestrictions
				or unixTimestamp < effectiveChatTimeoutDetails.timeoutEndTimestamp
			then
				v4 = setTimeout(function()
					if FFlagAppChatReactiveFeatureRestrictions then
						v2(AppChatNetworking.rodux.GetChatModerationStatuses.API(conversationId and { conversationId } or nil)):catch(function()
							v:warning("Failed to refresh expired Party Chat restriction")
						end)
					else
						v2(CurrentConversationTimeoutEnded(conversationId))
					end
				end, (effectiveChatTimeoutDetails.timeoutEndTimestamp - unixTimestamp + 1) * 1000)
			end
		end

		return function()
			if v4 then
				clearTimeout(v4)
			end
		end
	end, {
		effectiveChatTimeoutDetails.isTimedOut,
		effectiveChatTimeoutDetails.timeoutEndTimestamp,
		conversationId,
		v2
	})

	return effectiveChatTimeoutDetails
end

return useChatTimeoutDetails
