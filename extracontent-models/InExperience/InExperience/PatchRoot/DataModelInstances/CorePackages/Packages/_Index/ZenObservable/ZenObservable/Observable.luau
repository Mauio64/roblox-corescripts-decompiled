local ParentParent = script.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local Promise = require(ParentParent.Promise)
local instanceof = LuauPolyfill.instanceof
local Boolean = LuauPolyfill.Boolean
local Error = LuauPolyfill.Error
local setTimeout = LuauPolyfill.setTimeout
local Array = LuauPolyfill.Array
local Symbol = LuauPolyfill.Symbol
local t10 = nil
local t8 = nil
local notifySubscription = nil

local function isCallable(p1) -- line: 29
	if typeof(p1) == "function" then
		return true
	end

	if typeof(p1) == "table" then
		local mt = getmetatable(p1)

		if mt and rawget(mt, "__call") then
			return true
		end

		if p1._isMockFunction then
			return true
		end
	end

	return false
end
local function hasSymbols() -- line: 45
	-- upvalues: Symbol (copy)
	return typeof(Symbol) == "table" and typeof(getmetatable(Symbol).__call) == "function"
end
local function hasSymbol(s1: string) -- line: 50
	-- upvalues: Symbol (copy), Boolean (copy)
	return typeof(Symbol) == "table" and typeof(getmetatable(Symbol).__call) == "function" and Boolean.toJSBoolean(Symbol[s1])
end
local function getSymbol(s2: string) -- line: 54
	-- upvalues: Symbol (copy), Boolean (copy)
	if typeof(Symbol) == "table" and typeof(getmetatable(Symbol).__call) == "function" and Boolean.toJSBoolean(Symbol[s2]) then
		return Symbol[s2]
	end

	return "@@" .. s2
end

if typeof(Symbol) == "table" and typeof(getmetatable(Symbol).__call) == "function" and (typeof(Symbol) ~= "table" or typeof(getmetatable(Symbol).__call) ~= "function" or not Boolean.toJSBoolean(Symbol.observable)) then
	Symbol.observable = Symbol("observable")
end

if typeof(Symbol) == "table" and typeof(getmetatable(Symbol).__call) == "function" and Boolean.toJSBoolean(Symbol.iterator) then
	local _ = Symbol.iterator
end

local v18 = not (typeof(Symbol) == "table" and typeof(getmetatable(Symbol).__call) == "function" and Boolean.toJSBoolean(Symbol.observable)) and "@@observable" or Symbol.observable
local v19 = not (typeof(Symbol) == "table" and typeof(getmetatable(Symbol).__call) == "function" and Boolean.toJSBoolean(Symbol.species)) and "@@species" or Symbol.species

local function getMethod(p2, p3) -- line: 72
	-- upvalues: Error (copy)
	local v37 = p2[p3]

	if v37 == nil then
		return nil
	end

	local g39 = nil
	local mt = nil
	local v38 = nil

	if typeof(v37) == "function" then
		v38 = true
		g39 = true
	end

	repeat
		if g39 or (g39 or typeof(v37) == "table") then
			if not g39 then
				if not g39 then
					mt = getmetatable(v37)
				end
			end

			repeat
				if g39 or (g39 or (g39 or mt and rawget(mt, "__call"))) then
					if not g39 then
						if not g39 then
							if not g39 then
								v38 = true
							end
						end
					end

					g39 = false

					if not v38 then
						error(Error.new(tostring(v37) .. " is not a function"))
					end

					return v37
				end

				if v37._isMockFunction then
					v38 = true
					g39 = true
				end
			until not g39
		end

		v38 = false
		g39 = true
	until not g39
end
local function getSpecies(p4) -- line: 86
	-- upvalues: v19 (copy), t10 (ref)
	local v42 = p4[v19]

	if v42 ~= nil then
		return v42
	end

	return t10
end
local function isObservable(p5) -- line: 97
	-- upvalues: instanceof (copy), t10 (ref)
	return instanceof(p5, t10)
end

local self = nil

self = setmetatable({}, {
	__call = function(_, p7) -- line: 104
		-- upvalues: self (ref), setTimeout (copy)
		if self.log then
			self:log(p7)

			return
		end

		setTimeout(function() -- line: 108
			-- upvalues: p7 (copy)
			error(p7)
		end, 0)
	end
})

