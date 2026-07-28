local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local Http = require(AppChatParent.Http)

require(AppChatParent.LuauPolyfill)

local Promise = require(AppChatParent.Promise)
local React = require(AppChatParent.React)
local RetrievalStatus = Http.Enum.RetrievalStatus
local StatusCodes = Http.StatusCodes
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local NavigateIntoChat = require(AppChat.Actions.NavigateIntoChat)
local NavigateIntoChat2 = require(AppChat.Conversations.Thunks.NavigateIntoChat)
local ReceivedConversation = require(AppChat.Conversations.Actions.ReceivedConversation)
local SendTextMessage = require(AppChat.Conversations.Thunks.SendTextMessage)
local createConversationFromFriendPlaceholder = require(AppChat.Conversations.createConversationFromFriendPlaceholder)
local EnumScreens = require(AppChat.EnumScreens)
local GetChatModerationStatusDataHydration = require(AppChat.Stores.GetChatModerationStatusDataHydration)

require(AppChat.Stores.GetConversationStore)

local getConversationSendEligibilityStatus = require(AppChat.Utils.getConversationSendEligibilityStatus)
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
local navigateWithOsaGate = require(AppChat.Utils.navigateWithOsaGate)
local useAppPolicy = require(AppChat.Hooks.useAppPolicy)
local useIsChatEnabled = require(AppChat.Hooks.useIsChatEnabled)
local useIsChatUserMessagesEnabled = require(AppChat.Hooks.useIsChatUserMessagesEnabled)
local useIsGroupChatEnabled = require(AppChat.Hooks.useIsGroupChatEnabled)
local isNavigationAvailable = require(AppChatParent.RobloxAppNavigation).isNavigationAvailable
local FFlagAppChatNilGuardReceivedChatResponse = require(AppChat.Flags.FFlagAppChatNilGuardReceivedChatResponse)
local FFlagAppChatRenameGuacPolicyEnabled = require(AppChatParent.SharedFlags).FFlagAppChatRenameGuacPolicyEnabled
local _ = {
	Success = "success",
	Failure = "failure",
	Declined = "declined"
}

local function makeSendResult(s1: string, s2: string?) -- line: 59
	return {
		conversationId = s2,
		status = s1
	}
end
local function isSuccessfulResponse(p1) -- line: 66
	-- upvalues: StatusCodes (copy), AppChatNetworking (copy)
	local v35 = p1 and (p1.responseCode == StatusCodes.OK and (p1.responseBody and (p1.responseBody.messages and p1.responseBody.messages[1])))
	local v36 = v35 and v35.status

	return v35 ~= nil and (v36 == nil or (v36 == "" or v36 == AppChatNetworking.Constants.ResponseStatus.SUCCESS))
