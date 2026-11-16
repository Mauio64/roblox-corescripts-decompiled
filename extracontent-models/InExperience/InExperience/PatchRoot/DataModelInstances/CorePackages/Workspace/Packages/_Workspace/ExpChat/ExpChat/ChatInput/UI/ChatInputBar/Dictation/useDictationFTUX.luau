local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local GetTransparencyStore = require(ExpChat.Stores.GetTransparencyStore)
local useIsChatBackgroundVisible = require(ExpChat.Stores.GetTransparencyStore.useIsChatBackgroundVisible)
local usePausableTimeout = require(ExpChat.Stores.GetTransparencyStore.usePausableTimeout)

local DictationAnalytics = require(script.Parent.DictationAnalytics)
local DictationFTUXStorage = require(script.Parent.DictationFTUXStorage)

local function useDictationFTUX(data)
	local v = useIsChatBackgroundVisible()

	local transparencyStore = GetTransparencyStore(false)
	local v2 = SignalsReact.useSignalState(transparencyStore.getIsTextBoxFocused)

	local state, setState = React.useState(function()
		return DictationFTUXStorage.hasBeenDismissed()
	end)

	local state2, setState2 = React.useState(function()
		return DictationFTUXStorage.hasBeenUsed()
	end)

	local dismiss = React.useCallback(function(p)
		setState(function(p2)
			if p2 then
				return p2
			end

			DictationFTUXStorage.markDismissed()
			DictationAnalytics.fire(DictationAnalytics.Events.FtuxDismiss, {
				[DictationAnalytics.Properties.SttMode] = DictationAnalytics.Modes.Continuous,
				[DictationAnalytics.Properties.DismissReason] = p or DictationAnalytics.DismissReasons.UserInteraction
			})

			return true
		end)
	end, {})

	local markUsed = React.useCallback(function()
		setState2(function(p)
			if p then
				return p
			end

			DictationFTUXStorage.markUsed()
			return true
		end)
	end, {})

	local shouldShow = state2
		and not state
		and data.isEligible
		and not (data.isComposing or data.isActive)
		and not v2
		and v

	usePausableTimeout(shouldShow, 10, (React.useCallback(function()
		dismiss(DictationAnalytics.DismissReasons.Visibility)
	end, { dismiss })))

	local ref = React.useRef(false)
	React.useEffect(function()
		if shouldShow and not ref.current then
			ref.current = true
			DictationAnalytics.fire(DictationAnalytics.Events.FtuxShown, {
				[DictationAnalytics.Properties.SttMode] = DictationAnalytics.Modes.Continuous
			})
		end
	end, { shouldShow })

	return { shouldShow = shouldShow, dismiss = dismiss, markUsed = markUsed }
end

return useDictationFTUX
