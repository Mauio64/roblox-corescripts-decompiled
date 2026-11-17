local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")

local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
require(parent.Signals)

local Config = require(ExpChat.Config)
local advanceHistoryScroll = require(script.Parent.advanceHistoryScroll)

local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local debounce = require(ExpChat.ChatWindow.Helpers.debounce)
local getFFlagExpChatSendWindowScrollEvent = require(ExpChat.Flags.getFFlagExpChatSendWindowScrollEvent)
local defineFastInt = game:DefineFastInt("ExpChatWindowScrollV3Debounce", 0)
local FFlagExpChatLimitScrollingV2Window = require(ExpChat.Flags.FFlagExpChatLimitScrollingV2Window)
local FFlagExpChatScrollbarInset = require(ExpChat.Flags.FFlagExpChatScrollbarInset)
local FFlagExpChatFixWarmMountBottomLock = require(ExpChat.Flags.FFlagExpChatFixWarmMountBottomLock)
local FFlagExpChatRenderHistoricalMessages = require(ExpChat.Flags.FFlagExpChatRenderHistoricalMessages)

local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local ExpChatPerfTracker = ChatUIPrimitives.Telemetry.ExpChatPerfTracker
local ChatUIPrimitives2 = require(parent.ChatUIPrimitives)
local FFlagExpChatPerfTrackerTabName = ChatUIPrimitives2.Flags.FFlagExpChatPerfTrackerTabName
require(parent.SocialLuaAnalytics)

local v = game:DefineFastInt("ExpChatScrollLockThreshold", 90) / 100

local function isScrollbarNearBottom(data): boolean -- 1 equivalent call inferred from this helper
	local absoluteWindowSize = data.AbsoluteWindowSize
	local canvasPosition = data.CanvasPosition
	local absoluteCanvasSize = data.AbsoluteCanvasSize
	local v2 = absoluteCanvasSize - absoluteWindowSize
	local v3 = canvasPosition.Y / v2.Y

	return absoluteCanvasSize.Y <= absoluteWindowSize.Y or v <= v3
end

local function isMouseMovementOrTouch(preferredInput): boolean -- 2 equivalent calls inferred from this helper
	return preferredInput == Enum.PreferredInput.KeyboardAndMouse or preferredInput == Enum.PreferredInput.Touch
end

local v2 = debounce(function()
	TextChatService:SendExpChatWindowScroll()
end, defineFastInt)