end
local function useExternalChatMessageSender(b1: boolean) -- line: 77
	-- upvalues: useDispatch (copy), GetChatModerationStatusDataHydration (copy), useAppPolicy (copy), FFlagAppChatRenameGuacPolicyEnabled (copy), useSelector (copy), getDeepValue2 (copy), useIsChatEnabled (copy), useIsChatUserMessagesEnabled (copy), useIsGroupChatEnabled (copy), RetrievalStatus (copy), FFlagAppChatNilGuardReceivedChatResponse (copy), React (copy), getConversationSendEligibilityStatus (copy), Promise (copy), createConversationFromFriendPlaceholder (copy), ReceivedConversation (copy), SendTextMessage (copy), StatusCodes (copy), AppChatNetworking (copy), navigateWithOsaGate (copy), NavigateIntoChat2 (copy), NavigateIntoChat (copy), EnumScreens (copy), isNavigationAvailable (copy)
	local v38 = useDispatch()
	local v39 = GetChatModerationStatusDataHydration()
	local v40 = useAppPolicy(function(p2) -- line: 80
		return p2.getCanUsePlatformChat()
	end)
	local v41 = useAppPolicy(function(p3) -- line: 83
		-- upvalues: FFlagAppChatRenameGuacPolicyEnabled (copy)
		return not FFlagAppChatRenameGuacPolicyEnabled or p3.getCanSeeChatTerminology()
	end)
	local v42 = useSelector(function(p4) -- line: 86
		-- upvalues: getDeepValue2 (copy)
		return getDeepValue2(p4, "ChatAppReducer.ChatSettings.retrievalStatus")
	end)
	local v43 = useSelector(function(p5) -- line: 89
		return tonumber(p5.LocalUserId) or 0
	end)
	local v44 = useSelector(function(p6) -- line: 92
		return p6.Navigation ~= nil
	end)
	local v45 = useIsChatEnabled()
	local v46 = useIsChatUserMessagesEnabled()
	local v47 = useIsGroupChatEnabled()
	local v48 = v42 ~= RetrievalStatus.Done
	local v49 = not v48 and (v40 and (v41 and (v45 and (v46 and (FFlagAppChatNilGuardReceivedChatResponse or not b1)))))
	local v50 = React.useCallback(function(p7, b2: boolean) -- line: 108
		-- upvalues: getConversationSendEligibilityStatus (copy), v49 (copy), v47 (copy), v39 (copy)
		return getConversationSendEligibilityStatus({
			scope = false,
			allowConversationStatusLoading = b2,
			conversation = p7,
			currentTimestamp = DateTime.now().UnixTimestamp,
			isAvailable = v49,
			isGroupChatEnabled = v47,
			timeoutStore = v39
		})
	end, {
		v49,
		v47,
		v39
	})
	local v51 = React.useCallback(function(p8) -- line: 121
		-- upvalues: v50 (copy)
		return v50(p8, false) == "eligible"
	end, { v50 })
	local v52 = React.useCallback(function(p9, s3: string) -- line: 126
		-- upvalues: v51 (copy), Promise (copy), createConversationFromFriendPlaceholder (copy), v43 (copy), v50 (copy), v38 (copy), ReceivedConversation (copy), SendTextMessage (copy), StatusCodes (copy), AppChatNetworking (copy), navigateWithOsaGate (copy)
		if not v51(p9) then
			return Promise.resolve({
				conversationId = nil,
				status = "failure"
			})
		end

		local v65 = p9.source == "friends"
		local v66

		if v65 then
			v66 = createConversationFromFriendPlaceholder(p9, v43)

			if v66 == nil then
				return Promise.resolve({
					conversationId = nil,
					status = "failure"
				})
			end
		else
			v66 = Promise.resolve(p9)
		end

		return v66:andThen(function(p10) -- line: 143
			-- upvalues: v50 (copy), v65 (copy), v38 (copy), ReceivedConversation (copy), Promise (copy), SendTextMessage (copy), s3 (copy), StatusCodes (copy), AppChatNetworking (copy), navigateWithOsaGate (copy)
			local v69 = p10 and p10.id

			if p10 == nil or (v69 == nil or v69 == "" or p10.source == "friends" or v50(p10, v65) ~= "eligible") then
				return {
					conversationId = nil,
					status = "failure"
				}
			end

			if v65 then
				v38(ReceivedConversation(p10))
			end

			return Promise.new(function(resolve) -- line: 159
				-- upvalues: v38 (copy), SendTextMessage (copy), v69 (copy), s3 (copy), StatusCodes (copy), AppChatNetworking (copy), navigateWithOsaGate (copy)
				local function sendMessage() -- line: 160
					-- upvalues: v38 (copy), SendTextMessage (copy), v69 (copy), s3 (copy), resolve (copy), StatusCodes (copy), AppChatNetworking (copy)
					v38(SendTextMessage(v69, s3, nil)):andThen(function(p11) -- line: 161
						-- upvalues: resolve (copy), StatusCodes (copy), AppChatNetworking (copy), v69 (copy)
						local v73 = resolve
						local v74 = p11 and (p11.responseCode == StatusCodes.OK and (p11.responseBody and (p11.responseBody.messages and p11.responseBody.messages[1])))
						local v75 = v74 and v74.status
						local t1

						if v74 ~= nil and (v75 == nil or (v75 == "" or v75 == AppChatNetworking.Constants.ResponseStatus.SUCCESS)) then
							local v76 = v69

							t1 = {
								status = "success",
								conversationId = v76
							}
						else
							t1 = {
								conversationId = nil,
								status = "failure"
							}
						end

						v73(t1)
					end, function() -- line: 167
						-- upvalues: resolve (copy)
						resolve({
							conversationId = nil,
							status = "failure"
						})
					end)
				end

				navigateWithOsaGate({
					conversationId = v69,
					dispatch = v38,
					onAccepted = function() -- line: 175
						-- upvalues: sendMessage (copy)
						sendMessage()
					end,
					onDeclined = function() -- line: 178
						-- upvalues: resolve (copy)
						resolve({
							conversationId = nil,
							status = "declined"
						})
					end,
					onError = function() -- line: 181
						-- upvalues: resolve (copy)
						resolve({
							conversationId = nil,
							status = "failure"
						})
					end
				})
			end)
		end):catch(function() -- line: 187
			return {
				conversationId = nil,
				status = "failure"
			}
		end)
	end, {
		v51,
		v38,
		v50,
		v43
	})
	local v53 = React.useCallback(function(s4: string?) -- line: 193
		-- upvalues: v38 (copy), NavigateIntoChat2 (copy), NavigateIntoChat (copy), EnumScreens (copy)
		v38(NavigateIntoChat2({
			conversationId = s4
		}, true))

		if s4 == nil then
			v38(NavigateIntoChat({
				screen = EnumScreens.ChatLanding,
				params = {}
			}))
		end
	end, { v38 })
	local v54 = not b1 and (isNavigationAvailable() or v44)

	return React.useMemo(function() -- line: 206
		-- upvalues: v49 (copy), v47 (copy), v48 (copy), v51 (copy), v54 (copy), v53 (copy), v52 (copy)
		return {
			isAvailable = v49,
			isGroupChatEnabled = v47,
			isLoading = v48,
			canSendToConversation = v51,
			navigateToChat = if not v54 then nil else v53,
			sendToConversation = v52
		}
	end, {
		v49,
		v47,
		v48,
		v51,
		v53,
		v54,
		v52
	})
end

return useExternalChatMessageSender
