local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local Rodux = require(AppChatParent.Rodux)
local Logger = require(AppChat.Logger)
local DismissedConversationTopModal = require(AppChat.Conversations.Actions.DismissedConversationTopModal)
local RemovedConversation = require(AppChat.Conversations.Actions.RemovedConversation)
local FriendConversationCreated = require(AppChat.Conversations.Actions.FriendConversationCreated)
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local DismissedChatModal = require(AppChat.Conversations.Actions.DismissedChatModal)
local DismissedAllConversationModalsForSequence = require(AppChat.Conversations.Actions.DismissedAllConversationModalsForSequence)
local FFlagDebugAppChatFae = require(AppChat.Flags.FFlagDebugAppChatFae)
local FFlagDebugAEGIS1AppChatBanner = require(AppChat.Flags.FFlagDebugAEGIS1AppChatBanner)
local FFlagTCUpsellModalEnabled_DEV = require(AppChatParent.SharedFlags).FFlagTCUpsellModalEnabled_DEV
local FFlagDebugEnableTCDoubleOptIn_DEV = require(AppChatParent.SharedFlags).FFlagDebugEnableTCDoubleOptIn_DEV
local FFlagAppChatEnableDoubleOptIn = require(AppChatParent.SharedFlags).FFlagAppChatEnableDoubleOptIn
local FFlagEnableAEGIS2AppChatConversationBanner = require(AppChatParent.SharedFlags).FFlagEnableAEGIS2AppChatConversationBanner
local FFlagAppChatNudgeToChatUpsellEnabled = require(AppChat.Flags.FFlagAppChatNudgeToChatUpsellEnabled)
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local ModalSequence = AppChatNetworking.Constants.ModalSequence
local t1 = {
	chatLandingModal = {},
	conversationTopModals = {},
	conversationTopModalsDismissed = if not FFlagAppChatEnableDoubleOptIn then {} else nil,
	conversationOverlays = {},
	pendingStateModals = {},
	conversationBottomModals = {}
}

