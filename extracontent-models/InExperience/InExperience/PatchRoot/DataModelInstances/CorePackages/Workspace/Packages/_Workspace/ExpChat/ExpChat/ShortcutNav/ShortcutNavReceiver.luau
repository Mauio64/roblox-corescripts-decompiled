local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local SharedFlags = require(parent.SharedFlags)
require(parent.ExpChatShared)
local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local chatTabNavigationSignal = ChatUIPrimitives.chatTabNavigationSignal

local Config = require(ExpChat.Config)
local FocusChatHotKeyActivated = require(ExpChat.Actions.FocusChatHotKeyActivated)
local getTabShortcutBehavior = require(script.Parent.getTabShortcutBehavior)
local chatFocusRequestSignal = require(script.Parent.chatFocusRequestSignal)
local FocusNavigationExperiment = require(script.Parent.FocusNavigationExperiment)
local FFlagExpChatGenericChatFocus = require(ExpChat.Flags.FFlagExpChatGenericChatFocus)
local useSelectedTabType = require(ExpChat.useSelectedTabType)
local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)
local GetFocusNavigationStore = require(ExpChat.Stores.GetFocusNavigationStore)
local getAdjacentTabName = require(ExpChat.TabNavigation.getAdjacentTabName)
local selectTabByType = require(ExpChat.TabNavigation.selectTabByType)
local shouldNavigateTabs = require(ExpChat.TabNavigation.shouldNavigateTabs)

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useStore = RoactUtils.Hooks.RoactRodux.useStore

local FFlagExpChatTabShortcutNav = SharedFlags.FFlagExpChatTabShortcutNav
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore

local function getActiveTabState(object)
	if FFlagExpChatUseChannelTabsStore then
		local channelTabsState = GetChannelTabsStore(false).getChannelTabsState(false)
		return channelTabsState.selectedTabName, channelTabsState.allChannelTabs
	end

	local channelTabs = object:getState().ChannelTabs

	if channelTabs == nil or channelTabs.allChannelTabs == nil then
		return nil, {}
	end

	local result = {}

	for k, allChannelTab in channelTabs.allChannelTabs do
		result[k] = { name = k, tabIndex = allChannelTab.TabIndex, type = allChannelTab.Type }
	end

	return channelTabs.selectedTabName, result
end

local Tab = Enum.KeyCode.Tab
local v = { [Enum.KeyCode.ButtonR1] = 1, [Enum.KeyCode.ButtonL1] = -1 }

local value = Enum.ContextActionPriority.High.Value

local function selectIsChatHotkeyEnabled(p)
	return p.ChatVisibility.isChatHotkeyEnabled.value
end

local function selectDevDefinedFocusKeyCode(p)
	return p.ChatLayout.ChatInputBarSettings.KeyboardKeyCode
end

