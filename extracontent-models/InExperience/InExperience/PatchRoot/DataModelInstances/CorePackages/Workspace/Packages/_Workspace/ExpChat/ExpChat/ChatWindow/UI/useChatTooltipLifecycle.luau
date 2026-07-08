local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local SignalsReact = require(ExpChatParent.SignalsReact)
local Config = require(ExpChat.Config)
local GetTransparencyStore = require(ExpChat.Stores.GetTransparencyStore)
local GetChatTooltipStore = require(ExpChat.Stores.GetChatTooltipStore)

require(ExpChat.Stores.GetChatTooltipStore.createChatTooltipStore)

local function useChatTooltipLifecycle(t1: {[any]: any}) -- line: 49
	-- upvalues: GetChatTooltipStore (copy), GetTransparencyStore (copy), SignalsReact (copy), React (copy), Config (copy)
	local tooltipKey = t1.tooltipKey
	local targetTextChannel = t1.targetTextChannel
	local v12 = GetChatTooltipStore(false)
	local v13 = GetTransparencyStore(false)
	local v14 = SignalsReact.useSignalState(v12.getShouldShow(tooltipKey))
	local v15 = SignalsReact.useSignalState(v12.getIsScreenWideEnough)
	local v16 = v13.getIsFocused or v13.getIsTextBoxFocused
	local v17 = SignalsReact.useSignalState(v13.getLastActivity)
	local v18 = SignalsReact.useSignalState(v16)
	local v19, v20 = React.useState(true)
	local v21, v22 = React.useState(false)
	local v23 = React.useRef(false)
	local v24 = React.useRef(0)
	local v25 = React.useRef(targetTextChannel)
	local setIsDismissed = v12.setIsDismissed
	local reportImpression = v12.reportImpression
	local v28 = React.useCallback(function() -- line: 71
		-- upvalues: v23 (copy), reportImpression (copy), tooltipKey (copy), setIsDismissed (copy)
		if not v23.current then
			v23.current = true
			reportImpression(tooltipKey)
		end

		setIsDismissed(tooltipKey, true)
	end, {
		tooltipKey,
		setIsDismissed,
		reportImpression
	})

	React.useEffect(function() -- line: 79
		-- upvalues: v18 (copy), v20 (copy), Config (copy), v17 (copy)
		if v18 then
			v20(true)

			return nil
		end

		local v29 = Config.ChatWindowBackgroundFadeOutTime - (os.clock() - v17)

		if v29 <= 0 then
			v20(false)

			return nil
		end

		v20(true)

		local thread = task.delay(v29, function() -- line: 93
			-- upvalues: v20 (copy)
			v20(false)
		end)

		return function() -- line: 96
			-- upvalues: thread (copy)
			task.cancel(thread)
		end
	end, {
		v17,
		v18
	})
	React.useEffect(function() -- line: 105
		-- upvalues: v19 (copy), v15 (copy), v21 (copy), v14 (copy), v24 (copy), v22 (copy)
		if not v19 or not v15 or (v21 or not v14) then
			return nil
		end

		local elapsed = os.clock()
		local v32 = math.max(0, 10 - v24.current)
		local thread = task.delay(v32, function() -- line: 112
			-- upvalues: v22 (copy)
			v22(true)
		end)

		return function() -- line: 115
			-- upvalues: v24 (copy), elapsed (copy), thread (copy)
			local v36 = v24

			v36.current = v36.current + (os.clock() - elapsed)
			task.cancel(thread)
		end
	end, {
		v19,
		v15,
		v21,
		v14
	})
	React.useEffect(function() -- line: 122
		-- upvalues: v21 (copy), v28 (copy)
		if not v21 then
			return nil
		end

		local thread = task.delay(1, function() -- line: 126
			-- upvalues: v28 (copy)
			v28()
		end)

		return function() -- line: 129
			-- upvalues: thread (copy)
			task.cancel(thread)
		end
	end, {
		v21,
		v28
	})
	React.useEffect(function() -- line: 135
		-- upvalues: v25 (copy), targetTextChannel (copy), v14 (copy), v21 (copy), v22 (copy)
		local current = v25.current

		v25.current = targetTextChannel

		if current and (current ~= targetTextChannel and v14 and not v21) then
			v22(true)
		end
	end, {
		targetTextChannel,
		v14,
		v21
	})

	return {
		isActive = v14 and (v19 and (v15 and not v21)),
		onDismiss = v28
	}
end

return useChatTooltipLifecycle
