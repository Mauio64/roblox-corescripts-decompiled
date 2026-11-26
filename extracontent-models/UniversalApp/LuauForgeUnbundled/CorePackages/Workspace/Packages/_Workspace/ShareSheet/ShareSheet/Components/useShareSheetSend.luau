local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/AppChat/GetExternalChatMessageSenderStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/InExperienceLocales")
local localizationRoactContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Localization").LocalizationRoactContext
local Recipient = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/Recipient")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/RecipientSource")
local ShareSheetTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/telemetry/ShareSheetTelemetry")

local function formatLocalizedSnackbarTitle(object, flag, count, list, formatSuccessSnackbarText)
	if not flag then
		return object:Format(count == 1 and "Feature.UniversalShareSheet.Response.NotSharedMessage" or "Feature.UniversalShareSheet.Response.NotSharedMultipleMessages")
	end

	if formatSuccessSnackbarText == nil then
		return object:Format(count == 1 and "Feature.UniversalShareSheet.Response.SharedMessage" or "Feature.UniversalShareSheet.Response.SharedMultipleMessages")
	end

	local v5 = formatSuccessSnackbarText(list)
	local v6 = #list - 1

	if v6 <= 0 then
		return v5
	end

	return (object:Format(
		v6 == 1 and "Feature.UniversalShareSheet.Response.SharedCustomMessage" or "Feature.UniversalShareSheet.SharedCustomMultipleMessages",
		{ CUSTOM_MESSAGE = v5, N = v6 }
	))
end

local function useShareSheetSend(data)
	local state, setState = React.useState(false)
	local ref = React.useRef(false)
	local v5 = React.useContext(localizationRoactContext)

	return {
		isSending = state,
		onSendActivated = React.useCallback(function(value)
			if ref.current then
				return
			end

			local v6 = string.find(value, "%S") ~= nil

			if v6 then
				ShareSheetTelemetry.logInteraction({
					context = data.context,
					recipientSource = data.recipientSource,
					telemetryId = data.telemetryId or "",
					interactionType = ShareSheetTelemetry.InteractionType.CustomMessageSubmitted
				})
			end

			local recipients = {}

			if data.chatShare ~= nil then
				for k, recipient in data.recipients do
					if
						data.selectedConversationIds[recipient.id]
						and Recipient.canSend(data.chatShare, recipient)
					then
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
			local v7 = false
			local flag2 = false
			local v8 = {}
			local v9 = if value == "" then data.url else `{data.url} {value}`
			local function finishSending()
				ref.current = false
				setState(false)

				if not (v7 or flag2) then
					return
				end

				if data.onShareSendResultSnackbar then
					local navigateToChat = chatShare.navigateToChat
					local conversationId = if count == 1 and #v8 == 1 then v8[1].conversationId else nil

					data.onShareSendResultSnackbar({
						action = flag2 and navigateToChat and {
							onActivated = function()
								local logInteraction = ShareSheetTelemetry.logInteraction
								local v10 = {
									context = data.context,
									recipientSource = data.recipientSource,
									telemetryId = data.telemetryId or "",
									interactionType = ShareSheetTelemetry.InteractionType.ViewMessage,
									requestedConversationId = 0,
									resolvedConversationId = 0,
									viewDestination = 0
								}
								local v11 = if count == 1 then recipients[1].id else nil
								v10.requestedConversationId = v11

								v10.resolvedConversationId = conversationId

								local v12 = if conversationId then ShareSheetTelemetry.ViewDestination.Conversation else ShareSheetTelemetry.ViewDestination.ChatLanding
								v10.viewDestination = v12
								logInteraction(v10)

								navigateToChat(conversationId)
							end,
							text = v5:Format("CommonUI.Messages.Action.View")
						} or nil,
						title = formatLocalizedSnackbarTitle(
							v5,
							flag2,
							count,
							v8,
							data.formatSuccessSnackbarText
						)
					})
				end

				if flag2 then
					data.onSendActivated()
					data.onCloseWithReason(ShareSheetTelemetry.CloseReason.SendSuccess)
				end
			end

			local function send(p2)
				local v10 = recipients[p2]
				local v11 = ShareSheetTelemetry.startMessageSendResult({
					context = data.context,
					recipientSource = data.recipientSource,
					telemetryId = data.telemetryId or "",
					requestedConversationId = v10.id,
					hasCustomMessage = v6
				})

				return Recipient.send(chatShare, v10, v9):catch(function()
					return { status = "failure" }
				end):andThen(function(p3)
					v11(p3)

					if p3.status == "success" and p3.conversationId then
						flag2 = true
						table.insert(v8, {
							conversationId = p3.conversationId,
							displayName = Recipient.getName(v10, false)
						})
					elseif p3.status == "failure" then
						v7 = true
					elseif p3.status == "declined" then
						flag = true
					end
				end)
			end

			local v10 = send(1)

			for i = 2, count do
				v10 = v10:andThen(function()
					if flag then
						return
					end

					return send(i)
				end)
			end

			v10:andThen(finishSending)
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
			v5
		})
	}
end

return useShareSheetSend
