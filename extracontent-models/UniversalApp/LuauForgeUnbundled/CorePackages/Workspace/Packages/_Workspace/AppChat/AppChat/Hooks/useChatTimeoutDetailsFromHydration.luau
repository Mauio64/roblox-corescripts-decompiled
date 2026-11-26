local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration")
local LuauPolyfill = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LuauPolyfill")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
local createCurrentTimeSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsUtils").createCurrentTimeSignal
local clearTimeout = LuauPolyfill.clearTimeout
local setTimeout = LuauPolyfill.setTimeout

require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local GetChatModerationStatusDataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetChatModerationStatusDataHydration")
local getEffectiveChatTimeoutDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getEffectiveChatTimeoutDetails")
local toTimeoutEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/toTimeoutEntry")

local fFlagAppChatReactiveFeatureRestrictions = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatReactiveFeatureRestrictions

local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("useChatTimeoutDetailsFromHydration")

local function areChatTimeoutDetailsEqual(data, data2): boolean
	return data.isTimedOut == data2.isTimedOut
		and data.timeoutEndTimestamp == data2.timeoutEndTimestamp
		and data.decisionEventId == data2.decisionEventId
		and data.duration == data2.duration
		and (not fFlagAppChatReactiveFeatureRestrictions or data.requiresAcknowledgement == data2.requiresAcknowledgement)
end

local function useChatTimeoutDetailsFromHydration(p2)
	local v6 = React.useMemo(function()
		if fFlagAppChatReactiveFeatureRestrictions then
			return function()
				return DateTime.now().UnixTimestamp
			end
		end

		return createCurrentTimeSignal(1)
	end, {})

	local v7 = GetChatModerationStatusDataHydration(false)

	local v8 = false
	local v9

	if fFlagAppChatReactiveFeatureRestrictions then
		v9, v8 = v7.getCachedUserStatus()
	else
		v9 = v7.getUserStatus()
	end

	local conversationId = p2.conversationId

	local v10 = false
	local v11

	if conversationId then
		if fFlagAppChatReactiveFeatureRestrictions then
			v11, v10 = v7.getCachedConversationStatus(conversationId)
		else
			v11 = v7.getConversationStatus(conversationId)
		end
	else
		v11 = v9
	end

	React.useEffect(function()
		if fFlagAppChatReactiveFeatureRestrictions and (v8 or v10) then
			v7.refreshStatuses(conversationId and { conversationId } or nil):catch(function()
				v5:warning("Failed to fetch Party Chat moderation status")
			end)
		end
	end, { conversationId, v10, v7, v8 })

	local v12 = React.useMemo(function()
		return Signals.createComputed(function(p3)
			local data = v9.data(p3)
			local status = v9.status(p3)
			local data2 = v11.data(p3)
			local status2 = v11.status(p3)

			local v14 = if status ~= DataHydration.DataStatus.Failed then toTimeoutEntry(data) else nil
			local v15 = if conversationId and status2 ~= DataHydration.DataStatus.Failed then toTimeoutEntry(data2) else nil
			return getEffectiveChatTimeoutDetails(v14, v15, p2.conversationModerationType, v6(p3))
		end, areChatTimeoutDetailsEqual)
	end, {
		conversationId,
		v11.data,
		v11.status,
		v6,
		p2.conversationModerationType,
		v9.data,
		v9.status
	})

	if fFlagAppChatReactiveFeatureRestrictions then
		React.useEffect(function()
			local v13 = nil

			local effect = Signals.createEffect(function(p3)
				local v14 = v13

				if v14 then
					clearTimeout(v14)
					v13 = nil
				end

				local v15 = v12(p3)
				local unixTimestamp = DateTime.now().UnixTimestamp

				if v15.isTimedOut and unixTimestamp < v15.timeoutEndTimestamp then
					v13 = setTimeout(function()
						v13 = nil
						v7.refreshStatuses(conversationId and { conversationId } or nil):catch(function()
							v5:warning("Failed to refresh expired Party Chat restriction")
						end)
					end, (v15.timeoutEndTimestamp - unixTimestamp + 1) * 1000)
				end
			end)

			return function()
				local v14 = v13

				if v14 then
					clearTimeout(v14)
				end

				effect()
			end
		end, { conversationId, v12, v7 })
	end

	return v12
end

return useChatTimeoutDetailsFromHydration
