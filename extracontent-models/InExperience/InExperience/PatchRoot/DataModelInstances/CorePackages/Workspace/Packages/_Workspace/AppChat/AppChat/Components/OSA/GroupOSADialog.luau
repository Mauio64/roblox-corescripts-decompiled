local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local Time = require(parent.Time)
local DateTime = Time.DateTime

local Constants = require(AppChat.Constants)
local Conversation = require(AppChat.Models.Conversation)
local Logger = require(AppChat.Logger)
local v = Logger:new(script.Name)
local useGetConversationFromId = require(AppChat.Hooks.useGetConversationFromId)
local getDeepValue2 = require(AppChat.Utils.getDeepValue2)
local GetConversationStore = require(AppChat.Stores.GetConversationStore)
local ReceivedConversation = require(AppChat.Conversations.Actions.ReceivedConversation)
local ConversationRoduxSeed = require(AppChat.Utils.ConversationRoduxSeed)

local useRecordModalSequenceResponseForConversation = require(AppChat.Hooks.useRecordModalSequenceResponseForConversation)

local Foundation = require(parent.Foundation)
local Dialog = Foundation.Dialog
local DialogSize = Foundation.Enums.DialogSize

local ButtonVariant = Foundation.Enums.ButtonVariant
local BadgeVariant = Foundation.Enums.BadgeVariant
local Orientation = Foundation.Enums.Orientation
local Skeleton = Foundation.Skeleton
local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local InputHandlers = require(parent.InputHandlers)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local useDefaultFocusBehavior = ReactFocusNavigation.useDefaultFocusBehavior

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack
}

local Responsive = require(parent.Responsive)
local useLastInput = Responsive.useLastInput

local UserList = require(parent.UserList)
local UserRow = UserList.UserRow

local UserProfiles = require(parent.UserProfiles)
local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
local getCombinedNameFromId = UserProfiles.Selectors.getCombinedNameFromId

local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RoactUtils2 = require(parent.RoactUtils)
local useStore = RoactUtils2.Hooks.RoactRodux.useStore
local useEffect = React.useEffect
local RoactUtils3 = require(parent.RoactUtils)
local useSelector = RoactUtils3.Hooks.RoactRodux.useSelector
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId

local AppChatNetworking = require(parent.AppChatNetworking)
local api = AppChatNetworking.rodux.GetConversationDetails.API
local api2 = AppChatNetworking.rodux.RemoveUserFromConversation.API

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local AppTelemetryLayer = require(AppChat.Telemetry.Layers.AppTelemetryLayer)

local ConversationListOverlayTelemetry = require(AppChat.Components.OSA.ConversationListOverlayTelemetry)
local ModalTelemetry = require(AppChat.Components.ModalTelemetry)
local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local Enums = require(parent.SquadsCore.Enums)
local SquadPromptType = Enums.SquadPromptType

local shouldShowU13ChatOptInForConversation = require(AppChat.Utils.shouldShowU13ChatOptInForConversation)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatEnableU13ChatOptIn = SharedFlags.FFlagAppChatEnableU13ChatOptIn

local SharedFlags2 = require(parent.SharedFlags)
local FFlagFriendsChatEnableConversationConsent = SharedFlags2.FFlagFriendsChatEnableConversationConsent
local FFlagAppChatUseUserProfileHydration = require(AppChat.Flags.FFlagAppChatUseUserProfileHydration)
local useProfileName = require(AppChat.Hooks.useProfileName)
local DataHydration = require(parent.DataHydration)
local DataStatus = DataHydration.DataStatus
local defineFastString = game:DefineFastString(
	"AppChatGroupOsaViewDetailsUrl",
	"https://en.help.roblox.com/hc/en-us/articles/360000432483-Party-chat-In-App"
)

local InlineRichText = require(parent.InlineRichText)
local Renderer = InlineRichText.Renderer
local LinkBehavior = InlineRichText.Enums.LinkBehavior
local useAppPolicy = require(AppChat.Hooks.useAppPolicy)

