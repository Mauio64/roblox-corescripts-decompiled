local parent = script:FindFirstAncestor("DictationCore").Parent

local Signals = require(parent.Signals)

local function createMicStore()
	local signal, v = Signals.createSignal(nil)

	local v2 = nil
	local count = 0

	local function createHolderId()
		count += 1
		return count
	end

	local function hold(p: number, callback): boolean
		local v3 = signal(false)

		if v3 ~= nil and v3 ~= p then
			return false
		end

		v2 = callback

		if v3 == nil then
			v(p)
		end

		return true
	end

	local function steal(p: number, callback)
		local v3 = signal(false)
		local v4 = v2
		v2 = callback

		if v3 == p then
			return
		end

		v(p)

		if v3 ~= nil and v4 ~= nil then
			v4()
		end
	end

	local function drop(p: number)
		if signal(false) ~= p then
			return
		end

		v2 = nil
		v(nil)
	end

	local function reset()
		v2 = nil
		v(nil)
	end

	return {
		getHolderId = signal,
		createHolderId = createHolderId,
		hold = hold,
		steal = steal,
		drop = drop,
		reset = reset
	}
end

return createMicStore
