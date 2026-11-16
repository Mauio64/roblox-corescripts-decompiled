local parent = script:FindFirstAncestor("SplitPane").Parent

local Signals = require(parent.Signals)

local FFlagSplitPaneEducationalTourSkipOnDeepLink = require(script.Parent.Parent.Flags.FFlagSplitPaneEducationalTourSkipOnDeepLink)

return Signals.createComputed(function()
	local signal, setStepIndex = Signals.createSignal(0)
	local signal2, setIsOpen = Signals.createSignal(false)

	local signal3, setPendingUserId = Signals.createSignal(nil)

	local v = {}
	local v2 = nil
	local signal4, v3 = Signals.createSignal(false)
	local function setTourVisibleCallback(callback) -- 2 equivalent calls inferred from this helper
		v2 = callback
	end

	local getIsTourActive = Signals.createComputed(function(p): boolean
		return signal(p) > 0
	end)

	local signal5, setCollapsedExpandButtonRect = Signals.createSignal(nil)

	local signal6, setCollapsedExpandButtonInstance = Signals.createSignal(nil)
	local function reset() -- 1 equivalent call inferred from this helper
		setStepIndex(0)
	end

	return {
		getStepIndex = signal,
		setStepIndex = setStepIndex,
		getIsOpen = signal2,
		setIsOpen = setIsOpen,
		getPendingUserId = signal3,
		setPendingUserId = setPendingUserId,
		hasHandledCustomPromptForUser = function(p): boolean
			return v[p] == true
		end,
		setHasHandledCustomPromptForUser = function(p, p2)
			v[p] = p2
		end,
		setOnTourVisible = setTourVisibleCallback,
		notifyTourVisible = function()
			if FFlagSplitPaneEducationalTourSkipOnDeepLink then
				v3(true)
			end

			local v4 = v2
			v2 = nil

			if v4 ~= nil then
				v4()
			end
		end,
		clearOnTourVisible = function()
			setTourVisibleCallback(nil) -- inferred equivalent call
		end,
		getHasShownTour = signal4,
		discardPendingTour = function()
			if FFlagSplitPaneEducationalTourSkipOnDeepLink then
				v3(false)
			end

			setIsOpen(false)
			setPendingUserId(nil)
			setTourVisibleCallback(nil) -- inferred equivalent call
			reset() -- inferred equivalent call
		end,
		getIsTourActive = getIsTourActive,
		getCollapsedExpandButtonRect = signal5,
		setCollapsedExpandButtonRect = setCollapsedExpandButtonRect,
		getCollapsedExpandButtonInstance = signal6,
		setCollapsedExpandButtonInstance = setCollapsedExpandButtonInstance,
		reset = reset
	}
end)
