local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Signals = require(Parent.Signals)
local SignalsReact = require(Parent.SignalsReact)
local v4 = game:DefineFastInt("MyStatsExperienceSearchDebounceMs", 200)

local function createSearchQueryStore(t1: {[any]: any}?) -- line: 47
	-- upvalues: v4 (copy), Signals (copy), SignalsReact (copy)
	local v7 = t1 or {}
	local v8 = v7.debounceMs or v4
	local v9 = v7.schedule or task.delay
	local v10 = v7.cancel or task.cancel
	local v11, v12 = Signals.createSignal("")
	local v13, v14 = Signals.createSignal("")
	local u15 = nil

	local function cancelPending() -- line: 58
		-- upvalues: u15 (ref), v10 (copy)
		if u15 ~= nil then
			pcall(v10, u15)
			u15 = nil
		end
	end

	return {
		getDraftQuery = v11,
		useDraftQuery = function() -- line: 94
			-- upvalues: SignalsReact (copy), v11 (copy)
			return SignalsReact.useSignalState(v11)
		end,
		getDebouncedQuery = v13,
		useDebouncedQuery = function() -- line: 98
			-- upvalues: SignalsReact (copy), v13 (copy)
			return SignalsReact.useSignalState(v13)
		end,
		setQuery = function(s1: string) -- line: 68
			-- upvalues: v12 (copy), u15 (ref), v10 (copy), v13 (copy), v8 (copy), v9 (copy), v14 (copy)
			v12(s1)

			if u15 ~= nil then
				pcall(v10, u15)
				u15 = nil
			end

			if s1 == v13() then
				return
			end

			local v18 = v8 / 1000

			u15 = v9(v18, function() -- line: 78
				-- upvalues: u15 (ref), v14 (copy), s1 (copy)
				u15 = nil
				v14(s1)
			end)
		end,
		clear = function() -- line: 84
			-- upvalues: u15 (ref), v10 (copy), v12 (copy), v14 (copy)
			if u15 ~= nil then
				pcall(v10, u15)
				u15 = nil
			end

			v12("")
			v14("")
		end,
		destroy = function() -- line: 90
			-- upvalues: u15 (ref), v10 (copy)
			if u15 ~= nil then
				pcall(v10, u15)
				u15 = nil
			end
		end
	}
end

return createSearchQueryStore
