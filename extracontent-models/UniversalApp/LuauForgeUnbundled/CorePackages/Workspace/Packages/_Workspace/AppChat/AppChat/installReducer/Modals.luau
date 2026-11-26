local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Rodux")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger")

local RemovedConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/RemovedConversation")
local FriendConversationCreated = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/FriendConversationCreated")
local ConversationChannels = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/ConversationChannels")
local DismissedChatModal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/DismissedChatModal")

local DismissedAllConversationModalsForSequence = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/DismissedAllConversationModalsForSequence")
local FFlagDebugAppChatFae = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAppChatFae")
local FFlagDebugAEGIS1AppChatBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagDebugAEGIS1AppChatBanner")
local fFlagTCUpsellModalEnabled_DEV = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagTCUpsellModalEnabled_DEV
local fFlagDebugEnableTCDoubleOptIn_DEV = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagDebugEnableTCDoubleOptIn_DEV

local fFlagEnableAEGIS2AppChatConversationBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagEnableAEGIS2AppChatConversationBanner

local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local modalSequence = AppChatNetworking.Constants.ModalSequence

return Rodux.createReducer({
	chatLandingModal = {},
	conversationTopModals = {},
	conversationOverlays = {},
	pendingStateModals = {},
	conversationBottomModals = {}
}, {
	[AppChatNetworking.rodux.GetChatLandingModal.Succeeded.name] = function(p2, p3)
		local responseBody = p3.responseBody

		return Cryo.Dictionary.join(p2, { chatLandingModal = responseBody })
	end,
	[AppChatNetworking.rodux.GetModalSequence.Succeeded.name] = function(data, p2)
		local v6 = p2.postBody and p2.postBody.conversation_id
		local friend_id = p2.postBody and p2.postBody.friend_id

		if friend_id and not v6 then
			v6 = ConversationChannels.getFriendConversationId({ friend_id })
		end

		if p2.postBody.modal_sequence == modalSequence.ConversationOverlay then
			if v6 then
				return Cryo.Dictionary.join(data, {
					conversationOverlays = Cryo.Dictionary.join(data.conversationOverlays, {
						[v6] = p2.responseBody
					})
				})
			end
		elseif p2.postBody.modal_sequence == modalSequence.ConversationTopModal then
			if v6 then
				return Cryo.Dictionary.join(data, {
					conversationTopModals = Cryo.Dictionary.join(data.conversationTopModals, {
						[v6] = p2.responseBody
					})
				})
			end
		else
			if p2.postBody.modal_sequence ~= modalSequence.ConversationBottomModal then
				Logger:warning(`GetModalSequence.Succeeded with unsupported modal sequence: {p2.postBody.modal_sequence}`)

				return data
			end

			if v6 then
				return Cryo.Dictionary.join(data, {
					conversationBottomModals = Cryo.Dictionary.join(data.conversationBottomModals, {
						[v6] = p2.responseBody
					})
				})
			end
		end

		return data
	end,
	[DismissedChatModal.name] = function(p2, p3)
		local key = p3.key
		local modalSequence2 = p3.modalSequence

		if modalSequence2 == modalSequence.ConversationOverlay then
			if key then
				return Cryo.Dictionary.join(p2, {
					conversationOverlays = Cryo.Dictionary.join(p2.conversationOverlays, {
						[key] = Cryo.None
					})
				})
			end
		else
			if modalSequence2 ~= modalSequence.ConversationTopModal then
				return p2
			end

			if key then
				return Cryo.Dictionary.join(p2, {
					conversationTopModals = Cryo.Dictionary.join(p2.conversationTopModals, {
						[key] = Cryo.None
					})
				})
			end
		end

		return p2
	end,
	[DismissedAllConversationModalsForSequence.name] = function(p2, p3)
		local modalSequence2 = p3.modalSequence

		if
			not fFlagEnableAEGIS2AppChatConversationBanner
			or modalSequence2 ~= modalSequence.ConversationBottomModal
		then
			Logger:warning(`DismissedAllConversationModalsForSequence received unsupported modal sequence: {modalSequence2} `)

			return p2
		end

		Logger:debug("Removing all modals of sequence:ConversationBottomModal from the store")
		local nones = {}

		for k, conversationBottomModal in p2.conversationBottomModals do
			nones[k] = Cryo.None
		end

		return Cryo.Dictionary.join(p2, {
			conversationBottomModals = Cryo.Dictionary.join(p2.conversationBottomModals, nones)
		})
	end,
	[AppChatNetworking.rodux.GetPendingStateModal.Succeeded.name] = function(p2, p3)
		local conversation_id = p3.postBody and p3.postBody.conversation_id

		if conversation_id then
			return Cryo.Dictionary.join(p2, {
				pendingStateModals = Cryo.Dictionary.join(p2.pendingStateModals, {
					[conversation_id] = p3.responseBody
				})
			})
		end

		return p2
	end,
	[RemovedConversation.name] = function(data, p2)
		local conversationId = p2.conversationId

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
	[FriendConversationCreated.name] = function(data, p2)
		local oldFriendConversationId = p2.oldFriendConversationId
		local newConversationId = p2.newConversationId

		if not (oldFriendConversationId and newConversationId) then
			return data
		end

		local v6

		if data.conversationTopModals[oldFriendConversationId] then
			v6 = Cryo.Dictionary.join(data, {
				conversationTopModals = Cryo.Dictionary.join(data.conversationTopModals, {
					[newConversationId] = data.conversationTopModals[oldFriendConversationId],
					[oldFriendConversationId] = Cryo.None
				})
			})
		else
			v6 = data
		end

		if data.conversationOverlays[oldFriendConversationId] then
			v6 = Cryo.Dictionary.join(v6, {
				conversationOverlays = Cryo.Dictionary.join(v6.conversationOverlays, {
					[newConversationId] = data.conversationOverlays[oldFriendConversationId],
					[oldFriendConversationId] = Cryo.None
				})
			})
		end

		if data.conversationBottomModals[oldFriendConversationId] then
			v6 = Cryo.Dictionary.join(v6, {
				conversationBottomModals = Cryo.Dictionary.join(v6.conversationBottomModals, {
					[newConversationId] = data.conversationBottomModals[oldFriendConversationId],
					[oldFriendConversationId] = Cryo.None
				})
			})
		end

		return v6
	end,
	DEBUG_ShowChatLandingAgeVerifiedTimedModal = FFlagDebugAEGIS1AppChatBanner and function(p2)
		return Cryo.Dictionary.union(p2, {
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
	DEBUG_ShowAppChatFaeUpsell = FFlagDebugAppChatFae and function(p2)
		return Cryo.Dictionary.union(p2, {
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
	DEBUG_ShowNewTCOverlay = (fFlagTCUpsellModalEnabled_DEV or fFlagDebugEnableTCDoubleOptIn_DEV) and function(p2, p3)
		return Cryo.Dictionary.join(p2, {
			conversationOverlays = Cryo.Dictionary.join(p2.conversationOverlays, {
				[p3.conversationId] = {
					modal_variant = p3.modalVariant,
					modal_layout = {
						id = "asdf",
						seen_record_action = "none",
						dismissed_record_action = "none"
					}
				}
			})
		})
	end or nil,
	DEBUG_ShowNewTopModal = fFlagDebugEnableTCDoubleOptIn_DEV and function(p2, p3)
		return Cryo.Dictionary.join(p2, {
			conversationTopModals = Cryo.Dictionary.join(p2.conversationTopModals, {
				[p3.conversationId] = {
					modal_variant = p3.modalVariant,
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
	DEBUG_DismissChatLandingModal = (FFlagDebugAppChatFae or FFlagDebugAEGIS1AppChatBanner) and function(p2)
		return Cryo.Dictionary.join(p2, { chatLandingModal = Cryo.None })
	end or nil
})