local function ShortcutNavReceiver(p): nil
	local contextActionService = p.contextActionService or ContextActionService

	local v2 = useSelector(selectIsChatHotkeyEnabled)
	local v3 = useSelectedTabType()
	local v4 = useSelector(selectDevDefinedFocusKeyCode)
	local v5 = useDispatch()

	local v6 = useStore()
	local ref

	if FocusNavigationExperiment.isExposureLoggingEnabled then
		ref = React.useRef(false)
	else
		ref = nil
	end

	React.useEffect(function()
		local function handleAction(_: string, p2, p3)
			if not v2 or (p2 ~= Enum.UserInputState.Begin or p3 == nil) then
				return Enum.ContextActionResult.Pass
			end

			local keyCode = p3.KeyCode

			if keyCode ~= Config.ChatInputBarDefaultFocusKeyCode and keyCode ~= v4 or v3 == nil then
				return Enum.ContextActionResult.Pass
			end

			local tabShortcutBehavior = getTabShortcutBehavior(v3)

			if not tabShortcutBehavior.canOpenChat() then
				return Enum.ContextActionResult.Pass
			end

			v5(FocusChatHotKeyActivated())

			return tabShortcutBehavior.focus({ keyCode = keyCode }) or Enum.ContextActionResult.Sink
		end

		contextActionService:BindCoreAction("ExpChatFocusHotKey", handleAction, false, Enum.UserInputType.Keyboard)

		return function()
			contextActionService:UnbindCoreAction("ExpChatFocusHotKey")
		end
	end, { v2, v3, v4, contextActionService, v5 })

	React.useEffect(function()
		if not FFlagExpChatGenericChatFocus or v3 == nil then
			return
		end

		local tabShortcutBehavior = getTabShortcutBehavior(v3)
		local connection = chatFocusRequestSignal:connect(function()
			if tabShortcutBehavior.focus ~= nil and tabShortcutBehavior.canOpenChat() then
				tabShortcutBehavior.focus({ keyCode = Enum.KeyCode.None })
			end
		end)
		return function()
			connection.disconnect()
		end
	end, { v3 })

	React.useEffect(function()
		if not FFlagExpChatTabShortcutNav then
			return
		end

		local function tryNavigateTabs(p2: number, flag: boolean?): boolean
			local activeTabState, v7 = getActiveTabState(v6)

			if not (activeTabState ~= nil and v7[activeTabState] ~= nil) then
				return false
			end

			local focusNavigationStore = GetFocusNavigationStore(false)
			local v8 = {}

			for _, v9 in v7 do
				table.insert(v8, { name = v9.name, tabIndex = v9.tabIndex })
			end

			if not shouldNavigateTabs({
				isTabBarVisible = focusNavigationStore.getIsTabBarVisible(false),
				tabCount = #v8,
				isChatFocused = flag == true or focusNavigationStore.getIsChatFocused()
			}) then
				return false
			end

			local adjacentTabName = getAdjacentTabName(v8, activeTabState, p2)

			if adjacentTabName == nil then
				return false
			end

			local v9 = v7[adjacentTabName]

			if ref and not ref.current then
				ref.current = true
				FocusNavigationExperiment.logExposure()
			end

			if not FocusNavigationExperiment.isTabNavEnabled then
				return false
			end

			selectTabByType(v5, {
				channelName = adjacentTabName,
				tabType = v9.type,
				shouldReorderTabs = false
			})

			focusNavigationStore.clearChatInputBarFocusRequest()
			getTabShortcutBehavior(v9.type).focus({ keyCode = Tab })
			focusNavigationStore.requestTabNavFocus(adjacentTabName)
			return true
		end

		local function handleTabNav(_: string, p2, object)
			if p2 ~= Enum.UserInputState.Begin or object == nil then
				return Enum.ContextActionResult.Pass
			end

			local v7 = v[object.KeyCode]
			local v8 = object.KeyCode == Tab and (object:IsModifierKeyDown(Enum.ModifierKey.Shift) and -1 or 1) or v7

			if v8 == nil then
				return Enum.ContextActionResult.Pass
			end

			if tryNavigateTabs(v8) then
				return Enum.ContextActionResult.Sink
			end

			return Enum.ContextActionResult.Pass
		end

		contextActionService:BindCoreActionAtPriority(
			"ExpChatTabShortcutNav",
			handleTabNav,
			false,
			value,
			Tab,
			Enum.KeyCode.ButtonR1,
			Enum.KeyCode.ButtonL1
		)

		local connection = chatTabNavigationSignal:connect(function(p2: number)
			tryNavigateTabs(p2, true)
		end)

		return function()
			contextActionService:UnbindCoreAction("ExpChatTabShortcutNav")
			connection.disconnect()
		end
	end, { contextActionService, v5, v6 })

	React.useEffect(function()
		if not FFlagExpChatTabShortcutNav then
			return
		end

		local function handleEscape(_: string, p2, _)
			if not (p2 == Enum.UserInputState.Begin and GetFocusNavigationStore(false).getIsChatFocused()) then
				return Enum.ContextActionResult.Pass
			end

			GuiService.SelectedCoreObject = nil
			return Enum.ContextActionResult.Sink
		end

		contextActionService:BindCoreActionAtPriority(
			"ExpChatShortcutNavEscape",
			handleEscape,
			false,
			value,
			Enum.KeyCode.Escape
		)

		return function()
			contextActionService:UnbindCoreAction("ExpChatShortcutNavEscape")
		end
	end, { contextActionService })

	return nil
end

return ShortcutNavReceiver
