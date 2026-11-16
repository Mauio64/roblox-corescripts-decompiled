local parent = script.Parent.Parent

local React = require(parent.React)
local ReactUtils = require(parent.ReactUtils)
local Foundation = require(parent.Foundation)
local Responsive = require(parent.Responsive)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local InputHandlers = require(parent.InputHandlers)
require(parent.Signals)
local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local TextChatWindowInputBarHost = require(script.Parent.TextChatWindowInputBarHost)
local ChatWindowTopBanner = require(script.Parent.ChatWindowTopBanner)
local MessageListArea = require(script.Parent.MessageListArea)
require(script.Parent.Message)
local themeFromBackgroundColor = require(script.Parent.themeFromBackgroundColor)
local useChatWindowEntryHandoff = require(script.Parent.useChatWindowEntryHandoff)
local SelectionInputs = require(script.Parent.FocusNavigation.SelectionInputs)

local FFlagExpChatTextChannelWindowThemeByBackground = require(script.Parent.Flags.FFlagExpChatTextChannelWindowThemeByBackground)
local FFlagExpChatTextChannelWindowFocusNav = require(script.Parent.Flags.FFlagExpChatTextChannelWindowFocusNav)
local FFlagExpChatExpressionTrayReducedMotion = ChatUIPrimitives.Flags.FFlagExpChatExpressionTrayReducedMotion
local defineFastFlag = game:DefineFastFlag("ExpChatTCWAllowKeyboardNav", false)
local FFlagExpChatTCWMemoizeChatWindowBody = require(script.Parent.Flags.FFlagExpChatTCWMemoizeChatWindowBody)

local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local UserGameSettings = UserSettings():GetService("UserGameSettings")

local Provider = FocusNavigationUtils.FocusNavigableSurfaceRegistry.Provider
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useFocusRoot = FocusNavigationUtils.useFocusRoot

local createNextOrder = ReactUtils.createNextOrder
local focusNavigationService

if FFlagExpChatTextChannelWindowFocusNav then
	focusNavigationService = ReactFocusNavigation.FocusNavigationService.new(ReactFocusNavigation.EngineInterface.CoreGui)
else
	focusNavigationService = nil
end

local navigateBacks = {}

if defineFastFlag then
	for _, v in SelectionInputs.Back do
		if v.EnumType == Enum.KeyCode then
			navigateBacks[v] = FocusNavigationEventNameEnum.NavigateBack
		end
	end
