local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local dateTime = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Time").DateTime

local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Constants")
local Conversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Models/Conversation")
local v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger"):new("GroupOSADialog")
local useGetConversationFromId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useGetConversationFromId")
local getDeepValue2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/getDeepValue2")
local GetConversationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetConversationStore")
local ReceivedConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Actions/ReceivedConversation")
local ConversationRoduxSeed = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/ConversationRoduxSeed")

local useRecordModalSequenceResponseForConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useRecordModalSequenceResponseForConversation")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local dialog = Foundation.Dialog
local dialogSize = Foundation.Enums.DialogSize

local buttonVariant = Foundation.Enums.ButtonVariant
local badgeVariant = Foundation.Enums.BadgeVariant
local orientation = Foundation.Enums.Orientation
local skeleton = Foundation.Skeleton
local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/InputHandlers")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FocusNavigationUtils")
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot
local useDefaultFocusBehavior = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ReactFocusNavigation").useDefaultFocusBehavior

local navigateBacks = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack
}

local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Responsive")
local useLastInput = Responsive.useLastInput

local userRow = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserList").UserRow

local UserProfiles = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UserProfiles")
local useUserProfilesFetch = UserProfiles.Hooks.useUserProfilesFetch
local getCombinedNameFromId = UserProfiles.Selectors.getCombinedNameFromId

local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useStore
local useEffect = React.useEffect
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppHooks").useLocalUserId

local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local api = AppChatNetworking.rodux.GetConversationDetails.API
local api2 = AppChatNetworking.rodux.RemoveUserFromConversation.API

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Localization").Hooks.useLocalization

local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")
local AppTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/AppTelemetryLayer")

local ConversationListOverlayTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/OSA/ConversationListOverlayTelemetry")
local ModalTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ModalTelemetry")
local squadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/SquadExternalContractProvider").SquadExternalContractContext
local squadPromptType = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/Enums").SquadPromptType

local shouldShowU13ChatOptInForConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/shouldShowU13ChatOptInForConversation")

local fFlagAppChatEnableU13ChatOptIn = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatEnableU13ChatOptIn

local fFlagFriendsChatEnableConversationConsent = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagFriendsChatEnableConversationConsent
local FFlagAppChatUseUserProfileHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseUserProfileHydration")
local useProfileName = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useProfileName")
local dataStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/DataHydration").DataStatus
local defineFastString = game:DefineFastString(
	"AppChatGroupOsaViewDetailsUrl",
	"https://en.help.roblox.com/hc/en-us/articles/360000432483-Party-chat-In-App"
)

local InlineRichText = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/InlineRichText")
local renderer = InlineRichText.Renderer
local linkBehavior = InlineRichText.Enums.LinkBehavior
local module25 = require("@luauforge/bundled/fNh")

local v6 = game.PlaceId > 0

local v7 = { source = nil, createdAt = nil, title = "" }

local conversationListOverlay = Constants.ModalSequence.ConversationListOverlay
local osaContextCard = Constants.OptInVariant.OsaContextCard
local accept = Constants.ModalAction.Accept

local v8 = {
	dialogSize = dialogSize.Medium,
	disablePortal = false,
	hasBackdrop = true,
	onClose = function() end,
	onJoin = function() end,
	onDecline = function() end
}

local function resolveModalVariant(p2, p3)
	if p2 then
		return p2
	end

	if shouldShowU13ChatOptInForConversation(p3) then
		return Constants.OptInVariant.ChatOptInInfoCard
	end

	return osaContextCard
end