local function enqueue(p8) -- line: 116
	-- upvalues: Promise (copy), self (ref)
	Promise.delay(0):doneCall(function() -- line: 117
		-- upvalues: p8 (copy), self (ref)
		xpcall(p8, function(err) -- line: 118
			-- upvalues: self (ref)
			self(err)
		end)
	end)
end
local function cleanupSubscription(t1: {[any]: any}) -- line: 124
	-- upvalues: Error (copy), self (ref)
	local _cleanup = t1._cleanup

	if _cleanup == nil then
		return
	end

	t1._cleanup = nil

	if not _cleanup then
		return
	end

	local v49 = true
	local result = nil
	local g52 = nil
	local mt = nil
	local v51 = nil
	local g54 = nil
	local g56 = nil
	local g58 = nil
	local unsubscribe = nil
	local mt2 = nil
	local v57 = nil

	if typeof(_cleanup) == "function" then
		v51 = true
		g52 = true
	end

	repeat
		if g52 or (g52 or typeof(_cleanup) == "table") then
			if not g52 then
				if not g52 then
					mt = getmetatable(_cleanup)
				end
			end

			repeat
				if g52 or (g52 or (g52 or mt and rawget(mt, "__call"))) then
					if not g52 then
						if not g52 then
							if not g52 then
								v51 = true
							end
						end
					end

					g52 = false

					if v51 then
						v49, result = pcall(_cleanup)
						g54 = true
					end

					if not g54 then
						unsubscribe = _cleanup.unsubscribe

						if unsubscribe == nil then
							unsubscribe = nil
							g56 = true
						end

						if not g56 then
							if typeof(unsubscribe) == "function" then
								v57 = true
								g58 = true
							end
						end
					end

					repeat
						if g54 or (g56 or (g58 or (g58 or typeof(unsubscribe) == "table"))) then
							if not g54 then
								if not g56 then
									if not g58 then
										if not g58 then
											mt2 = getmetatable(unsubscribe)
										end
									end
								end
							end

							repeat
								if g54 or (g56 or (g58 or (g58 or (g58 or mt2 and rawget(mt2, "__call"))))) then
									if not g54 then
										if not g56 then
											if not g58 then
												if not g58 then
													if not g58 then
														v57 = true
													end
												end
											end

											g58 = false

											if not v57 then
												error(Error.new(tostring(unsubscribe) .. " is not a function"))
											end
										end

										g56 = false

										if unsubscribe then
											v49, result = pcall(unsubscribe, _cleanup)
										end
									end

									g54 = false

									if not v49 then
										self(result)
									end

									return
								end

								if unsubscribe._isMockFunction then
									v57 = true
									g58 = true
								end
							until not g58
						end

						v57 = false
						g58 = true
					until not g58
				end

				if _cleanup._isMockFunction then
					v51 = true
					g52 = true
				end
			until not g52
		end

		v51 = false
		g52 = true
	until not g52
end
local function closeSubscription(t2: {[any]: any}) -- line: 153
	t2._observer = nil
	t2._queue = nil
	t2._state = "closed"
end
local function flushSubscription(t3: {[any]: any}) -- line: 159
	-- upvalues: Boolean (copy), notifySubscription (ref)
	local _queue = t3._queue

	if not Boolean.toJSBoolean(_queue) then
		return
	end

	t3._queue = nil
	t3._state = "ready"

	for i = 1, #_queue do
		notifySubscription(t3, _queue[i].type, _queue[i].value)

		if t3._state == "closed" then
			return
		end
	end
end

function notifySubscription(t4: {[any]: any}, p9, p10) -- line: 177
	-- upvalues: getMethod (copy), self (ref), cleanupSubscription (copy)
	t4._state = "running"

	local _observer = t4._observer
	local result = nil
	local ok, result2 = pcall(getMethod, _observer, p9)

	if not ok then
		self(result2)

		return
	end

	if p9 == "next" then
		if result2 then
			ok, result = pcall(result2, _observer, p10)
		end
	elseif p9 == "error" then
		t4._observer = nil
		t4._queue = nil
		t4._state = "closed"

		if result2 then
			ok, result = pcall(result2, _observer, p10)
		else
			self(p10)
		end
	elseif p9 == "complete" then
		t4._observer = nil
		t4._queue = nil
		t4._state = "closed"

		if result2 then
			ok, result = pcall(result2, _observer, p10)
		end
	end

	if not ok then
		self(result)
	end

	if t4._state == "closed" then
		cleanupSubscription(t4)

		return
	end

	if t4._state == "running" then
		t4._state = "ready"
	end
