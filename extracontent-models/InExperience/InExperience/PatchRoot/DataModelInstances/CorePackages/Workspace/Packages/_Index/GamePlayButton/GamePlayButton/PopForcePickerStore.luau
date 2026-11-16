local parent = script:FindFirstAncestor("GamePlayButton").Parent

local Signals = require(parent.Signals)

local function createStore(fn)
	local signal, v = Signals.createSignal("")
	local signal2, v2 = Signals.createSignal(false)
	local v3 = nil

	local function refresh()
		local success, result, v4 = pcall(function()
			local v4 = fn()

			if v4 and type(v4.SetForcedPop) == "function" then
				return v4, v4:GetForcedPop()
			end

			return nil, nil
		end)

		if success and type(v4) == "string" then
			v3 = result
			v(v4)
			v2(true)
		else
			v3 = nil
			v2(false)
		end
	end

	local function select(p: string)
		if not v3 then
			refresh()
		end

		if not v3 then
			return false
		end

		local v4 = pcall(function()
			v3:SetForcedPop(p)
		end)

		refresh()
		return v4 and signal2(false) and signal(false) == p
	end

	local function getSnapshot()
		local success, result = pcall(function()
			return v3:GetSnapshot()
		end)

		if success and type(result) == "table" then
			return result
		end

		return nil
	end

	return {
		getSelection = signal,
		getSupported = signal2,
		refresh = refresh,
		select = select,
		getSnapshot = getSnapshot
	}
end

return {
	createStore = createStore,
	getStore = Signals.createComputed(function()
		return createStore(function()
			return game:GetService("PopLatencyService")
		end)
	end)
}
