local parent = script.Parent.Parent

local Signals = require(parent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed

local SignalsScheduler = require(parent.SignalsScheduler)
local batch = SignalsScheduler.batch

local function createWrappedSignal(p) -- 3 equivalent calls inferred from this helper
	local signal, setter = createSignal(function()
		return p
	end)

	return { getter = signal, setter = setter }
end

local function createProxy(items)
	local result = {}

	for k, item in items do
		result[k] = createWrappedSignal(item) -- inferred equivalent call
	end

	local signal, v = createSignal(nil, function(): boolean
		return false
	end)

	local computed = createComputed(function(p)
		signal(p)
		local count = 0

		for _, v2 in ipairs(result) do
			if v2.getter(false) ~= nil then
				count += 1
			end
		end

		return count
	end)

	local function createTrackedProxy(_, p)
		local function trackedLength()
			return computed(p)
		end

		local function nextSignal(items2, p2)
			while true do
				local v2
				p2, v2 = next(items2, p2)

				if p2 == nil then
					return nil
				end

				if v2 == nil then
					continue
				end

				local getter = v2.getter(p)

				if getter ~= nil then
					return p2, getter
				end
			end
		end

		local function trackedIterator()
			signal(p)
			return nextSignal, result
		end

		local function trackedIndex(_, p2)
			local v2 = result[p2]

			if v2 ~= nil then
				return v2.getter(p)
			end

			if p == nil then
				return nil
			end

			v2 = createWrappedSignal(nil) -- inferred equivalent call

			result[p2] = v2

			return v2.getter(p)
		end

		local function noNewIndex(_, p2, p3)
			error(`attempt to update read-only store at {p2} with {p3}`, 2)
		end

		return (setmetatable({}, (table.freeze({
			__len = trackedLength,
			__iter = trackedIterator,
			__index = trackedIndex,
			__newindex = noNewIndex,
			__metatable = false
		}))))
	end

	local function untrackedLength()
		return computed(false)
	end

	local function nextSignal(items2, p)
		while true do
			local v2
			p, v2 = next(items2, p)

			if p == nil then
				return nil
			end

			if v2 == nil then
				continue
			end

			local getter = v2.getter(false)

			if getter ~= nil then
				return p, getter
			end
		end
	end

	local function untrackedIterator()
		return nextSignal, result
	end

	local function untrackedIndex(_, p)
		local v2 = result[p]

		if v2 == nil then
			return nil
		end

		return v2.getter(false)
	end

	local function newIndex(_, p, p2)
		local v2 = result[p]

		if v2 == nil then
			if p2 ~= nil then
				result[p] = createWrappedSignal(p2) -- inferred equivalent call
				v()
			end
		else
			local getter = v2.getter(false)

			if getter ~= p2 then
				batch(function()
					v2.setter(function()
						return p2
					end)

					if getter == nil or p2 == nil then
						v()
					end
				end)
			end
		end
	end

	return (setmetatable({}, (table.freeze({
		__len = untrackedLength,
		__call = createTrackedProxy,
		__iter = untrackedIterator,
		__index = untrackedIndex,
		__newindex = newIndex,
		__metatable = false
	}))))
end

return createProxy
