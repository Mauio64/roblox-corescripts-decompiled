local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local Foundation = require(parent.Foundation)
local Coachmark = Foundation.Coachmark
local PopoverSide = Foundation.Enums.PopoverSide
local PopoverAlign = Foundation.Enums.PopoverAlign

local ExpChatShared = require(parent.ExpChatShared)
local FFlagExpChatUseUnifiedTooltipStore = ExpChatShared.Flags.FFlagExpChatUseUnifiedTooltipStore
local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatUseChannelTabsStore = SharedFlags.FFlagExpChatUseChannelTabsStore

local Localization = require(ExpChat.Localization)
local Config = require(ExpChat.Config)
local isUserChatEnabled = require(ExpChat.isUserChatEnabled)
local GetTransparencyStore = require(ExpChat.Stores.GetTransparencyStore)
local GetGlobalChatTooltipStore = require(ExpChat.Stores.GetGlobalChatTooltipStore)
local GetChatTooltipStore = require(ExpChat.Stores.GetChatTooltipStore)
local GetChannelTabsStore

if FFlagExpChatUseChannelTabsStore then
	GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)
else
	GetChannelTabsStore = nil
end

local useChatTooltipLifecycle = require(script.Parent.Parent.useChatTooltipLifecycle)
local FFlagExpChatGlobalTabDefault = require(ExpChat.Flags.FFlagExpChatGlobalTabDefault)

local MinTabWidth = Config.ChannelTabsSettings.MinTabWidth
local DropdownIconContainerWidth = Config.ChannelTabsSettings.DropdownIconContainerWidth

local function useGlobalTabIndex()
	if not FFlagExpChatUseChannelTabsStore then
		return useSelector(function(p)
			local allChannelTabs = p.ChannelTabs and p.ChannelTabs.allChannelTabs
			local rbxGlobal = allChannelTabs and allChannelTabs.RBXGlobal
			return if rbxGlobal then rbxGlobal.TabIndex else 2
		end)
	end

	local v = React.useMemo(function()
		return Signals.createComputed(function(p)
			local rbxGlobal = GetChannelTabsStore(false).getChannelTabsState(p).allChannelTabs.RBXGlobal
			return if rbxGlobal then rbxGlobal.tabIndex else 2
		end)
	end, {})
	return SignalsReact.useSignalState(v)
end

local function useTabCount()
	if not FFlagExpChatUseChannelTabsStore then
		return useSelector(function(p)
			local allChannelTabs = p.ChannelTabs and p.ChannelTabs.allChannelTabs

			if allChannelTabs == nil then
				return 0
			end

			local count = 0

			for _ in allChannelTabs do
				count += 1
			end

			return count
		end)
	end

	local v = React.useMemo(function()
		return Signals.createComputed(function(p)
			local count = 0

			for _ in GetChannelTabsStore(false).getChannelTabsState(p).allChannelTabs do
				count += 1
			end

			return count
		end)
	end, {})
	return SignalsReact.useSignalState(v)
end

local function GlobalChatTooltipNew(p)
	local chatTooltipStore = GetChatTooltipStore(false)
	local v = SignalsReact.useSignalState(chatTooltipStore.getShouldShow("GlobalChatTooltip"))

	local v2 = useTabCount()

	local state, setState = React.useState(0)
	local v3 = not FFlagExpChatGlobalTabDefault and 2 or useGlobalTabIndex()
	local v4

	if state > 0 then
		v4 = state < v2 * MinTabWidth
	else
		v4 = false
	end

	local v5

	if v2 < v3 then
		v5 = 1
	elseif v4 then
		local v6 = state - DropdownIconContainerWidth
		local v7 = math.floor(v6 / MinTabWidth)
		v5 = not (v3 <= v7) and 1 or v3 * v6 / (v7 * state)
	else
		v5 = v3 / v2
	end

	local v6 = useSelector(function(p2): boolean
		local alignment = p2.ChatLayout and p2.ChatLayout.Alignment
		return alignment ~= nil and alignment.AnchorPoint.X == 0 and alignment.AnchorPoint.Y == 0
	end)

	local v7 = useChatTooltipLifecycle({
		tooltipKey = "GlobalChatTooltip",
		targetTextChannel = p.targetTextChannel
	})

	local v8 = Localization.useLocalization({
		headerText = "CoreScripts.TextChat.Tooltip.Global.Header",
		bodyText = "CoreScripts.TextChat.Tooltip.Global.Body"
	})

	if p.visible and v and v6 then
		local function onAnchorChanged(p2)
			local parent2 = p2.Parent

			if parent2 and parent2:IsA("GuiObject") then
				setState(parent2.AbsoluteSize.X)
			end
		end

		return React.createElement(Coachmark, {
			title = v8.headerText,
			text = v8.bodyText,
			isOpen = v7.isActive,
			onClose = v7.onDismiss,
			side = PopoverSide.Right,
			align = PopoverAlign.Start,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(v5, -13, 0, -48),
			onAbsoluteSizeChanged = onAnchorChanged,
			onAbsolutePositionChanged = onAnchorChanged
		}, {
			AnchorSizer = React.createElement("Frame", {
				Size = UDim2.new(0, 1, 0, Config.ChannelTabsSettings.HorizontalBarHeight),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			})
		})
	end

	return nil
