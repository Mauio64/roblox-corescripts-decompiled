local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/Signals")

local FFlagSplitPaneEducationalTourSkipOnDeepLink = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Flags/FFlagSplitPaneEducationalTourSkipOnDeepLink")

return Signals.createComputed(function()
	local signal, v5 = Signals.createSignal(0)
	local signal2, v6 = Signals.createSignal(false)

	local signal3, v7 = Signals.createSignal(nil)

	local v8 = {}
	local v9 = nil
	local signal4, v10 = Signals.createSignal(false)
	local function setTourVisibleCallback(p2)
		v9 = p2
	end

	local computed = Signals.createComputed(function(p2): boolean
		return signal(p2) > 0
	end)

	local signal5, v11 = Signals.createSignal(nil)

	local signal6, v12 = Signals.createSignal(nil)
	return {
		getStepIndex = signal,
		setStepIndex = v5,
		getIsOpen = signal2,
		setIsOpen = v6,
		getPendingUserId = signal3,
		setPendingUserId = v7,
		hasHandledCustomPromptForUser = function(p2): boolean
			return v8[p2] == true
		end,
		setHasHandledCustomPromptForUser = function(p2, p3)
			v8[p2] = p3
		end,
		setOnTourVisible = setTourVisibleCallback,
		notifyTourVisible = function()
			if FFlagSplitPaneEducationalTourSkipOnDeepLink then
				v10(true)
			end

			local v13 = v9
			v9 = nil

			if v13 ~= nil then
				v13()
			end
		end,
		clearOnTourVisible = function()
			v9 = nil
		end,
		getHasShownTour = signal4,
		discardPendingTour = function()
			if FFlagSplitPaneEducationalTourSkipOnDeepLink then
				v10(false)
			end

			v6(false)
			v7(nil)
			v9 = nil

			v5(0)
		end,
		getIsTourActive = computed,
		getCollapsedExpandButtonRect = signal5,
		setCollapsedExpandButtonRect = v11,
		getCollapsedExpandButtonInstance = signal6,
		setCollapsedExpandButtonInstance = v12,
		reset = function()
			v5(0)
		end
	}
end)
