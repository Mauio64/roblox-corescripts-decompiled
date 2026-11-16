local parent = script.Parent.Parent

local ReactGlobals = require(parent.ReactGlobals)
local LuauPolyfill = require(parent.LuauPolyfill)
local Shared = require(parent.Shared)
local ReactSymbols = Shared.ReactSymbols

require(parent.Shared)

local Symbol = LuauPolyfill.Symbol
local createSignalroblox = require(script.Parent["createSignal.roblox"])

local Shared2 = require(parent.Shared)
local enableAllocationTrims = Shared2.ReactFeatureFlags.enableAllocationTrims

local symbol = Symbol("BindingImpl")

local Roblox = {}

local v = {
	__index = {
		getValue = function(p)
			return Roblox.getValue(p)
		end,
		map = function(p, callback)
			return Roblox.map(p, callback)
		end
	},
	__tostring = function(object)
		return string.format("RoactBinding(%s)", (tostring(object:getValue())))
	end
}

local v2 = {
	getValue = function(p)
		return p.value
	end,
	update = function(p, p2)
		p.value = p2
		local fire = p.fire

		if fire ~= nil then
			fire(p2)
		end
	end,
	subscribe = function(p, callback)
		local subscribeToSignal = p.subscribeToSignal

		if subscribeToSignal == nil then
			local fire
			subscribeToSignal, fire = createSignalroblox()
			p.fire = fire
			p.subscribeToSignal = subscribeToSignal
		end

		return subscribeToSignal(callback)
	end
}

local v3 = { __index = v2 }

function Roblox.update(p, p2)
	if not enableAllocationTrims then
		return p[symbol].update(p2)
	end

	local v4 = p[symbol]

	if getmetatable(v4) == v3 then
		return v2.update(v4, p2)
	end

	return v4.update(p2)
end

function Roblox.subscribe(p, callback)
	if not enableAllocationTrims then
		return p[symbol].subscribe(callback)
	end

	local v4 = p[symbol]

	if getmetatable(v4) == v3 then
		return v2.subscribe(v4, callback)
	end

	return v4.subscribe(callback)
end

function Roblox.getValue(p)
	return p[symbol]:getValue()
end

function Roblox.createWithoutUpdater(p, source: string?)
	local object = setmetatable({ value = p }, v3)

	return (setmetatable({
		["$$typeof"] = ReactSymbols.REACT_BINDING_TYPE,
		[symbol] = object,
		_source = source
	}, v))
end

function Roblox.create(p)
	if enableAllocationTrims then
		local v4

		if ReactGlobals.__DEV__ then
			v4 = debug.traceback("Binding created at:", 3)
		end

		local withoutUpdater = Roblox.createWithoutUpdater(p, v4)
		local v5 = withoutUpdater[symbol]

		return withoutUpdater, function(p2)
			v2.update(v5, p2)
		end
	else
		local signalroblox, v4 = createSignalroblox()
		local v5 = { value = p, subscribe = signalroblox }

		function v5.update(p2)
			v5.value = p2
			v4(p2)
		end

		function v5.getValue()
			return v5.value
		end

		local source

		if ReactGlobals.__DEV__ then
			source = debug.traceback("Binding created at:", 3)
		end

		return
			setmetatable({
				["$$typeof"] = ReactSymbols.REACT_BINDING_TYPE,
				[symbol] = v5,
				_source = source
			}, v),
			v5.update
	end
end

function Roblox:map(callback)
	if ReactGlobals.__DEV__ then
		local v4 = typeof(self) == "table" and self["$$typeof"] == ReactSymbols.REACT_BINDING_TYPE
		assert(v4, "Expected `self` to be a binding")

		assert(typeof(callback) == "function", "Expected arg #1 to be a function")
	end

	local source

	if ReactGlobals.__DEV__ then
		source = debug.traceback("Mapped binding created at:", 3)
	end

	return (setmetatable({
		["$$typeof"] = ReactSymbols.REACT_BINDING_TYPE,
		[symbol] = {
			subscribe = function(callback2)
				return Roblox.subscribe(self, function(p)
					callback2(callback(p))
				end)
			end,
			update = function(_)
				error("Bindings created by Binding:map(fn) cannot be updated directly", 2)
			end,
			getValue = function()
				return callback(self:getValue())
			end
		},
		_source = source
	}, v))
end

function Roblox.join(items)
	if ReactGlobals.__DEV__ then
		assert(typeof(items) == "table", "Expected arg #1 to be of type table")

		for k, item in items do
			if not (typeof(item) ~= "table" or item["$$typeof"] ~= ReactSymbols.REACT_BINDING_TYPE) then
				continue
			end

			local formatted = ("Expected arg #1 to contain only bindings, but key %q had a non-binding value"):format((tostring(k)))

			error(formatted, 2)
		end
	end

	local function getValue()
		local value = {}

		for k, item in pairs(items) do
			value[k] = item:getValue()
		end

		return value
	end

	local source

	if ReactGlobals.__DEV__ then
		source = debug.traceback("Joined binding created at:", 2)
	end

	return (setmetatable({
		["$$typeof"] = ReactSymbols.REACT_BINDING_TYPE,
		[symbol] = {
			subscribe = function(callback)
				local v4 = {}

				for k, item in items do
					v4[k] = Roblox.subscribe(item, function(_)
						callback(getValue())
					end)
				end

				return function()
					if v4 == nil then
						return
					end

					for _, v5 in v4 do
						v5()
					end

					v4 = nil
				end
			end,
			update = function(_)
				error("Bindings created by joinBindings(...) cannot be updated directly", 2)
			end,
			getValue = function()
				return getValue()
			end
		},
		_source = source
	}, v))
end

return Roblox
