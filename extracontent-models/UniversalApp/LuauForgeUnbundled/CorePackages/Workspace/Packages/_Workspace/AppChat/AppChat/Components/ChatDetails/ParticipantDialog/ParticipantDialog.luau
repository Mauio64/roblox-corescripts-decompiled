require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/FocusNavigationUtils")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/InputHandlers")
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ParticipantDialog/Logger")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local memo = React.memo
local useLayerCollector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Core.Layout.LayerCollector.useLayerCollector
local useTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/useTelemetry")
local ChatDetailsTelemetryEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatDetails/ChatDetailsTelemetryEvents")
local ChatLandingTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/ChatLandingTelemetryLayer")

local menu = Foundation.Menu
local popoverAlign = Foundation.Enums.PopoverAlign
local popoverSide = Foundation.Enums.PopoverSide
local inputSize = Foundation.Enums.InputSize

local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot

local udim = UDim.new(0, 400)

local v5 = {
	conversationId = nil,
	participantId = nil,
	anchorRef = nil,
	showRemoveUserButton = false,
	showViewProfileButton = true,
	showChatButton = false,
	showTrustedFriendButton = false,
	isWideMode = false,
	unitTestScreenSize = nil,
	viewProfileText = "localizedText.ViewProfile",
	chatText = "localizedText.Chat",
	reportUserText = "localizedText.ReportUser",
	removeFromGroupText = "localizedText.RemoveFromGroup",
	trustedFriendText = "localizedText.AddTrustedFriend",
	isTrustedFriendButtonDisabled = false,
	openViewProfile = function(p2)
		Logger:warning("openViewProfile was not passed to ParticipantDialog")
	end,
	openChat = function(...)
		Logger:warning("openChat was not passed to ParticipantDialog")
	end,
	openReportUser = function(...)
		Logger:warning("openReportUser was not passed to ParticipantDialog")
	end,
	openRemoveUserDialog = function(...)
		Logger:warning("openRemoveUserDialog was not passed to ParticipantDialog")
	end,
	openTrustedFriend = function(...)
		Logger:warning("openTrustedFriend was not passed to ParticipantDialog")
	end,
	onDismiss = function(p2)
		Logger:warning("onDismiss was not passed to ParticipantDialog")
	end
}

