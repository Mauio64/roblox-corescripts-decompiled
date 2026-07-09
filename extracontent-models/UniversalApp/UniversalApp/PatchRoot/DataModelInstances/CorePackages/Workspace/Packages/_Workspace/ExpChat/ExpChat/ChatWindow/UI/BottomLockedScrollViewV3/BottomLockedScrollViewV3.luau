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
local useStyle = require(ExpChatParent.UIBlox).Core.Style.useStyle
local debounce = require(ExpChat.ChatWindow.Helpers.debounce)
local useV2MessagePool = require(script.Parent.useV2MessagePool)
local FFlagExpChatEnableFocusNavigation = require(ExpChat.Flags.FFlagExpChatEnableFocusNavigation)
local FFlagExpChatEnableV2ChatWindow = require(ExpChat.Flags.FFlagExpChatEnableV2ChatWindow)
local FFlagExpChatWindowMessageSourceRefactor = SharedFlags.FFlagExpChatWindowMessageSourceRefactor
local FFlagExpChatChannelTabRefactor = SharedFlags.FFlagExpChatChannelTabRefactor
local getFFlagExpChatSendWindowScrollEvent = require(ExpChat.Flags.getFFlagExpChatSendWindowScrollEvent)
local v18 = game:DefineFastInt("ExpChatWindowScrollV3Debounce", 0)
local FFlagExpChatScrollPerfTracking = require(ExpChatParent.ChatUIPrimitives).Flags.FFlagExpChatScrollPerfTracking
local FFlagExpChatLimitScrollingV2Window = require(ExpChat.Flags.FFlagExpChatLimitScrollingV2Window)
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local ExpChatPerfTracker = require(ExpChatParent.ChatUIPrimitives).Telemetry.ExpChatPerfTracker

require(ExpChatParent.SocialLuaAnalytics)

local v23 = game:DefineFastInt("ExpChatScrollLockThreshold", 90) / 100

local function isScrollbarNearBottom(p1) -- line: 53
	-- upvalues: v23 (copy)
	local AbsoluteWindowSize = p1.AbsoluteWindowSize
	local CanvasPosition = p1.CanvasPosition
	local AbsoluteCanvasSize = p1.AbsoluteCanvasSize
	local v32 = AbsoluteCanvasSize - AbsoluteWindowSize
	local v33 = CanvasPosition.Y / v32.Y

	if AbsoluteCanvasSize.Y <= AbsoluteWindowSize.Y then
		return true
	end

	return v33 >= v23
end
local function isMouseMovementOrTouch(p2) -- line: 68
	return p2 == Enum.PreferredInput.KeyboardAndMouse or p2 == Enum.PreferredInput.Touch
end

local v26 = debounce(function() -- line: 72
	-- upvalues: TextChatService (copy)
	TextChatService:SendExpChatWindowScroll()
end, v18)

