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
local GetFFlagTextChatEnableUniverseChatTabs = ExpChatShared.Flags.GetFFlagTextChatEnableUniverseChatTabs
local ExpChatPerfTracker = require(ExpChatParent.ChatUIPrimitives).Telemetry.ExpChatPerfTracker

require(ExpChatParent.SocialLuaAnalytics)

local v25 = game:DefineFastInt("ExpChatScrollLockThreshold", 90) / 100

local function isScrollbarNearBottom(p1) -- line: 56
	-- upvalues: v25 (copy)
	local AbsoluteWindowSize = p1.AbsoluteWindowSize
	local CanvasPosition = p1.CanvasPosition
	local AbsoluteCanvasSize = p1.AbsoluteCanvasSize
	local v34 = AbsoluteCanvasSize - AbsoluteWindowSize
	local v35 = CanvasPosition.Y / v34.Y

	if AbsoluteCanvasSize.Y <= AbsoluteWindowSize.Y then
		return true
	end

	return v35 >= v25
end
local function isMouseMovementOrTouch(p2) -- line: 71
	return p2 == Enum.PreferredInput.KeyboardAndMouse or p2 == Enum.PreferredInput.Touch
end

local v28 = debounce(function() -- line: 75
	-- upvalues: TextChatService (copy)
	TextChatService:SendExpChatWindowScroll()
end, v19)

local function BottomLockedScrollViewV3(t1: {[any]: any}) -- line: 82
	-- upvalues: useStyle (copy), React (copy), FFlagExpChatWindowMessageSourceRefactor (copy), FFlagExpChatEnableV2ChatWindow (copy), GetMessagesStore (copy), useV2MessagePool (copy), GetFFlagTextChatEnableUniverseChatTabs (copy), SignalsReact (copy), UserInputService (copy), FFlagExpChatScrollPerfTracking (copy), ExpChatPerfTracker (copy), v25 (copy), getFFlagExpChatSendWindowScrollEvent (copy), v28 (copy), FFlagExpChatChannelTabRefactor (copy), Config (copy), FFlagExpChatScrollbarInset (copy), FFlagExpChatLimitScrollingV2Window (copy), FFlagExpChatEnableFocusNavigation (copy)
	local Theme = useStyle().Theme
	local v39 = React.useRef(nil)
	local v40 = React.useRef(true)
	local v41, v42 = React.useBinding(false)
	local v43 = React.useRef(false)
	local v44 = not FFlagExpChatWindowMessageSourceRefactor and (FFlagExpChatEnableV2ChatWindow and t1.children == nil)
	local v45 = React.useBinding(0)
	local v46 = t1.textTransparency or v45
	local v47 = GetMessagesStore(false)
	local children = nil

	if not FFlagExpChatWindowMessageSourceRefactor then
		children = useV2MessagePool({
			enabled = v44,
			visible = t1.visible,
			messagesStore = v47,
			textTransparency = v46,
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

	local v49 = nil

	if FFlagExpChatWindowMessageSourceRefactor then
		v49 = SignalsReact.useSignalState(t1.messageComponentsSignal)
	end

	local v50 = React.useCallback(function() -- line: 124
		-- upvalues: UserInputService (copy), v42 (copy), v43 (copy)
		local PreferredInput = UserInputService.PreferredInput

		if PreferredInput == Enum.PreferredInput.KeyboardAndMouse or PreferredInput == Enum.PreferredInput.Touch then
			v42(true)
		end

		if PreferredInput == Enum.PreferredInput.Touch then
			v43.current = true
		end
	end, { UserInputService.PreferredInput })
	local v51 = React.useCallback(function() -- line: 135
		-- upvalues: UserInputService (copy), v42 (copy), v43 (copy)
		local PreferredInput = UserInputService.PreferredInput

		if PreferredInput == Enum.PreferredInput.KeyboardAndMouse or PreferredInput == Enum.PreferredInput.Touch then
			v42(false)
		end

		if PreferredInput == Enum.PreferredInput.Touch then
			v43.current = false
		end
	end, { UserInputService.PreferredInput })
	local u52 = nil

	if FFlagExpChatScrollPerfTracking then
		u52 = React.useRef(nil)
		React.useEffect(function() -- line: 149
			-- upvalues: u52 (ref)
			return function() -- line: 150
				-- upvalues: u52 (ref)
				if u52.current then
					u52.current.cleanup()
				end
			end
		end, {})
	end

	local v53 = React.useCallback(function(p3) -- line: 158
		-- upvalues: FFlagExpChatScrollPerfTracking (copy), u52 (ref), ExpChatPerfTracker (copy), v40 (copy), v25 (copy), getFFlagExpChatSendWindowScrollEvent (copy), v28 (copy)
		if FFlagExpChatScrollPerfTracking then
			if u52.current == nil then
				u52.current = ExpChatPerfTracker.startChatWindowScrollInterval(ExpChatPerfTracker.Events.ChatWindowScrollInterval, p3, {})
			end

			if u52.current then
				u52.current.onScrollTick()
			end
		end

		local v58 = v40
		local AbsoluteWindowSize = p3.AbsoluteWindowSize
		local CanvasPosition = p3.CanvasPosition
		local AbsoluteCanvasSize = p3.AbsoluteCanvasSize
		local v62 = AbsoluteCanvasSize - AbsoluteWindowSize
		local v63 = CanvasPosition.Y / v62.Y

		v58.current = AbsoluteCanvasSize.Y <= AbsoluteWindowSize.Y or v63 >= v25

		if getFFlagExpChatSendWindowScrollEvent() and not v40.current then
			v28()
		end
	end, {})
	local v54 = if not FFlagExpChatChannelTabRefactor then t1.targetTextChannel else t1.scrollResetKey

	React.useEffect(function() -- line: 186
		-- upvalues: t1 (copy), v54 (copy), v40 (copy), v43 (copy), v39 (copy)
		if t1.isChannelBarVisible and v54 then
			v40.current = true

			if not v43.current and v39.current then
				v39.current.CanvasPosition = Vector2.new(0, 9007199254740992)
			end
		end
	end, {
		v54,
		t1.isChannelBarVisible
	})
	React.useEffect(function() -- line: 197
		-- upvalues: v39 (copy), v40 (copy), v43 (copy)
		local current = v39.current

		if not current then
			return
		end

		local connection = current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function() -- line: 205
			-- upvalues: v40 (copy), v43 (copy), v39 (copy)
			if v40.current and (not v43.current and v39.current) then
				v39.current.CanvasPosition = Vector2.new(0, 9007199254740992)
			end
		end)

		return function() -- line: 214
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, if not FFlagExpChatEnableV2ChatWindow and not FFlagExpChatWindowMessageSourceRefactor then {
		tostring(v39),
		v40,
		v43
	} else {
		v40.current,
		v43.current,
		v39.current,
		v54
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = t1.Size,
		[React.Event.InputBegan] = v50,
		[React.Event.InputEnded] = v51
	}, {
		padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 0),
			PaddingBottom = UDim.new(0, 0),
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8)
		}),
		scrollView = React.createElement("ScrollingFrame", {
			ref = v39,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BorderSizePixel = 0,
			ScrollBarImageColor3 = Theme.UIEmphasis.Color,
			ScrollBarImageTransparency = v41:map(function(p4) -- line: 251
				if p4 then
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
			[React.Change.CanvasPosition] = v53
		}, if not FFlagExpChatWindowMessageSourceRefactor then if not v44 then t1.children else children else v49)
	})
end

return React.memo(BottomLockedScrollViewV3)
