local GuiService = game:GetService("GuiService")

local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local React = require(parent.React)

local RobloxAppLocales = require(parent.RobloxAppLocales)
local Localization = RobloxAppLocales.Localization
local LocalizationService = game:GetService("LocalizationService")
local Localization2 = require(parent.Localization)
local LocalizationProvider = Localization2.LocalizationProvider

local ChatLineReporting = require(parent.ChatLineReporting)
local ChatBoxContextMenu = ChatLineReporting.ChatBoxContextMenu
local ChatLineReporting2 = require(parent.ChatLineReporting)
local Constants = ChatLineReporting2.Constants
local SharedFlags = require(parent.SharedFlags)
local GetFFlagMemoizeChatReportingMenu = SharedFlags.GetFFlagMemoizeChatReportingMenu
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local SignalsReact = require(parent.SignalsReact)

local Foundation = require(parent.Foundation)
local Icon = Foundation.Icon
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local View = Foundation.View

local getFFlagChatWindowUseCallbackOptimizations = require(ExpChat.Flags.getFFlagChatWindowUseCallbackOptimizations)
local defineFastFlag = game:DefineFastFlag("ExpChatTopBannerZIndexFix", false)

local GetFocusNavigationStore = require(ExpChat.Stores.GetFocusNavigationStore)
local focusNavigationStore = GetFocusNavigationStore(false)

local function fn(props)
	local ref = React.useRef(nil)
	local state, setState = React.useState(false)
	local localization = Localization.new(LocalizationService.RobloxLocaleId)

	local v = ReactFocusNavigation.useFocusGuiObject()
	local v2 = SignalsReact.useSignalState(focusNavigationStore.getChatInputBarFocused)

	local current = React.useCallback(function()
		props.onUnfocus()

		if v2 and ref.current then
			v(ref.current)
			GuiService.SelectedCoreObject = nil
		end
	end, { v2, v, props.onUnfocus })

	local ref2 = React.useRef(current)

	React.useEffect(function()
		ref2.current = current
	end, { current })

	React.useEffect(function()
		return function()
			if state and ref2.current then
				ref2.current()
			end
		end
	end, { state })

	React.useEffect(function()
		if v2 and state then
			return function()
				setState(false)
			end
		end

		return nil
	end, { v2, state })

	local createElement = React.createElement
	local v3 = {
		Size = UDim2.new(1, 0, 0, Constants.TopBannerSize),
		BackgroundTransparency = 1,
		ZIndex = defineFastFlag and 2 or nil
	}

	local v4 = {
		DotMenu = React.createElement(View, {
			Size = UDim2.new(0, Constants.IconButtonSize, 0, Constants.IconButtonSize),
			Position = UDim2.new(1, Constants.IconButtonPositionXOffset, 0, Constants.IconButtonPositionYOffset),
			onActivated = not getFFlagChatWindowUseCallbackOptimizations() and function()
				setState(true)
				props.onFocus()
			end or React.useCallback(function()
				setState(true)
				props.onFocus()
			end, { setState, props.onFocus }),
			tag = "auto-xy padding-small radius-medium align-x-center align-y-center",
			ref = ref
		}, React.createElement(Icon, {
			name = IconName.ThreeDotsHorizontal,
			size = IconSize.Large,
			style = { Transparency = props.iconTransparency }
		})),
		LocalizationProvider = 0
	}

	local createElement2 = React.createElement
	local contextMenu

	if state then
		local createElement3 = React.createElement
		local v5 = {
			setContextMenuOpen = setState,
			backgroundColor3 = props.backgroundColor3,
			backgroundTransparency = props.backgroundTransparency,
			getMessages = 0,
			messages = 0
		}
		local getMessages

		if GetFFlagMemoizeChatReportingMenu() then
			getMessages = props.getMessages
		end

		v5.getMessages = getMessages
		local messages

		if not GetFFlagMemoizeChatReportingMenu() then
			messages = props.messages
		end

		v5.messages = messages
		contextMenu = createElement3(ChatBoxContextMenu, v5)
	end

	v4.LocalizationProvider = createElement2(LocalizationProvider, { localization = localization }, {
		ContextMenu = contextMenu
	})
	return createElement("Frame", v3, v4)
end

if GetFFlagMemoizeChatReportingMenu() then
	return (React.memo(fn))
end

return fn
