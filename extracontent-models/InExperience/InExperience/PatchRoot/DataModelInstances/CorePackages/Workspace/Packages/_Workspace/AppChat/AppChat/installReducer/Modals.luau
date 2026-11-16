local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local Rodux = require(parent.Rodux)
local Logger = require(AppChat.Logger)

local RemovedConversation = require(AppChat.Conversations.Actions.RemovedConversation)
local FriendConversationCreated = require(AppChat.Conversations.Actions.FriendConversationCreated)
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local DismissedChatModal = require(AppChat.Conversations.Actions.DismissedChatModal)

local DismissedAllConversationModalsForSequence = require(AppChat.Conversations.Actions.DismissedAllConversationModalsForSequence)
local FFlagDebugAppChatFae = require(AppChat.Flags.FFlagDebugAppChatFae)
local FFlagDebugAEGIS1AppChatBanner = require(AppChat.Flags.FFlagDebugAEGIS1AppChatBanner)
local SharedFlags = require(parent.SharedFlags)
local FFlagTCUpsellModalEnabled_DEV = SharedFlags.FFlagTCUpsellModalEnabled_DEV
local SharedFlags2 = require(parent.SharedFlags)
local FFlagDebugEnableTCDoubleOptIn_DEV = SharedFlags2.FFlagDebugEnableTCDoubleOptIn_DEV

local SharedFlags3 = require(parent.SharedFlags)
local FFlagEnableAEGIS2AppChatConversationBanner = SharedFlags3.FFlagEnableAEGIS2AppChatConversationBanner

local AppChatNetworking = require(parent.AppChatNetworking)
local ModalSequence = AppChatNetworking.Constants.ModalSequence