end

local function onNotify(t5: {[any]: any}, p11, p12) -- line: 216
	-- upvalues: flushSubscription (copy), Promise (copy), self (ref), notifySubscription (ref)
	if t5._state == "closed" then
		return
	end

	if t5._state == "buffering" then
		assert(t5._queue, "observable subscription queue nil during onNotify")
		table.insert(t5._queue, {
			type = p11,
			value = p12
		})

		return
	end

	if t5._state ~= "ready" then
		t5._state = "buffering"
		t5._queue = {{
			type = p11,
			value = p12
		}}

		local function v74() -- line: 230
			-- upvalues: flushSubscription (copy), t5 (copy)
			return flushSubscription(t5)
		end

		Promise.delay(0):doneCall(function() -- line: 117
			-- upvalues: v74 (copy), self (ref)
			xpcall(v74, function(err) -- line: 118
				-- upvalues: self (ref)
				self(err)
			end)
		end)

		return
	end

	notifySubscription(t5, p11, p12)
end

local t6 = {}

function t6.__index(p13, p14) -- line: 259
	-- upvalues: t6 (copy)
	if p14 == "closed" then
		return p13._state == "closed"
	end

	if rawget(p13, p14) then
		return (rawget(p13, p14))
	end

	if rawget(t6, p14) then
		return (rawget(t6, p14))
	end

	return nil
end
function t6.__newindex(p15, p16, p17) -- line: 271
	if p16 == "closed" then
		error("setting getter-only property 'closed'")
	end

	rawset(p15, p16, p17)
end
function t6.new(t7: {[any]: any}, p18: ((...any) -> ...any)) -- line: 278
	-- upvalues: t6 (copy), t8 (ref)
	local self2 = setmetatable({}, t6)

	self2._cleanup = nil
	self2._observer = t7
	self2._queue = nil
	self2._state = "initializing"

	local v83 = t8.new(self2)
	local ok, result = pcall(p18, v83)

	if ok then
		self2._cleanup = result
	else
		v83:error(result)
	end

	if self2._state == "initializing" then
		self2._state = "ready"
	end

	return self2
end
function t6.unsubscribe(p19) -- line: 304
	-- upvalues: cleanupSubscription (copy)
	if p19._state ~= "closed" then
		p19._observer = nil
		p19._queue = nil
		p19._state = "closed"
		cleanupSubscription(p19)
	end
end

t8 = {}

function t8.__index(p20, p21) -- line: 320
	-- upvalues: t8 (ref)
	if p21 == "closed" then
		return p20._subscription._state == "closed"
	end

	if rawget(t8, p21) then
		return (rawget(t8, p21))
	end

	return (rawget(p20, p21))
end
function t8.__newindex(p22, p23, p24) -- line: 329
	if p23 == "closed" then
		error("setting getter-only property 'closed'")
	end

	rawset(p22, p23, p24)
end
function t8.new(t9: {[any]: any}) -- line: 336
	-- upvalues: t8 (ref)
	return (setmetatable({
		_subscription = t9
	}, t8))
end
function t8.next(p25, p26) -- line: 345
	-- upvalues: onNotify (copy)
	onNotify(p25._subscription, "next", p26)
end
function t8.error(p27, p28) -- line: 349
	-- upvalues: onNotify (copy)
	onNotify(p27._subscription, "error", p28)
end
function t8.complete(p29) -- line: 353
	-- upvalues: onNotify (copy)
	onNotify(p29._subscription, "complete")
end

t10 = {}
t10.__index = t10

local function isObservableClass(p30) -- line: 413
	-- upvalues: v18 (copy), t10 (ref)
	return typeof(p30) == "table" and (p30[v18] == t10[v18] and typeof((rawget(p30, "new"))) == "function")
end

