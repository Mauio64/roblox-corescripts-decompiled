local parent = script:FindFirstAncestor("BuildExperience").Parent

local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

local defineFastInt = game:DefineFastInt("MyStatsExperienceSearchDebounceMs", 200)

local function createSearchQueryStore(options)
	local v = options or {}
	local debounceMs = v.debounceMs or defineFastInt
	local schedule = v.schedule or task.delay
	local cancel = v.cancel or task.cancel

	local signal, v2 = Signals.createSignal("")
	local signal2, v3 = Signals.createSignal("")
	local signal3, setIsSearchActive = Signals.createSignal(false)

	local getShowEmptyState = Signals.createComputed(function(p)
		return signal3(p) and signal(p) == ""
	end)

	local v4 = nil

	local function cancelPending() -- 3 equivalent calls inferred from this helper
		if v4 ~= nil then
			pcall(cancel, v4)
			v4 = nil
		end
	end

	local function clear() -- 1 equivalent call inferred from this helper
		cancelPending() -- inferred equivalent call
		v2("")
		v3("")
	end

	return {
		getDraftQuery = signal,
		useDraftQuery = function()
			return SignalsReact.useSignalState(signal)
		end,
		getDebouncedQuery = signal2,
		useDebouncedQuery = function()
			return SignalsReact.useSignalState(signal2)
		end,
		getIsSearchActive = signal3,
		useIsSearchActive = function()
			return SignalsReact.useSignalState(signal3)
		end,
		getShowEmptyState = getShowEmptyState,
		useShowEmptyState = function()
			return SignalsReact.useSignalState(getShowEmptyState)
		end,
		setQuery = function(p: string)
			v2(p)
			cancelPending() -- inferred equivalent call

			if p == signal2() then
				return
			end

			v4 = schedule(debounceMs / 1000, function()
				v4 = nil
				v3(p)
			end)
		end,
		setIsSearchActive = setIsSearchActive,
		beginSearch = function()
			setIsSearchActive(true)
		end,
		endSearch = function()
			clear() -- inferred equivalent call
			setIsSearchActive(false)
		end,
		endSearchIfEmpty = function()
			if signal() == "" then
				setIsSearchActive(false)
			end
		end,
		clear = clear,
		destroy = function()
			cancelPending() -- inferred equivalent call
		end
	}
end

return createSearchQueryStore
