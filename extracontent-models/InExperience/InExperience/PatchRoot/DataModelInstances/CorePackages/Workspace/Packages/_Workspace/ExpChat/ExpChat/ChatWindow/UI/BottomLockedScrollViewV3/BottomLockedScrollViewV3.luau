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
local FFlagExpChatEnableFriendsTab = SharedFlags.FFlagExpChatEnableFriendsTab
local FFlagExpChatWindowMessageSourceRefactor = SharedFlags.FFlagExpChatWindowMessageSourceRefactor
local FFlagExpChatChannelTabRefactor = SharedFlags.FFlagExpChatChannelTabRefactor
local getFFlagExpChatSendWindowScrollEvent = require(ExpChat.Flags.getFFlagExpChatSendWindowScrollEvent)
local v20 = game:DefineFastInt("ExpChatWindowScrollV3Debounce", 0)
local FFlagExpChatScrollPerfTracking = require(ExpChatParent.ChatUIPrimitives).Flags.FFlagExpChatScrollPerfTracking
local FFlagExpChatLimitScrollingV2Window = require(ExpChat.Flags.FFlagExpChatLimitScrollingV2Window)
local FFlagExpChatScrollbarInset = require(ExpChat.Flags.FFlagExpChatScrollbarInset)
local FFlagExpChatFixWarmMountBottomLock = require(ExpChat.Flags.FFlagExpChatFixWarmMountBottomLock)
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local ExpChatPerfTracker = require(ExpChatParent.ChatUIPrimitives).Telemetry.ExpChatPerfTracker
local FFlagExpChatPerfTrackerTabName = require(ExpChatParent.ChatUIPrimitives).Flags.FFlagExpChatPerfTrackerTabName

require(ExpChatParent.SocialLuaAnalytics)

local v28 = game:DefineFastInt("ExpChatScrollLockThreshold", 90) / 100

local function isScrollbarNearBottom(p1) -- line: 61
	-- upvalues: v28 (copy)
	local AbsoluteWindowSize = p1.AbsoluteWindowSize
	local CanvasPosition = p1.CanvasPosition
	local AbsoluteCanvasSize = p1.AbsoluteCanvasSize
	local v37 = AbsoluteCanvasSize - AbsoluteWindowSize
	local v38 = CanvasPosition.Y / v37.Y

	if AbsoluteCanvasSize.Y <= AbsoluteWindowSize.Y then
		return true
	end

	return v38 >= v28
end
local function isMouseMovementOrTouch(p2) -- line: 76
	return p2 == Enum.PreferredInput.KeyboardAndMouse or p2 == Enum.PreferredInput.Touch
end

local v31 = debounce(function() -- line: 80
	-- upvalues: TextChatService (copy)
	TextChatService:SendExpChatWindowScroll()
end, v20)

