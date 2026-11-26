local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Signals")

local function createStore(fn)
	local signal, v5 = Signals.createSignal("")
	local signal2, v6 = Signals.createSignal(false)
	local v7 = nil

	local function refresh()
		local success, result, v8 = pcall(function()
			local v9 = fn()

			if v9 and type(v9.SetForcedPop) == "function" then
				return v9, v9:GetForcedPop()
			end

			return nil, nil
		end)

		if success and type(v8) == "string" then
			v7 = result
			v5(v8)
			v6(true)
		else
			v7 = nil
			v6(false)
		end
	end

	local function select2(p2)
		if not v7 then
			refresh()
		end

		if not v7 then
			return false
		end

		local v8 = pcall(function()
			v7:SetForcedPop(p2)
		end)

		refresh()
		return v8 and signal2(false) and signal(false) == p2
	end

	local function getSnapshot()
		local success, result = pcall(function()
			return v7:GetSnapshot()
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
		select = select2,
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
