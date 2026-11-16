local parent = script.Parent.Parent
local Signals = require(parent.Signals)
require(parent.InternalHttpStore)
local createHttpStore = require(script.Parent.createHttpStore)

local v = nil

local signal, v2 = Signals.createSignal(nil)
local HttpStore = {}

function HttpStore._create(p)
	v = createHttpStore(p)
	v2(v)
	return v
end

function HttpStore._dispose()
	local v3 = signal()

	if v3 ~= nil then
		v3.cancelAll()
	end

	v2(nil)
end

function HttpStore.get(p)
	return signal(p)
end

return HttpStore