else
	navigateBacks[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack
end

local v = {}

local v2 = {
	SelectionBehaviorUp = Enum.SelectionBehavior.Stop,
	SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
	SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
	SelectionBehaviorRight = Enum.SelectionBehavior.Stop
}

local function ChatWindowBody(props)
	local v3 = Foundation.Hooks.useTokens()
	local nextOrder = createNextOrder()

	local createElement = React.createElement
	local view = Foundation.View
	local v4 = {
		Size = props.Size or UDim2.fromScale(1, 1),
		ref = props.focusRootRef,
		selectionGroup = 0
	}
	local selectionGroup

	if props.focusNavEnabled then
		selectionGroup = v2
	end

	v4.selectionGroup = selectionGroup

	local createElement2 = React.createElement
	local view2 = Foundation.View
	local cornerRadius

	if not FFlagExpChatTextChannelWindowThemeByBackground then
		cornerRadius = UDim.new(0, v3.Radius.Medium)
	end

	return createElement(view, v4, {
		chatView = createElement2(view2, {
			tag = "col fill size-full clip",
			cornerRadius = cornerRadius,
			backgroundStyle = not FFlagExpChatTextChannelWindowThemeByBackground and {
				Color3 = v3.DarkMode.Surface.Surface_100.Color3,
				Transparency = 0.3
			} or nil
		}, {
			messageList = React.createElement(
				Foundation.View,
				{ tag = "fill size-full-0", LayoutOrder = nextOrder() },
				{
					content = React.createElement(MessageListArea, {
						channelState = props.channelState,
						messagesSignal = props.messagesSignal,
						fontFace = props.fontFace,
						windowName = props.windowName,
						selectableRows = props.focusNavEnabled,
						selectionCursor = props.selectionCursor,
						onLatestUsernameChanged = props.onLatestUsernameChanged
					})
				}
			),
			inputBar = React.createElement(
				Foundation.View,
				{ tag = "size-full-0 auto-y padding-small", LayoutOrder = nextOrder() },
				{
					host = React.createElement(TextChatWindowInputBarHost, {
						targetChannel = props.targetChannel,
						canLocalUserChat = props.canLocalUserChat,
						localUserId = props.localUserId,
						fontFace = props.fontFace,
						textBoxRef = props.inputTextBoxRef,
						focusNavEnabled = props.focusNavEnabled,
						selectionCursor = props.selectionCursor,
						onExpressionTrayOpenChanged = props.setExpressionTrayOpen
					})
				}
			)
		}),
		topBanner = React.createElement(ChatWindowTopBanner, {
			ZIndex = 2,
			messagesSignal = props.messagesSignal,
			targetChannel = props.targetChannel,
			focusNavEnabled = props.focusNavEnabled,
			onOpenChanged = props.setReportMenuOpen
		})
	})
end

if FFlagExpChatTCWMemoizeChatWindowBody then
	ChatWindowBody = React.memo(ChatWindowBody)
end

local function ChatAppFocusNav(p)
	local ref = React.useRef(nil)
	local v3 = Responsive.usePreferredInput() == Responsive.Input.Directional
	local v4

	if defineFastFlag then
		v4 = p.windowInstance ~= nil
	else
		v4 = v3 and p.windowInstance ~= nil
	end

	local selectionCursor = Foundation.Hooks.useCursor(Foundation.Enums.CursorType.RoundedRect)

	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(false)

	local windowInstance = p.windowInstance

	local v5 = React.useCallback(function()
		GuiService.SelectedCoreObject = nil

		if windowInstance and windowInstance:IsDescendantOf(game) then
			GuiService.SelectedObject = windowInstance
		end
	end, { windowInstance })

	local setSelection = ReactFocusNavigation.useFocusGuiObject()
	local eventHandlers = React.useMemo(function()
		local v6 = {}
		v6[FocusNavigationEventNameEnum.NavigateBack] = {
			handler = InputHandlers.onRelease(function(object)
				if UserInputService:GetFocusedTextBox() ~= nil then
					return
				end

				v5()
				object:cancel()
			end)
		}

		return v6
	end, { v5 })
	local v6 = {
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isAutoFocusRoot = false,
		shouldRestoreFocus = false,
		eventMap = 0,
		eventHandlers = 0
	}
	local eventMap = if state or state2 then v else navigateBacks
	v6.eventMap = eventMap
	v6.eventHandlers = eventHandlers
	local focusRootRef = useFocusRoot(v6)

	useChatWindowEntryHandoff({
		enabled = v4,
		windowInstance = p.windowInstance,
		focusTargetRef = ref,
		setSelection = setSelection
	})

	local ref2 = React.useRef(nil)
	local onLatestUsernameChanged = React.useCallback(function(p2)
		local current = ref.current
		local current2 = ref2.current

		if current2 ~= nil and current2 ~= p2 then
			current2.NextSelectionDown = nil
		end

		ref2.current = p2

		if current == nil then
			return
		end

		current.NextSelectionUp = p2

		if p2 ~= nil then
			p2.NextSelectionDown = current
		end
	end, { ref })

	local clone = table.clone(p)
	clone.focusNavEnabled = v4
	clone.selectionCursor = selectionCursor
	clone.focusRootRef = focusRootRef
	clone.onLatestUsernameChanged = onLatestUsernameChanged
	clone.inputTextBoxRef = ref
	clone.setReportMenuOpen = setState
	clone.setExpressionTrayOpen = setState2
	return React.createElement(ChatWindowBody, clone)
end

local function useReducedMotion()
	local state, setState = React.useState(UserGameSettings.ReducedMotion)
	React.useEffect(function()
		setState(UserGameSettings.ReducedMotion)
		local reducedMotionChangedConnection = UserGameSettings:GetPropertyChangedSignal("ReducedMotion"):Connect(function()
			setState(UserGameSettings.ReducedMotion)
		end)
		return function()
			reducedMotionChangedConnection:Disconnect()
		end
	end, {})
	return state
end

local function ChatApp(p)
	local colorMode

	if FFlagExpChatTextChannelWindowThemeByBackground and p.backgroundColor then
		colorMode = themeFromBackgroundColor(p.backgroundColor)
	else
		colorMode = Foundation.Enums.ColorMode.Dark
	end

	local reducedMotion

	if FFlagExpChatExpressionTrayReducedMotion then
		reducedMotion = useReducedMotion()
	else
		reducedMotion = false
	end

	local inner

	if FFlagExpChatTextChannelWindowFocusNav then
		inner = React.createElement(
			ReactFocusNavigation.FocusNavigationContext.Provider,
			{ value = focusNavigationService },
			{
				registryProvider = React.createElement(Provider, nil, {
					inner = React.createElement(ChatAppFocusNav, p)
				})
			}
		)
	else
		local clone = table.clone(p)
		clone.focusNavEnabled = false
		inner = React.createElement(ChatWindowBody, clone)
	end

	return React.createElement(Foundation.FoundationProvider, {
		colorMode = colorMode,
		preferences = FFlagExpChatExpressionTrayReducedMotion and { reducedMotion = reducedMotion } or nil
	}, { inner = inner })
end

return ChatApp