function t10.new(p31: ((...any) -> ...any)) -- line: 419
	-- upvalues: t10 (ref)
	local g101 = nil
	local mt = nil
	local v100 = nil

	if typeof(p31) == "function" then
		v100 = true
		g101 = true
	end

	repeat
		if g101 or (g101 or typeof(p31) == "table") then
			if not g101 then
				if not g101 then
					mt = getmetatable(p31)
				end
			end

			repeat
				if g101 or (g101 or (g101 or mt and rawget(mt, "__call"))) then
					if not g101 then
						if not g101 then
							if not g101 then
								v100 = true
							end
						end
					end

					g101 = false

					if not v100 then
						error("Observable initializer must be a function")
					end

					return (setmetatable({
						_subscriber = p31
					}, t10))
				end

				if p31._isMockFunction then
					v100 = true
					g101 = true
				end
			until not g101
		end

		v100 = false
		g101 = true
	until not g101
end
function t10.subscribe(t11: {[any]: any}, p32, p33: ((...any) -> ...any)?, p34: ((...any) -> ...any)?) -- line: 437
	-- upvalues: t6 (copy)
	if typeof(p32) ~= "table" or p32 == nil then
		p32 = {
			start = nil,
			next = p32,
			error = p33,
			complete = p34
		}
	end

	return (t6.new(p32, t11._subscriber))
end
function t10.forEach(t12: {[any]: any}, p35: ((...any) -> ...any)) -- line: 455
	-- upvalues: Promise (copy), Error (copy)
	return Promise.new(function(resolve, reject) -- line: 456
		-- upvalues: p35 (copy), Error (copy), t12 (copy)
		local v160 = p35
		local g162 = nil
		local mt = nil
		local v161 = nil

		if typeof(v160) == "function" then
			v161 = true
			g162 = true
		end

		repeat
			if g162 or (g162 or typeof(v160) == "table") then
				if not g162 then
					if not g162 then
						mt = getmetatable(v160)
					end
				end

				repeat
					if g162 or (g162 or (g162 or mt and rawget(mt, "__call"))) then
						if not g162 then
							if not g162 then
								if not g162 then
									v161 = true
								end
							end
						end

						g162 = false

						if not v161 then
							reject(Error.new(tostring(p35) .. " is not a function"))

							return
						end

						local u164 = nil

						local function done() -- line: 466
							-- upvalues: u164 (ref), resolve (copy)
							u164:unsubscribe()
							resolve()
						end

						u164 = t12:subscribe({
							next = function(_, p37) -- line: 472
								-- upvalues: p35 (copy), done (copy), reject (copy), u164 (ref)
								local ok, result = pcall(p35, p37, done)

								if not ok then
									reject(result)
									u164:unsubscribe()
								end
							end,
							error = function(_, p39) -- line: 481
								-- upvalues: reject (copy)
								reject(p39)
							end,
							complete = function(_) -- line: 484
								-- upvalues: resolve (copy)
								resolve()
							end
						})

						return
					end

					if v160._isMockFunction then
						v161 = true
						g162 = true
					end
				until not g162
			end

			v161 = false
			g162 = true
		until not g162
	end)
end
function t10.map(t13: {[any]: any}, p41: ((...any) -> ...any)) -- line: 492
	-- upvalues: Error (copy), v19 (copy), t10 (ref)
	local g112 = nil
	local mt = nil
	local v111 = nil

	if typeof(p41) == "function" then
		v111 = true
		g112 = true
	end

	repeat
		if g112 or (g112 or typeof(p41) == "table") then
			if not g112 then
				if not g112 then
					mt = getmetatable(p41)
				end
			end

			repeat
				if g112 or (g112 or (g112 or mt and rawget(mt, "__call"))) then
					if not g112 then
						if not g112 then
							if not g112 then
								v111 = true
							end
						end
					end

					g112 = false

					if not v111 then
						error(Error.new(tostring(p41) .. " is not a function"))
					end

					local v114 = t13[v19]

					return ((if v114 == nil then t10 else v114)).new(function(p42) -- line: 501
						-- upvalues: t13 (copy), p41 (copy)
						return t13:subscribe({
							next = function(_, p44) -- line: 503
								-- upvalues: p41 (copy), p42 (copy)
								local ok, result = pcall(p41, p44)

								if not ok then
									p42:error(result)

									return
								end

								p42:next(result)
							end,
							error = function(_, p46) -- line: 514
								-- upvalues: p42 (copy)
								p42:error(p46)
							end,
							complete = function(_) -- line: 517
								-- upvalues: p42 (copy)
								p42:complete()
							end
						})
					end)
				end

				if p41._isMockFunction then
					v111 = true
					g112 = true
				end
			until not g112
		end

		v111 = false
		g112 = true
	until not g112
