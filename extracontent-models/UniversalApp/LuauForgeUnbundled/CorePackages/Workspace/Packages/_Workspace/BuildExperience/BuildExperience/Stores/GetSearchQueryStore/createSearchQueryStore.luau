local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local defineFastInt = game:DefineFastInt("MyStatsExperienceSearchDebounceMs", 200)

local function createSearchQueryStore(options)
	local v5 = options or {}
	local debounceMs = v5.debounceMs or defineFastInt
	local schedule = v5.schedule or task.delay
	local cancel = v5.cancel or task.cancel

	local signal, v6 = Signals.createSignal("")
	local signal2, v7 = Signals.createSignal("")
	local signal3, v8 = Signals.createSignal(false)

	local computed = Signals.createComputed(function(p2)
		return signal3(p2) and signal(p2) == ""
	end)

	local v9 = nil

	local function cancelPending()
		if v9 ~= nil then
			pcall(cancel, v9)
			v9 = nil
		end
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
		getShowEmptyState = computed,
		useShowEmptyState = function()
			return SignalsReact.useSignalState(computed)
		end,
		setQuery = function(p2)
			v6(p2)

			if v9 ~= nil then
				pcall(cancel, v9)
				v9 = nil
			end

			if p2 == signal2() then
				return
			end

			v9 = schedule(debounceMs / 1000, function()
				v9 = nil
				v7(p2)
			end)
		end,
		setIsSearchActive = v8,
		beginSearch = function()
			v8(true)
		end,
		endSearch = function()
			if v9 ~= nil then
				pcall(cancel, v9)
				v9 = nil
			end

			v6("")
			v7("")

			v8(false)
		end,
		endSearchIfEmpty = function()
			if signal() == "" then
				v8(false)
			end
		end,
		clear = function()
			if v9 ~= nil then
				pcall(cancel, v9)
				v9 = nil
			end

			v6("")
			v7("")
		end,
		destroy = function()
			if v9 ~= nil then
				pcall(cancel, v9)
				v9 = nil
			end
		end
	}
end

return createSearchQueryStore