function LUAUFORGE_MODULE_GLOBALS_hDI_ParticipantDialog(p2)
	local joined = Cryo.Dictionary.join(v5, p2)
	local v6 = useTelemetry(ChatLandingTelemetryLayer.Context)
	local ref = React.useRef(nil)
	local v7 = useLayerCollector()
	local state, setState = React.useState(true)
	local conversationId = joined.conversationId
	local participantId = joined.participantId
	local showRemoveUserButton = joined.showRemoveUserButton
	local unitTestScreenSize = joined.unitTestScreenSize or v7.absoluteSize
	local anchorRef = if joined.anchorRef and joined.anchorRef.current then joined.anchorRef else nil
	local onDismiss = joined.onDismiss or function() end

	local function onPressedOutside()
		setState(false)
		onDismiss()
	end

	local v8 = {
		[focusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(p3)
				p3.cancelled = true
				setState(false)
				onDismiss()
			end)
		}
	}

	local v9 = useAppFocusRoot({
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.ContextualMenu,
		isFocusable = state,
		customEventHandlers = v8
	})

	local ref2 = React.useRef(false)

	local v10 = {}
	local function onDisabledActivated() end

	local function insertAction(p3, callback, p4)
		local v13

		if p4 then
			v13 = onDisabledActivated
		else
			v13 = function()
				if ref2.current then
					return
				end

				ref2.current = true
				setState(false)

				if callback then
					callback()
				end
			end
		end

		table.insert(v10, { text = p3, isDisabled = p4, onActivated = v13 })
	end

	if joined.showViewProfileButton then
		local viewProfileText = joined.viewProfileText
		local function fn()
			Logger:info("User activated viewProfile | userId: {}", participantId)
			joined.openViewProfile(participantId)
		end

		table.insert(v10, {
			text = viewProfileText,
			isDisabled = nil,
			onActivated = function()
				if ref2.current then
					return
				end

				ref2.current = true
				setState(false)

				if fn then
					fn()
				end
			end
		})
	end

	if joined.showTrustedFriendButton then
		local trustedFriendText = joined.trustedFriendText
		local function fn()
			Logger:info("User activated openTrustedFriend | userId: {}", participantId)
			joined.openTrustedFriend(participantId)
		end
		local isTrustedFriendButtonDisabled = joined.isTrustedFriendButtonDisabled
		table.insert(v10, {
			text = trustedFriendText,
			isDisabled = isTrustedFriendButtonDisabled,
			onActivated = not isTrustedFriendButtonDisabled and function()
				if ref2.current then
					return
				end

				ref2.current = true
				setState(false)

				if fn then
					fn()
				end
			end or onDisabledActivated
		})
	end

	if joined.showChatButton then
		local chatText = joined.chatText
		local function fn()
			Logger:info("User activated openChat | userId: {}", participantId)
			v6.emit(ChatDetailsTelemetryEvents.ParticipantDialogChatClicked, {})
			joined.openChat(participantId)
		end

		table.insert(v10, {
			text = chatText,
			isDisabled = nil,
			onActivated = function()
				if ref2.current then
					return
				end

				ref2.current = true
				setState(false)

				if fn then
					fn()
				end
			end
		})
	end

	local reportUserText = joined.reportUserText
	local function fn()
		Logger:info(
			"User activated reportUser | userId: {}, conversationId: {}",
			participantId,
			conversationId
		)
		v6.emit(ChatDetailsTelemetryEvents.ParticipantDialogReportUserClicked, {})
		joined.openReportUser(participantId, conversationId)
	end

	table.insert(v10, {
		text = reportUserText,
		isDisabled = nil,
		onActivated = function()
			if ref2.current then
				return
			end

			ref2.current = true
			setState(false)

			if fn then
				fn()
			end
		end
	})

	if showRemoveUserButton then
		local function fn2()
			joined.openRemoveUserDialog(participantId, conversationId)
		end

		table.insert(v10, {
			text = joined.removeFromGroupText,
			isDisabled = nil,
			onActivated = function()
				if ref2.current then
					return
				end

				ref2.current = true
				setState(false)

				if fn2 then
					fn2()
				end
			end
		})
	end

	if anchorRef then
		local absolutePosition = anchorRef.current.AbsolutePosition
		local absoluteSize = anchorRef.current.AbsoluteSize
		local v11

		if absolutePosition.Y + absoluteSize.Y / 2 > unitTestScreenSize.Y / 2 then
			v11 = popoverSide.Top
		else
			v11 = popoverSide.Bottom
		end

		local createElement = React.createElement
		local v13 = {
			align = popoverAlign.End,
			anchorRef = anchorRef,
			isOpen = state,
			items = v10,
			onPressedOutside = onPressedOutside,
			ref = v9,
			side = v11,
			size = inputSize.Medium,
			width = 0
		}
		local v14 = if joined.isWideMode then udim else nil
		v13.width = v14
		return createElement(menu, v13)
	else
		local createElement = React.createElement
		local view = Foundation.View
		local v11 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }

		local v12 = {
			MenuAnchor = React.createElement("Frame", {
				AnchorPoint = Vector2.new(0.5, 1),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = UDim2.new(0.5, 0, 1, -10),
				Size = UDim2.fromOffset(400, 1),
				ref = ref
			}),
			Menu = 0
		}

		local createElement2 = React.createElement
		local v14 = {
			align = popoverAlign.Center,
			anchorRef = ref,
			isOpen = state,
			items = v10,
			onPressedOutside = onPressedOutside,
			ref = v9,
			side = popoverSide.Top,
			size = inputSize.Medium,
			width = 0
		}
		local v15 = if joined.isWideMode then udim else nil
		v14.width = v15
		v12.Menu = createElement2(menu, v14)
		return createElement(view, v11, v12)
	end
end

return memo(LUAUFORGE_MODULE_GLOBALS_hDI_ParticipantDialog)