end
function t10.filter(t14: {[any]: any}, p48: ((...any) -> ...any)) -- line: 526
	-- upvalues: Error (copy), v19 (copy), t10 (ref), Boolean (copy)
	local g118 = nil
	local mt = nil
	local v117 = nil

	if typeof(p48) == "function" then
		v117 = true
		g118 = true
	end

	repeat
		if g118 or (g118 or typeof(p48) == "table") then
			if not g118 then
				if not g118 then
					mt = getmetatable(p48)
				end
			end

			repeat
				if g118 or (g118 or (g118 or mt and rawget(mt, "__call"))) then
					if not g118 then
						if not g118 then
							if not g118 then
								v117 = true
							end
						end
					end

					g118 = false

					if not v117 then
						error(Error.new(tostring(p48) .. " is not a function"))
					end

					local v120 = t14[v19]

					return ((if v120 == nil then t10 else v120)).new(function(t15: {[any]: any}) -- line: 535
						-- upvalues: t14 (copy), p48 (copy), Boolean (copy)
						return t14:subscribe({
							next = function(_, p50) -- line: 537
								-- upvalues: p48 (copy), t15 (copy), Boolean (copy)
								local ok, result = xpcall(p48, function(err) -- line: 539
									-- upvalues: t15 (copy)
									t15:error(err)
								end, p50)

								if ok and not Boolean.toJSBoolean(result) then
									return
								end

								if not ok then
									return
								end

								t15:next(p50)
							end,
							error = function(_, p52) -- line: 552
								-- upvalues: t15 (copy)
								t15:error(p52)
							end,
							complete = function(_) -- line: 555
								-- upvalues: t15 (copy)
								t15:complete()
							end
						})
					end)
				end

				if p48._isMockFunction then
					v117 = true
					g118 = true
				end
			until not g118
		end

		v117 = false
		g118 = true
	until not g118
end
function t10.reduce(t16: {[any]: any}, p54: ((...any) -> ...any), ...) -- line: 562
	-- upvalues: Error (copy), v19 (copy), t10 (ref)
	local t17 = {
		p54,
		...
	}
	local g125 = nil
	local mt = nil
	local v124 = nil

	if typeof(p54) == "function" then
		v124 = true
		g125 = true
	end

	repeat
		if g125 or (g125 or typeof(p54) == "table") then
			if not g125 then
				if not g125 then
					mt = getmetatable(p54)
				end
			end

			repeat
				if g125 or (g125 or (g125 or mt and rawget(mt, "__call"))) then
					if not g125 then
						if not g125 then
							if not g125 then
								v124 = true
							end
						end
					end

					g125 = false

					if not v124 then
						error(Error.new(tostring(p54) .. " is not a function"))
					end

					local v127 = t16[v19]
					local v128 = if v127 == nil then t10 else v127
					local v129 = #t17 > 1
					local u130 = false
					local u131 = t17[2]

					return v128.new(function(t18: {[any]: any}) -- line: 577
						-- upvalues: t16 (copy), u130 (ref), v129 (copy), u131 (ref), p54 (copy), Error (copy)
						return t16:subscribe({
							next = function(_, p56) -- line: 579
								-- upvalues: u130 (ref), v129 (copy), u131 (ref), p54 (copy), t18 (copy)
								local v207 = u130

								u130 = true

								if v207 or v129 then
									local _, result = xpcall(p54, function(err) -- line: 585
										-- upvalues: t18 (copy)
										t18:error(err)
									end, u131, p56)

									u131 = result

									return
								end

								u131 = p56
							end,
							error = function(_, p58) -- line: 593
								-- upvalues: t18 (copy)
								t18:error(p58)
							end,
							complete = function(_) -- line: 596
								-- upvalues: u130 (ref), v129 (copy), t18 (copy), Error (copy), u131 (ref)
								if not u130 and not v129 then
									t18:error(Error.new("Cannot reduce an empty sequence"))
								end

								t18:next(u131)
								t18:complete()
							end
						})
					end)
				end

				if p54._isMockFunction then
					v124 = true
					g125 = true
				end
			until not g125
		end

		v124 = false
		g125 = true
	until not g125
