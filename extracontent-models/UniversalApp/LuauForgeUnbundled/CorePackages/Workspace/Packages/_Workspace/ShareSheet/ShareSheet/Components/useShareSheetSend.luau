local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/React")

require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/AppChat/GetExternalChatMessageSenderStore")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/InExperienceLocales")
local localizationRoactContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/Localization").LocalizationRoactContext
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/LuauPolyfill")
local fFlagShareSheetFriendsSort = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/SharedFlags").FFlagShareSheetFriendsSort
local Recipient = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/Recipient")
require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/Recipients/RecipientSource")
local ShareSheetTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/ShareSheet/telemetry/ShareSheetTelemetry")

local useConversationList = require("@game/CorePackages/Workspace/Packages/_Workspace/ShareSheet/AppChat/useConversationList")

local function getConversationDisplayName(p2)
	local titleForViewer = p2.titleForViewer

	if titleForViewer and titleForViewer ~= "" then
		return titleForViewer
	end

	return p2.title or ""
end

local function formatLocalizedSnackbarTitle(object, flag, p2, list, formatSuccessSnackbarText)
	if not flag then
		return object:Format(p2 == 1 and "Feature.UniversalShareSheet.Response.NotSharedMessage" or "Feature.UniversalShareSheet.Response.NotSharedMultipleMessages")
	end

	if formatSuccessSnackbarText == nil then
		return object:Format(p2 == 1 and "Feature.UniversalShareSheet.Response.SharedMessage" or "Feature.UniversalShareSheet.Response.SharedMultipleMessages")
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
	local items = if not fFlagShareSheetFriendsSort then useConversationList(data.chatShare ~= nil).items else nil
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
				local logInteraction = ShareSheetTelemetry.logInteraction
				local v7 = {
					context = data.context,
					recipientSource = 0,
					telemetryId = 0,
					interactionType = 0
				}
				local v8 = if fFlagShareSheetFriendsSort then data.recipientSource else nil
				v7.recipientSource = v8
				v7.telemetryId = data.telemetryId or ""
				v7.interactionType = ShareSheetTelemetry.InteractionType.CustomMessageSubmitted
				logInteraction(v7)
			end

			local v7 = not fFlagShareSheetFriendsSort and {} or nil
			local recipients = fFlagShareSheetFriendsSort and {} or nil

			if data.chatShare ~= nil then
				if fFlagShareSheetFriendsSort then
					for k, recipient in data.recipients do
						if
							data.selectedConversationIds[recipient.id]
							and Recipient.canSend(data.chatShare, recipient)
						then
							table.insert(recipients, recipient)
						end
					end
				else
					for k, item in items do
						if
							data.selectedConversationIds[item.id]
							and data.chatShare.canSendToConversation(item)
						then
							table.insert(v7, item)
						end
					end
				end
			end

			local v8 = if fFlagShareSheetFriendsSort then #recipients else #v7
			local chatShare = data.chatShare

			if chatShare == nil or v8 == 0 then
				data.onSendActivated()
				return
			end

			ref.current = true
			setState(true)

			local flag = false
			local v9 = false
			local flag2 = false
			local v10 = {}
			local v11 = if value == "" then data.url else `{data.url} {value}`
			local function finishSending()
				ref.current = false
				setState(false)

				if not (v9 or flag2) then
					return
				end

				if data.onShareSendResultSnackbar then
					local navigateToChat = chatShare.navigateToChat
					local conversationId = if v8 == 1 and #v10 == 1 then v10[1].conversationId else nil

					data.onShareSendResultSnackbar({
						action = flag2 and navigateToChat and {
							onActivated = function()
								local logInteraction = ShareSheetTelemetry.logInteraction
								local v12 = {
									context = data.context,
									recipientSource = 0,
									telemetryId = 0,
									interactionType = 0,
									requestedConversationId = 0,
									resolvedConversationId = 0,
									viewDestination = 0
								}

								local v13 = if fFlagShareSheetFriendsSort then data.recipientSource else nil
								v12.recipientSource = v13

								v12.telemetryId = data.telemetryId or ""
								v12.interactionType = ShareSheetTelemetry.InteractionType.ViewMessage
								local id

								if v8 == 1 then
									id = if fFlagShareSheetFriendsSort then recipients[1].id else v7[1].id
								end

								v12.requestedConversationId = id

								v12.resolvedConversationId = conversationId

								local v14 = if conversationId then ShareSheetTelemetry.ViewDestination.Conversation else ShareSheetTelemetry.ViewDestination.ChatLanding
								v12.viewDestination = v14
								logInteraction(v12)

								navigateToChat(conversationId)
							end,
							text = v5:Format("CommonUI.Messages.Action.View")
						} or nil,
						title = formatLocalizedSnackbarTitle(
							v5,
							flag2,
							v8,
							v10,
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
				local v12 = if fFlagShareSheetFriendsSort then recipients[p2] else nil
				local v13 = if not fFlagShareSheetFriendsSort then v7[p2] else nil
				local startMessageSendResult = ShareSheetTelemetry.startMessageSendResult
				local v14 = {
					context = data.context,
					recipientSource = 0,
					telemetryId = 0,
					requestedConversationId = 0,
					hasCustomMessage = 0
				}
				local v15 = if fFlagShareSheetFriendsSort then data.recipientSource else nil
				v14.recipientSource = v15
				v14.telemetryId = data.telemetryId or ""
				local v16 = if fFlagShareSheetFriendsSort then v12.id else v13.id
				v14.requestedConversationId = v16
				v14.hasCustomMessage = v6
				local v17 = startMessageSendResult(v14)
				local v18

				if fFlagShareSheetFriendsSort then
					v18 = Recipient.send(chatShare, v12, v11)
				else
					v18 = chatShare.sendToConversation(v13, v11)
				end

				return v18:catch(function()
					return { status = "failure" }
				end):andThen(function(p3)
					v17(p3)

					if p3.status == "success" and p3.conversationId then
						flag2 = true
						local v20 = {
							conversationId = p3.conversationId,
							displayName = 0
						}
						local v21

						if fFlagShareSheetFriendsSort then
							v21 = Recipient.getName(v12, false)
						else
							local v22 = v13
							local titleForViewer = v22.titleForViewer
							v21 = (not titleForViewer or titleForViewer == "") and (v22.title or "")
								or titleForViewer
						end

						v20.displayName = v21
						table.insert(v10, v20)
					elseif p3.status == "failure" then
						v9 = true
					elseif p3.status == "declined" then
						flag = true
					end
				end)
			end

			local v12 = send(1)

			for i = 2, v8 do
				v12 = v12:andThen(function()
					if flag then
						return
					end

					return send(i)
				end)
			end

			v12:andThen(finishSending)
		end, {
			data.chatShare,
			data.context,
			items,
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