local function BottomLockedScrollViewV3(t1: {[any]: any}) -- line: 79
	-- upvalues: useStyle (copy), React (copy), FFlagExpChatWindowMessageSourceRefactor (copy), FFlagExpChatEnableV2ChatWindow (copy), GetMessagesStore (copy), useV2MessagePool (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), SignalsReact (copy), UserInputService (copy), FFlagExpChatScrollPerfTracking (copy), ExpChatPerfTracker (copy), v23 (copy), getFFlagExpChatSendWindowScrollEvent (copy), v26 (copy), FFlagExpChatChannelTabRefactor (copy), FFlagExpChatLimitScrollingV2Window (copy), FFlagExpChatEnableFocusNavigation (copy)
	local Theme = useStyle().Theme
	local v37 = React.useRef(nil)
	local v38 = React.useRef(true)
	local v39, v40 = React.useBinding(false)
	local v41 = React.useRef(false)
	local v42 = not FFlagExpChatWindowMessageSourceRefactor and (FFlagExpChatEnableV2ChatWindow and t1.children == nil)
	local v43 = React.useBinding(0)
	local v44 = t1.textTransparency or v43
	local v45 = GetMessagesStore(false)
	local children = nil

	if not FFlagExpChatWindowMessageSourceRefactor then
		children = useV2MessagePool({
			enabled = v42,
			visible = t1.visible,
			messagesStore = v45,
			textTransparency = v44,
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

	local v47 = nil

	if FFlagExpChatWindowMessageSourceRefactor then
		v47 = SignalsReact.useSignalState(t1.messageComponentsSignal)
	end

	local v48 = React.useCallback(function() -- line: 121
		-- upvalues: UserInputService (copy), v40 (copy), v41 (copy)
		local PreferredInput = UserInputService.PreferredInput

		if PreferredInput == Enum.PreferredInput.KeyboardAndMouse or PreferredInput == Enum.PreferredInput.Touch then
			v40(true)
		end

		if PreferredInput == Enum.PreferredInput.Touch then
			v41.current = true
		end
	end, { UserInputService.PreferredInput })
	local v49 = React.useCallback(function() -- line: 132
		-- upvalues: UserInputService (copy), v40 (copy), v41 (copy)
		local PreferredInput = UserInputService.PreferredInput

		if PreferredInput == Enum.PreferredInput.KeyboardAndMouse or PreferredInput == Enum.PreferredInput.Touch then
			v40(false)
		end

		if PreferredInput == Enum.PreferredInput.Touch then
			v41.current = false
		end
	end, { UserInputService.PreferredInput })
	local u50 = nil

	if FFlagExpChatScrollPerfTracking then
		u50 = React.useRef(nil)
		React.useEffect(function() -- line: 146
			-- upvalues: u50 (ref)
			return function() -- line: 147
				-- upvalues: u50 (ref)
				if u50.current then
					u50.current.cleanup()
				end
			end
		end, {})
	end

	local v51 = React.useCallback(function(p3) -- line: 155
		-- upvalues: FFlagExpChatScrollPerfTracking (copy), u50 (ref), ExpChatPerfTracker (copy), v38 (copy), v23 (copy), getFFlagExpChatSendWindowScrollEvent (copy), v26 (copy)
		if FFlagExpChatScrollPerfTracking then
			if u50.current == nil then
				u50.current = ExpChatPerfTracker.startChatWindowScrollInterval(ExpChatPerfTracker.Events.ChatWindowScrollInterval, p3, {})
			end

			if u50.current then
				u50.current.onScrollTick()
			end
		end

		local v56 = v38
		local AbsoluteWindowSize = p3.AbsoluteWindowSize
		local CanvasPosition = p3.CanvasPosition
		local AbsoluteCanvasSize = p3.AbsoluteCanvasSize
		local v60 = AbsoluteCanvasSize - AbsoluteWindowSize
		local v61 = CanvasPosition.Y / v60.Y

		v56.current = AbsoluteCanvasSize.Y <= AbsoluteWindowSize.Y or v61 >= v23

		if getFFlagExpChatSendWindowScrollEvent() and not v38.current then
			v26()
		end
	end, {})
	local v52 = if not FFlagExpChatChannelTabRefactor then t1.targetTextChannel else t1.scrollResetKey

	React.useEffect(function() -- line: 183
		-- upvalues: t1 (copy), v52 (copy), v38 (copy), v41 (copy), v37 (copy)
		if t1.isChannelBarVisible and v52 then
			v38.current = true

			if not v41.current and v37.current then
				v37.current.CanvasPosition = Vector2.new(0, 9007199254740992)
			end
		end
	end, {
		v52,
		t1.isChannelBarVisible
	})
	React.useEffect(function() -- line: 194
		-- upvalues: v37 (copy), v38 (copy), v41 (copy)
		local current = v37.current

		if not current then
			return
		end

		local connection = current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function() -- line: 202
			-- upvalues: v38 (copy), v41 (copy), v37 (copy)
			if v38.current and (not v41.current and v37.current) then
				v37.current.CanvasPosition = Vector2.new(0, 9007199254740992)
			end
		end)

		return function() -- line: 211
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, if not FFlagExpChatEnableV2ChatWindow and not FFlagExpChatWindowMessageSourceRefactor then {
		tostring(v37),
		v38,
		v41
	} else {
		v38.current,
		v41.current,
		v37.current,
		v52
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = t1.Size,
		[React.Event.InputBegan] = v48,
		[React.Event.InputEnded] = v49
	}, {
		padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 0),
			PaddingBottom = UDim.new(0, 0),
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8)
		}),
		scrollView = React.createElement("ScrollingFrame", {
			ref = v37,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			ScrollBarImageColor3 = Theme.UIEmphasis.Color,
			ScrollBarImageTransparency = v39:map(function(p4) -- line: 248
				if p4 then
					return 0
				end

				return 1
			end),
			ScrollBarThickness = 8,
			ScrollingDirection = if not FFlagExpChatLimitScrollingV2Window then nil else Enum.ScrollingDirection.Y,
			Selectable = not FFlagExpChatEnableFocusNavigation and nil,
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			CanvasSize = UDim2.new(),
			[React.Change.CanvasPosition] = v51
		}, if not FFlagExpChatWindowMessageSourceRefactor then if not v42 then t1.children else children else v47)
	})
end

return React.memo(BottomLockedScrollViewV3)