end
function t10.concat(p60, ...) -- line: 609
	-- upvalues: v19 (copy), t10 (ref), Boolean (copy)
	local t19 = { ... }
	local v134 = p60[v19]
	local v135 = if v134 == nil then t10 else v134

	return v135.new(function(p61) -- line: 614
		-- upvalues: t19 (copy), v135 (copy), p60 (copy), Boolean (copy)
		local u170 = nil
		local n1 = 1

		local function startNext(p62) -- line: 617
			-- upvalues: u170 (ref), p61 (copy), n1 (ref), t19 (copy), startNext (copy), v135 (copy)
			u170 = p62:subscribe({
				next = function(_, p64) -- line: 619
					-- upvalues: p61 (copy)
					p61:next(p64)
				end,
				error = function(_, p66) -- line: 622
					-- upvalues: p61 (copy)
					p61:error(p66)
				end,
				complete = function(_) -- line: 625
					-- upvalues: n1 (ref), t19 (copy), u170 (ref), p61 (copy), startNext (copy), v135 (copy)
					if n1 == #t19 + 1 then
						u170 = nil
						p61:complete()

						return
					end

					local v232 = startNext
					local from = v135.from
					local v234 = t19
					local v235 = n1

					n1 += 1
					v232(from(v234[v235]))
				end
			})
		end

		startNext(p60)

		return function() -- line: 644
			-- upvalues: Boolean (copy), u170 (ref)
			if Boolean.toJSBoolean(u170) then
				u170:unsubscribe()
				u170 = nil
			end
		end
	end)
end
function t10.flatMap(t20: {[any]: any}, p68: ((...any) -> ...any)) -- line: 654
	-- upvalues: Error (copy), v19 (copy), t10 (ref), Boolean (copy), Array (copy)
	local u138 = nil
	local g140 = nil
	local mt = nil
	local v139 = nil

	if typeof(p68) == "function" then
		v139 = true
		g140 = true
	end

	repeat
		if g140 or (g140 or typeof(p68) == "table") then
			if not g140 then
				if not g140 then
					mt = getmetatable(p68)
				end
			end

			repeat
				if g140 or (g140 or (g140 or mt and rawget(mt, "__call"))) then
					if not g140 then
						if not g140 then
							if not g140 then
								v139 = true
							end
						end
					end

					g140 = false

					if not v139 then
						error(Error.new(tostring(p68) .. " is not a function"))
					end

					local v142 = t20[v19]
					local v143 = if v142 == nil then t10 else v142

					return v143.new(function(p69) -- line: 665
						-- upvalues: t20 (copy), Boolean (copy), p68 (copy), v143 (copy), Array (copy), u138 (ref)
						local t21 = {}
						local v175 = t20:subscribe({
							next = function(_, p71) -- line: 668
								-- upvalues: Boolean (copy), p68 (copy), p69 (copy), v143 (copy), Array (copy), t21 (copy), u138 (ref)
								if Boolean.toJSBoolean(p68) then
									local ok

									ok, p71 = xpcall(p68, function(err) -- line: 672
										-- upvalues: p69 (copy)
										p69:error(err)
									end, p71)
								end

								local u217 = nil

								u217 = v143.from(p71):subscribe({
									next = function(_, p73) -- line: 680
										-- upvalues: p69 (copy)
										p69:next(p73)
									end,
									error = function(_, p75) -- line: 683
										-- upvalues: p69 (copy)
										p69:error(p75)
									end,
									complete = function(_) -- line: 686
										-- upvalues: Array (copy), t21 (copy), u217 (ref), u138 (ref)
										local v242 = Array.indexOf(t21, u217)

										if v242 >= 1 then
											Array.splice(t21, v242, 1)
										end

										u138()
									end
								})
								table.insert(t21, u217)

								return nil
							end,
							error = function(_, p78) -- line: 701
								-- upvalues: p69 (copy)
								p69:error(p78)
							end,
							complete = function(_) -- line: 704
								-- upvalues: u138 (ref)
								u138()
							end
						})

						local function completeIfDone() -- line: 709
							-- upvalues: v175 (copy), t21 (copy), p69 (copy)
							if v175.closed and #t21 == 0 then
								p69:complete()
							end
						end

						u138 = completeIfDone

						return function() -- line: 715
							-- upvalues: Array (copy), t21 (copy), v175 (copy)
							Array.forEach(t21, function(p80) -- line: 716
								return p80:unsubscribe()
							end)
							v175:unsubscribe()
						end
					end)
				end

				if p68._isMockFunction then
					v139 = true
					g140 = true
				end
			until not g140
		end

		v139 = false
		g140 = true
	until not g140