local function GroupOSADialog(p2)
	local union = Cryo.Dictionary.union(v8, p2)

	local v9 = if fFlagAppChatEnableU13ChatOptIn then union.modalVariant else osaContextCard

	local v10 = useDispatch()
	local v11 = useStore()
	local v12 = useLocalUserId()
	local v13 = useTokens()

	local v14 = module25(function(p3)
		return p3.getWebViewSupport()
	end)

	local v15 = React.useMemo(function()
		return {
			evaluateLinkBehavior = function(p3, p4)
				if v14 and not v6 then
					return linkBehavior.Webview
				end

				return linkBehavior.Hide
			end
		}
	end, { v14 })

	local state, setState = React.useState(false)
	useEffect(function()
		return function()
			setState(false)
		end
	end, {})

	local v16 = useTelemetry(AppTelemetryLayer.Context)
	useEffect(function()
		v16.emit(ConversationListOverlayTelemetry.Events.ModalRendered, {
			modalVariant = v9,
			conversationId = union.conversationId,
			impressionId = union.impressionId
		})
	end, { v16, union.impressionId, union.conversationId, v9 })
	local v17 = React.useContext(squadExternalContractContext)

	local v18 = useGetConversationFromId(union.conversationId)
	local v19 = v18 or v7

	if fFlagAppChatEnableU13ChatOptIn then
		local v20 = v9

		if v20 then
			v9 = v20
		elseif shouldShowU13ChatOptInForConversation(v19) then
			v9 = Constants
			v9 = v9.OptInVariant
			v9 = v9.ChatOptInInfoCard
		else
			v9 = osaContextCard
		end
	end

	useEffect(function()
		if not union.conversationId or v18 then
			return
		end

		if not fFlagFriendsChatEnableConversationConsent then
			v10(api(union.conversationId)):catch(function(p3)
				v5:warning("Error fetching conversation in GroupOSADialog: " .. tostring(p3))
				union.onClose()
			end)
			return
		end

		local conversation = GetConversationStore(false).getConversation(union.conversationId, false)

		if conversation then
			v10(ReceivedConversation(ConversationRoduxSeed.normalizeStoreConversationForRodux(conversation)))
		end

		if not ConversationRoduxSeed.isFriendsPlaceholderConversationId(union.conversationId) then
			v10(api(union.conversationId)):catch(function(p3)
				v5:warning("Error fetching conversation in GroupOSADialog: " .. tostring(p3))

				if conversation == nil then
					union.onClose()
				end
			end)
		end
	end, { v10, union.conversationId, v18, union.onClose })

	local source = v19.source

	local v20 = useSelector(function(p3)
		return getDeepValue2(p3, `ChatAppReducer.ParticipantMetadata.{union.conversationId or ""}`)
	end)

	useEffect(function()
		if source ~= "channels" or union.conversationId == nil then
			return
		end

		v10(AppChatNetworking.rodux.GetConversationsParticipantsMetadata.API({ union.conversationId })):catch(function()
			v5:warning("Error in GroupOSADialog -> GetConversationsParticipantsMetadata")
		end)
	end, { v10, union.conversationId, source })

	local v21 = React.useMemo(function()
		if not v20 then
			return nil
		end

		for k, v22 in v20 do
			if v22.isInviter then
				return k
			end
		end

		return nil
	end, { v20 })

	local v22 = nil
	local v23 = nil

	if FFlagAppChatUseUserProfileHydration then
		v23 = useProfileName(v21)
	else
		v22 = useUserProfilesFetch({
			userIds = v21 and { v21 } or {},
			query = UserProfiles.Queries.userProfilesCombinedNameAndUsernameByUserIds
		})
	end

	local v24 = React.useMemo(function()
		if v19 and v19.participants then
			return Cryo.List.filter(v19.participants, function(p3): boolean
				return tostring(p3) ~= v12
			end)
		end

		return {}
	end, { v19, v12 })

	local v25 = React.useMemo(function()
		if v19.createdAt then
			return dateTime.fromIsoDate(v19.createdAt):Format("MMM DD, YYYY")
		end

		v5:warning("Conversation createdAt not found for conversationId: " .. tostring(union.conversationId))
		return " - "
	end, { v19, union.conversationId })

	local data = if v22 then v22.data else nil
	local combinedName = if FFlagAppChatUseUserProfileHydration then v23.combinedName else nil
	local v26

	if FFlagAppChatUseUserProfileHydration then
		v26 = v23.status == dataStatus.NotReady and combinedName == nil
	else
		v26 = if v22 then v22.loading else false
	end

	local v27 = React.useMemo(function()
		if FFlagAppChatUseUserProfileHydration then
			return combinedName
		end

		if v21 and data then
			return getCombinedNameFromId(data, v21)
		end

		return nil
	end, { v21, data, combinedName })

	local v28 = v19.conversationType == Conversation.Type.MULTI_USER_CONVERSATION

	local v29 = useLocalization({
		titleText = "Feature.Chat.Heading.YouWereInvitedToGroup",
		inviterTitleText = {
			"Feature.Chat.Heading.UserInvitedYouToJoinAGroup",
			combinedName = v27 or ""
		},
		inviterTitleTextOneToOne = {
			"Feature.Chat.Heading.UserInvitedYouToJoin",
			combinedName = v27 or ""
		},
		subtitleText = {
			"Feature.Chat.Description.ConversationInviteGroupCreatedOn",
			creation_date = v25
		},
		footerText = {
			"Feature.Chat.Description.OSAGroupDescriptionWithLinker",
			osaViewDetailsUrl = defineFastString
		},
		joinButtonText = "Feature.Chat.Action.GroupOSAJoin",
		declineButtonText = "Feature.Chat.Action.GroupOSADoNotJoin",
		blockedText = "Feature.Chat.Label.Blocked"
	})

	local v30 = React.useMemo(function()
		local children = {}

		for k, v31 in v24 do
			local v32 = tostring(v31)

			local v33 = v20 and v20[v32]

			if not v33 then
				v5:debug("Metadata not found for participant: " .. v32)
			end

			local isBlocked = v33 and v33.isBlocked

			local element = React.createElement(userRow, {
				entityId = v32,
				layoutMode = "wide",
				onActivated = union.onViewUserProfile ~= nil and function()
					union.onClose()
					union.onViewUserProfile(v32, {})
				end or nil
			})

			children["Participant_" .. v32] = React.createElement(
				Foundation.View,
				{ tag = "size-full-0 auto-y", LayoutOrder = k },
				{
					Row = element,
					Badge = isBlocked and React.createElement(
						Foundation.View,
						{
							tag = "position-center-right anchor-center-right auto-xy",
							ZIndex = 2
						},
						{
							BadgeContent = React.createElement(Foundation.Badge, {
								text = v29.blockedText,
								variant = badgeVariant.Warning
							})
						}
					) or nil
				}
			)
		end

		return children
	end, { v24, v20, v29.blockedText, union.onViewUserProfile, union.onClose })

	local v31 = React.useCallback(function()
		v16.emit(ConversationListOverlayTelemetry.Events.ModalAction, {
			modalVariant = v9,
			action = ModalTelemetry.Enums.ModalActions.Dismiss,
			conversationId = union.conversationId,
			impressionId = union.impressionId
		})

		union.onClose()
	end, { union.onClose, v16, union.impressionId, union.conversationId, v9 })

	local v32 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					v31()
					object:cancel()
				end)
			}
		}
	end, { v31 })

	local v34, v35 = useDefaultFocusBehavior((useFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = true,
		shouldRestoreFocus = false,
		eventHandlers = v32,
		eventMap = navigateBacks
	})))

	local v36 = useLastInput() == Responsive.Input.Directional

	local v37 = React.useCallback(function()
		v17.setSquadPrompt(v11, {
			hideCancelButton = true,
			promptType = squadPromptType.Error
		})
	end, { v17.setSquadPrompt, v11 })

	local v38 = useRecordModalSequenceResponseForConversation(union.conversationId)
	local v39 = React.useCallback(function()
		if state then
			return
		end

		setState(true)

		local v40 = {
			modalVariant = v9,
			action = ModalTelemetry.Enums.ModalActions.PrimaryCta,
			conversationId = union.conversationId,
			impressionId = union.impressionId
		}

		v16.emit(ConversationListOverlayTelemetry.Events.ModalAction, v40)
		v38(accept, conversationListOverlay, nil, v9):andThen(function()
			v16.emit(
				ConversationListOverlayTelemetry.Events.ModalActionResult,
				Cryo.Dictionary.union(v40, {
					actionResult = ModalTelemetry.Enums.ModalActionResults.Success
				})
			)

			union.onJoin()
		end):catch(function(p3)
			v16.emit(
				ConversationListOverlayTelemetry.Events.ModalActionResult,
				Cryo.Dictionary.union(v40, {
					actionResult = ModalTelemetry.Enums.ModalActionResults.Failure
				})
			)

			v5:warning(`Error in GroupOSADialog Join-> RecordModalSequenceResponse: {tostring(p3)}`)
			v37()
			union.onClose()
		end)
	end, {
		union.onJoin,
		union.onClose,
		v37,
		v38,
		v10,
		union.conversationId,
		v9,
		v16,
		union.impressionId,
		state
	})

	local v40 = React.useCallback(function()
		if state then
			return
		end

		setState(true)

		local v41 = {
			modalVariant = v9,
			action = ModalTelemetry.Enums.ModalActions.SecondaryCta,
			conversationId = union.conversationId,
			impressionId = union.impressionId
		}

		v16.emit(ConversationListOverlayTelemetry.Events.ModalAction, v41)

		if union.conversationId then
			if v19.conversationType == Conversation.Type.MULTI_USER_CONVERSATION then
				v10(api2(union.conversationId, v12)):andThen(function()
					v16.emit(
						ConversationListOverlayTelemetry.Events.ModalActionResult,
						Cryo.Dictionary.union(v41, {
							actionResult = ModalTelemetry.Enums.ModalActionResults.Success
						})
					)

					union.onDecline()
				end):catch(function(p3)
					v16.emit(
						ConversationListOverlayTelemetry.Events.ModalActionResult,
						Cryo.Dictionary.union(v41, {
							actionResult = ModalTelemetry.Enums.ModalActionResults.Failure
						})
					)

					v5:warning(`Error in GroupOSADialog Decline -> RemoveUserFromConversation: {tostring(p3)}`)

					v37()
					union.onClose()
				end)
			else
				v16.emit(
					ConversationListOverlayTelemetry.Events.ModalActionResult,
					Cryo.Dictionary.union(v41, {
						actionResult = ModalTelemetry.Enums.ModalActionResults.Success
					})
				)

				union.onDecline()
			end
		end
	end, {
		union.onDecline,
		union.onClose,
		v37,
		v10,
		union.conversationId,
		v9,
		v19,
		v12,
		v16,
		union.impressionId,
		state,
		v12
	})

	local v42 = v19.source == "channels" and v20 == nil

	if v21 == nil then
		v26 = false
	end

	local v43 = not v18 or v42 or v26
	local v44

	if v27 then
		v44 = if v28 then v29.inviterTitleText else v29.inviterTitleTextOneToOne
	else
		v44 = v29.titleText
	end

	local v45 = React.useMemo(function()
		return React.createElement(
			Foundation.View,
			{ tag = "col gap-medium size-full-0 auto-y margin-top-small" },
			{
				Heading = React.createElement(skeleton, {
					Size = UDim2.new(0.6, 0, 0, v13.Size.Size_1100),
					radius = radius.Medium,
					LayoutOrder = 1
				}),
				Row1 = React.createElement(skeleton, {
					Size = UDim2.new(1, 0, 0, v13.Size.Size_1200),
					radius = radius.Medium,
					LayoutOrder = 2
				}),
				Row2 = React.createElement(skeleton, {
					Size = UDim2.new(1, 0, 0, v13.Size.Size_1200),
					radius = radius.Medium,
					LayoutOrder = 3
				}),
				Row3 = React.createElement(skeleton, {
					Size = UDim2.new(1, 0, 0, v13.Size.Size_1200),
					radius = radius.Medium,
					LayoutOrder = 4
				}),
				Footer = React.createElement(skeleton, {
					Size = UDim2.new(1, 0, 0, v13.Size.Size_800),
					radius = radius.Medium,
					LayoutOrder = 5
				})
			}
		)
	end, { v13 })

	local v46 = React.useMemo(function()
		return React.createElement(Foundation.View, {
			tag = "col gap-medium size-full-0 auto-y"
		}, {
			DialogContentHeader = React.createElement(dialog.Text, {
				Text = v29.subtitleText,
				LayoutOrder = 1
			}),
			GroupMemberList = React.createElement(
				Foundation.View,
				{ tag = "col size-full-0 auto-y", LayoutOrder = 2 },
				v30
			),
			DialogContentFooter = React.createElement(renderer, {
				text = v29.footerText,
				textStyle = v13.Color.Content.Default,
				fontStyle = v13.Typography.BodyMedium,
				linkerOptions = v15,
				wrapperProps = { tag = "size-full-0 auto-y", LayoutOrder = 3 }
			})
		})
	end, {
		v29.subtitleText,
		v29.footerText,
		v30,
		v13.Color.Content.Default,
		v13.Typography.BodyMedium,
		v15
	})

	local createElement = React.createElement
	local root = dialog.Root
	local v47 = {
		ref = v35,
		size = union.dialogSize,
		onClose = if not v36 then v31 else nil,
		hasBackdrop = union.hasBackdrop,
		disablePortal = union.disablePortal
	}
	local v49 = {
		DialogTitle = not v43 and React.createElement(dialog.Title, {
			text = v44,
			LayoutOrder = 1
		}),
		DialogContent = 0,
		DialogActions = 0
	}

	local createElement2 = React.createElement
	local content = dialog.Content

	if not v43 then
		v45 = v46
	end

	v49.DialogContent = createElement2(content, { LayoutOrder = 2 }, v45)

	v49.DialogActions = not v43 and React.createElement(dialog.Actions, {
		LayoutOrder = 3,
		orientation = orientation.Vertical,
		actions = {
			{
				text = v29.joinButtonText,
				variant = buttonVariant.Emphasis,
				ref = v34,
				onActivated = v39,
				isDisabled = state
			},
			{
				text = v29.declineButtonText,
				variant = buttonVariant.Standard,
				onActivated = v40,
				isDisabled = state
			}
		}
	})
	return createElement(root, v47, v49)
end

return GroupOSADialog
