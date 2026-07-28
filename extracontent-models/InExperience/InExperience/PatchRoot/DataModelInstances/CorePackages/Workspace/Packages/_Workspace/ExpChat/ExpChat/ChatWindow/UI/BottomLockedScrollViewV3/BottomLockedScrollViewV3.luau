local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local SignalsReact = require(ExpChatParent.SignalsReact)

require(ExpChatParent.Signals)

local ExpChatShared = require(ExpChatParent.ExpChatShared)
local SharedFlags = require(ExpChatParent.SharedFlags)
local GetMessagesStore = require(ExpChat.Stores.GetMessagesStore)
local Config = require(ExpChat.Config)
local useStyle = require(ExpChatParent.UIBlox).Core.Style.useStyle
local debounce = require(ExpChat.ChatWindow.Helpers.debounce)
local useV2MessagePool = require(script.Parent.useV2MessagePool)
local FFlagExpChatEnableFocusNavigation = require(ExpChat.Flags.FFlagExpChatEnableFocusNavigation)
local FFlagExpChatEnableV2ChatWindow = require(ExpChat.Flags.FFlagExpChatEnableV2ChatWindow)
local FFlagExpChatWindowMessageSourceRefactor = SharedFlags.FFlagExpChatWindowMessageSourceRefactor
local FFlagExpChatChannelTabRefactor = SharedFlags.FFlagExpChatChannelTabRefactor
local getFFlagExpChatSendWindowScrollEvent = require(ExpChat.Flags.getFFlagExpChatSendWindowScrollEvent)
local v19 = game:DefineFastInt("ExpChatWindowScrollV3Debounce", 0)
local FFlagExpChatScrollPerfTracking = require(ExpChatParent.ChatUIPrimitives).Flags.FFlagExpChatScrollPerfTracking
local FFlagExpChatLimitScrollingV2Window = require(ExpChat.Flags.FFlagExpChatLimitScrollingV2Window)
local FFlagExpChatScrollbarInset = require(ExpChat.Flags.FFlagExpChatScrollbarInset)
local FFlagExpChatFixWarmMountBottomLock = require(ExpChat.Flags.FFlagExpChatFixWarmMountBottomLock)
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local ExpChatPerfTracker = require(ExpChatParent.ChatUIPrimitives).Telemetry.ExpChatPerfTracker

require(ExpChatParent.SocialLuaAnalytics)

local v26 = game:DefineFastInt("ExpChatScrollLockThreshold", 90) / 100

local function isScrollbarNearBottom(p1) -- line: 57
	-- upvalues: v26 (copy)
	local AbsoluteWindowSize = p1.AbsoluteWindowSize
	local CanvasPosition = p1.CanvasPosition
	local AbsoluteCanvasSize = p1.AbsoluteCanvasSize
	local v35 = AbsoluteCanvasSize - AbsoluteWindowSize
	local v36 = CanvasPosition.Y / v35.Y

	if AbsoluteCanvasSize.Y <= AbsoluteWindowSize.Y then
		return true
	end

	return v36 >= v26
end
local function isMouseMovementOrTouch(p2) -- line: 72
	return p2 == Enum.PreferredInput.KeyboardAndMouse or p2 == Enum.PreferredInput.Touch
end

local v29 = debounce(function() -- line: 76
	-- upvalues: TextChatService (copy)
	TextChatService:SendExpChatWindowScroll()
end, v19)