end

t10[v18] = function(p81) -- line: 724
	return p81
end

function t10.from(p82, p83) -- line: 729
	-- upvalues: isObservableClass (ref), t10 (ref), Error (copy), v18 (copy), instanceof (copy), Array (copy), Promise (copy), self (ref)
	local g150 = nil
	local g152 = nil
	local mt = nil
	local v151 = nil
	local v147, u148

	if isObservableClass(p82) then
		v147 = p82
		u148 = p83
	else
		v147 = t10
		u148 = p82
	end

	if u148 == nil then
		error(Error.new(tostring(u148) .. " is not an object"))
	end

	local v149 = u148[v18]

	if v149 == nil then
		v149 = nil
		g150 = true
	end

	if not g150 then
		if typeof(v149) == "function" then
			v151 = true
			g152 = true
		end
	end

	repeat
		if g150 or (g152 or (g152 or typeof(v149) == "table")) then
			if not g150 then
				if not g152 then
					if not g152 then
						mt = getmetatable(v149)
					end
				end
			end

			repeat
				if g150 or (g152 or (g152 or (g152 or mt and rawget(mt, "__call")))) then
					if not g150 then
						if not g152 then
							if not g152 then
								if not g152 then
									v151 = true
								end
							end
						end

						g152 = false

						if not v151 then
							error(Error.new(tostring(v149) .. " is not a function"))
						end
					end

					g150 = false

					if v149 then
						local v154 = v149(u148)

						if instanceof(v154, t10) and v154.new == v147.new then
							return v154
						end

						return v147.new(function(p84) -- line: 758
							-- upvalues: v154 (copy)
							return v154:subscribe(p84)
						end)
					end

					if Array.isArray(u148) then
						return t10.new(function(p85) -- line: 780
							-- upvalues: u148 (ref), Promise (copy), self (ref)
							local function v179() -- line: 781
								-- upvalues: p85 (copy), u148 (ref)
								if p85.closed then
									return
								end

								for _, v in pairs(u148) do
									p85:next(v)

									if p85.closed then
										return
									end
								end

								p85:complete()
							end

							Promise.delay(0):doneCall(function() -- line: 117
								-- upvalues: v179 (copy), self (ref)
								xpcall(v179, function(err) -- line: 118
									-- upvalues: self (ref)
									self(err)
								end)
							end)
						end)
					end

					error(Error.new(tostring(u148) .. " is not observable"))

					return
				end

				if v149._isMockFunction then
					v151 = true
					g152 = true
				end
			until not g152
		end

		v151 = false
		g152 = true
	until not g152
end
function t10.of(p86, ...) -- line: 803
	-- upvalues: isObservableClass (ref), t10 (ref), Promise (copy), self (ref)
	local v156, t22

	if isObservableClass(p86) then
		v156 = p86
		t22 = { ... }
	else
		v156 = t10
		t22 = {
			p86,
			...
		}
	end

	return v156.new(function(p87) -- line: 813
		-- upvalues: t22 (ref), Promise (copy), self (ref)
		local function v181() -- line: 814
			-- upvalues: p87 (copy), t22 (ref)
			if p87.closed then
				return
			end

			for _, v in ipairs(t22) do
				p87:next(v)

				if p87.closed then
					return
				end
			end

			p87:complete()
		end

		Promise.delay(0):doneCall(function() -- line: 117
			-- upvalues: v181 (copy), self (ref)
			xpcall(v181, function(err) -- line: 118
				-- upvalues: self (ref)
				self(err)
			end)
		end)
	end)
end

if typeof(Symbol) == "table" and typeof(getmetatable(Symbol).__call) == "function" then
	t10[Symbol("extensions")] = {
		symbol = v18,
		hostReportError = self
	}
end

return {
	Observable = t10
}
