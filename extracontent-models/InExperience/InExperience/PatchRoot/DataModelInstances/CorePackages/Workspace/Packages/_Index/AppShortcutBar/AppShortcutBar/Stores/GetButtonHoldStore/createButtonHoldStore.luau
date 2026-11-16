local parent = script:FindFirstAncestor("AppShortcutBar").Parent

local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
require(parent.FocusNavigationUtils)

local function createButtonHoldStore()
	local signal, setButtonHoldState = Signals.createSignal({})

	local function updateButtonHoldState(p, p2) -- 2 equivalent calls inferred from this helper
		setButtonHoldState(function(p3)
			if p3[p] == p2 then
				return p3
			end

			local clone = table.clone(p3)
			clone[p] = p2
			return clone
		end)
	end

	local function useDispatchButtonHoldStarted()
		return (React.useCallback(function(p, p2)
			updateButtonHoldState(p, p2) -- inferred equivalent call
		end, { updateButtonHoldState }))
	end

	local function useDispatchButtonHoldEnded()
		return (React.useCallback(function(p)
			updateButtonHoldState(p) -- inferred equivalent call
		end, { updateButtonHoldState }))
	end

	local function useHeldProgressByEvent()
		return SignalsReact.useSignalState(signal)
	end

	return {
		getButtonHoldState = signal,
		setButtonHoldState = setButtonHoldState,
		useDispatchButtonHoldStarted = useDispatchButtonHoldStarted,
		useDispatchButtonHoldEnded = useDispatchButtonHoldEnded,
		useHeldProgressByEvent = useHeldProgressByEvent
	}
end

return createButtonHoldStore