return Rodux.createReducer({
	chatLandingModal = {},
	conversationTopModals = {},
	conversationOverlays = {},
	pendingStateModals = {},
	conversationBottomModals = {}
}, {
	[AppChatNetworking.rodux.GetChatLandingModal.Succeeded.name] = function(p, p2)
		local responseBody = p2.responseBody

		return Cryo.Dictionary.join(p, { chatLandingModal = responseBody })
	end,
	[AppChatNetworking.rodux.GetModalSequence.Succeeded.name] = function(data, p)
		local v = p.postBody and p.postBody.conversation_id
		local friend_id = p.postBody and p.postBody.friend_id

		if friend_id and not v then
			v = ConversationChannels.getFriendConversationId({ friend_id })
		end

		if p.postBody.modal_sequence == ModalSequence.ConversationOverlay then
			if v then
				return Cryo.Dictionary.join(data, {
					conversationOverlays = Cryo.Dictionary.join(data.conversationOverlays, {
						[v] = p.responseBody
					})
				})
			end
		elseif p.postBody.modal_sequence == ModalSequence.ConversationTopModal then
			if v then
				return Cryo.Dictionary.join(data, {
					conversationTopModals = Cryo.Dictionary.join(data.conversationTopModals, {
						[v] = p.responseBody
					})
				})
			end
		else
			if p.postBody.modal_sequence ~= ModalSequence.ConversationBottomModal then
				Logger:warning(`GetModalSequence.Succeeded with unsupported modal sequence: {p.postBody.modal_sequence}`)

				return data
			end

			if v then
				return Cryo.Dictionary.join(data, {
					conversationBottomModals = Cryo.Dictionary.join(data.conversationBottomModals, {
						[v] = p.responseBody
					})
				})
			end
		end

		return data
	end,
	[DismissedChatModal.name] = function(p, p2)
		local key = p2.key
		local modalSequence = p2.modalSequence

		if modalSequence == ModalSequence.ConversationOverlay then
			if key then
				return Cryo.Dictionary.join(p, {
					conversationOverlays = Cryo.Dictionary.join(p.conversationOverlays, {
						[key] = Cryo.None
					})
				})
			end
		else
			if modalSequence ~= ModalSequence.ConversationTopModal then
				return p
			end

			if key then
				return Cryo.Dictionary.join(p, {
					conversationTopModals = Cryo.Dictionary.join(p.conversationTopModals, {
						[key] = Cryo.None
					})
				})
			end
		end

		return p
	end,
	[DismissedAllConversationModalsForSequence.name] = function(p, p2)
		local modalSequence = p2.modalSequence

		if not FFlagEnableAEGIS2AppChatConversationBanner or modalSequence ~= ModalSequence.ConversationBottomModal then
			Logger:warning(`DismissedAllConversationModalsForSequence received unsupported modal sequence: {modalSequence} `)

			return p
		end

		Logger:debug("Removing all modals of sequence:ConversationBottomModal from the store")
		local nones = {}

		for k, _ in p.conversationBottomModals do
			nones[k] = Cryo.None
		end

		return Cryo.Dictionary.join(p, {
			conversationBottomModals = Cryo.Dictionary.join(p.conversationBottomModals, nones)
		})
	end,
	[AppChatNetworking.rodux.GetPendingStateModal.Succeeded.name] = function(p, p2)
		local conversation_id = p2.postBody and p2.postBody.conversation_id

		if conversation_id then
			return Cryo.Dictionary.join(p, {
				pendingStateModals = Cryo.Dictionary.join(p.pendingStateModals, {
					[conversation_id] = p2.responseBody
				})
			})
		end

		return p
	end,
	[RemovedConversation.name] = function(data, p)
		local conversationId = p.conversationId

		if conversationId then
			return Cryo.Dictionary.join(data, {
				conversationTopModals = Cryo.Dictionary.join(data.conversationTopModals, {
					[conversationId] = Cryo.None
				}),
				pendingStateModals = Cryo.Dictionary.join(data.pendingStateModals, {
					[conversationId] = Cryo.None
				}),
				conversationBottomModals = Cryo.Dictionary.join(data.conversationBottomModals, {
					[conversationId] = Cryo.None
				})
			})
		end

		return data
	end,
	[FriendConversationCreated.name] = function(data, p)
		local oldFriendConversationId = p.oldFriendConversationId
		local newConversationId = p.newConversationId

		if not (oldFriendConversationId and newConversationId) then
			return data
		end

		local v

		if data.conversationTopModals[oldFriendConversationId] then
			v = Cryo.Dictionary.join(data, {
				conversationTopModals = Cryo.Dictionary.join(data.conversationTopModals, {
					[newConversationId] = data.conversationTopModals[oldFriendConversationId],
					[oldFriendConversationId] = Cryo.None
				})
			})
		else
			v = data
		end

		if data.conversationOverlays[oldFriendConversationId] then
			v = Cryo.Dictionary.join(v, {
				conversationOverlays = Cryo.Dictionary.join(v.conversationOverlays, {
					[newConversationId] = data.conversationOverlays[oldFriendConversationId],
					[oldFriendConversationId] = Cryo.None
				})
			})
		end

		if data.conversationBottomModals[oldFriendConversationId] then
			return (Cryo.Dictionary.join(v, {
				conversationBottomModals = Cryo.Dictionary.join(v.conversationBottomModals, {
					[newConversationId] = data.conversationBottomModals[oldFriendConversationId],
					[oldFriendConversationId] = Cryo.None
				})
			}))
		end

		return v
	end,
	DEBUG_ShowChatLandingAgeVerifiedTimedModal = FFlagDebugAEGIS1AppChatBanner and function(p)
		return Cryo.Dictionary.union(p, {
			chatLandingModal = {
				modal_variant = AppChatNetworking.Constants.ChatLandingModalVariant.ChatLandingAgeVerifiedCommsTimedModal,
				modal_layout = {
					id = "asdf",
					header = {
						text = "FAE Title",
						additional_content = {
							{
								type = AppChatNetworking.Constants.ModalContentType.Countdown,
								text = "14 days left"
							}
						}
					},
					body = {
						text = "FAE debug Body",
						additional_content = {
							{
								type = AppChatNetworking.Constants.ModalContentType.Link,
								text = "Learn more"
							}
						}
					},
					buttons = {
						{
							text = "Continue",
							action = { type = "open_fae_upsell" }
						},
						{
							text = "View Details",
							action = { type = "open_fae_view_details" }
						}
					},
					dismissible = true,
					seen_record_action = "none",
					dismissed_record_action = "none"
				}
			}
		})
	end or nil,
	DEBUG_ShowAppChatFaeUpsell = FFlagDebugAppChatFae and function(p)
		return Cryo.Dictionary.union(p, {
			chatLandingModal = {
				modal_variant = AppChatNetworking.Constants.ChatLandingModalVariant.AgeAssuranceUpsell,
				modal_layout = {
					id = "asdf",
					label = { text = "New" },
					header = { text = "FAE Title" },
					body = {
						text = "FAE debug Body",
						additional_content = {
							{
								type = AppChatNetworking.Constants.ModalContentType.Link,
								text = "Learn more"
							}
						}
					},
					buttons = {
						{ text = "Continue" }
					},
					seen_record_action = "none",
					dismissed_record_action = "none"
				}
			}
		})
	end or nil,
	DEBUG_ShowNewTCOverlay = (FFlagTCUpsellModalEnabled_DEV or FFlagDebugEnableTCDoubleOptIn_DEV) and function(p, p2)
		return Cryo.Dictionary.join(p, {
			conversationOverlays = Cryo.Dictionary.join(p.conversationOverlays, {
				[p2.conversationId] = {
					modal_variant = p2.modalVariant,
					modal_layout = {
						id = "asdf",
						seen_record_action = "none",
						dismissed_record_action = "none"
					}
				}
			})
		})
	end or nil,
	DEBUG_ShowNewTopModal = FFlagDebugEnableTCDoubleOptIn_DEV and function(p, p2)
		return Cryo.Dictionary.join(p, {
			conversationTopModals = Cryo.Dictionary.join(p.conversationTopModals, {
				[p2.conversationId] = {
					modal_variant = p2.modalVariant,
					modal_layout = {
						id = "",
						body = { text = "Add Trusted Connection" },
						buttons = {
							{ text = "Add" }
						},
						seen_record_action = "none",
						dismissed_record_action = "none"
					}
				}
			})
		})
	end or nil,
	DEBUG_DismissChatLandingModal = (FFlagDebugAppChatFae or FFlagDebugAEGIS1AppChatBanner) and function(p)
		return Cryo.Dictionary.join(p, { chatLandingModal = Cryo.None })
	end or nil
})