local function BottomLockedScrollViewV3(props)
	local theme = useStyle().Theme

	local ref = React.useRef(nil)
	local scrollToTopOnReset = props.scrollToTopOnReset == true
	local ref2 = React.useRef(not scrollToTopOnReset)
	local ref3 = React.useRef(nil)
	local ref4 = React.useRef(false)
	local ref5 = React.useRef(nil)
	local v3, v4 = React.useBinding(false)
	local ref6 = React.useRef(false)
	local ref7 = React.useRef({ canvasHeight = nil, historicalCount = 0 })

	local v5 = SignalsReact.useSignalState(props.messageComponentsSignal)

	local v6 = React.useCallback(function()
		local preferredInput = UserInputService.PreferredInput

		if isMouseMovementOrTouch(preferredInput) then -- inferred equivalent call
			v4(true)
		end

		if preferredInput == Enum.PreferredInput.Touch then
			ref6.current = true
		end
	end, { UserInputService.PreferredInput })

	local v7 = React.useCallback(function()
		local preferredInput = UserInputService.PreferredInput

		if isMouseMovementOrTouch(preferredInput) then -- inferred equivalent call
			v4(false)
		end

		if preferredInput == Enum.PreferredInput.Touch then
			ref6.current = false

			if ref5.current ~= nil and ref5.current == ref3.current and ref.current then
				ref.current.CanvasPosition = Vector2.new(0, 0)
				ref4.current = true
				ref5.current = nil
			end
		end
	end, { UserInputService.PreferredInput })

	local ref8 = React.useRef(nil)
	React.useEffect(function()
		return function()
			if ref8.current then
				ref8.current.cleanup()
			end
		end
	end, {})

	local ref9 = React.useRef(props.selectedChannelName)
	ref9.current = props.selectedChannelName

	local v8 = React.useCallback(function(data)
		if ref8.current == nil then
			local current = ref9.current
			ref8.current = ExpChatPerfTracker.startChatWindowScrollInterval(
				ExpChatPerfTracker.Events.ChatWindowScrollInterval,
				data,
				{},
				FFlagExpChatPerfTrackerTabName and current and { tabName = current } or nil
			)
		end

		if ref8.current then
			ref8.current.onScrollTick()
		end

		ref2.current = isScrollbarNearBottom(data) -- inferred equivalent call

		if getFFlagExpChatSendWindowScrollEvent() and not ref2.current then
			v2()
		end

		if props.onCanvasPositionChanged then
			local v8 = math.max(data.AbsoluteCanvasSize.Y - data.AbsoluteWindowSize.Y, 0)
			props.onCanvasPositionChanged(data.CanvasPosition, v8)
		end
	end, { props.onCanvasPositionChanged })

	local v9 = React.useCallback(function(p)
		if ref2.current and not ref6.current then
			p.CanvasPosition = Vector2.new(0, 9007199254740992)
		end
	end, {})

	local scrollResetKey = props.scrollResetKey

	React.useEffect(function()
		if ref3.current ~= scrollResetKey then
			ref3.current = scrollResetKey
			ref4.current = false
			ref5.current = nil
		end

		local v10 = scrollResetKey and scrollToTopOnReset and not ref4.current

		local v11 = scrollResetKey and props.isChannelBarVisible and not (scrollToTopOnReset or ref4.current)

		if v10 then
			ref2.current = false

			if ref6.current or not ref.current then
				ref5.current = scrollResetKey
				return
			end

			ref.current.CanvasPosition = Vector2.new(0, 0)
			ref4.current = true
			ref5.current = nil
		elseif v11 then
			ref2.current = true

			if not ref6.current and ref.current then
				ref.current.CanvasPosition = Vector2.new(0, 9007199254740992)
			end
		end
	end, { scrollResetKey, props.isChannelBarVisible, scrollToTopOnReset })

	React.useEffect(function()
		local current = ref.current

		if not current then
			return
		end

		local historicalMessageCountSignal = props.historicalMessageCountSignal

		local absoluteCanvasSizeChangedConnection = current:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
			if FFlagExpChatRenderHistoricalMessages and historicalMessageCountSignal then
				local v10 = advanceHistoryScroll(
					ref7.current,
					current.AbsoluteCanvasSize.Y,
					historicalMessageCountSignal(false)
				)

				if v10 > 0 and not (ref2.current or ref6.current) then
					current.CanvasPosition += Vector2.new(0, v10)
				end
			end

			if ref2.current and not ref6.current and ref.current then
				ref.current.CanvasPosition = Vector2.new(0, 9007199254740992)
			end
		end)

		return function()
			absoluteCanvasSizeChangedConnection:Disconnect()
		end
	end, {
		ref2.current,
		ref6.current,
		ref.current,
		scrollResetKey,
		props.historicalMessageCountSignal
	})
	local paddingTop

	if type(props.contentTopPadding) == "number" then
		paddingTop = UDim.new(0, props.contentTopPadding)
	elseif props.contentTopPadding ~= nil then
		paddingTop = props.contentTopPadding:map(function(p: number)
			return UDim.new(0, p)
		end)
	end

	local createElement = React.createElement
	local v10 = {
		BackgroundTransparency = 1,
		Size = props.Size,
		[React.Event.InputBegan] = v6,
		[React.Event.InputEnded] = v7
	}
	local v11 = {
		padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 0),
			PaddingBottom = UDim.new(0, 0),
			PaddingLeft = UDim.new(0, 8),
			PaddingRight = UDim.new(0, 8)
		}),
		scrollView = 0
	}

	local createElement2 = React.createElement
	local v12 = {}
	v12.ref = ref
	v12.AutomaticCanvasSize = Enum.AutomaticSize.Y
	v12.BorderSizePixel = 0
	v12.ScrollBarImageColor3 = theme.UIEmphasis.Color
	v12.ScrollBarImageTransparency = v3:map(function(p): number
		return if p then 0 else 1
	end)

	v12.ScrollBarThickness = Config.ChatWindowScrollBarThickness
	local verticalScrollBarInset

	if FFlagExpChatScrollbarInset then
		verticalScrollBarInset = Enum.ScrollBarInset.Always
	end

	v12.VerticalScrollBarInset = verticalScrollBarInset
	local scrollingDirection

	if FFlagExpChatLimitScrollingV2Window then
		scrollingDirection = Enum.ScrollingDirection.Y
	end

	v12.ScrollingDirection = scrollingDirection
	v12.Selectable = false
	v12.BackgroundTransparency = 1
	v12.Size = UDim2.fromScale(1, 1)
	v12.CanvasSize = UDim2.new()
	v12[React.Change.CanvasPosition] = v8
	local absoluteWindowSize = React.Change.AbsoluteWindowSize

	if not FFlagExpChatFixWarmMountBottomLock then
		v9 = nil
	end

	v12[absoluteWindowSize] = v9
	local contentPadding

	if paddingTop ~= nil then
		contentPadding = React.createElement("UIPadding", { PaddingTop = paddingTop })
	end

	v11.scrollView = createElement2("ScrollingFrame", v12, {
		contentPadding = contentPadding,
		messages = React.createElement(React.Fragment, nil, v5)
	})
	return createElement("Frame", v10, v11)
end

return React.memo(BottomLockedScrollViewV3)
