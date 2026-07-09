local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local Cryo = require(AppChatParent.Cryo)
local DateTime = require(AppChatParent.Time).DateTime
local Constants = require(AppChat.Constants)
local Conversation = require(AppChat.Models.Conversation)
local v8 = require(AppChat.Logger):new(script.Name)
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
local useRecordModalSequenceResponseForConversation = require(AppChat.Hooks.useRecordModalSequenceResponseForConversation)
local Foundation = require(AppChatParent.Foundation)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize
local ButtonVariant = Foundation.Enums.ButtonVariant
local BadgeVariant = Foundation.Enums.BadgeVariant
local EnumsOrientation = Foundation.Enums.Orientation
local Skeleton = Foundation.Skeleton
local EnumsRadius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens
local UserRow = require(AppChatParent.UserList).UserRow
local UserProfiles = require(AppChatParent.UserProfiles)
local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
local getCombinedNameFromId = UserProfiles.Selectors.getCombinedNameFromId
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useStore = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useStore
local useEffect = React.useEffect
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalUserId = require(AppChatParent.RobloxAppHooks).useLocalUserId
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local API = AppChatNetworking.rodux.GetConversationDetails.API
local API2 = AppChatNetworking.rodux.RemoveUserFromConversation.API
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local AppTelemetryLayer = require(AppChat.Telemetry.Layers.AppTelemetryLayer)
local ConversationListOverlayTelemetry = require(AppChat.Components.OSA.ConversationListOverlayTelemetry)
local ModalTelemetry = require(AppChat.Components.ModalTelemetry)
local SquadExternalContractContext = require(AppChatParent.SquadsCore.SquadExternalContractProvider).SquadExternalContractContext
local SquadPromptType = require(AppChatParent.SquadsCore.Enums).SquadPromptType
local shouldShowU13ChatOptInForConversation = require(AppChat.Utils.shouldShowU13ChatOptInForConversation)
local FFlagAppChatEnableU13ChatOptIn = require(AppChatParent.SharedFlags).FFlagAppChatEnableU13ChatOptIn
local FFlagSupportViewingUserProfileOnOSA = require(AppChat.Flags.FFlagSupportViewingUserProfileOnOSA)
local v43 = game:DefineFastString("AppChatGroupOsaViewDetailsUrl", "https://en.help.roblox.com/hc/en-us/articles/360000432483-Party-chat-In-App")
local InlineRichText = require(AppChatParent.InlineRichText)
local Renderer = InlineRichText.Renderer
local LinkBehavior = InlineRichText.Enums.LinkBehavior
local useAppPolicy = require(AppChat.Hooks.useAppPolicy)
local v48 = game.PlaceId > 0
local t1 = {
	source = nil,
	createdAt = nil,
	title = ""
}
local ConversationListOverlay = Constants.ModalSequence.ConversationListOverlay
local OsaContextCard = Constants.OptInVariant.OsaContextCard
local Accept = Constants.ModalAction.Accept
local t2 = {
	disablePortal = false,
	hasBackdrop = true,
	dialogSize = DialogSize.Medium,
	onClose = function() -- line: 99
	end,
	onJoin = function() -- line: 100
	end,
	onDecline = function() -- line: 101
	end
}

local function resolveModalVariant(p1, p2) -- line: 104
	-- upvalues: shouldShowU13ChatOptInForConversation (copy), Constants (copy), OsaContextCard (copy)
	if p1 then
		return p1
	end

	if shouldShowU13ChatOptInForConversation(p2) then
		return Constants.OptInVariant.ChatOptInInfoCard
	end

	return OsaContextCard