local v2 = game.PlaceId > 0

local v3 = { source = nil, createdAt = nil, title = "" }

local ConversationListOverlay = Constants.ModalSequence.ConversationListOverlay
local OsaContextCard = Constants.OptInVariant.OsaContextCard
local Accept = Constants.ModalAction.Accept

local v4 = {
	dialogSize = DialogSize.Medium,
	disablePortal = false,
	hasBackdrop = true,
	onClose = function() end,
	onJoin = function() end,
	onDecline = function() end
}

local function resolveModalVariant(p, p2)
	if p then
		return p
	end

	if shouldShowU13ChatOptInForConversation(p2) then
		return Constants.OptInVariant.ChatOptInInfoCard
	end

	return OsaContextCard
end

local function GroupOSADialog(p)
	local union = Cryo.Dictionary.union(v4, p)
	local modalVariant

	if FFlagAppChatEnableU13ChatOptIn then
		modalVariant = union.modalVariant
	else
		modalVariant = OsaContextCard
	end

	local v5 = useDispatch()
	local v6 = useStore()
	local v7 = useLocalUserId()
	local v8 = useTokens()

	local v9 = useAppPolicy(function(p2)
		return p2.getWebViewSupport()
	end)

	local linkerOptions = React.useMemo(function()
		return {
			evaluateLinkBehavior = function(_, _)
				if v9 and not v2 then
					return LinkBehavior.Webview
				end

				return LinkBehavior.Hide
			end
		}
	end, { v9 })

	local state, setState = React.useState(false)
	useEffect(function()
		return function()
			setState(false)
		end
	end, {})

	local v10 = useTelemetry(AppTelemetryLayer.Context)
	useEffect(function()
		v10.emit(ConversationListOverlayTelemetry.Events.ModalRendered, {
			modalVariant = modalVariant,
			conversationId = union.conversationId,
			impressionId = union.impressionId
		})
	end, { v10, union.impressionId, union.conversationId, modalVariant })
	local v11 = React.useContext(SquadExternalContractContext)

	local v12 = useGetConversationFromId(union.conversationId)
	local v13 = v12 or v3

	if FFlagAppChatEnableU13ChatOptIn then
		local v14 = modalVariant

		if v14 then
			modalVariant = v14
		elseif shouldShowU13ChatOptInForConversation(v13) then
			modalVariant = Constants
			modalVariant = modalVariant.OptInVariant
			modalVariant = modalVariant.ChatOptInInfoCard
		else
			modalVariant = OsaContextCard
		end
	end

	useEffect(function()
		if not union.conversationId or v12 then
			return
		end

		if not FFlagFriendsChatEnableConversationConsent then
			v5(api(union.conversationId)):catch(function(p2)
				v:warning("Error fetching conversation in GroupOSADialog: " .. tostring(p2))
				union.onClose()
			end)
			return
		end

		local conversation = GetConversationStore(false).getConversation(union.conversationId, false)

		if conversation then
			v5(ReceivedConversation(ConversationRoduxSeed.normalizeStoreConversationForRodux(conversation)))
		end

		if not ConversationRoduxSeed.isFriendsPlaceholderConversationId(union.conversationId) then
			v5(api(union.conversationId)):catch(function(p2)
				v:warning("Error fetching conversation in GroupOSADialog: " .. tostring(p2))

				if conversation == nil then
					union.onClose()
				end
			end)
		end
	end, { v5, union.conversationId, v12, union.onClose })

	local source = v13.source

	local v14 = useSelector(function(p2)
		return getDeepValue2(p2, `ChatAppReducer.ParticipantMetadata.{union.conversationId or ""}`)
	end)

	useEffect(function()
		if source ~= "channels" or union.conversationId == nil then
			return
		end

		v5(AppChatNetworking.rodux.GetConversationsParticipantsMetadata.API({ union.conversationId })):catch(function()
			v:warning("Error in GroupOSADialog -> GetConversationsParticipantsMetadata")
		end)
	end, { v5, union.conversationId, source })

	local v15 = React.useMemo(function()
		if not v14 then
			return nil
		end

		for k, v15 in v14 do
			if v15.isInviter then
				return k
			end
		end

		return nil
	end, { v14 })

	local v16 = nil
	local v17 = nil

	if FFlagAppChatUseUserProfileHydration then
		v17 = useProfileName(v15)
	else
		v16 = useUserProfilesFetch({
			userIds = v15 and { v15 } or {},
			query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
		})
	end

	local v18 = React.useMemo(function()
		if v13 and v13.participants then
			return Cryo.List.filter(v13.participants, function(p2): boolean
				return tostring(p2) ~= v7
			end)
		end

		return {}
	end, { v13, v7 })

	local creation_date = React.useMemo(function()
		if v13.createdAt then
			return DateTime.fromIsoDate(v13.createdAt):Format("MMM DD, YYYY")
		end

		v:warning("Conversation createdAt not found for conversationId: " .. tostring(union.conversationId))
		return " - "
	end, { v13, union.conversationId })
	local data

	if v16 then
		data = v16.data
	else
		data = nil
	end

	local combinedName

	if FFlagAppChatUseUserProfileHydration then
		combinedName = v17.combinedName
	else
		combinedName = nil
	end

	local v19

	if FFlagAppChatUseUserProfileHydration then
		if v17.status == DataStatus.NotReady then
			v19 = combinedName == nil
		else
			v19 = false
		end
	else
		v19 = if v16 then v16.loading else false
	end

	local v20 = React.useMemo(function()
		if FFlagAppChatUseUserProfileHydration then
			return combinedName
		end

		if v15 and data then
			return getCombinedNameFromId(data, v15)
		end

		return nil
	end, { v15, data, combinedName })

	local v21 = v13.conversationType == Conversation.Type.MULTI_USER_CONVERSATION

	local v22 = useLocalization({
		titleText = "Feature.Chat.Heading.YouWereInvitedToGroup",
		inviterTitleText = {
			"Feature.Chat.Heading.UserInvitedYouToJoinAGroup",
			combinedName = v20 or ""
		},
		inviterTitleTextOneToOne = {
			"Feature.Chat.Heading.UserInvitedYouToJoin",
			combinedName = v20 or ""
		},
		subtitleText = {
			"Feature.Chat.Description.ConversationInviteGroupCreatedOn",
			creation_date = creation_date
		},
		footerText = {
			"Feature.Chat.Description.OSAGroupDescriptionWithLinker",
			osaViewDetailsUrl = defineFastString
		},
		joinButtonText = "Feature.Chat.Action.GroupOSAJoin",
		declineButtonText = "Feature.Chat.Action.GroupOSADoNotJoin",
		blockedText = "Feature.Chat.Label.Blocked"
	})

	local v23 = React.useMemo(function()
		local children = {}

		for k, v23 in v18 do
			local entityId = tostring(v23)

			local v24 = v14 and v14[entityId]

			if not v24 then
				v:debug("Metadata not found for participant: " .. entityId)
			end

			local isBlocked = v24 and v24.isBlocked

			local element = React.createElement(UserRow, {
				entityId = entityId,
				layoutMode = "wide",
				onActivated = union.onViewUserProfile ~= nil and function()
					union.onClose()
					union.onViewUserProfile(entityId, {})
				end or nil
			})

			children["Participant_" .. entityId] = React.createElement(
				Foundation.View,
				{ tag = "size-full-0 auto-y", LayoutOrder = k },
				{
					Row = element,
					Badge = isBlocked and React.createElement(
						Foundation.View,
						{ tag = "position-center-right anchor-center-right auto-xy", ZIndex = 2 },
						{
							BadgeContent = React.createElement(Foundation.Badge, {
								text = v22.blockedText,
								variant = BadgeVariant.Warning
							})
						}
					) or nil
				}
			)
		end

		return children
	end, { v18, v14, v22.blockedText, union.onViewUserProfile, union.onClose })

	local v24 = React.useCallback(function()
		v10.emit(ConversationListOverlayTelemetry.Events.ModalAction, {
			modalVariant = modalVariant,
			action = ModalTelemetry.Enums.ModalActions.Dismiss,
			conversationId = union.conversationId,
			impressionId = union.impressionId
		})

		union.onClose()
	end, { union.onClose, v10, union.impressionId, union.conversationId, modalVariant })

	local eventHandlers = React.useMemo(function()
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					v24()
					object:cancel()
				end)
			}
		}
	end, { v24 })

	local ref, ref2 = useDefaultFocusBehavior((useFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		shouldRestoreFocus = false,
		eventHandlers = eventHandlers,
		eventMap = navigateBacks
	})))

	local v25 = useLastInput() == Responsive.Input.Directional

	local v26 = React.useCallback(function()
		v11.setSquadPrompt(v6, { hideCancelButton = true, promptType = SquadPromptType.Error })
	end, { v11.setSquadPrompt, v6 })

	local v27 = useRecordModalSequenceResponseForConversation(union.conversationId)
	local onActivated = React.useCallback(function()
		if state then
			return
		end

		setState(true)

		local v28 = {
			modalVariant = modalVariant,
			action = ModalTelemetry.Enums.ModalActions.PrimaryCta,
			conversationId = union.conversationId,
			impressionId = union.impressionId
		}

		v10.emit(ConversationListOverlayTelemetry.Events.ModalAction, v28)
		v27(Accept, ConversationListOverlay, nil, modalVariant):andThen(function()
			v10.emit(
				ConversationListOverlayTelemetry.Events.ModalActionResult,
				Cryo.Dictionary.union(v28, {
					actionResult = ModalTelemetry.Enums.ModalActionResults.Success
				})
			)

			union.onJoin()
		end):catch(function(p2)
			v10.emit(
				ConversationListOverlayTelemetry.Events.ModalActionResult,
				Cryo.Dictionary.union(v28, {
					actionResult = ModalTelemetry.Enums.ModalActionResults.Failure
				})
			)

			v:warning(`Error in GroupOSADialog Join-> RecordModalSequenceResponse: {tostring(p2)}`)
			v26()
			union.onClose()
		end)
	end, {
		union.onJoin,
		union.onClose,
		v26,
		v27,
		v5,
		union.conversationId,
		modalVariant,
		v10,
		union.impressionId,
		state
	})

	local onActivated2 = React.useCallback(function()
		if state then
			return
		end

		setState(true)

		local v28 = {
			modalVariant = modalVariant,
			action = ModalTelemetry.Enums.ModalActions.SecondaryCta,
			conversationId = union.conversationId,
			impressionId = union.impressionId
		}

		v10.emit(ConversationListOverlayTelemetry.Events.ModalAction, v28)

		if union.conversationId then
			if v13.conversationType == Conversation.Type.MULTI_USER_CONVERSATION then
				v5(api2(union.conversationId, v7)):andThen(function()
					v10.emit(
						ConversationListOverlayTelemetry.Events.ModalActionResult,
						Cryo.Dictionary.union(v28, {
							actionResult = ModalTelemetry.Enums.ModalActionResults.Success
						})
					)

					union.onDecline()
				end):catch(function(p2)
					v10.emit(
						ConversationListOverlayTelemetry.Events.ModalActionResult,
						Cryo.Dictionary.union(v28, {
							actionResult = ModalTelemetry.Enums.ModalActionResults.Failure
						})
					)

					v:warning(`Error in GroupOSADialog Decline -> RemoveUserFromConversation: {tostring(p2)}`)

					v26()
					union.onClose()
				end)
			else
				v10.emit(
					ConversationListOverlayTelemetry.Events.ModalActionResult,
					Cryo.Dictionary.union(v28, {
						actionResult = ModalTelemetry.Enums.ModalActionResults.Success
					})
				)

				union.onDecline()
			end
		end
	end, {
		union.onDecline,
		union.onClose,
		v26,
		v5,
		union.conversationId,
		modalVariant,
		v13,
		v7,
		v10,
		union.impressionId,
		state,
		v7
	})
	local v28

	if v13.source == "channels" then
		v28 = v14 == nil
	else
		v28 = false
	end

	if v15 == nil then
		v19 = false
	end

	local v29 = not v12 or v28 or v19
	local text

	if v20 then
		if v21 then
			text = v22.inviterTitleText
		else
			text = v22.inviterTitleTextOneToOne
		end
	else
		text = v22.titleText
	end

	local v30 = React.useMemo(function()
		return React.createElement(Foundation.View, {
			tag = "col gap-medium size-full-0 auto-y margin-top-small"
		}, {
			Heading = React.createElement(Skeleton, {
				Size = UDim2.new(0.6, 0, 0, v8.Size.Size_1100),
				radius = Radius.Medium,
				LayoutOrder = 1
			}),
			Row1 = React.createElement(Skeleton, {
				Size = UDim2.new(1, 0, 0, v8.Size.Size_1200),
				radius = Radius.Medium,
				LayoutOrder = 2
			}),
			Row2 = React.createElement(Skeleton, {
				Size = UDim2.new(1, 0, 0, v8.Size.Size_1200),
				radius = Radius.Medium,
				LayoutOrder = 3
			}),
			Row3 = React.createElement(Skeleton, {
				Size = UDim2.new(1, 0, 0, v8.Size.Size_1200),
				radius = Radius.Medium,
				LayoutOrder = 4
			}),
			Footer = React.createElement(Skeleton, {
				Size = UDim2.new(1, 0, 0, v8.Size.Size_800),
				radius = Radius.Medium,
				LayoutOrder = 5
			})
		})
	end, { v8 })

	local v31 = React.useMemo(function()
		return React.createElement(Foundation.View, { tag = "col gap-medium size-full-0 auto-y" }, {
			DialogContentHeader = React.createElement(Dialog.Text, {
				Text = v22.subtitleText,
				LayoutOrder = 1
			}),
			GroupMemberList = React.createElement(
				Foundation.View,
				{ tag = "col size-full-0 auto-y", LayoutOrder = 2 },
				v23
			),
			DialogContentFooter = React.createElement(Renderer, {
				text = v22.footerText,
				textStyle = v8.Color.Content.Default,
				fontStyle = v8.Typography.BodyMedium,
				linkerOptions = linkerOptions,
				wrapperProps = { tag = "size-full-0 auto-y", LayoutOrder = 3 }
			})
		})
	end, {
		v22.subtitleText,
		v22.footerText,
		v23,
		v8.Color.Content.Default,
		v8.Typography.BodyMedium,
		linkerOptions
	})

	local createElement = React.createElement
	local root = Dialog.Root
	local v32 = {
		ref = ref2,
		size = union.dialogSize,
		onClose = 0,
		hasBackdrop = 0,
		disablePortal = 0
	}
	local onClose

	if not v25 then
		onClose = v24
	end

	v32.onClose = onClose
	v32.hasBackdrop = union.hasBackdrop
	v32.disablePortal = union.disablePortal
	local v45 = {
		DialogTitle = not v29 and React.createElement(Dialog.Title, { text = text, LayoutOrder = 1 }),
		DialogContent = 0,
		DialogActions = 0
	}

	local createElement2 = React.createElement
	local content = Dialog.Content

	if not v29 then
		v30 = v31
	end

	v45.DialogContent = createElement2(content, { LayoutOrder = 2 }, v30)

	v45.DialogActions = not v29 and React.createElement(Dialog.Actions, {
		LayoutOrder = 3,
		orientation = Orientation.Vertical,
		actions = {
			{
				text = v22.joinButtonText,
				variant = ButtonVariant.Emphasis,
				ref = ref,
				onActivated = onActivated,
				isDisabled = state
			},
			{
				text = v22.declineButtonText,
				variant = ButtonVariant.Standard,
				onActivated = onActivated2,
				isDisabled = state
			}
		}
	})
	return createElement(root, v32, v45)
end

return GroupOSADialog
