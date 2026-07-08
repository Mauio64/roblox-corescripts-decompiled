local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local SignalsReact = require(ExpChatParent.SignalsReact)
local GetTransparencyStore = require(ExpChat.Stores.GetTransparencyStore)
local useIsChatBackgroundVisible = require(ExpChat.Stores.GetTransparencyStore.useIsChatBackgroundVisible)
local usePausableTimeout = require(ExpChat.Stores.GetTransparencyStore.usePausableTimeout)
local DictationAnalytics = require(script.Parent.DictationAnalytics)
local DictationFTUXStorage = require(script.Parent.DictationFTUXStorage)

local function useDictationFTUX(t1: {[any]: any}) -- line: 44
	-- upvalues: useIsChatBackgroundVisible (copy), GetTransparencyStore (copy), SignalsReact (copy), React (copy), DictationFTUXStorage (copy), DictationAnalytics (copy), usePausableTimeout (copy)
	local v12 = useIsChatBackgroundVisible()
	local v13 = GetTransparencyStore(false)
	local v14 = SignalsReact.useSignalState(v13.getIsTextBoxFocused)
	local v15, v16 = React.useState(function() -- line: 53
		-- upvalues: DictationFTUXStorage (copy)
		return DictationFTUXStorage.hasBeenDismissed()
	end)
	local v17, v18 = React.useState(function() -- line: 56
		-- upvalues: DictationFTUXStorage (copy)
		return DictationFTUXStorage.hasBeenUsed()
	end)
	local v19 = React.useCallback(function(p1) -- line: 60
		-- upvalues: v16 (copy), DictationFTUXStorage (copy), DictationAnalytics (copy)
		v16(function(p2) -- line: 63
			-- upvalues: DictationFTUXStorage (copy), DictationAnalytics (copy), p1 (copy)
			if p2 then
				return p2
			end

			DictationFTUXStorage.markDismissed()
			DictationAnalytics.fire(DictationAnalytics.Events.FtuxDismiss, {
				[DictationAnalytics.Properties.SttMode] = DictationAnalytics.Modes.Continuous,
				[DictationAnalytics.Properties.DismissReason] = p1 or DictationAnalytics.DismissReasons.UserInteraction
			})

			return true
		end)
	end, {})
	local v20 = React.useCallback(function() -- line: 77
		-- upvalues: v18 (copy), DictationFTUXStorage (copy)
		v18(function(p3) -- line: 78
			-- upvalues: DictationFTUXStorage (copy)
			if p3 then
				return p3
			end

			DictationFTUXStorage.markUsed()

			return true
		end)
	end, {})
	local v21 = v17 and (not v15 and (t1.isEligible and (not t1.isComposing and (not t1.isActive and (not v14 and v12)))))
	local v22 = React.useCallback(function() -- line: 102
		-- upvalues: v19 (copy), DictationAnalytics (copy)
		v19(DictationAnalytics.DismissReasons.Visibility)
	end, { v19 })

	usePausableTimeout(v21, 10, v22)

	local v23 = React.useRef(false)

	React.useEffect(function() -- line: 111
		-- upvalues: v21 (copy), v23 (copy), DictationAnalytics (copy)
		if v21 and not v23.current then
			v23.current = true
			DictationAnalytics.fire(DictationAnalytics.Events.FtuxShown, {
				[DictationAnalytics.Properties.SttMode] = DictationAnalytics.Modes.Continuous
			})
		end
	end, { v21 })

	return {
		shouldShow = v21,
		dismiss = v19,
		markUsed = v20
	}
end

return useDictationFTUX
