local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Signals = require(AppChatParent.Signals)
local SignalsReact = require(AppChatParent.SignalsReact)
local createCurrentTimeSignal = require(AppChatParent.SignalsUtils).createCurrentTimeSignal
local GetChatModerationStatusDataHydration = require(AppChat.Stores.GetChatModerationStatusDataHydration)

require(AppChat.Stores.GetConversationStore)

local getConversationSendEligibilityStatus = require(AppChat.Utils.getConversationSendEligibilityStatus)

local function areResultsEqual(t1: {[any]: any}, t2: {[any]: any}) -- line: 29
	if t1.isLoading ~= t2.isLoading or #t1.eligibleConversations ~= #t2.eligibleConversations then
		return false
	end

	for v13, v14 in t1.eligibleConversations do
		if v14 ~= t2.eligibleConversations[v13] then
			return false
		end
	end

	return true
end
local function useExternalChatConversationEligibility(t3: {[any]: any}) -- line: 43
	-- upvalues: GetChatModerationStatusDataHydration (copy), React (copy), createCurrentTimeSignal (copy), Signals (copy), getConversationSendEligibilityStatus (copy), areResultsEqual (copy), SignalsReact (copy)
	local v16 = GetChatModerationStatusDataHydration()
	local v17 = React.useMemo(function() -- line: 45
		-- upvalues: createCurrentTimeSignal (copy)
		return createCurrentTimeSignal(1)
	end, {})
	local v18 = React.useMemo(function() -- line: 50
		-- upvalues: Signals (copy), t3 (copy), v17 (copy), getConversationSendEligibilityStatus (copy), v16 (copy), areResultsEqual (copy)
		return Signals.createComputed(function(p1) -- line: 51
			-- upvalues: t3 (copy), v17 (copy), getConversationSendEligibilityStatus (copy), v16 (copy)
			local t4 = {}

			if not t3.isActive then
				return {
					isLoading = true,
					eligibleConversations = t4
				}
			end

			local v21 = v17(p1)

			for _, v23 in t3.conversations do
				local v24 = getConversationSendEligibilityStatus({
					allowConversationStatusLoading = false,
					isAvailable = true,
					conversation = v23,
					currentTimestamp = v21,
					isGroupChatEnabled = t3.isGroupChatEnabled,
					scope = p1,
					timeoutStore = v16
				})

				if v24 == "loading" then
					return {
						isLoading = true,
						eligibleConversations = {}
					}
				end

				if v24 == "eligible" then
					table.insert(t4, v23)

					if #t4 >= t3.maxConversationCount then
						return {
							isLoading = false,
							eligibleConversations = t4
						}
					end
				end
			end

			return {
				isLoading = false,
				eligibleConversations = t4
			}
		end, areResultsEqual)
	end, {
		v17,
		t3.conversations,
		t3.isActive,
		t3.isGroupChatEnabled,
		t3.maxConversationCount,
		v16
	})

	return SignalsReact.useSignalState(v18)
end

return useExternalChatConversationEligibility
