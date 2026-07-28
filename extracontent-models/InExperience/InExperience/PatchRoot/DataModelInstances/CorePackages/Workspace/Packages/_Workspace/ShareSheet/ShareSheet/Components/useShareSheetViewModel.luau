local ShareSheet = script:FindFirstAncestor("ShareSheet")
local ShareSheetParent = ShareSheet.Parent
local AppChat = require(ShareSheetParent.AppChat)
local React = require(ShareSheetParent.React)
local SignalsReact = require(ShareSheetParent.SignalsReact)
local GetExternalChatMessageSenderStore = require(ShareSheetParent.AppChat.GetExternalChatMessageSenderStore)
local useConversationList = AppChat.Hooks.useConversationList
local fetchConversationListPageToSignals = require(ShareSheetParent.AppChat.fetchConversationListPageToSignals)
local useExternalChatConversationEligibility = require(ShareSheetParent.AppChat.useExternalChatConversationEligibility)
local useLocalization = require(ShareSheetParent.Localization).Hooks.useLocalization
local getAppFeaturePolicies = require(ShareSheetParent.UniversalAppPolicy).getAppFeaturePolicies
local ShareSheetConstants = require(ShareSheet.ShareSheetConstants)
local ShareSheetTelemetry = require(ShareSheet.telemetry.ShareSheetTelemetry)

require(script.Parent.ShareSheetView)

local useShareSheetSelection = require(script.Parent.useShareSheetSelection)

local function getConversationDisplayName(p1) -- line: 56
	local titleForViewer = p1.titleForViewer

	if titleForViewer and titleForViewer ~= "" then
		return titleForViewer
	end

	return p1.title or ""
end
local function appendOtherTargets(s1: string, n1: number) -- line: 61
	local v22 = n1 - 1

	if v22 <= 0 then
		return s1
	end

	if v22 == 1 then
		return `{ s1 } + 1 other`
	end

	return `{ s1 } + { v22 } others`
