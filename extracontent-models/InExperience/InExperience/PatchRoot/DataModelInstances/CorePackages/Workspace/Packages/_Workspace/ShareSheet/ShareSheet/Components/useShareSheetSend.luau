local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local React = require(parent.React)

require(parent.AppChat.GetExternalChatMessageSenderStore)
require(parent.InExperienceLocales)
local Localization = require(parent.Localization)
local LocalizationRoactContext = Localization.LocalizationRoactContext
local Recipient = require(ShareSheet.Recipients.Recipient)
require(ShareSheet.Recipients.RecipientSource)
local ShareSheetTelemetry = require(ShareSheet.telemetry.ShareSheetTelemetry)

local function formatLocalizedSnackbarTitle(object, flag: boolean, count: number, list, formatSuccessSnackbarText)
	if not flag then
		return object:Format(count == 1 and "Feature.UniversalShareSheet.Response.NotSharedMessage" or "Feature.UniversalShareSheet.Response.NotSharedMultipleMessages")
	end

	if formatSuccessSnackbarText == nil then
		return object:Format(count == 1 and "Feature.UniversalShareSheet.Response.SharedMessage" or "Feature.UniversalShareSheet.Response.SharedMultipleMessages")
	end

	local v = formatSuccessSnackbarText(list)
	local v2 = #list - 1

	if v2 <= 0 then
		return v
	end

	return (object:Format(
		v2 == 1 and "Feature.UniversalShareSheet.Response.SharedCustomMessage" or "Feature.UniversalShareSheet.SharedCustomMultipleMessages",
		{ CUSTOM_MESSAGE = v, N = v2 }
	))
end

local function useShareSheetSend(data)
	local state, setState = React.useState(false)
	local ref = React.useRef(false)
	local v = React.useContext(LocalizationRoactContext)

	return {
		isSending = state,
		onSendActivated = React.useCallback(function(value: string)
			if ref.current then
				return
			end

			local hasCustomMessage = string.find(value, "%S") ~= nil

			if hasCustomMessage then
				ShareSheetTelemetry.logInteraction({
					context = data.context,
					recipientSource = data.recipientSource,
					telemetryId = data.telemetryId or "",
					interactionType = ShareSheetTelemetry.InteractionType.CustomMessageSubmitted
				})
			end

			local recipients = {}

			if data.chatShare ~= nil then
				for _, recipient in data.recipients do
					if data.selectedConversationIds[recipient.id] and Recipient.canSend(data.chatShare, recipient) then
						table.insert(recipients, recipient)
					end
				end
			end

			local count = #recipients
			local chatShare = data.chatShare

			if chatShare == nil or count == 0 then
				data.onSendActivated()
				return
			end

			ref.current = true
			setState(true)

			local flag = false
			local v2 = false
			local flag2 = false
			local v3 = {}
			local v4

			if value == "" then
				v4 = data.url
			else
				v4 = `{data.url} {value}`
			end

			local function finishSending()
				ref.current = false
				setState(false)

				if not (v2 or flag2) then
					return
				end

				if data.onShareSendResultSnackbar then
					local navigateToChat = chatShare.navigateToChat
					local conversationId

					if count == 1 and #v3 == 1 then
						conversationId = v3[1].conversationId
					else
						conversationId = nil
					end

					data.onShareSendResultSnackbar({
						action = flag2 and navigateToChat and {
							onActivated = function()
								local logInteraction = ShareSheetTelemetry.logInteraction
								local v5 = {
									context = data.context,
									recipientSource = data.recipientSource,
									telemetryId = data.telemetryId or "",
									interactionType = ShareSheetTelemetry.InteractionType.ViewMessage,
									requestedConversationId = 0,
									resolvedConversationId = 0,
									viewDestination = 0
								}
								local requestedConversationId

								if count == 1 then
									requestedConversationId = recipients[1].id
								end

								v5.requestedConversationId = requestedConversationId

								v5.resolvedConversationId = conversationId
								local viewDestination

								if conversationId then
									viewDestination = ShareSheetTelemetry.ViewDestination.Conversation
								else
									viewDestination = ShareSheetTelemetry.ViewDestination.ChatLanding
								end

								v5.viewDestination = viewDestination
								logInteraction(v5)

								navigateToChat(conversationId)
							end,
							text = v:Format("CommonUI.Messages.Action.View")
						} or nil,
						title = formatLocalizedSnackbarTitle(v, flag2, count, v3, data.formatSuccessSnackbarText)
					})
				end

				if flag2 then
					data.onSendActivated()
					data.onCloseWithReason(ShareSheetTelemetry.CloseReason.SendSuccess)
				end
			end

			local function send(p: number)
				local v5 = recipients[p]
				local v6 = ShareSheetTelemetry.startMessageSendResult({
					context = data.context,
					recipientSource = data.recipientSource,
					telemetryId = data.telemetryId or "",
					requestedConversationId = v5.id,
					hasCustomMessage = hasCustomMessage
				})

				return Recipient.send(chatShare, v5, v4):catch(function()
					return { status = "failure" }
				end):andThen(function(p2)
					v6(p2)

					if p2.status == "success" and p2.conversationId then
						flag2 = true
						table.insert(v3, {
							conversationId = p2.conversationId,
							displayName = Recipient.getName(v5, false)
						})
					elseif p2.status == "failure" then
						v2 = true
					elseif p2.status == "declined" then
						flag = true
					end
				end)
			end

			local v5 = send(1)

			for i = 2, count do
				v5 = v5:andThen(function()
					if flag then
						return
					end

					return send(i)
				end)
			end

			v5:andThen(finishSending)
		end, {
			data.chatShare,
			data.context,
			data.formatSuccessSnackbarText,
			data.onCloseWithReason,
			data.onSendActivated,
			data.onShareSendResultSnackbar,
			data.recipients,
			data.recipientSource,
			data.selectedConversationIds,
			data.telemetryId,
			data.url,
			v
		})
	}
end

return useShareSheetSend