end

local function GlobalChatTooltipLegacy(props)
	local globalChatTooltipStore = GetGlobalChatTooltipStore(false)
	local transparencyStore = GetTransparencyStore(false)

	local v = SignalsReact.useSignalState(globalChatTooltipStore.getShouldShowGlobalChatTooltip)
	local v2 = SignalsReact.useSignalState(globalChatTooltipStore.getIsScreenWideEnough)
	local getIsFocused = transparencyStore.getIsFocused or transparencyStore.getIsTextBoxFocused
	local v3 = SignalsReact.useSignalState(transparencyStore.getLastActivity)
	local v4 = SignalsReact.useSignalState(getIsFocused)

	local v5 = useTabCount()

	local state, setState = React.useState(0)
	local v6 = not FFlagExpChatGlobalTabDefault and 2 or useGlobalTabIndex()
	local v7

	if state > 0 then
		v7 = state < v5 * MinTabWidth
	else
		v7 = false
	end

	local v8

	if v5 < v6 then
		v8 = 1
	elseif v7 then
		local v9 = state - DropdownIconContainerWidth
		local v10 = math.floor(v9 / MinTabWidth)
		v8 = not (v6 <= v10) and 1 or v6 * v9 / (v10 * state)
	else
		v8 = v6 / v5
	end

	local v9 = useSelector(function(p): boolean
		local alignment = p.ChatLayout and p.ChatLayout.Alignment
		return alignment ~= nil and alignment.AnchorPoint.X == 0 and alignment.AnchorPoint.Y == 0
	end)

	local v10 = props.chatStatus == nil or isUserChatEnabled(props.chatStatus)

	local state2, setState2 = React.useState(true)
	local state3, setState3 = React.useState(false)

	local ref = React.useRef(false)
	local ref2 = React.useRef(0)
	local ref3 = React.useRef(props.targetTextChannel)

	local onClose = React.useCallback(function()
		if not ref.current then
			ref.current = true
			globalChatTooltipStore.reportImpression()
		end

		globalChatTooltipStore.setIsGlobalChatTooltipDismissed(true)
	end, { globalChatTooltipStore.setIsGlobalChatTooltipDismissed, globalChatTooltipStore.reportImpression })

	React.useEffect(function()
		globalChatTooltipStore.setIsChatWindowOpen(props.visible)
		return function()
			globalChatTooltipStore.setIsChatWindowOpen(false)
		end
	end, { props.visible })

	React.useEffect(function()
		if v4 then
			setState2(true)
			return nil
		end

		local v11 = Config.ChatWindowBackgroundFadeOutTime - (os.clock() - v3)

		if v11 <= 0 then
			setState2(false)
			return nil
		end

		setState2(true)
		local thread = task.delay(v11, function()
			setState2(false)
		end)
		return function()
			task.cancel(thread)
		end
	end, { v3, v4 })

	React.useEffect(function()
		if not (state2 and v2) or state3 or not (v and v10) then
			return nil
		end

		local lastTime = os.clock()
		local v11 = math.max(0, 10 - ref2.current)
		local thread = task.delay(v11, function()
			setState3(true)
		end)
		return function()
			ref2.current += os.clock() - lastTime
			task.cancel(thread)
		end
	end, { state2, v2, state3, v, v10 })

	React.useEffect(function()
		if not state3 then
			return nil
		end

		local thread = task.delay(1, function()
			onClose()
		end)
		return function()
			task.cancel(thread)
		end
	end, { state3, onClose })

	React.useEffect(function()
		local current = ref3.current
		ref3.current = props.targetTextChannel

		if current and current ~= props.targetTextChannel and v and v10 and not state3 then
			setState3(true)
		end
	end, { props.targetTextChannel, v, v10, state3 })

	local v11 = Localization.useLocalization({
		headerText = "CoreScripts.TextChat.Tooltip.Global.Header",
		bodyText = "CoreScripts.TextChat.Tooltip.Global.Body"
	})

	if props.visible and v and v9 then
		local function onAnchorChanged(p)
			local parent2 = p.Parent

			if parent2 and parent2:IsA("GuiObject") then
				setState(parent2.AbsoluteSize.X)
			end
		end

		return React.createElement(Coachmark, {
			title = v11.headerText,
			text = v11.bodyText,
			isOpen = state2 and v2 and not state3,
			onClose = onClose,
			side = PopoverSide.Right,
			align = PopoverAlign.Start,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(v8, -13, 0, -48),
			onAbsoluteSizeChanged = onAnchorChanged,
			onAbsolutePositionChanged = onAnchorChanged
		}, {
			AnchorSizer = React.createElement("Frame", {
				Size = UDim2.new(0, 1, 0, Config.ChannelTabsSettings.HorizontalBarHeight),
				BackgroundTransparency = 1,
				BorderSizePixel = 0
			})
		})
	end

	return nil
end

local function GlobalChatTooltip(p)
	if FFlagExpChatUseUnifiedTooltipStore then
		return GlobalChatTooltipNew(p)
	end

	return GlobalChatTooltipLegacy(p)
end

return GlobalChatTooltip
