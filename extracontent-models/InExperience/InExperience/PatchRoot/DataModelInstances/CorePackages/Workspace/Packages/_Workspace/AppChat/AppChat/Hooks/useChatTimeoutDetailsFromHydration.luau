local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local DataHydration = require(parent.DataHydration)
local LuauPolyfill = require(parent.LuauPolyfill)
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local createCurrentTimeSignal = SignalsUtils.createCurrentTimeSignal
local clearTimeout = LuauPolyfill.clearTimeout
local setTimeout = LuauPolyfill.setTimeout

require(AppChat.Models.ConversationChannels)
local GetChatModerationStatusDataHydration = require(AppChat.Stores.GetChatModerationStatusDataHydration)
local getEffectiveChatTimeoutDetails = require(AppChat.Utils.getEffectiveChatTimeoutDetails)
local toTimeoutEntry = require(AppChat.Utils.toTimeoutEntry)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatReactiveFeatureRestrictions = SharedFlags.FFlagAppChatReactiveFeatureRestrictions

local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)

local function areChatTimeoutDetailsEqual(data, data2): boolean
	return data.isTimedOut == data2.isTimedOut
		and data.timeoutEndTimestamp == data2.timeoutEndTimestamp
		and data.decisionEventId == data2.decisionEventId
		and data.duration == data2.duration
		and (not FFlagAppChatReactiveFeatureRestrictions or data.requiresAcknowledgement == data2.requiresAcknowledgement)
end

local function useChatTimeoutDetailsFromHydration(p)
	local v2 = React.useMemo(function()
		if FFlagAppChatReactiveFeatureRestrictions then
			return function()
				return DateTime.now().UnixTimestamp
			end
		end

		return createCurrentTimeSignal(1)
	end, {})

	local chatModerationStatusDataHydration = GetChatModerationStatusDataHydration(false)

	local v3 = false
	local v4

	if FFlagAppChatReactiveFeatureRestrictions then
		v4, v3 = chatModerationStatusDataHydration.getCachedUserStatus()
	else
		v4 = chatModerationStatusDataHydration.getUserStatus()
	end

	local conversationId = p.conversationId

	local v5 = false
	local v6

	if conversationId then
		if FFlagAppChatReactiveFeatureRestrictions then
			v6, v5 = chatModerationStatusDataHydration.getCachedConversationStatus(conversationId)
		else
			v6 = chatModerationStatusDataHydration.getConversationStatus(conversationId)
		end
	else
		v6 = v4
	end

	React.useEffect(function()
		if FFlagAppChatReactiveFeatureRestrictions and (v3 or v5) then
			chatModerationStatusDataHydration.refreshStatuses(conversationId and { conversationId } or nil):catch(function()
				v:warning("Failed to fetch Party Chat moderation status")
			end)
		end
	end, { conversationId, v5, chatModerationStatusDataHydration, v3 })

	local v7 = React.useMemo(function()
		return Signals.createComputed(function(p2)
			local data = v4.data(p2)
			local status = v4.status(p2)
			local data2 = v6.data(p2)
			local status2 = v6.status(p2)
			local v7

			if status ~= DataHydration.DataStatus.Failed then
				v7 = toTimeoutEntry(data)
			end

			local v8

			if conversationId and status2 ~= DataHydration.DataStatus.Failed then
				v8 = toTimeoutEntry(data2)
			end

			return getEffectiveChatTimeoutDetails(v7, v8, p.conversationModerationType, v2(p2))
		end, areChatTimeoutDetailsEqual)
	end, {
		conversationId,
		v6.data,
		v6.status,
		v2,
		p.conversationModerationType,
		v4.data,
		v4.status
	})

	if FFlagAppChatReactiveFeatureRestrictions then
		React.useEffect(function()
			local v8 = nil

			local effect = Signals.createEffect(function(p2)
				local v9 = v8

				if v9 then
					clearTimeout(v9)
					v8 = nil
				end

				local v10 = v7(p2)
				local unixTimestamp = DateTime.now().UnixTimestamp

				if v10.isTimedOut and unixTimestamp < v10.timeoutEndTimestamp then
					v8 = setTimeout(function()
						v8 = nil
						chatModerationStatusDataHydration.refreshStatuses(conversationId and { conversationId } or nil):catch(function()
							v:warning("Failed to refresh expired Party Chat restriction")
						end)
					end, (v10.timeoutEndTimestamp - unixTimestamp + 1) * 1000)
				end
			end)

			return function()
				local v9 = v8

				if v9 then
					clearTimeout(v9)
				end

				effect()
			end
		end, { conversationId, v7, chatModerationStatusDataHydration })
	end

	return v7
end

return useChatTimeoutDetailsFromHydration
