local ParentParent = script.Parent.Parent
local Signals = require(ParentParent.Signals)
local createSignal = Signals.createSignal
local createComputed = Signals.createComputed
local batch = require(ParentParent.SignalsScheduler).batch

local function createWrappedSignal(p1) -- line: 21
	-- upvalues: createSignal (copy)
	local v9, v10 = createSignal(function() -- line: 22
		-- upvalues: p1 (copy)
		return p1
	end)

	return {
		getter = v9,
		setter = v10
	}
end
local function createProxy(p2) -- line: 28
	-- upvalues: createSignal (copy), createComputed (copy), batch (copy)
	local t1 = {}

	for v13, v14 in p2 do
		local v15, v16 = createSignal(function() -- line: 22
			-- upvalues: v14 (copy)
			return v14
		end)

		t1[v13] = {
			getter = v15,
			setter = v16
		}
	end

	local v17, v18 = createSignal(nil, function() -- line: 35
		return false
	end)
	local v19 = createComputed(function(p3) -- line: 39
		-- upvalues: v17 (copy), t1 (copy)
		v17(p3)

		local n1 = 0

		for _, v in ipairs(t1) do
			if v.getter(false) ~= nil then
				n1 += 1
			end
		end

		return n1
	end)

	local function createTrackedProxy(_, p5) -- line: 50
		-- upvalues: v19 (copy), v17 (copy), t1 (copy), createSignal (copy)
		local function trackedLength() -- line: 51
			-- upvalues: v19 (copy), p5 (copy)
			return v19(p5)
		end
		local function nextSignal(p6, p7) -- line: 55
			-- upvalues: p5 (copy)
			while true do
				local v53

				p7, v53 = next(p6, p7)

				if p7 == nil then
					break
				end

				if v53 ~= nil then
					local v54 = v53.getter(p5)

					if v54 ~= nil then
						return p7, v54
					end
				end
			end

			return nil
		end
		local function trackedIterator() -- line: 71
			-- upvalues: v17 (copy), p5 (copy), nextSignal (copy), t1 (copy)
			v17(p5)

			return nextSignal, t1
		end
		local function trackedIndex(_, p9) -- line: 76
			-- upvalues: t1 (copy), p5 (copy), createSignal (copy)
			local v57 = t1[p9]

			if v57 == nil then
				if p5 == nil then
					return nil
				end

				local v58 = nil
				local v59, v60 = createSignal(function() -- line: 22
					-- upvalues: v58 (copy)
					return v58
				end)

				v57 = {
					getter = v59,
					setter = v60
				}
				t1[p9] = v57
			end

			return v57.getter(p5)
		end
		local function noNewIndex(_, p11, p12) -- line: 88
			error(`attempt to update read-only store at { p11 } with { p12 }`, 2)
		end

		return (setmetatable({}, (table.freeze({
			__metatable = false,
			__len = trackedLength,
			__iter = trackedIterator,
			__index = trackedIndex,
			__newindex = noNewIndex
		}))))
	end
	local function untrackedLength() -- line: 103
		-- upvalues: v19 (copy)
		return v19(false)
	end
	local function nextSignal(p13, p14) -- line: 107
		while true do
			local v39

			p14, v39 = next(p13, p14)

			if p14 == nil then
				break
			end

			if v39 ~= nil then
				local v40 = v39.getter(false)

				if v40 ~= nil then
					return p14, v40
				end
			end
		end

		return nil
	end
	local function untrackedIterator() -- line: 123
		-- upvalues: nextSignal (copy), t1 (copy)
		return nextSignal, t1
	end
	local function untrackedIndex(_, p16) -- line: 127
		-- upvalues: t1 (copy)
		local v43 = t1[p16]

		if v43 ~= nil then
			return v43.getter(false)
		end

		return nil
	end
	local function newIndex(_, p18, p19) -- line: 135
		-- upvalues: t1 (copy), createSignal (copy), v18 (copy), batch (copy)
		local u47 = t1[p18]

		if u47 == nil then
			if p19 ~= nil then
				local v48, v49 = createSignal(function() -- line: 22
					-- upvalues: p19 (copy)
					return p19
				end)

				u47 = {
					getter = v48,
					setter = v49
				}
				t1[p18] = u47
				v18()
			end
		else
			local v50 = u47.getter(false)

			if v50 ~= p19 then
				batch(function() -- line: 146
					-- upvalues: u47 (ref), p19 (copy), v50 (copy), v18 (copy)
					u47.setter(function() -- line: 147
						-- upvalues: p19 (copy)
						return p19
					end)

					if v50 == nil or p19 == nil then
						v18()
					end
				end)
			end
		end
	end

	return (setmetatable({}, (table.freeze({
		__metatable = false,
		__len = untrackedLength,
		__call = createTrackedProxy,
		__iter = untrackedIterator,
		__index = untrackedIndex,
		__newindex = newIndex
	}))))
end

return createProxy
