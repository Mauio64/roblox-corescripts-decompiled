local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local Config = require(ExpChat.Config)
local GetTransparencyStore = require(ExpChat.Stores.GetTransparencyStore)
local GetChatTooltipStore = require(ExpChat.Stores.GetChatTooltipStore)
require(ExpChat.Stores.GetChatTooltipStore.createChatTooltipStore)

local function useChatTooltipLifecycle(p)
	local tooltipKey = p.tooltipKey
	local targetTextChannel = p.targetTextChannel

	local chatTooltipStore = GetChatTooltipStore(false)
	local transparencyStore = GetTransparencyStore(false)

	local v = SignalsReact.useSignalState(chatTooltipStore.getShouldShow(tooltipKey))
	local v2 = SignalsReact.useSignalState(chatTooltipStore.getIsScreenWideEnough)
	local getIsFocused = transparencyStore.getIsFocused or transparencyStore.getIsTextBoxFocused
	local v3 = SignalsReact.useSignalState(transparencyStore.getLastActivity)
	local v4 = SignalsReact.useSignalState(getIsFocused)

	local state, setState = React.useState(true)
	local state2, setState2 = React.useState(false)

	local ref = React.useRef(false)
	local ref2 = React.useRef(0)
	local ref3 = React.useRef(targetTextChannel)

	local setIsDismissed = chatTooltipStore.setIsDismissed
	local reportImpression = chatTooltipStore.reportImpression
	local onDismiss = React.useCallback(function()
		if not ref.current then
			ref.current = true
			reportImpression(tooltipKey)
		end

		setIsDismissed(tooltipKey, true)
	end, { tooltipKey, setIsDismissed, reportImpression })

	React.useEffect(function()
		if v4 then
			setState(true)
			return nil
		end

		local v5 = Config.ChatWindowBackgroundFadeOutTime - (os.clock() - v3)

		if v5 <= 0 then
			setState(false)
			return nil
		end

		setState(true)
		local thread = task.delay(v5, function()
			setState(false)
		end)
		return function()
			task.cancel(thread)
		end
	end, { v3, v4 })

	React.useEffect(function()
		if not (state and v2) or state2 or not v then
			return nil
		end

		local lastTime = os.clock()
		local v5 = math.max(0, 10 - ref2.current)
		local thread = task.delay(v5, function()
			setState2(true)
		end)
		return function()
			ref2.current += os.clock() - lastTime
			task.cancel(thread)
		end
	end, { state, v2, state2, v })

	React.useEffect(function()
		if not state2 then
			return nil
		end

		local thread = task.delay(1, function()
			onDismiss()
		end)
		return function()
			task.cancel(thread)
		end
	end, { state2, onDismiss })

	React.useEffect(function()
		local current = ref3.current
		ref3.current = targetTextChannel

		if current and current ~= targetTextChannel and v and not state2 then
			setState2(true)
		end
	end, { targetTextChannel, v, state2 })

	return {
		isActive = v and state and v2 and not state2,
		onDismiss = onDismiss
	}
end

return useChatTooltipLifecycle
