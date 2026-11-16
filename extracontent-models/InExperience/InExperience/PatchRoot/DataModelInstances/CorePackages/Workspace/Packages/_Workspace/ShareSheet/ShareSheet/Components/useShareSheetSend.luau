local ShareSheet = script:FindFirstAncestor("ShareSheet")
local parent = ShareSheet.Parent

local React = require(parent.React)

require(parent.AppChat.GetExternalChatMessageSenderStore)
require(parent.InExperienceLocales)
local Localization = require(parent.Localization)
local LocalizationRoactContext = Localization.LocalizationRoactContext
require(parent.LuauPolyfill)
local SharedFlags = require(parent.SharedFlags)
local FFlagShareSheetFriendsSort = SharedFlags.FFlagShareSheetFriendsSort
local Recipient = require(ShareSheet.Recipients.Recipient)
require(ShareSheet.Recipients.RecipientSource)
local ShareSheetTelemetry = require(ShareSheet.telemetry.ShareSheetTelemetry)

local useConversationList = require(parent.AppChat.useConversationList)

local function getConversationDisplayName(p) -- 1 equivalent call inferred from this helper
	local titleForViewer = p.titleForViewer

	if titleForViewer and titleForViewer ~= "" then
		return titleForViewer
	end

	return p.title or ""
end

