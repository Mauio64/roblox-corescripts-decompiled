local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(AppChat.types)

local Foundation = require(parent.Foundation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
local Logger = require(script.Parent.Logger)
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local memo = React.memo
local UIBlox = require(parent.UIBlox)
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local ChatDetailsTelemetryEvents = require(AppChat.Components.ChatDetails.ChatDetailsTelemetryEvents)
local ChatDialogTelemetryLayer = require(AppChat.Telemetry.Layers.ChatDialogTelemetryLayer)

local Menu = Foundation.Menu
local PopoverAlign = Foundation.Enums.PopoverAlign
local PopoverSide = Foundation.Enums.PopoverSide
local InputSize = Foundation.Enums.InputSize

local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useAppFocusRoot = FocusNavigationUtils.useAppFocusRoot

local udim = UDim.new(0, 400)

local v = {
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
	openViewProfile = function(_)
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
	onDismiss = function(_)
		Logger:warning("onDismiss was not passed to ParticipantDialog")
	end
}

function ParticipantDialog(p)
	local joined = Cryo.Dictionary.join(v, p)
	local v2 = useTelemetry(ChatDialogTelemetryLayer.Context)
	local ref = React.useRef(nil)
	local v3 = useLayerCollector()
	local state, setState = React.useState(true)
	local conversationId = joined.conversationId
	local participantId = joined.participantId
	local showRemoveUserButton = joined.showRemoveUserButton
	local unitTestScreenSize = joined.unitTestScreenSize or v3.absoluteSize
	local anchorRef

	if joined.anchorRef and joined.anchorRef.current then
		anchorRef = joined.anchorRef
	end

	local onDismiss = joined.onDismiss or function() end

	local function onPressedOutside() -- 1 equivalent call inferred from this helper
		setState(false)
		onDismiss()
	end

	local customEventHandlers = {
		[FocusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(p2)
				p2.cancelled = true
				onPressedOutside() -- inferred equivalent call
			end)
		}
	}

	local ref3 = useAppFocusRoot({
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ContextualMenu,
		isFocusable = state,
		customEventHandlers = customEventHandlers
	})

	local ref2 = React.useRef(false)

	local items = {}
	local function onDisabledActivated() end

	local function insertAction(text: string?, callback, isDisabled: boolean?)
		local onActivated

		if isDisabled then
			onActivated = onDisabledActivated
		else
			onActivated = function()
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

		table.insert(items, { text = text, isDisabled = isDisabled, onActivated = onActivated })
	end

	if joined.showViewProfileButton then
		local viewProfileText = joined.viewProfileText
		local function fn()
			Logger:info("User activated viewProfile | userId: {}", participantId)
			joined.openViewProfile(participantId)
		end

		table.insert(items, {
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
		table.insert(items, {
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
			v2.emit(ChatDetailsTelemetryEvents.ParticipantDialogChatClicked, {})
			joined.openChat(participantId)
		end

		table.insert(items, {
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
		Logger:info("User activated reportUser | userId: {}, conversationId: {}", participantId, conversationId)
		v2.emit(ChatDetailsTelemetryEvents.ParticipantDialogReportUserClicked, {})
		joined.openReportUser(participantId, conversationId)
	end

	table.insert(items, {
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

		table.insert(items, {
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
		local side

		if absolutePosition.Y + absoluteSize.Y / 2 > unitTestScreenSize.Y / 2 then
			side = PopoverSide.Top
		else
			side = PopoverSide.Bottom
		end

		local createElement = React.createElement
		local v4 = {
			align = PopoverAlign.End,
			anchorRef = anchorRef,
			isOpen = state,
			items = items,
			onPressedOutside = onPressedOutside,
			ref = ref3,
			side = side,
			size = InputSize.Medium,
			width = 0
		}
		local width

		if joined.isWideMode then
			width = udim
		end

		v4.width = width
		return (createElement(Menu, v4))
	else
		local createElement = React.createElement
		local view = Foundation.View
		local v4 = { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }

		local v5 = {
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
		local v6 = {
			align = PopoverAlign.Center,
			anchorRef = ref,
			isOpen = state,
			items = items,
			onPressedOutside = onPressedOutside,
			ref = ref3,
			side = PopoverSide.Top,
			size = InputSize.Medium,
			width = 0
		}
		local width

		if joined.isWideMode then
			width = udim
		end

		v6.width = width
		v5.Menu = createElement2(Menu, v6)
		return createElement(view, v4, v5)
	end
end

return memo(ParticipantDialog)