end
local function GroupOSADialog(t3: {[any]: any}) -- line: 118
	-- upvalues: Cryo (copy), t2 (copy), FFlagAppChatEnableU13ChatOptIn (copy), OsaContextCard (copy), useDispatch (copy), useStore (copy), useLocalUserId (copy), useTokens (copy), useAppPolicy (copy), React (copy), v48 (copy), LinkBehavior (copy), useEffect (copy), useTelemetry (copy), AppTelemetryLayer (copy), ConversationListOverlayTelemetry (copy), SquadExternalContractContext (copy), useGetConversationFromId (copy), t1 (copy), shouldShowU13ChatOptInForConversation (copy), Constants (copy), API (copy), v8 (copy), useSelector (copy), getDeepValue2 (copy), AppChatNetworking (copy), useUserProfilesFetch (copy), UserProfiles (copy), DateTime (copy), getCombinedNameFromId (copy), Conversation (copy), useLocalization (copy), v43 (copy), UserRow (copy), Foundation (copy), BadgeVariant (copy), FFlagSupportViewingUserProfileOnOSA (copy), ModalTelemetry (copy), SquadPromptType (copy), useRecordModalSequenceResponseForConversation (copy), Accept (copy), ConversationListOverlay (copy), API2 (copy), Skeleton (copy), EnumsRadius (copy), Dialog (copy), Renderer (copy), EnumsOrientation (copy), ButtonVariant (copy)
	local v59 = Cryo.Dictionary.union(t2, t3)
	local u60 = if not FFlagAppChatEnableU13ChatOptIn then OsaContextCard else v59.modalVariant
	local v61 = useDispatch()
	local v62 = useStore()
	local v63 = useLocalUserId()
	local v64 = useTokens()
	local v65 = useAppPolicy(function(p3) -- line: 129
		return p3.getWebViewSupport()
	end)
	local v66 = React.useMemo(function() -- line: 132
		-- upvalues: v65 (copy), v48 (copy), LinkBehavior (copy)
		return {
			evaluateLinkBehavior = function(_, _) -- line: 134
				-- upvalues: v65 (copy), v48 (copy), LinkBehavior (copy)
				if v65 and not v48 then
					return LinkBehavior.Webview
				end

				return LinkBehavior.Hide
			end
		}
	end, { v65 })
	local v67, v68 = React.useState(false)

	useEffect(function() -- line: 145
		-- upvalues: v68 (copy)
		return function() -- line: 146
			-- upvalues: v68 (copy)
			v68(false)
		end
	end, {})

	local v69 = useTelemetry(AppTelemetryLayer.Context)

	useEffect(function() -- line: 152
		-- upvalues: v69 (copy), ConversationListOverlayTelemetry (copy), u60 (ref), v59 (copy)
		v69.emit(ConversationListOverlayTelemetry.Events.ModalRendered, {
			modalVariant = u60,
			conversationId = v59.conversationId,
			impressionId = v59.impressionId
		})
	end, {
		v69,
		v59.impressionId,
		v59.conversationId,
		u60
	})

	local v70 = React.useContext(SquadExternalContractContext)
	local v71 = useGetConversationFromId(v59.conversationId)
	local v72 = v71 or t1

	if FFlagAppChatEnableU13ChatOptIn then
		local v73 = u60

		if v73 then
			u60 = v73
		elseif shouldShowU13ChatOptInForConversation(v72) then
			u60 = Constants
			u60 = u60.OptInVariant
			u60 = u60.ChatOptInInfoCard
		else
			u60 = OsaContextCard
		end
	end

	useEffect(function() -- line: 167
		-- upvalues: v59 (copy), v71 (copy), v61 (copy), API (copy), v8 (copy)
		if v59.conversationId and not v71 then
			v61(API(v59.conversationId)):catch(function(p6) -- line: 169
				-- upvalues: v8 (copy), v59 (copy)
				v8:warning("Error fetching conversation in GroupOSADialog: " .. tostring(p6))
				v59.onClose()
			end)
		end
	end, {
		v61,
		v59.conversationId,
		v71,
		v59.onClose
	})

	local source = v72.source
	local u75 = useSelector(function(p7) -- line: 179
		-- upvalues: getDeepValue2 (copy), v59 (copy)
		return getDeepValue2(p7, `ChatAppReducer.ParticipantMetadata.{ v59.conversationId or "" }`)
	end)

	useEffect(function() -- line: 183
		-- upvalues: source (copy), v59 (copy), v61 (copy), AppChatNetworking (copy), v8 (copy)
		if source ~= "channels" or v59.conversationId == nil then
			return
		end

		v61(AppChatNetworking.rodux.GetConversationsParticipantsMetadata.API({ v59.conversationId })):catch(function() -- line: 189
			-- upvalues: v8 (copy)
			v8:warning("Error in GroupOSADialog -> GetConversationsParticipantsMetadata")
		end)
	end, {
		v61,
		v59.conversationId,
		source
	})

	local v76 = React.useMemo(function() -- line: 194
		-- upvalues: u75 (ref)
		if not u75 then
			return nil
		end

		for v99, v100 in u75 do
			if v100.isInviter then
				return v99
			end
		end

		return nil
	end, { u75 })
	local v77 = useUserProfilesFetch({
		userIds = if not v76 then {} else { v76 },
		query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
	})
	local v78 = React.useMemo(function() -- line: 213
		-- upvalues: v72 (copy), Cryo (copy), v63 (copy)
		if not v72 or not v72.participants then
			return {}
		end

		return Cryo.List.filter(v72.participants, function(p8) -- line: 217
			-- upvalues: v63 (copy)
			return tostring(p8) ~= v63
		end)
	end, {
		v72,
		v63
	})
	local v79 = React.useMemo(function() -- line: 223
		-- upvalues: v72 (copy), DateTime (copy), v8 (copy), v59 (copy)
		if v72.createdAt then
			return DateTime.fromIsoDate(v72.createdAt):Format("MMM DD, YYYY")
		end

		v8:warning("Conversation createdAt not found for conversationId: " .. tostring(v59.conversationId))

		return " - "
	end, {
		v72,
		v59.conversationId
	})
	local v80 = if not v77 then nil else v77.data
	local v81 = not not v77 and v77.loading
	local v82 = React.useMemo(function() -- line: 233
		-- upvalues: v76 (copy), v80 (copy), getCombinedNameFromId (copy)
		if not v76 or not v80 then
			return nil
		end

		return getCombinedNameFromId(v80, v76)
	end, {
		v76,
		v80
	})
	local v83 = v72.conversationType == Conversation.Type.MULTI_USER_CONVERSATION
	local v84 = useLocalization({
		titleText = "Feature.Chat.Heading.YouWereInvitedToGroup",
		joinButtonText = "Feature.Chat.Action.GroupOSAJoin",
		declineButtonText = "Feature.Chat.Action.GroupOSADoNotJoin",
		blockedText = "Feature.Chat.Label.Blocked",
		inviterTitleText = {
			"Feature.Chat.Heading.UserInvitedYouToJoinAGroup",
			combinedName = v82 or ""
		},
		inviterTitleTextOneToOne = {
			"Feature.Chat.Heading.UserInvitedYouToJoin",
			combinedName = v82 or ""
		},
		subtitleText = {
			"Feature.Chat.Description.ConversationInviteGroupCreatedOn",
			creation_date = v79
		},
		footerText = {
			"Feature.Chat.Description.OSAGroupDescriptionWithLinker",
			osaViewDetailsUrl = v43
		}
	})
	local v85 = React.useMemo(function() -- line: 266
		-- upvalues: v78 (copy), u75 (ref), v8 (copy), React (copy), UserRow (copy), v59 (copy), Foundation (copy), v84 (copy), BadgeVariant (copy)
		local t4 = {}

		for v102, v103 in v78 do
			local str = tostring(v103)
			local v105 = u75 and u75[str]

			if not v105 then
				v8:debug("Metadata not found for participant: " .. str)
			end

			local v106 = v105 and v105.isBlocked
			local v107 = React.createElement(UserRow, {
				layoutMode = "wide",
				entityId = str,
				onActivated = if v59.onViewUserProfile == nil then nil else function() -- line: 284
					-- upvalues: v59 (copy), str (copy)
					v59.onClose()
					v59.onViewUserProfile(str, {})
				end
			})

			t4["Participant_" .. str] = React.createElement(Foundation.View, {
				tag = "size-full-0 auto-y",
				LayoutOrder = v102
			}, {
				Row = v107,
				Badge = v106 and React.createElement(Foundation.View, {
					tag = "position-center-right anchor-center-right auto-xy",
					ZIndex = 2
				}, {
					BadgeContent = React.createElement(Foundation.Badge, {
						text = v84.blockedText,
						variant = BadgeVariant.Warning
					})
				}) or nil
			})
		end

		return t4
	end, {
		v78,
		u75,
		v84.blockedText,
		if not FFlagSupportViewingUserProfileOnOSA then nil else v59.onViewUserProfile,
		if not FFlagSupportViewingUserProfileOnOSA then nil else v59.onClose
	})
	local v86 = React.useCallback(function() -- line: 318
		-- upvalues: v69 (copy), ConversationListOverlayTelemetry (copy), u60 (ref), ModalTelemetry (copy), v59 (copy)
		v69.emit(ConversationListOverlayTelemetry.Events.ModalAction, {
			modalVariant = u60,
			action = ModalTelemetry.Enums.ModalActions.Dismiss,
			conversationId = v59.conversationId,
			impressionId = v59.impressionId
		})
		v59.onClose()
	end, {
		v59.onClose,
		v69,
		v59.impressionId,
		v59.conversationId,
		u60
	})
	local v87 = React.useCallback(function() -- line: 327
		-- upvalues: v70 (copy), v62 (copy), SquadPromptType (copy)
		v70.setSquadPrompt(v62, {
			hideCancelButton = true,
			promptType = SquadPromptType.Error
		})
	end, {
		v70.setSquadPrompt,
		v62
	})
	local v88 = useRecordModalSequenceResponseForConversation(v59.conversationId)
	local v89 = React.useCallback(function() -- line: 336
		-- upvalues: v67 (copy), v68 (copy), u60 (ref), ModalTelemetry (copy), v59 (copy), v69 (copy), ConversationListOverlayTelemetry (copy), v88 (copy), Accept (copy), ConversationListOverlay (copy), Cryo (copy), v8 (copy), v87 (copy)
		if v67 then
			return
		end

		v68(true)

		local t5 = {
			modalVariant = u60,
			action = ModalTelemetry.Enums.ModalActions.PrimaryCta,
			conversationId = v59.conversationId,
			impressionId = v59.impressionId
		}

		v69.emit(ConversationListOverlayTelemetry.Events.ModalAction, t5)
		v88(Accept, ConversationListOverlay, nil, u60):andThen(function() -- line: 350
			-- upvalues: v69 (copy), ConversationListOverlayTelemetry (copy), Cryo (copy), t5 (copy), ModalTelemetry (copy), v59 (copy)
			v69.emit(ConversationListOverlayTelemetry.Events.ModalActionResult, Cryo.Dictionary.union(t5, {
				actionResult = ModalTelemetry.Enums.ModalActionResults.Success
			}))
			v59.onJoin()
		end):catch(function(p9) -- line: 359
			-- upvalues: v69 (copy), ConversationListOverlayTelemetry (copy), Cryo (copy), t5 (copy), ModalTelemetry (copy), v8 (copy), v87 (copy), v59 (copy)
			v69.emit(ConversationListOverlayTelemetry.Events.ModalActionResult, Cryo.Dictionary.union(t5, {
				actionResult = ModalTelemetry.Enums.ModalActionResults.Failure
			}))
			v8:warning(`Error in GroupOSADialog Join-> RecordModalSequenceResponse: { tostring(p9) }`)
			v87()
			v59.onClose()
		end)
	end, {
		v59.onJoin,
		v59.onClose,
		v87,
		v88,
		v61,
		v59.conversationId,
		u60,
		v69,
		v59.impressionId,
		v67
	})
	local v90 = React.useCallback(function() -- line: 385
		-- upvalues: v67 (copy), v68 (copy), u60 (ref), ModalTelemetry (copy), v59 (copy), v69 (copy), ConversationListOverlayTelemetry (copy), v72 (copy), Conversation (copy), v61 (copy), API2 (copy), v63 (copy), Cryo (copy), v8 (copy), v87 (copy)
		if v67 then
			return
		end

		v68(true)

		local t6 = {
			modalVariant = u60,
			action = ModalTelemetry.Enums.ModalActions.SecondaryCta,
			conversationId = v59.conversationId,
			impressionId = v59.impressionId
		}

		v69.emit(ConversationListOverlayTelemetry.Events.ModalAction, t6)

		if v59.conversationId then
			if v72.conversationType == Conversation.Type.MULTI_USER_CONVERSATION then
				v61(API2(v59.conversationId, v63)):andThen(function() -- line: 402
					-- upvalues: v69 (copy), ConversationListOverlayTelemetry (copy), Cryo (copy), t6 (copy), ModalTelemetry (copy), v59 (copy)
					v69.emit(ConversationListOverlayTelemetry.Events.ModalActionResult, Cryo.Dictionary.union(t6, {
						actionResult = ModalTelemetry.Enums.ModalActionResults.Success
					}))
					v59.onDecline()
				end):catch(function(p10) -- line: 411
					-- upvalues: v69 (copy), ConversationListOverlayTelemetry (copy), Cryo (copy), t6 (copy), ModalTelemetry (copy), v8 (copy), v87 (copy), v59 (copy)
					v69.emit(ConversationListOverlayTelemetry.Events.ModalActionResult, Cryo.Dictionary.union(t6, {
						actionResult = ModalTelemetry.Enums.ModalActionResults.Failure
					}))
					v8:warning(`Error in GroupOSADialog Decline -> RemoveUserFromConversation: { tostring(p10) }`)
					v87()
					v59.onClose()
				end)

				return
			end

			v69.emit(ConversationListOverlayTelemetry.Events.ModalActionResult, Cryo.Dictionary.union(t6, {
				actionResult = ModalTelemetry.Enums.ModalActionResults.Success
			}))
			v59.onDecline()
		end
	end, {
		v59.onDecline,
		v59.onClose,
		v87,
		v61,
		v59.conversationId,
		u60,
		v72,
		v63,
		v69,
		v59.impressionId,
		v67,
		v63
	})
	local v91 = v72.source == "channels" and u75 == nil
	local v92 = v76 ~= nil and v81
	local v93 = not v71 or (v91 or v92)
	local v94 = if not v82 then v84.titleText else if not v83 then v84.inviterTitleTextOneToOne else v84.inviterTitleText
	local v95 = React.useMemo(function() -- line: 465
		-- upvalues: React (copy), Foundation (copy), Skeleton (copy), v64 (copy), EnumsRadius (copy)
		return React.createElement(Foundation.View, {
			tag = "col gap-medium size-full-0 auto-y margin-top-small"
		}, {
			Heading = React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.new(0.6, 0, 0, v64.Size.Size_1100),
				radius = EnumsRadius.Medium
			}),
			Row1 = React.createElement(Skeleton, {
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, v64.Size.Size_1200),
				radius = EnumsRadius.Medium
			}),
			Row2 = React.createElement(Skeleton, {
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, v64.Size.Size_1200),
				radius = EnumsRadius.Medium
			}),
			Row3 = React.createElement(Skeleton, {
				LayoutOrder = 4,
				Size = UDim2.new(1, 0, 0, v64.Size.Size_1200),
				radius = EnumsRadius.Medium
			}),
			Footer = React.createElement(Skeleton, {
				LayoutOrder = 5,
				Size = UDim2.new(1, 0, 0, v64.Size.Size_800),
				radius = EnumsRadius.Medium
			})
		})
	end, { v64 })
	local v96 = React.useMemo(function() -- line: 498
		-- upvalues: React (copy), Foundation (copy), Dialog (copy), v84 (copy), v85 (copy), Renderer (copy), v64 (copy), v66 (copy)
		return React.createElement(Foundation.View, {
			tag = "col gap-medium size-full-0 auto-y"
		}, {
			DialogContentHeader = React.createElement(Dialog.Text, {
				LayoutOrder = 1,
				Text = v84.subtitleText
			}),
			GroupMemberList = React.createElement(Foundation.View, {
				tag = "col size-full-0 auto-y",
				LayoutOrder = 2
			}, v85),
			DialogContentFooter = React.createElement(Renderer, {
				text = v84.footerText,
				textStyle = v64.Color.Content.Default,
				fontStyle = v64.Typography.BodyMedium,
				linkerOptions = v66,
				wrapperProps = {
					tag = "size-full-0 auto-y",
					LayoutOrder = 3
				}
			})
		})
	end, {
		v84.subtitleText,
		v84.footerText,
		v85,
		v64.Color.Content.Default,
		v64.Typography.BodyMedium,
		v66
	})

	return React.createElement(Dialog.Root, {
		size = v59.dialogSize,
		onClose = v86,
		hasBackdrop = v59.hasBackdrop,
		disablePortal = v59.disablePortal
	}, {
		DialogTitle = not v93 and React.createElement(Dialog.Title, {
			LayoutOrder = 1,
			text = v94
		}),
		DialogContent = React.createElement(Dialog.Content, {
			LayoutOrder = 2
		}, if not v93 then v96 else v95),
		DialogActions = not v93 and React.createElement(Dialog.Actions, {
			LayoutOrder = 3,
			orientation = EnumsOrientation.Vertical,
			actions = {
				{
					text = v84.joinButtonText,
					variant = ButtonVariant.Emphasis,
					onActivated = v89,
					isDisabled = v67
				},
				{
					text = v84.declineButtonText,
					variant = ButtonVariant.Standard,
					onActivated = v90,
					isDisabled = v67
				}
			}
		})
	})
end

return GroupOSADialog