local function formatLocalizedSnackbarTitle(object, flag: boolean, p: number, list, formatSuccessSnackbarText)
	if not flag then
		return object:Format(p == 1 and "Feature.UniversalShareSheet.Response.NotSharedMessage" or "Feature.UniversalShareSheet.Response.NotSharedMultipleMessages")
	end

	if formatSuccessSnackbarText == nil then
		return object:Format(p == 1 and "Feature.UniversalShareSheet.Response.SharedMessage" or "Feature.UniversalShareSheet.Response.SharedMultipleMessages")
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
	local items

	if FFlagShareSheetFriendsSort then
		items = nil
	else
		items = useConversationList(data.chatShare ~= nil).items
	end

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
				local logInteraction = ShareSheetTelemetry.logInteraction
				local v2 = {
					context = data.context,
					recipientSource = 0,
					telemetryId = 0,
					interactionType = 0
				}
				local recipientSource

				if FFlagShareSheetFriendsSort then
					recipientSource = data.recipientSource
				end

				v2.recipientSource = recipientSource
				v2.telemetryId = data.telemetryId or ""
				v2.interactionType = ShareSheetTelemetry.InteractionType.CustomMessageSubmitted
				logInteraction(v2)
			end

			local v2 = not FFlagShareSheetFriendsSort and {} or nil
			local recipients = FFlagShareSheetFriendsSort and {} or nil

			if data.chatShare ~= nil then
				if FFlagShareSheetFriendsSort then
					for _, recipient in data.recipients do
						if
							data.selectedConversationIds[recipient.id]
							and Recipient.canSend(data.chatShare, recipient)
						then
							table.insert(recipients, recipient)
						end
					end
				else
					for _, item in items do
						if data.selectedConversationIds[item.id] and data.chatShare.canSendToConversation(item) then
							table.insert(v2, item)
						end
					end
				end
			end

			local v3

			if FFlagShareSheetFriendsSort then
				v3 = #recipients
			else
				v3 = #v2
			end

			local chatShare = data.chatShare

			if chatShare == nil or v3 == 0 then
				data.onSendActivated()
				return
			end

			ref.current = true
			setState(true)

			local flag = false
			local v4 = false
			local flag2 = false
			local v5 = {}
			local v6

			if value == "" then
				v6 = data.url
			else
				v6 = `{data.url} {value}`
			end

			local function finishSending()
				ref.current = false
				setState(false)

				if not (v4 or flag2) then
					return
				end

				if data.onShareSendResultSnackbar then
					local navigateToChat = chatShare.navigateToChat
					local conversationId

					if v3 == 1 and #v5 == 1 then
						conversationId = v5[1].conversationId
					else
						conversationId = nil
					end

					data.onShareSendResultSnackbar({
						action = flag2 and navigateToChat and {
							onActivated = function()
								local logInteraction = ShareSheetTelemetry.logInteraction
								local v7 = {
									context = data.context,
									recipientSource = 0,
									telemetryId = 0,
									interactionType = 0,
									requestedConversationId = 0,
									resolvedConversationId = 0,
									viewDestination = 0
								}
								local recipientSource

								if FFlagShareSheetFriendsSort then
									recipientSource = data.recipientSource
								end

								v7.recipientSource = recipientSource

								v7.telemetryId = data.telemetryId or ""
								v7.interactionType = ShareSheetTelemetry.InteractionType.ViewMessage
								local id

								if v3 == 1 then
									if FFlagShareSheetFriendsSort then
										id = recipients[1].id
									else
										id = v2[1].id
									end
								end

								v7.requestedConversationId = id

								v7.resolvedConversationId = conversationId
								local viewDestination

								if conversationId then
									viewDestination = ShareSheetTelemetry.ViewDestination.Conversation
								else
									viewDestination = ShareSheetTelemetry.ViewDestination.ChatLanding
								end

								v7.viewDestination = viewDestination
								logInteraction(v7)

								navigateToChat(conversationId)
							end,
							text = v:Format("CommonUI.Messages.Action.View")
						} or nil,
						title = formatLocalizedSnackbarTitle(v, flag2, v3, v5, data.formatSuccessSnackbarText)
					})
				end

				if flag2 then
					data.onSendActivated()
					data.onCloseWithReason(ShareSheetTelemetry.CloseReason.SendSuccess)
				end
			end

			local function send(p: number)
				local v7

				if FFlagShareSheetFriendsSort then
					v7 = recipients[p]
				else
					v7 = nil
				end

				local v8

				if FFlagShareSheetFriendsSort then
					v8 = nil
				else
					v8 = v2[p]
				end

				local startMessageSendResult = ShareSheetTelemetry.startMessageSendResult
				local v9 = {
					context = data.context,
					recipientSource = 0,
					telemetryId = 0,
					requestedConversationId = 0,
					hasCustomMessage = 0
				}
				local recipientSource

				if FFlagShareSheetFriendsSort then
					recipientSource = data.recipientSource
				end

				v9.recipientSource = recipientSource
				v9.telemetryId = data.telemetryId or ""
				local requestedConversationId

				if FFlagShareSheetFriendsSort then
					requestedConversationId = v7.id
				else
					requestedConversationId = v8.id
				end

				v9.requestedConversationId = requestedConversationId
				v9.hasCustomMessage = hasCustomMessage
				local v10 = startMessageSendResult(v9)
				local v11

				if FFlagShareSheetFriendsSort then
					v11 = Recipient.send(chatShare, v7, v6)
				else
					v11 = chatShare.sendToConversation(v8, v6)
				end

				return v11:catch(function()
					return { status = "failure" }
				end):andThen(function(p2)
					v10(p2)

					if p2.status == "success" and p2.conversationId then
						flag2 = true
						local v12 = { conversationId = p2.conversationId, displayName = 0 }
						local displayName

						if FFlagShareSheetFriendsSort then
							displayName = Recipient.getName(v7, false)
						else
							displayName = getConversationDisplayName(v8) -- inferred equivalent call
						end

						v12.displayName = displayName
						table.insert(v5, v12)
					elseif p2.status == "failure" then
						v4 = true
					elseif p2.status == "declined" then
						flag = true
					end
				end)
			end

			local v7 = send(1)

			for i = 2, v3 do
				v7 = v7:andThen(function()
					if flag then
						return
					end

					return send(i)
				end)
			end

			v7:andThen(finishSending)
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
			v
		})
	}
end

return useShareSheetSend