local function BottomLockedScrollViewV3(t1: {[any]: any}) -- line: 87
	-- upvalues: useStyle (copy), React (copy), FFlagExpChatWindowMessageSourceRefactor (copy), FFlagExpChatEnableV2ChatWindow (copy), GetMessagesStore (copy), useV2MessagePool (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), SignalsReact (copy), UserInputService (copy), FFlagExpChatScrollPerfTracking (copy), ExpChatPerfTracker (copy), FFlagExpChatPerfTrackerTabName (copy), v28 (copy), getFFlagExpChatSendWindowScrollEvent (copy), v31 (copy), FFlagExpChatEnableFriendsTab (copy), FFlagExpChatChannelTabRefactor (copy), Config (copy), FFlagExpChatScrollbarInset (copy), FFlagExpChatLimitScrollingV2Window (copy), FFlagExpChatEnableFocusNavigation (copy), FFlagExpChatFixWarmMountBottomLock (copy)
	local Theme = useStyle().Theme
	local v42 = React.useRef(nil)
	local v43 = React.useRef(true)
	local v44, v45 = React.useBinding(false)
	local v46 = React.useRef(false)
	local v47 = not FFlagExpChatWindowMessageSourceRefactor and (FFlagExpChatEnableV2ChatWindow and t1.children == nil)
	local v48 = React.useBinding(0)
	local v49 = t1.textTransparency or v48
	local v50 = GetMessagesStore(false)
	local children = nil

	if not FFlagExpChatWindowMessageSourceRefactor then
		children = useV2MessagePool({
			enabled = v47,
			visible = t1.visible,
			messagesStore = v50,
			textTransparency = v49,
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

	local v52 = nil

	if FFlagExpChatWindowMessageSourceRefactor then
		v52 = SignalsReact.useSignalState(t1.messageComponentsSignal)
	end

	local v53 = React.useCallback(function() -- line: 129
		-- upvalues: UserInputService (copy), v45 (copy), v46 (copy)
		local PreferredInput = UserInputService.PreferredInput

		if PreferredInput == Enum.PreferredInput.KeyboardAndMouse or PreferredInput == Enum.PreferredInput.Touch then
			v45(true)
		end

		if PreferredInput == Enum.PreferredInput.Touch then
			v46.current = true
		end
	end, { UserInputService.PreferredInput })
	local v54 = React.useCallback(function() -- line: 140
		-- upvalues: UserInputService (copy), v45 (copy), v46 (copy)
		local PreferredInput = UserInputService.PreferredInput

		if PreferredInput == Enum.PreferredInput.KeyboardAndMouse or PreferredInput == Enum.PreferredInput.Touch then
			v45(false)
		end

		if PreferredInput == Enum.PreferredInput.Touch then
			v46.current = false
		end
	end, { UserInputService.PreferredInput })
	local u55 = nil

	if FFlagExpChatScrollPerfTracking then
		u55 = React.useRef(nil)
		React.useEffect(function() -- line: 154
			-- upvalues: u55 (ref)
			return function() -- line: 155
				-- upvalues: u55 (ref)
				if u55.current then
					u55.current.cleanup()
				end
			end
		end, {})
	end

	local v56 = React.useRef(t1.selectedChannelName)

	v56.current = t1.selectedChannelName

	local v57 = React.useCallback(function(p3) -- line: 166
		-- upvalues: FFlagExpChatScrollPerfTracking (copy), u55 (ref), v56 (copy), ExpChatPerfTracker (copy), FFlagExpChatPerfTrackerTabName (copy), v43 (copy), v28 (copy), getFFlagExpChatSendWindowScrollEvent (copy), v31 (copy), FFlagExpChatEnableFriendsTab (copy), t1 (copy)
		if FFlagExpChatScrollPerfTracking then
			if u55.current == nil then
				local current = v56.current

				u55.current = ExpChatPerfTracker.startChatWindowScrollInterval(ExpChatPerfTracker.Events.ChatWindowScrollInterval, p3, {}, if not FFlagExpChatPerfTrackerTabName or not current then nil else {
					tabName = current
				})
			end

			if u55.current then
				u55.current.onScrollTick()
			end
		end

		local v66 = v43
		local AbsoluteWindowSize = p3.AbsoluteWindowSize
		local CanvasPosition = p3.CanvasPosition
		local AbsoluteCanvasSize = p3.AbsoluteCanvasSize
		local v70 = AbsoluteCanvasSize - AbsoluteWindowSize
		local v71 = CanvasPosition.Y / v70.Y

		v66.current = AbsoluteCanvasSize.Y <= AbsoluteWindowSize.Y or v71 >= v28

		if getFFlagExpChatSendWindowScrollEvent() and not v43.current then
			v31()
		end

		if FFlagExpChatEnableFriendsTab and t1.onCanvasPositionChanged then
			local v72 = math.max(p3.AbsoluteCanvasSize.Y - p3.AbsoluteWindowSize.Y, 0)

			t1.onCanvasPositionChanged(p3.CanvasPosition, v72)
		end
	end, { if not FFlagExpChatEnableFriendsTab then nil else t1.onCanvasPositionChanged })
	local v58 = React.useCallback(function(p4) -- line: 191
		-- upvalues: v43 (copy), v46 (copy)
		if v43.current and not v46.current then
			p4.CanvasPosition = Vector2.new(0, 9007199254740992)
		end
	end, {})
	local v59 = if not FFlagExpChatChannelTabRefactor then t1.targetTextChannel else t1.scrollResetKey

	React.useEffect(function() -- line: 206
		-- upvalues: t1 (copy), v59 (copy), v43 (copy), v46 (copy), v42 (copy)
		if t1.isChannelBarVisible and v59 then
			v43.current = true

			if not v46.current and v42.current then
				v42.current.CanvasPosition = Vector2.new(0, 9007199254740992)
			end
		end
	end, {
		v59,
		t1.isChannelBarVisible
	})
	React.useEffect(function() -- line: 217
		-- upvalues: v42 (copy), v43 (copy), v46 (copy)
		local current = v42.current

		if not current then
			return
		end

		local connection = current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function() -- line: 225
			-- upvalues: v43 (copy), v46 (copy), v42 (copy)
			if v43.current and (not v46.current and v42.current) then
				v42.current.CanvasPosition = Vector2.new(0, 9007199254740992)
			end
		end)

		return function() -- line: 234
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, if not FFlagExpChatEnableV2ChatWindow and not FFlagExpChatWindowMessageSourceRefactor then {
		tostring(v42),
		v43,
		v46
	} else {
		v43.current,
		v46.current,
		v42.current,
		v59
	})

	local v60 = if not FFlagExpChatEnableFriendsTab or type(t1.contentTopPadding) ~= "number" then if not FFlagExpChatEnableFriendsTab or t1.contentTopPadding == nil then nil else t1.contentTopPadding:map(function(n1: number) -- line: 256
		return UDim.new(0, n1)
	end) else UDim.new(0, t1.contentTopPadding)
	local v61 = if not FFlagExpChatWindowMessageSourceRefactor then if not v47 then t1.children else children else v52

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = t1.Size,
		[React.Event.InputBegan] = v53,
		[React.Event.InputEnded] = v54
	}, {
		padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 0),
			PaddingBottom = UDim.new(0, 0),
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8)
		}),
		scrollView = React.createElement("ScrollingFrame", {
			ref = v42,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			ScrollBarImageColor3 = Theme.UIEmphasis.Color,
			ScrollBarImageTransparency = v44:map(function(p5) -- line: 284
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
			[React.Change.CanvasPosition] = v57,
			[React.Change.AbsoluteWindowSize] = if not FFlagExpChatFixWarmMountBottomLock then nil else v58
		}, if not FFlagExpChatEnableFriendsTab then v61 else {
			contentPadding = if v60 == nil then nil else React.createElement("UIPadding", {
				PaddingTop = v60
			}),
			messages = React.createElement(React.Fragment, nil, v61)
		})
	})
end

return React.memo(BottomLockedScrollViewV3)
