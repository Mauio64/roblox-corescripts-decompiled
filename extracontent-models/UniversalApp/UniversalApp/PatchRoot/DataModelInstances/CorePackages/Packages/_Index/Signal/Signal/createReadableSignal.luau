local createSignal = require(script.Parent.createSignal)

local function createReadableSignal(p)
	local signal, v = createSignal()

	local value = p

	local function fire(p2)
		value = p2
		v(p2)
	end

	return {
		subscribe = function(self, callback)
			return signal:subscribe(callback)
		end,
		getValue = function(_)
			return value
		end
	}, fire
end

return createReadableSignal