return Rodux.createReducer(t1, {
	[AppChatNetworking.rodux.GetChatLandingModal.Succeeded.name] = function(t2: {[any]: any}, p1) -- line: 46
		-- upvalues: Cryo (copy)
		local responseBody = p1.responseBody

		return Cryo.Dictionary.join(t2, {
			chatLandingModal = responseBody
		})
	end,
	[AppChatNetworking.rodux.GetConversationTopModal.Succeeded.name] = not FFlagAppChatEnableDoubleOptIn and function(t3: {[any]: any}, p2) -- line: 60
		-- upvalues: ConversationChannels (copy), Cryo (copy)
		local v27 = p2.postBody and p2.postBody.conversation_id
		local v28 = p2.postBody and p2.postBody.friend_id

		if v28 and not v27 then
			v27 = ConversationChannels.getFriendConversationId({ v28 })
		end

		if not v27 then
			return t3
		end

		return Cryo.Dictionary.join(t3, {
			conversationTopModals = Cryo.Dictionary.join(t3.conversationTopModals, {
				[v27] = p2.responseBody
			})
		})
	end or nil,
	[AppChatNetworking.rodux.GetModalSequence.Succeeded.name] = function(t4: {[any]: any}, p3) -- line: 84
		-- upvalues: ConversationChannels (copy), ModalSequence (copy), Cryo (copy), FFlagAppChatEnableDoubleOptIn (copy), FFlagEnableAEGIS2AppChatConversationBanner (copy), FFlagAppChatNudgeToChatUpsellEnabled (copy), Logger (copy)
		local v31 = p3.postBody and p3.postBody.conversation_id
		local v32 = p3.postBody and p3.postBody.friend_id

		if v32 and not v31 then
			v31 = ConversationChannels.getFriendConversationId({ v32 })
		end

		if p3.postBody.modal_sequence == ModalSequence.ConversationOverlay then
			if not v31 then
				return t4
			end

			return Cryo.Dictionary.join(t4, {
				conversationOverlays = Cryo.Dictionary.join(t4.conversationOverlays, {
					[v31] = p3.responseBody
				})
			})
		end

		if p3.postBody.modal_sequence == ModalSequence.ConversationTopModal and FFlagAppChatEnableDoubleOptIn then
			if not v31 then
				return t4
			end

			return Cryo.Dictionary.join(t4, {
				conversationTopModals = Cryo.Dictionary.join(t4.conversationTopModals, {
					[v31] = p3.responseBody
				})
			})
		end

		if p3.postBody.modal_sequence == ModalSequence.ConversationBottomModal and (FFlagEnableAEGIS2AppChatConversationBanner or FFlagAppChatNudgeToChatUpsellEnabled) then
			if not v31 then
				return t4
			end

			return Cryo.Dictionary.join(t4, {
				conversationBottomModals = Cryo.Dictionary.join(t4.conversationBottomModals, {
					[v31] = p3.responseBody
				})
			})
		end

		Logger:warning(`GetModalSequence.Succeeded with unsupported modal sequence: { p3.postBody.modal_sequence }`)

		return t4
	end,
	[DismissedConversationTopModal.name] = not FFlagAppChatEnableDoubleOptIn and function(t5: {[any]: any}, p4) -- line: 142
		-- upvalues: Cryo (copy)
		local conversationId = p4.conversationId
		local modalVariant = p4.modalVariant

		if not conversationId or not modalVariant then
			return t5
		end

		return Cryo.Dictionary.join(t5, {
			conversationTopModalsDismissed = Cryo.Dictionary.join(t5.conversationTopModalsDismissed, {
				[conversationId] = Cryo.Dictionary.join(t5.conversationTopModalsDismissed[conversationId] or {}, {
					[modalVariant] = true
				})
			})
		})
	end or nil,
	[DismissedChatModal.name] = function(t6: {[any]: any}, p5) -- line: 160
		-- upvalues: ModalSequence (copy), Cryo (copy), FFlagAppChatEnableDoubleOptIn (copy)
		local key = p5.key
		local modalSequence = p5.modalSequence

		if modalSequence == ModalSequence.ConversationOverlay then
			if not key then
				return t6
			end

			return Cryo.Dictionary.join(t6, {
				conversationOverlays = Cryo.Dictionary.join(t6.conversationOverlays, {
					[key] = Cryo.None
				})
			})
		end

		if modalSequence == ModalSequence.ConversationTopModal and FFlagAppChatEnableDoubleOptIn then
			if not key then
				return t6
			end

			return Cryo.Dictionary.join(t6, {
				conversationTopModals = Cryo.Dictionary.join(t6.conversationTopModals, {
					[key] = Cryo.None
				})
			})
		end

		return t6
	end,
	[DismissedAllConversationModalsForSequence.name] = function(t7: {[any]: any}, p6) -- line: 185
		-- upvalues: FFlagEnableAEGIS2AppChatConversationBanner (copy), ModalSequence (copy), Logger (copy), Cryo (copy)
		local modalSequence = p6.modalSequence

		if FFlagEnableAEGIS2AppChatConversationBanner and modalSequence == ModalSequence.ConversationBottomModal then
			Logger:debug("Removing all modals of sequence:ConversationBottomModal from the store")

			local t8 = {}

			for v45, _ in t7.conversationBottomModals do
				t8[v45] = Cryo.None
			end

			return Cryo.Dictionary.join(t7, {
				conversationBottomModals = Cryo.Dictionary.join(t7.conversationBottomModals, t8)
			})
		end

		Logger:warning(`DismissedAllConversationModalsForSequence received unsupported modal sequence: { modalSequence } `)

		return t7
	end,
	[AppChatNetworking.rodux.GetPendingStateModal.Succeeded.name] = function(t9: {[any]: any}, p7) -- line: 206
		-- upvalues: Cryo (copy)
		local v49 = p7.postBody and p7.postBody.conversation_id

		if not v49 then
			return t9
		end

		return Cryo.Dictionary.join(t9, {
			pendingStateModals = Cryo.Dictionary.join(t9.pendingStateModals, {
				[v49] = p7.responseBody
			})
		})
	end,
	[RemovedConversation.name] = function(t10: {[any]: any}, p8) -- line: 225
		-- upvalues: Cryo (copy)
		local conversationId = p8.conversationId

		if not conversationId then
			return t10
		end

		return Cryo.Dictionary.join(t10, {
			conversationTopModals = Cryo.Dictionary.join(t10.conversationTopModals, {
				[conversationId] = Cryo.None
			}),
			pendingStateModals = Cryo.Dictionary.join(t10.pendingStateModals, {
				[conversationId] = Cryo.None
			}),
			conversationBottomModals = Cryo.Dictionary.join(t10.conversationBottomModals, {
				[conversationId] = Cryo.None
			})
		})
	end,
	[FriendConversationCreated.name] = function(t11: {[any]: any}, p9) -- line: 243
		-- upvalues: Cryo (copy), FFlagAppChatEnableDoubleOptIn (copy)
		local oldFriendConversationId = p9.oldFriendConversationId
		local newConversationId = p9.newConversationId

		if not oldFriendConversationId or not newConversationId then
			return t11
		end

		local v57 = t11

		if t11.conversationTopModals[oldFriendConversationId] then
			v57 = Cryo.Dictionary.join(v57, {
				conversationTopModals = Cryo.Dictionary.join(v57.conversationTopModals, {
					[newConversationId] = t11.conversationTopModals[oldFriendConversationId],
					[oldFriendConversationId] = Cryo.None
				})
			})
		end

		if not FFlagAppChatEnableDoubleOptIn and t11.conversationTopModalsDismissed[oldFriendConversationId] then
			v57 = Cryo.Dictionary.join(v57, {
				conversationTopModalsDismissed = Cryo.Dictionary.join(v57.conversationTopModalsDismissed, {
					[newConversationId] = t11.conversationTopModalsDismissed[oldFriendConversationId],
					[oldFriendConversationId] = Cryo.None
				})
			})
		end

		if t11.conversationOverlays[oldFriendConversationId] then
			v57 = Cryo.Dictionary.join(v57, {
				conversationOverlays = Cryo.Dictionary.join(v57.conversationOverlays, {
					[newConversationId] = t11.conversationOverlays[oldFriendConversationId],
					[oldFriendConversationId] = Cryo.None
				})
			})
		end

		if t11.conversationBottomModals[oldFriendConversationId] then
			v57 = Cryo.Dictionary.join(v57, {
				conversationBottomModals = Cryo.Dictionary.join(v57.conversationBottomModals, {
					[newConversationId] = t11.conversationBottomModals[oldFriendConversationId],
					[oldFriendConversationId] = Cryo.None
				})
			})
		end

		return v57
	end,
	DEBUG_ShowChatLandingAgeVerifiedTimedModal = if not FFlagDebugAEGIS1AppChatBanner then nil else function(t12: {[any]: any}) -- line: 292
		-- upvalues: Cryo (copy), AppChatNetworking (copy)
		return Cryo.Dictionary.union(t12, {
			chatLandingModal = {
				modal_variant = AppChatNetworking.Constants.ChatLandingModalVariant.ChatLandingAgeVerifiedCommsTimedModal,
				modal_layout = {
					id = "asdf",
					dismissible = true,
					seen_record_action = "none",
					dismissed_record_action = "none",
					header = {
						text = "FAE Title",
						additional_content = {{
							text = "14 days left",
							type = AppChatNetworking.Constants.ModalContentType.Countdown
						}}
					},
					body = {
						text = "FAE debug Body",
						additional_content = {{
							text = "Learn more",
							type = AppChatNetworking.Constants.ModalContentType.Link
						}}
					},
					buttons = {
						{
							text = "Continue",
							action = {
								type = "open_fae_upsell"
							}
						},
						{
							text = "View Details",
							action = {
								type = "open_fae_view_details"
							}
						}
					}
				}
			}
		})
	end,
	DEBUG_ShowAppChatFaeUpsell = if not FFlagDebugAppChatFae then nil else function(t13: {[any]: any}) -- line: 340
		-- upvalues: Cryo (copy), AppChatNetworking (copy)
		return Cryo.Dictionary.union(t13, {
			chatLandingModal = {
				modal_variant = AppChatNetworking.Constants.ChatLandingModalVariant.AgeAssuranceUpsell,
				modal_layout = {
					id = "asdf",
					seen_record_action = "none",
					dismissed_record_action = "none",
					label = {
						text = "New"
					},
					header = {
						text = "FAE Title"
					},
					body = {
						text = "FAE debug Body",
						additional_content = {{
							text = "Learn more",
							type = AppChatNetworking.Constants.ModalContentType.Link
						}}
					},
					buttons = {{
						text = "Continue"
					}}
				}
			}
		})
	end,
	DEBUG_ShowNewTCOverlay = if not FFlagTCUpsellModalEnabled_DEV and not FFlagDebugEnableTCDoubleOptIn_DEV then nil else function(t14: {[any]: any}, p10) -- line: 374
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(t14, {
			conversationOverlays = Cryo.Dictionary.join(t14.conversationOverlays, {
				[p10.conversationId] = {
					modal_variant = p10.modalVariant,
					modal_layout = {
						id = "asdf",
						seen_record_action = "none",
						dismissed_record_action = "none"
					}
				}
			})
		})
	end,
	DEBUG_ShowNewTopModal = if not FFlagDebugEnableTCDoubleOptIn_DEV then nil else function(t15: {[any]: any}, p11) -- line: 390
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(t15, {
			conversationTopModals = Cryo.Dictionary.join(t15.conversationTopModals, {
				[p11.conversationId] = {
					modal_variant = p11.modalVariant,
					modal_layout = {
						id = "",
						seen_record_action = "none",
						dismissed_record_action = "none",
						body = {
							text = "Add Trusted Connection"
						},
						buttons = {{
							text = "Add"
						}}
					}
				}
			})
		})
	end,
	DEBUG_DismissChatLandingModal = if not FFlagDebugAppChatFae and not FFlagDebugAEGIS1AppChatBanner then nil else function(t16: {[any]: any}) -- line: 414
		-- upvalues: Cryo (copy)
		return Cryo.Dictionary.join(t16, {
			chatLandingModal = Cryo.None
		})
	end
})