end
local function useShareSheetViewModel(t1: {[any]: any}) -- line: 68
	-- upvalues: SignalsReact (copy), GetExternalChatMessageSenderStore (copy), useConversationList (copy), useShareSheetSelection (copy), useExternalChatConversationEligibility (copy), ShareSheetConstants (copy), React (copy), useLocalization (copy), fetchConversationListPageToSignals (copy), ShareSheetTelemetry (copy), getAppFeaturePolicies (copy)
	local v24 = SignalsReact.useSignalState(GetExternalChatMessageSenderStore().getSender)
	local v25 = v24 ~= nil
	local v26 = useConversationList(v25)
	local v27 = useShareSheetSelection()
	local listStatus = v26.listStatus
	local v29 = #v26.items > 0
	local v30 = v25 and (not v29 and (listStatus.error == nil and (listStatus.isFetchingConversations == true or listStatus.hasFetchedInitialPage ~= true)))
	local v31 = v24 ~= nil and v24.isAvailable
	local v32 = t1.isOpen == true and (v31 and v29)
	local v33 = useExternalChatConversationEligibility({
		conversations = v26.items,
		isActive = v32,
		isGroupChatEnabled = not not v24 and v24.isGroupChatEnabled,
		maxConversationCount = ShareSheetConstants.FIntShareSheetMaxConversations
	})
	local v34, v35 = React.useState(false)
	local v36 = React.useRef(false)
	local v37 = useLocalization({
		send = "CommonUI.Features.Action.Send",
		share = "Feature.SocialShare.Action.Share"
	})

	React.useEffect(function() -- line: 94
		-- upvalues: v25 (copy), fetchConversationListPageToSignals (copy)
		if v25 then
			fetchConversationListPageToSignals()
		end
	end, { v25 })

	local v38 = React.useCallback(function(s2: string) -- line: 100
		-- upvalues: v36 (copy), v24 (copy), v26 (copy), v27 (copy), v35 (copy), t1 (copy), ShareSheetTelemetry (copy)
		if v36.current then
			return
		end

		local t2 = {}

		if v24 ~= nil then
			for _, v44 in v26.items do
				if v27.selectedConversationIds[v44.id] and v24.canSendToConversation(v44) then
					table.insert(t2, v44)
				end
			end
		end

		v27.onSendActivated()

		if v24 == nil or #t2 == 0 then
			return
		end

		v36.current = true
		v35(true)

		local u45 = false
		local u46 = false
		local u47 = false
		local t3 = {}
		local v49 = if s2 ~= "" then `{ t1.url } { s2 }` else t1.url

		local function finishSending() -- line: 130
			-- upvalues: v36 (copy), v35 (copy), u46 (ref), u47 (ref), t1 (copy), v24 (copy), t2 (copy), t3 (copy), ShareSheetTelemetry (copy)
			v36.current = false
			v35(false)

			if not u46 and not u47 then
				return
			end

			if t1.onShareSendResultSnackbar then
				local navigateToChat = v24.navigateToChat
				local v56 = if #t2 ~= 1 or #t3 ~= 1 then nil else t3[1].conversationId
				local onShareSendResultSnackbar = t1.onShareSendResultSnackbar
				local t4 = {
					action = if not u47 or not navigateToChat then nil else {
						text = "View",
						onActivated = function() -- line: 146
							-- upvalues: navigateToChat (copy), v56 (copy)
							navigateToChat(v56)
						end
					}
				}
				local v59

				if not u47 then
					v59 = #t2 ~= 1 and "Messages can't be sent" or "Message can't be sent"
				elseif t1.formatSuccessSnackbarText then
					local v60 = t1.formatSuccessSnackbarText(t3)
					local v61 = #t3 - 1

					v59 = if not (v61 <= 0) then if v61 ~= 1 then `{ v60 } + { v61 } others` else `{ v60 } + 1 other` else v60
				else
					v59 = #t2 ~= 1 and "Messages were sent" or "Message was sent"
				end

				t4.title = v59
				onShareSendResultSnackbar(t4)
			end

			if u47 then
				ShareSheetTelemetry.logShareSheetMessageSent({
					context = t1.context,
					url = t1.url,
					telemetryId = t1.telemetryId or ""
				})
				t1.onClose()
			end
		end
		local function send(p2) -- line: 171
			-- upvalues: v24 (copy), v49 (copy), u47 (ref), t3 (copy), u46 (ref), u45 (ref)
			return v24.sendToConversation(p2, v49):catch(function() -- line: 174
				return {
					status = "failure"
				}
			end):andThen(function(p3) -- line: 179
				-- upvalues: u47 (ref), t3 (copy), p2 (copy), u46 (ref), u45 (ref)
				if p3.status == "success" and p3.conversationId then
					u47 = true

					local v64 = t3
					local t5 = {
						conversationId = p3.conversationId
					}
					local v66 = p2
					local titleForViewer = v66.titleForViewer

					t5.displayName = if not titleForViewer or titleForViewer == "" then v66.title or "" else titleForViewer
					table.insert(v64, t5)

					return
				end

				if p3.status == "failure" then
					u46 = true

					return
				end

				if p3.status == "declined" then
					u45 = true
				end
			end)
		end

		local v52 = send(t2[1])

		for i = 2, #t2 do
			local v54 = t2[i]

			v52 = v52:andThen(function() -- line: 197
				-- upvalues: u45 (ref), send (copy), v54 (copy)
				if not u45 then
					return send(v54)
				end
			end)
		end

		v52:andThen(finishSending)
	end, {
		v26.items,
		v24,
		t1.context,
		t1.formatSuccessSnackbarText,
		t1.onClose,
		t1.onShareSendResultSnackbar,
		t1.telemetryId,
		t1.url,
		v27.onSendActivated,
		v27.selectedConversationIds
	})
	local v39 = v24 ~= nil and (v24.isAvailable and v30)
	local v40 = v24 ~= nil and (v24.isAvailable and (v29 or v30))

	return {
		canShareLink = getAppFeaturePolicies().getEligibleForExternalContentSharing(),
		conversationEligibility = v33,
		context = t1.context,
		isOpen = t1.isOpen == true,
		isSending = v34,
		isSocialRowLoading = v39,
		messagePlaceholder = t1.messagePlaceholder or "Share a message",
		onConversationActivated = v27.onConversationActivated,
		onClose = t1.onClose,
		onSendActivated = v38,
		selectedConversationIds = v27.selectedConversationIds,
		sendLabel = v37.send,
		shareLabel = v37.share,
		telemetryId = t1.telemetryId,
		shouldShowSocialRow = v40,
		url = t1.url
	}
end

return useShareSheetViewModel