local function BottomLockedScrollViewV3(t1: {[any]: any}) -- line: 83
	-- upvalues: useStyle (copy), React (copy), FFlagExpChatWindowMessageSourceRefactor (copy), FFlagExpChatEnableV2ChatWindow (copy), GetMessagesStore (copy), useV2MessagePool (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), SignalsReact (copy), UserInputService (copy), FFlagExpChatScrollPerfTracking (copy), ExpChatPerfTracker (copy), v26 (copy), getFFlagExpChatSendWindowScrollEvent (copy), v29 (copy), FFlagExpChatChannelTabRefactor (copy), Config (copy), FFlagExpChatScrollbarInset (copy), FFlagExpChatLimitScrollingV2Window (copy), FFlagExpChatEnableFocusNavigation (copy), FFlagExpChatFixWarmMountBottomLock (copy)
	local Theme = useStyle().Theme
	local v40 = React.useRef(nil)
	local v41 = React.useRef(true)
	local v42, v43 = React.useBinding(false)
	local v44 = React.useRef(false)
	local v45 = not FFlagExpChatWindowMessageSourceRefactor and (FFlagExpChatEnableV2ChatWindow and t1.children == nil)
	local v46 = React.useBinding(0)
	local v47 = t1.textTransparency or v46
	local v48 = GetMessagesStore(false)
	local children = nil

	if not FFlagExpChatWindowMessageSourceRefactor then
		children = useV2MessagePool({
			enabled = v45,
			visible = t1.visible,
			messagesStore = v48,
			textTransparency = v47,
			chatWindowSettings = t1.chatWindowSettings,
			isSpatialUIEnabled = t1.isSpatialUIEnabled,
			onTextMessageLabelButtonActivated = t1.onTextMessageLabelButtonActivated,
			targetTextChannel = t1.targetTextChannel,
			isChannelBarVisible = t1.isChannelBarVisible,
			showTranslationButton = t1.showTranslationButton,
			chatWindowTransparencyBindable = t1.chatWindowTransparencyBindable,
			selectedChannelName = if not GetFFlagTextChatEnableUniverseChatTabs() then nil else t1.selectedChannelName
		}).children
	end

	local v50 = nil

	if FFlagExpChatWindowMessageSourceRefactor then
		v50 = SignalsReact.useSignalState(t1.messageComponentsSignal)
	end

	local v51 = React.useCallback(function() -- line: 125
		-- upvalues: UserInputService (copy), v43 (copy), v44 (copy)
		local PreferredInput = UserInputService.PreferredInput

		if PreferredInput == Enum.PreferredInput.KeyboardAndMouse or PreferredInput == Enum.PreferredInput.Touch then
			v43(true)
		end

		if PreferredInput == Enum.PreferredInput.Touch then
			v44.current = true
		end
	end, { UserInputService.PreferredInput })
	local v52 = React.useCallback(function() -- line: 136
		-- upvalues: UserInputService (copy), v43 (copy), v44 (copy)
		local PreferredInput = UserInputService.PreferredInput

		if PreferredInput == Enum.PreferredInput.KeyboardAndMouse or PreferredInput == Enum.PreferredInput.Touch then
			v43(false)
		end

		if PreferredInput == Enum.PreferredInput.Touch then
			v44.current = false
		end
	end, { UserInputService.PreferredInput })
	local u53 = nil

	if FFlagExpChatScrollPerfTracking then
		u53 = React.useRef(nil)
		React.useEffect(function() -- line: 150
			-- upvalues: u53 (ref)
			return function() -- line: 151
				-- upvalues: u53 (ref)
				if u53.current then
					u53.current.cleanup()
				end
			end
		end, {})
	end

	local v54 = React.useCallback(function(p3) -- line: 159
		-- upvalues: FFlagExpChatScrollPerfTracking (copy), u53 (ref), ExpChatPerfTracker (copy), v41 (copy), v26 (copy), getFFlagExpChatSendWindowScrollEvent (copy), v29 (copy)
		if FFlagExpChatScrollPerfTracking then
			if u53.current == nil then
				u53.current = ExpChatPerfTracker.startChatWindowScrollInterval(ExpChatPerfTracker.Events.ChatWindowScrollInterval, p3, {})
			end

			if u53.current then
				u53.current.onScrollTick()
			end
		end

		local v60 = v41
		local AbsoluteWindowSize = p3.AbsoluteWindowSize
		local CanvasPosition = p3.CanvasPosition
		local AbsoluteCanvasSize = p3.AbsoluteCanvasSize
		local v64 = AbsoluteCanvasSize - AbsoluteWindowSize
		local v65 = CanvasPosition.Y / v64.Y

		v60.current = AbsoluteCanvasSize.Y <= AbsoluteWindowSize.Y or v65 >= v26

		if getFFlagExpChatSendWindowScrollEvent() and not v41.current then
			v29()
		end
	end, {})
	local v55 = React.useCallback(function(p4) -- line: 178
		-- upvalues: v41 (copy), v44 (copy)
		if v41.current and not v44.current then
			p4.CanvasPosition = Vector2.new(0, 9007199254740992)
		end
	end, {})
	local v56 = if not FFlagExpChatChannelTabRefactor then t1.targetTextChannel else t1.scrollResetKey

	React.useEffect(function() -- line: 193
		-- upvalues: t1 (copy), v56 (copy), v41 (copy), v44 (copy), v40 (copy)
		if t1.isChannelBarVisible and v56 then
			v41.current = true

			if not v44.current and v40.current then
				v40.current.CanvasPosition = Vector2.new(0, 9007199254740992)
			end
		end
	end, {
		v56,
		t1.isChannelBarVisible
	})
	React.useEffect(function() -- line: 204
		-- upvalues: v40 (copy), v41 (copy), v44 (copy)
		local current = v40.current

		if not current then
			return
		end

		local connection = current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function() -- line: 212
			-- upvalues: v41 (copy), v44 (copy), v40 (copy)
			if v41.current and (not v44.current and v40.current) then
				v40.current.CanvasPosition = Vector2.new(0, 9007199254740992)
			end
		end)

		return function() -- line: 221
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, if not FFlagExpChatEnableV2ChatWindow and not FFlagExpChatWindowMessageSourceRefactor then {
		tostring(v40),
		v41,
		v44
	} else {
		v41.current,
		v44.current,
		v40.current,
		v56
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = t1.Size,
		[React.Event.InputBegan] = v51,
		[React.Event.InputEnded] = v52
	}, {
		padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 0),
			PaddingBottom = UDim.new(0, 0),
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8)
		}),
		scrollView = React.createElement("ScrollingFrame", {
			ref = v40,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			ScrollBarImageColor3 = Theme.UIEmphasis.Color,
			ScrollBarImageTransparency = v42:map(function(p5) -- line: 258
				if p5 then
					return 0
				end

				return 1
			end),
			ScrollBarThickness = Config.ChatWindowScrollBarThickness,
			VerticalScrollBarInset = if not FFlagExpChatScrollbarInset then nil else Enum.ScrollBarInset.Always,
			ScrollingDirection = if not FFlagExpChatLimitScrollingV2Window then nil else Enum.ScrollingDirection.Y,
			Selectable = not FFlagExpChatEnableFocusNavigation and nil,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			CanvasSize = UDim2.new(),
			[React.Change.CanvasPosition] = v54,
			[React.Change.AbsoluteWindowSize] = if not FFlagExpChatFixWarmMountBottomLock then nil else v55
		}, if not FFlagExpChatWindowMessageSourceRefactor then if not v45 then t1.children else children else v50)
	})
end

return React.memo(BottomLockedScrollViewV3)
