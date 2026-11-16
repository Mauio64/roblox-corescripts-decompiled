local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/SignalsReact")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppShortcutBar/FocusNavigationUtils")

local function createButtonHoldStore()
	local signal, v5 = Signals.createSignal({})

	local function updateButtonHoldState(p2, p3)
		v5(function(p4)
			if p4[p2] == p3 then
				return p4
			end

			local clone = table.clone(p4)
			clone[p2] = p3
			return clone
		end)
	end

	local function useDispatchButtonHoldStarted()
		return (React.useCallback(function(p2, p3)
			v5(function(p4)
				if p4[p2] == p3 then
					return p4
				end

				local clone = table.clone(p4)
				clone[p2] = p3
				return clone
			end)
		end, { updateButtonHoldState }))
	end

	local function useDispatchButtonHoldEnded()
		return (React.useCallback(function(p2)
			local v6 = nil
			v5(function(p3)
				if p3[p2] == v6 then
					return p3
				end

				local clone = table.clone(p3)
				clone[p2] = v6
				return clone
			end)
		end, { updateButtonHoldState }))
	end

	local function useHeldProgressByEvent()
		return SignalsReact.useSignalState(signal)
	end

	return {
		getButtonHoldState = signal,
		setButtonHoldState = v5,
		useDispatchButtonHoldStarted = useDispatchButtonHoldStarted,
		useDispatchButtonHoldEnded = useDispatchButtonHoldEnded,
		useHeldProgressByEvent = useHeldProgressByEvent
	}
end

return createButtonHoldStore
