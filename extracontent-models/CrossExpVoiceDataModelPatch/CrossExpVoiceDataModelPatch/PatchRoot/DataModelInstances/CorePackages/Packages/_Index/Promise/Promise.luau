local t1 = {
	__mode = "k"
}

local function isCallable(p1) -- line: 10
	if type(p1) == "function" then
		return true
	end

	if type(p1) == "table" then
		local mt = getmetatable(p1)

		if mt and type((rawget(mt, "__call"))) == "function" then
			return true
		end
	end

	return false
end
local function makeEnum(p2, p3) -- line: 28
	local t2 = {}

	for _, v in ipairs(p3) do
		t2[v] = v
	end

	return (setmetatable(t2, {
		__index = function(_, p5) -- line: 36
			-- upvalues: p2 (copy)
			error(string.format("%s is not in %s!", p5, p2), 2)
		end,
		__newindex = function() -- line: 39
			-- upvalues: p2 (copy)
			error(string.format("Creating new members in %s is not allowed!", p2), 2)
		end
	}))
end

local t3 = {
	Kind = makeEnum("Promise.Error.Kind", {
		"ExecutionError",
		"AlreadyCancelled",
		"NotResolvedInTime",
		"TimedOut"
	})
}

t3.__index = t3

function t3.new(p6, p7) -- line: 64
	-- upvalues: t3 (ref)
	local v25 = p6 or {}

	return (setmetatable({
		error = tostring(v25.error) or "[This error has no error text.]",
		trace = v25.trace,
		context = v25.context,
		kind = v25.kind,
		parent = p7,
		createdTick = os.clock(),
		createdTrace = debug.traceback()
	}, t3))
end
function t3.is(p8) -- line: 77
	if type(p8) == "table" then
		local mt = getmetatable(p8)

		if type(mt) == "table" then
			return rawget(p8, "error") ~= nil and type((rawget(mt, "extend"))) == "function"
		end
	end

	return false
end
function t3.isKind(p9, p10) -- line: 89
	-- upvalues: t3 (ref)
	assert(p10 ~= nil, "Argument #2 to Promise.Error.isKind must not be nil")

	return t3.is(p9) and p10 == p9.kind
end
function t3.extend(p11, p12) -- line: 95
	-- upvalues: t3 (ref)
	local v32 = p12 or {}

	v32.kind = v32.kind or p11.kind

	return t3.new(v32, p11)
end
function t3.getErrorChain(p13) -- line: 103
	local t4 = { p13 }

	while t4[#t4].parent do
		table.insert(t4, t4[#t4].parent)
	end

	return t4
end
function t3.__tostring(p14) -- line: 113
	local t5 = { string.format("-- Promise.Error(%s) --", p14.kind or "?") }

	for _, v in ipairs(p14:getErrorChain()) do
		table.insert(t5, table.concat({
			v.trace or v.error,
			v.context
		}, "\n"))
	end

	return table.concat(t5, "\n")
end

local function pack(...) -- line: 137
	return select("#", ...), { ... }
end
local function packResult(p15, ...) -- line: 144
	return p15, select("#", ...), { ... }
end
local function makeErrorHandler(p16) -- line: 148
	-- upvalues: t3 (ref)
	assert(p16 ~= nil, "traceback is nil")

	return function(p17) -- line: 151
		-- upvalues: t3 (ref), p16 (copy)
		if type(p17) == "table" then
			return p17
		end

		return t3.new({
			error = p17,
			kind = t3.Kind.ExecutionError,
			trace = debug.traceback(tostring(p17), 2),
			context = "Promise created at:\n\n" .. p16
		})
	end
end
local function runExecutor(p18, p19, ...) -- line: 171
	-- upvalues: packResult (copy), t3 (ref)
	local v43 = packResult
	local _xpcall = xpcall

	assert(p18 ~= nil, "traceback is nil")

	return v43(_xpcall(p19, function(p20) -- line: 151
		-- upvalues: t3 (ref), p18 (copy)
		if type(p20) == "table" then
			return p20
		end

		return t3.new({
			error = p20,
			kind = t3.Kind.ExecutionError,
			trace = debug.traceback(tostring(p20), 2),
			context = "Promise created at:\n\n" .. p18
		})
	end, ...))
end
local function createAdvancer(p21, p22, p23, p24) -- line: 179
	-- upvalues: runExecutor (copy)
	return function(...) -- line: 180
		-- upvalues: runExecutor (copy), p21 (copy), p22 (copy), p23 (copy), p24 (copy)
		local v244, v245, v246 = runExecutor(p21, p22, ...)

		if v244 then
			p23(unpack(v246, 1, v245))

			return
		end

		p24(v246[1])
	end
end
local function isEmpty(p25) -- line: 191
	return next(p25) == nil
end

local t6 = {
	Error = t3,
	Status = makeEnum("Promise.Status", {
		"Started",
		"Resolved",
		"Rejected",
		"Cancelled"
	}),
	_getTime = os.clock,
	_timeEvent = game:GetService("RunService").Heartbeat,
	_unhandledRejectionCallbacks = {},
	prototype = {}
}

t6.__index = t6.prototype

function t6._new(p26, p27, p28) -- line: 230
	-- upvalues: t6 (copy), t1 (copy), runExecutor (copy)
	if p28 ~= nil and not t6.is(p28) then
		error("Argument #2 to Promise.new must be a promise or nil", 2)
	end

	local t7 = {
		_thread = nil,
		_values = nil,
		_valuesLength = -1,
		_unhandledRejection = true,
		_cancellationHook = nil,
		_source = p26,
		_status = t6.Status.Started,
		_queuedResolve = {},
		_queuedReject = {},
		_queuedFinally = {},
		_parent = p28,
		_consumers = setmetatable({}, t1)
	}

	if p28 and p28._status == t6.Status.Started then
		p28._consumers[t7] = true
	end

	setmetatable(t7, t6)

	local function resolve(...) -- line: 278
		-- upvalues: t7 (copy)
		t7:_resolve(...)
	end
	local function reject(...) -- line: 282
		-- upvalues: t7 (copy)
		t7:_reject(...)
	end
	local function onCancel(p29) -- line: 286
		-- upvalues: t7 (copy), t6 (copy)
		if p29 then
			if t7._status == t6.Status.Cancelled then
				p29()
			else
				t7._cancellationHook = p29
			end
		end

		return t7._status == t6.Status.Cancelled
	end

	t7._thread = coroutine.create(function() -- line: 298
		-- upvalues: runExecutor (copy), t7 (copy), p27 (copy), resolve (copy), reject (copy), onCancel (copy)
		local v248, _, v250 = runExecutor(t7._source, p27, resolve, reject, onCancel)

		if not v248 then
			reject(v250[1])
		end
	end)
	task.spawn(t7._thread)

	return t7
end
function t6.new(p30) -- line: 349
	-- upvalues: t6 (copy)
	return t6._new(debug.traceback(nil, 2), p30)
end
function t6.__tostring(p31) -- line: 353
	return string.format("Promise(%s)", p31._status)
end
function t6.defer(p32) -- line: 375
	-- upvalues: t6 (copy), runExecutor (copy)
	local trace = debug.traceback(nil, 2)

	return (t6._new(trace, function(p33, p34, p35) -- line: 378
		-- upvalues: t6 (copy), runExecutor (copy), trace (copy), p32 (copy)
		local connection = nil

		connection = t6._timeEvent:Connect(function() -- line: 380
			-- upvalues: connection (ref), runExecutor (copy), trace (copy), p32 (copy), p33 (copy), p34 (copy), p35 (copy)
			connection:Disconnect()

			local v362, _, v364 = runExecutor(trace, p32, p33, p34, p35)

			if not v362 then
				p34(v364[1])
			end
		end)
	end))
end

t6.async = t6.defer

function t6.resolve(...) -- line: 418
	-- upvalues: pack (copy), t6 (copy)
	local v61, v62 = pack(...)

	return t6._new(debug.traceback(nil, 2), function(p36) -- line: 420
		-- upvalues: v62 (copy), v61 (copy)
		p36(unpack(v62, 1, v61))
	end)
end
function t6.reject(...) -- line: 435
	-- upvalues: pack (copy), t6 (copy)
	local v63, v64 = pack(...)

	return t6._new(debug.traceback(nil, 2), function(_, p38) -- line: 437
		-- upvalues: v64 (copy), v63 (copy)
		p38(unpack(v64, 1, v63))
	end)
end
function t6._try(p39, p40, ...) -- line: 446
	-- upvalues: pack (copy), t6 (copy)
	local v67, v68 = pack(...)

	return t6._new(p39, function(p41) -- line: 449
		-- upvalues: p40 (copy), v68 (copy), v67 (copy)
		p41(p40(unpack(v68, 1, v67)))
	end)
end
function t6.try(p42, ...) -- line: 477
	-- upvalues: t6 (copy)
	return t6._try(debug.traceback(nil, 2), p42, ...)
end
function t6._all(p43, p44, p45) -- line: 486
	-- upvalues: t6 (copy)
	if type(p44) ~= "table" then
		error(string.format("Please pass a list of promises to %s", "Promise.all"), 3)
	end

	for k, v in pairs(p44) do
		if not t6.is(v) then
			error(string.format("Non-promise value passed into %s at index %s", "Promise.all", (tostring(k))), 3)
		end
	end

	if #p44 == 0 or p45 == 0 then
		return t6.resolve({})
	end

	return t6._new(p43, function(p46, p47, p48) -- line: 504
		-- upvalues: p45 (copy), p44 (copy)
		local t8 = {}
		local t9 = {}
		local n1 = 0
		local n2 = 0
		local u266 = false

		local function cancel() -- line: 515
			-- upvalues: t9 (copy)
			for _, v in ipairs(t9) do
				v:cancel()
			end
		end
		local function resolveOne(p49, ...) -- line: 522
			-- upvalues: u266 (ref), n1 (ref), p45 (copy), t8 (copy), p44 (copy), p46 (copy), t9 (copy)
			if u266 then
				return
			end

			n1 += 1

			if p45 == nil then
				t8[p49] = ...
			else
				t8[n1] = ...
			end

			if n1 >= (p45 or #p44) then
				u266 = true
				p46(t8)

				for _, v in ipairs(t9) do
					v:cancel()
				end
			end
		end

		p48(cancel)

		for i, v in ipairs(p44) do
			t9[i] = v:andThen(function(...) -- line: 547
				-- upvalues: resolveOne (copy), i (copy)
				resolveOne(i, ...)
			end, function(...) -- line: 549
				-- upvalues: n2 (ref), p45 (copy), p44 (copy), t9 (copy), u266 (ref), p47 (copy)
				n2 += 1

				if p45 == nil or #p44 - n2 < p45 then
					for _, v2 in ipairs(t9) do
						v2:cancel()
					end

					u266 = true
					p47(...)
				end
			end)
		end

		if u266 then
			for _, v in ipairs(t9) do
				v:cancel()
			end
		end
	end)
end
function t6.all(...) -- line: 591
	-- upvalues: t6 (copy)
	local t10 = { ... }

	if type(t10[1]) == "table" and not t6.is(t10[1]) then
		t10 = t10[1]
	end

	return t6._all(debug.traceback(nil, 2), t10)
end
function t6.fold(p50, p51, p52) -- line: 628
	-- upvalues: t6 (copy)
	assert(type(p50) == "table", "Bad argument #1 to Promise.fold: must be a table")

	local g80 = nil
	local mt = nil
	local v79 = nil

	if type(p51) == "function" then
		v79 = true
		g80 = true
	end

	repeat
		if g80 or (g80 or type(p51) == "table") then
			if not g80 then
				if not g80 then
					mt = getmetatable(p51)
				end
			end

			if g80 or (g80 or mt and type((rawget(mt, "__call"))) == "function") then
				if not g80 then
					if not g80 then
						v79 = true
					end
				end

				g80 = false
				assert(v79, "Bad argument #2 to Promise.fold: must be a function")

				local u82 = t6.resolve(p52)

				return t6.each(p50, function(p53, p54) -- line: 633
					-- upvalues: u82 (ref), p51 (copy)
					u82 = u82:andThen(function(p55) -- line: 634
						-- upvalues: p51 (copy), p53 (copy), p54 (copy)
						return p51(p55, p53, p54)
					end)
				end):andThen(function() -- line: 637
					-- upvalues: u82 (ref)
					return u82
				end)
			end
		end

		v79 = false
		g80 = true
	until not g80
end
function t6.some(p56, p57) -- line: 661
	-- upvalues: t6 (copy)
	assert(type(p57) == "number", "Bad argument #2 to Promise.some: must be a number")

	return t6._all(debug.traceback(nil, 2), p56, p57)
end
function t6.any(p58) -- line: 685
	-- upvalues: t6 (copy)
	return t6._all(debug.traceback(nil, 2), p58, 1):andThen(function(p59) -- line: 686
		return p59[1]
	end)
end
function t6.allSettled(p60) -- line: 707
	-- upvalues: t6 (copy)
	if type(p60) ~= "table" then
		error(string.format("Please pass a list of promises to %s", "Promise.allSettled"), 2)
	end

	for k, v in pairs(p60) do
		if not t6.is(v) then
			error(string.format("Non-promise value passed into %s at index %s", "Promise.allSettled", (tostring(k))), 2)
		end
	end

	if #p60 == 0 then
		return t6.resolve({})
	end

	return t6._new(debug.traceback(nil, 2), function(p61, _, p63) -- line: 725
		-- upvalues: p60 (copy)
		local t11 = {}
		local t12 = {}
		local n3 = 0

		local function resolveOne(p64, ...) -- line: 735
			-- upvalues: n3 (ref), t11 (copy), p60 (copy), p61 (copy)
			n3 += 1
			t11[p64] = ...

			if n3 >= #p60 then
				p61(t11)
			end
		end

		p63(function() -- line: 745
			-- upvalues: t12 (copy)
			for _, v in ipairs(t12) do
				v:cancel()
			end
		end)

		for i, v in ipairs(p60) do
			t12[i] = v:finally(function(...) -- line: 754
				-- upvalues: resolveOne (copy), i (copy)
				resolveOne(i, ...)
			end)
		end
	end)
end
function t6.race(p65) -- line: 785
	-- upvalues: t6 (copy)
	assert(type(p65) == "table", string.format("Please pass a list of promises to %s", "Promise.race"))

	for k, v in pairs(p65) do
		assert(t6.is(v), string.format("Non-promise value passed into %s at index %s", "Promise.race", (tostring(k))))
	end

	return t6._new(debug.traceback(nil, 2), function(p66, p67, p68) -- line: 792
		-- upvalues: p65 (copy)
		local t13 = {}
		local u289 = false

		local function cancel() -- line: 796
			-- upvalues: t13 (copy)
			for _, v in ipairs(t13) do
				v:cancel()
			end
		end
		local function finalize(p69) -- line: 802
			-- upvalues: t13 (copy), u289 (ref)
			return function(...) -- line: 803
				-- upvalues: t13 (copy), u289 (ref), p69 (copy)
				for _, v in ipairs(t13) do
					v:cancel()
				end

				u289 = true

				return p69(...)
			end
		end

		if p68(function(...) -- line: 803
			-- upvalues: t13 (copy), u289 (ref), p67 (copy)
			for _, v in ipairs(t13) do
				v:cancel()
			end

			u289 = true

			return p67(...)
		end) then
			return
		end

		for i, v in ipairs(p65) do
			t13[i] = v:andThen(function(...) -- line: 803
				-- upvalues: t13 (copy), u289 (ref), p66 (copy)
				for _, v3 in ipairs(t13) do
					v3:cancel()
				end

				u289 = true

				return p66(...)
			end, function(...) -- line: 803
				-- upvalues: t13 (copy), u289 (ref), p67 (copy)
				for _, v4 in ipairs(t13) do
					v4:cancel()
				end

				u289 = true

				return p67(...)
			end)
		end

		if u289 then
			for _, v in ipairs(t13) do
				v:cancel()
			end
		end
	end)
end
function t6.each(p70, p71) -- line: 880
	-- upvalues: t6 (copy), t3 (ref)
	assert(type(p70) == "table", string.format("Please pass a list of promises to %s", "Promise.each"))

	local g95 = nil
	local mt = nil
	local v94 = nil

	if type(p71) == "function" then
		v94 = true
		g95 = true
	end

	repeat
		if g95 or (g95 or type(p71) == "table") then
			if not g95 then
				if not g95 then
					mt = getmetatable(p71)
				end
			end

			if g95 or (g95 or mt and type((rawget(mt, "__call"))) == "function") then
				if not g95 then
					if not g95 then
						v94 = true
					end
				end

				g95 = false
				assert(v94, string.format("Please pass a handler function to %s!", "Promise.each"))

				return t6._new(debug.traceback(nil, 2), function(p72, p73, p74) -- line: 884
					-- upvalues: p70 (copy), t6 (copy), t3 (ref), p71 (copy)
					local t14 = {}
					local t15 = {}
					local u301 = false

					local function cancel() -- line: 890
						-- upvalues: t15 (copy)
						for _, v in ipairs(t15) do
							v:cancel()
						end
					end

					p74(function() -- line: 896
						-- upvalues: u301 (ref), t15 (copy)
						u301 = true

						for _, v in ipairs(t15) do
							v:cancel()
						end
					end)

					local t16 = {}

					for i, v in ipairs(p70) do
						if t6.is(v) then
							if v:getStatus() == t6.Status.Cancelled then
								for _, v5 in ipairs(t15) do
									v5:cancel()
								end

								return p73(t3.new({
									error = "Promise is cancelled",
									kind = t3.Kind.AlreadyCancelled,
									context = string.format("The Promise that was part of the array at index %d passed into Promise.each was already cancelled when Promise.each began.\n\nThat Promise was created at:\n\n%s", i, v._source)
								}))
							end

							if v:getStatus() == t6.Status.Rejected then
								for _, v6 in ipairs(t15) do
									v6:cancel()
								end

								return p73(select(2, v:await()))
							end

							local v310 = v:andThen(function(...) -- line: 929
								return ...
							end)

							table.insert(t15, v310)
							t16[i] = v310

							continue
						end

						t16[i] = v
					end

					for i, v in ipairs(t16) do
						local v313 = v

						if t6.is(v313) then
							local v314

							v314, v313 = v313:await()

							if not v314 then
								for _, v7 in ipairs(t15) do
									v7:cancel()
								end

								return p73(v313)
							end
						end

						if u301 then
							return
						end

						local v317 = t6.resolve(p71(v313, i))

						table.insert(t15, v317)

						local v318, v319 = v317:await()

						if not v318 then
							for _, v8 in ipairs(t15) do
								v8:cancel()
							end

							return p73(v319)
						end

						t14[i] = v319
					end

					p72(t14)
				end)
			end
		end

		v94 = false
		g95 = true
	until not g95
end
function t6.is(p75) -- line: 979
	-- upvalues: t6 (copy)
	if type(p75) ~= "table" then
		return false
	end

	local mt = getmetatable(p75)

	if mt == t6 then
		return true
	end

	if mt == nil then
		local andThen = p75.andThen

		if type(andThen) == "function" then
			return true
		end

		if type(andThen) == "table" then
			local mt2 = getmetatable(andThen)

			if mt2 and type((rawget(mt2, "__call"))) == "function" then
				return true
			end
		end

		return false
	end

	if type(mt) ~= "table" or type((rawget(mt, "__index"))) ~= "table" then
		return false
	end

	local v101 = rawget(rawget(mt, "__index"), "andThen")
	local g103 = nil
	local mt3 = nil
	local v102 = nil

	if type(v101) == "function" then
		v102 = true
		g103 = true
	end

	repeat
		if g103 or (g103 or type(v101) == "table") then
			if not g103 then
				if not g103 then
					mt3 = getmetatable(v101)
				end
			end

			if g103 or (g103 or mt3 and type((rawget(mt3, "__call"))) == "function") then
				if not g103 then
					if not g103 then
						v102 = true
					end
				end

				g103 = false

				if v102 then
					return true
				end

				return false
			end
		end

		v102 = false
		g103 = true
	until not g103
end
function t6.promisify(p76) -- line: 1028
	-- upvalues: t6 (copy)
	return function(...) -- line: 1029
		-- upvalues: t6 (copy), p76 (copy)
		return t6._try(debug.traceback(nil, 2), p76, ...)
	end
end

local u12 = nil
local u13 = nil

function t6.delay(p77) -- line: 1059
	-- upvalues: t6 (copy), u13 (ref), u12 (ref)
	assert(type(p77) == "number", "Bad argument #1 to Promise.delay, must be a number.")

	if not (p77 >= 0.016666666666666666) or p77 == 1e999 then
		p77 = 0.016666666666666666
	end

	return t6._new(debug.traceback(nil, 2), function(p78, _, p80) -- line: 1067
		-- upvalues: t6 (copy), p77 (ref), u13 (ref), u12 (ref)
		local v325 = t6._getTime()
		local v326 = v325 + p77
		local t17 = {
			resolve = p78,
			startTime = v325,
			endTime = v326
		}

		if u13 == nil then
			u12 = t17
			u13 = t6._timeEvent:Connect(function() -- line: 1079
				-- upvalues: t6 (copy), u12 (ref), u13 (ref)
				local v389 = t6._getTime()

				while u12 ~= nil and v389 > u12.endTime do
					local v390 = u12

					u12 = v390.next

					if u12 == nil then
						u13:Disconnect()
						u13 = nil
					else
						u12.previous = nil
					end

					v390.resolve(t6._getTime() - v390.startTime)
				end
			end)
		elseif v326 > u12.endTime then
			local v328 = u12
			local next2 = v328.next

			while next2 ~= nil and v326 > next2.endTime do
				v328 = next2
				next2 = v328.next
			end

			v328.next = t17
			t17.previous = v328

			if next2 ~= nil then
				t17.next = next2
				next2.previous = t17
			end
		else
			t17.next = u12
			u12.previous = t17
			u12 = t17
		end

		p80(function() -- line: 1124
			-- upvalues: t17 (copy), u12 (ref), u13 (ref)
			local next3 = t17.next

			if u12 == t17 then
				if next3 == nil then
					u13:Disconnect()
					u13 = nil
				else
					next3.previous = nil
				end

				u12 = next3

				return
			end

			local previous = t17.previous

			previous.next = next3

			if next3 ~= nil then
				next3.previous = previous
			end
		end)
	end)
end
function t6.prototype.timeout(p81, p82, p83) -- line: 1188
	-- upvalues: t6 (copy), t3 (ref)
	local trace = debug.traceback(nil, 2)

	return t6.race({
		t6.delay(p82):andThen(function() -- line: 1192
			-- upvalues: t6 (copy), p83 (copy), t3 (ref), p82 (copy), trace (copy)
			return t6.reject(p83 == nil and t3.new({
				error = "Timed out",
				kind = t3.Kind.TimedOut,
				context = string.format("Timeout of %d seconds exceeded.\n:timeout() called at:\n\n%s", p82, trace)
			}) or p83)
		end),
		p81
	})
end
function t6.prototype.getStatus(p84) -- line: 1212
	return p84._status
end
function t6.prototype._andThen(p85, p86, p87, p88) -- line: 1221
	-- upvalues: t6 (copy), runExecutor (copy), t3 (ref)
	p85._unhandledRejection = false

	return t6._new(p86, function(p89, p90) -- line: 1225
		-- upvalues: p87 (copy), p86 (copy), runExecutor (copy), p88 (copy), p85 (copy), t6 (copy), t3 (ref)
		local v332 = p89

		if p87 then
			local v333 = p86
			local v334 = p87

			function v332(...) -- line: 180
				-- upvalues: runExecutor (copy), v333 (copy), v334 (copy), p89 (copy), p90 (copy)
				local v393, v394, v395 = runExecutor(v333, v334, ...)

				if v393 then
					p89(unpack(v395, 1, v394))

					return
				end

				p90(v395[1])
			end
		end

		local v335 = p90

		if p88 then
			local v336 = p86
			local v337 = p88

			function v335(...) -- line: 180
				-- upvalues: runExecutor (copy), v336 (copy), v337 (copy), p89 (copy), p90 (copy)
				local v396, v397, v398 = runExecutor(v336, v337, ...)

				if v396 then
					p89(unpack(v398, 1, v397))

					return
				end

				p90(v398[1])
			end
		end

		if p85._status == t6.Status.Started then
			table.insert(p85._queuedResolve, v332)
			table.insert(p85._queuedReject, v335)

			return
		end

		if p85._status == t6.Status.Resolved then
			v332(unpack(p85._values, 1, p85._valuesLength))

			return
		end

		if p85._status == t6.Status.Rejected then
			v335(unpack(p85._values, 1, p85._valuesLength))

			return
		end

		if p85._status == t6.Status.Cancelled then
			p90(t3.new({
				error = "Promise is cancelled",
				kind = t3.Kind.AlreadyCancelled,
				context = "Promise created at\n\n" .. p86
			}))
		end
	end, p85)
end
function t6.prototype.andThen(p91, p92, p93) -- line: 1282
	local v120 = true
	local g124 = nil
	local g121

	if p92 ~= nil then
		g121 = nil

		if type(p92) == "function" then
			v120 = true
			g121 = true
		end

		if not g121 then
			if type(p92) == "table" then
				local mt = getmetatable(p92)

				if mt and type((rawget(mt, "__call"))) == "function" then
					v120 = true
					g121 = true
				end
			end

			if not g121 then
				v120 = false
				g121 = true
			end
		end
	end

	g121 = false
	assert(v120, string.format("Please pass a handler function to %s!", "Promise:andThen"))

	local v123 = true

	if p93 ~= nil then
		if type(p93) == "function" then
			v123 = true
			g124 = true
		end

		if not g124 then
			if type(p93) == "table" then
				local mt = getmetatable(p93)

				if mt and type((rawget(mt, "__call"))) == "function" then
					v123 = true
					g124 = true
				end
			end

			if not g124 then
				v123 = false
				g124 = true
			end
		end
	end

	g124 = false
	assert(v123, string.format("Please pass a handler function to %s!", "Promise:andThen"))

	return p91:_andThen(debug.traceback(nil, 2), p92, p93)
end
function t6.prototype.andThenAsync(p94, p95, p96) -- line: 1310
	-- upvalues: pack (copy), t6 (copy)
	local v129 = true
	local g133 = nil
	local g130

	if p95 ~= nil then
		g130 = nil

		if type(p95) == "function" then
			v129 = true
			g130 = true
		end

		if not g130 then
			if type(p95) == "table" then
				local mt = getmetatable(p95)

				if mt and type((rawget(mt, "__call"))) == "function" then
					v129 = true
					g130 = true
				end
			end

			if not g130 then
				v129 = false
				g130 = true
			end
		end
	end

	g130 = false
	assert(v129, string.format("Please pass a handler function to %s!", "Promise:andThenAsync"))

	local v132 = true

	if p96 ~= nil then
		if type(p96) == "function" then
			v132 = true
			g133 = true
		end

		if not g133 then
			if type(p96) == "table" then
				local mt = getmetatable(p96)

				if mt and type((rawget(mt, "__call"))) == "function" then
					v132 = true
					g133 = true
				end
			end

			if not g133 then
				v132 = false
				g133 = true
			end
		end
	end

	g133 = false
	assert(v132, string.format("Please pass a handler function to %s!", "Promise:andThenAsync"))

	return p94:_andThen(debug.traceback(nil, 2), function(...) -- line: 1317
		-- upvalues: pack (copy), t6 (copy)
		local v338, v339 = pack(...)

		return t6.defer(function(p97) -- line: 1319
			-- upvalues: v339 (copy), v338 (copy)
			p97(unpack(v339, 1, v338))
		end)
	end, function(...) -- line: 1323
		-- upvalues: pack (copy), t6 (copy)
		local v340, v341 = pack(...)

		return t6.defer(function(_, p99) -- line: 1325
			-- upvalues: v341 (copy), v340 (copy)
			p99(unpack(v341, 1, v340))
		end)
	end):andThen(p95, p96)
end
function t6.prototype.catch(p100, p101) -- line: 1352
	local v137 = true
	local g138

	if p101 ~= nil then
		g138 = nil

		if type(p101) == "function" then
			v137 = true
			g138 = true
		end

		if not g138 then
			if type(p101) == "table" then
				local mt = getmetatable(p101)

				if mt and type((rawget(mt, "__call"))) == "function" then
					v137 = true
					g138 = true
				end
			end

			if not g138 then
				v137 = false
				g138 = true
			end
		end
	end

	g138 = false
	assert(v137, string.format("Please pass a handler function to %s!", "Promise:catch"))

	return p100:_andThen(debug.traceback(nil, 2), nil, p101)
end
function t6.prototype.tap(p102, p103) -- line: 1373
	-- upvalues: t6 (copy), pack (copy)
	local g143 = nil
	local mt = nil
	local v142 = nil

	if type(p103) == "function" then
		v142 = true
		g143 = true
	end

	repeat
		if g143 or (g143 or type(p103) == "table") then
			if not g143 then
				if not g143 then
					mt = getmetatable(p103)
				end
			end

			if g143 or (g143 or mt and type((rawget(mt, "__call"))) == "function") then
				if not g143 then
					if not g143 then
						v142 = true
					end
				end

				g143 = false
				assert(v142, string.format("Please pass a handler function to %s!", "Promise:tap"))

				return p102:_andThen(debug.traceback(nil, 2), function(...) -- line: 1375
					-- upvalues: p103 (copy), t6 (copy), pack (copy)
					local v342 = p103(...)

					if t6.is(v342) then
						local v343, v344 = pack(...)

						return v342:andThen(function() -- line: 1380
							-- upvalues: v344 (copy), v343 (copy)
							return unpack(v344, 1, v343)
						end)
					end

					return ...
				end)
			end
		end

		v142 = false
		g143 = true
	until not g143
end
function t6.prototype.andThenCall(p104, p105, ...) -- line: 1408
	-- upvalues: pack (copy)
	local g148 = nil
	local mt = nil
	local v147 = nil

	if type(p105) == "function" then
		v147 = true
		g148 = true
	end

	repeat
		if g148 or (g148 or type(p105) == "table") then
			if not g148 then
				if not g148 then
					mt = getmetatable(p105)
				end
			end

			if g148 or (g148 or mt and type((rawget(mt, "__call"))) == "function") then
				if not g148 then
					if not g148 then
						v147 = true
					end
				end

				g148 = false
				assert(v147, string.format("Please pass a handler function to %s!", "Promise:andThenCall"))

				local v150, v151 = pack(...)

				return p104:_andThen(debug.traceback(nil, 2), function() -- line: 1411
					-- upvalues: p105 (copy), v151 (copy), v150 (copy)
					return p105(unpack(v151, 1, v150))
				end)
			end
		end

		v147 = false
		g148 = true
	until not g148
end
function t6.prototype.andThenReturn(p106, ...) -- line: 1438
	-- upvalues: pack (copy)
	local v153, v154 = pack(...)

	return p106:_andThen(debug.traceback(nil, 2), function() -- line: 1440
		-- upvalues: v154 (copy), v153 (copy)
		return unpack(v154, 1, v153)
	end)
end
function t6.prototype.cancel(p107) -- line: 1456
	-- upvalues: t6 (copy)
	if p107._status ~= t6.Status.Started then
		return
	end

	p107._status = t6.Status.Cancelled

	if p107._cancellationHook then
		p107._cancellationHook()
	end

	coroutine.close(p107._thread)

	if p107._parent then
		p107._parent:_consumerCancelled(p107)
	end

	for k in pairs(p107._consumers) do
		k:cancel()
	end

	p107:_finalize()
end
function t6.prototype._consumerCancelled(p108, p109) -- line: 1484
	-- upvalues: t6 (copy)
	if p108._status ~= t6.Status.Started then
		return
	end

	p108._consumers[p109] = nil

	if next(p108._consumers) == nil then
		p108:cancel()
	end
end
function t6.prototype._finally(p110, p111, p112, p113) -- line: 1500
	-- upvalues: t6 (copy), runExecutor (copy)
	if not p113 then
		p110._unhandledRejection = false
	end

	return t6._new(p111, function(p114, p115) -- line: 1506
		-- upvalues: p112 (copy), p111 (copy), runExecutor (copy), p113 (copy), p110 (copy), t6 (copy)
		local v347 = p114

		if p112 then
			local v348 = p111
			local v349 = p112

			function v347(...) -- line: 180
				-- upvalues: runExecutor (copy), v348 (copy), v349 (copy), p114 (copy), p115 (copy)
				local v402, v403, v404 = runExecutor(v348, v349, ...)

				if v402 then
					p114(unpack(v404, 1, v403))

					return
				end

				p115(v404[1])
			end
		end

		if p113 then
			local v350 = v347

			function v347(...) -- line: 1514
				-- upvalues: p110 (copy), t6 (copy), p114 (copy), v350 (copy)
				if p110._status == t6.Status.Rejected then
					return p114(p110)
				end

				return v350(...)
			end
		end

		if p110._status == t6.Status.Started then
			table.insert(p110._queuedFinally, v347)

			return
		end

		v347(p110._status)
	end, p110)
end
function t6.prototype.finally(p116, p117) -- line: 1582
	local v165 = true
	local g166

	if p117 ~= nil then
		g166 = nil

		if type(p117) == "function" then
			v165 = true
			g166 = true
		end

		if not g166 then
			if type(p117) == "table" then
				local mt = getmetatable(p117)

				if mt and type((rawget(mt, "__call"))) == "function" then
					v165 = true
					g166 = true
				end
			end

			if not g166 then
				v165 = false
				g166 = true
			end
		end
	end

	g166 = false
	assert(v165, string.format("Please pass a handler function to %s!", "Promise:finally"))

	return p116:_finally(debug.traceback(nil, 2), p117)
end
function t6.prototype.finallyCall(p118, p119, ...) -- line: 1596
	-- upvalues: pack (copy)
	local g171 = nil
	local mt = nil
	local v170 = nil

	if type(p119) == "function" then
		v170 = true
		g171 = true
	end

	repeat
		if g171 or (g171 or type(p119) == "table") then
			if not g171 then
				if not g171 then
					mt = getmetatable(p119)
				end
			end

			if g171 or (g171 or mt and type((rawget(mt, "__call"))) == "function") then
				if not g171 then
					if not g171 then
						v170 = true
					end
				end

				g171 = false
				assert(v170, string.format("Please pass a handler function to %s!", "Promise:finallyCall"))

				local v173, v174 = pack(...)

				return p118:_finally(debug.traceback(nil, 2), function() -- line: 1599
					-- upvalues: p119 (copy), v174 (copy), v173 (copy)
					return p119(unpack(v174, 1, v173))
				end)
			end
		end

		v170 = false
		g171 = true
	until not g171
end
function t6.prototype.finallyReturn(p120, ...) -- line: 1622
	-- upvalues: pack (copy)
	local v176, v177 = pack(...)

	return p120:_finally(debug.traceback(nil, 2), function() -- line: 1624
		-- upvalues: v177 (copy), v176 (copy)
		return unpack(v177, 1, v176)
	end)
end
function t6.prototype.done(p121, p122) -- line: 1632
	local v180 = true
	local g181

	if p122 ~= nil then
		g181 = nil

		if type(p122) == "function" then
			v180 = true
			g181 = true
		end

		if not g181 then
			if type(p122) == "table" then
				local mt = getmetatable(p122)

				if mt and type((rawget(mt, "__call"))) == "function" then
					v180 = true
					g181 = true
				end
			end

			if not g181 then
				v180 = false
				g181 = true
			end
		end
	end

	g181 = false
	assert(v180, string.format("Please pass a handler function to %s!", "Promise:done"))

	return p121:_finally(debug.traceback(nil, 2), p122, true)
end
function t6.prototype.doneCall(p123, p124, ...) -- line: 1643
	-- upvalues: pack (copy)
	local g186 = nil
	local mt = nil
	local v185 = nil

	if type(p124) == "function" then
		v185 = true
		g186 = true
	end

	repeat
		if g186 or (g186 or type(p124) == "table") then
			if not g186 then
				if not g186 then
					mt = getmetatable(p124)
				end
			end

			if g186 or (g186 or mt and type((rawget(mt, "__call"))) == "function") then
				if not g186 then
					if not g186 then
						v185 = true
					end
				end

				g186 = false
				assert(v185, string.format("Please pass a handler function to %s!", "Promise:doneCall"))

				local v188, v189 = pack(...)

				return p123:_finally(debug.traceback(nil, 2), function() -- line: 1646
					-- upvalues: p124 (copy), v189 (copy), v188 (copy)
					return p124(unpack(v189, 1, v188))
				end, true)
			end
		end

		v185 = false
		g186 = true
	until not g186
end
function t6.prototype.doneReturn(p125, ...) -- line: 1654
	-- upvalues: pack (copy)
	local v191, v192 = pack(...)

	return p125:_finally(debug.traceback(nil, 2), function() -- line: 1656
		-- upvalues: v192 (copy), v191 (copy)
		return unpack(v192, 1, v191)
	end, true)
end
function t6.prototype.awaitStatus(p126) -- line: 1668
	-- upvalues: t6 (copy)
	p126._unhandledRejection = false

	if p126._status == t6.Status.Started then
		local thread = coroutine.running()

		p126:finally(function() -- line: 1674
			-- upvalues: thread (copy)
			task.spawn(thread)
		end)
		coroutine.yield()
	end

	if p126._status == t6.Status.Resolved then
		return p126._status, unpack(p126._values, 1, p126._valuesLength)
	end

	if p126._status == t6.Status.Rejected then
		return p126._status, unpack(p126._values, 1, p126._valuesLength)
	end

	return p126._status
end

local function awaitHelper(p127, ...) -- line: 1690
	-- upvalues: t6 (copy)
	return p127 == t6.Status.Resolved, ...
end

function t6.prototype.await(p128) -- line: 1715
	-- upvalues: awaitHelper (copy)
	return awaitHelper(p128:awaitStatus())
end

local function expectHelper(p129, ...) -- line: 1719
	-- upvalues: t6 (copy)
	if p129 ~= t6.Status.Resolved then
		error(if ... ~= nil then ... else "Expected Promise rejected with no value.", 3)
	end

	return ...
end

function t6.prototype.expect(p130) -- line: 1752
	-- upvalues: expectHelper (copy)
	return expectHelper(p130:awaitStatus())
end

t6.prototype.awaitValue = t6.prototype.expect

function t6.prototype._unwrap(p131) -- line: 1766
	-- upvalues: t6 (copy)
	if p131._status == t6.Status.Started then
		error("Promise has not resolved or rejected.", 2)
	end

	return p131._status == t6.Status.Resolved, unpack(p131._values, 1, p131._valuesLength)
end
function t6.prototype._resolve(p132, ...) -- line: 1776
	-- upvalues: t6 (copy), t3 (ref), pack (copy)
	if p132._status ~= t6.Status.Started then
		if t6.is((...)) then
			(...):_consumerCancelled(p132)
		end

		return
	end

	if t6.is((...)) then
		if select("#", ...) > 1 then
			local v201 = string.format("When returning a Promise from andThen, extra arguments are discarded! See:\n\n%s", p132._source)

			warn(v201)
		end

		local v202 = ...
		local v203 = v202:andThen(function(...) -- line: 1797
			-- upvalues: p132 (copy)
			p132:_resolve(...)
		end, function(...) -- line: 1799
			-- upvalues: v202 (copy), t3 (ref), p132 (copy)
			local v351 = v202._values[1]

			if v202._error then
				v351 = t3.new({
					context = "[No stack trace available as this Promise originated from an older version of the Promise library (< v2)]",
					error = v202._error,
					kind = t3.Kind.ExecutionError
				})
			end

			if t3.isKind(v351, t3.Kind.ExecutionError) then
				return p132:_reject(v351:extend({
					error = "This Promise was chained to a Promise that errored.",
					trace = "",
					context = string.format("The Promise at:\n\n%s\n...Rejected because it was chained to the following Promise, which encountered an error:\n", p132._source)
				}))
			end

			p132:_reject(...)
		end)

		if v203._status == t6.Status.Cancelled then
			p132:cancel()

			return
		end

		if v203._status == t6.Status.Started then
			p132._parent = v203
			v203._consumers[p132] = true
		end

		return
	end

	p132._status = t6.Status.Resolved

	local v204, v205 = pack(...)

	p132._valuesLength = v204
	p132._values = v205

	for _, v in ipairs(p132._queuedResolve) do
		coroutine.wrap(v)(...)
	end

	p132:_finalize()
end
function t6.prototype._reject(p133, ...) -- line: 1847
	-- upvalues: t6 (copy), pack (copy)
	if p133._status ~= t6.Status.Started then
		return
	end

	p133._status = t6.Status.Rejected

	local v209, v210 = pack(...)

	p133._valuesLength = v209
	p133._values = v210

	local _queuedReject = p133._queuedReject

	if next(_queuedReject) ~= nil then
		for _, v in ipairs(p133._queuedReject) do
			coroutine.wrap(v)(...)
		end
	else
		local str = tostring((...))

		coroutine.wrap(function() -- line: 1869
			-- upvalues: t6 (copy), p133 (copy), str (copy)
			t6._timeEvent:Wait()

			if not p133._unhandledRejection then
				return
			end

			local v352 = string.format("Unhandled Promise rejection:\n\n%s\n\n%s", str, p133._source)

			for _, v in ipairs(t6._unhandledRejectionCallbacks) do
				task.spawn(v, p133, unpack(p133._values, 1, p133._valuesLength))
			end

			if t6.TEST then
				return
			end

			warn(v352)
		end)()
	end

	p133:_finalize()
end
function t6.prototype._finalize(p134) -- line: 1901
	-- upvalues: t6 (copy)
	for _, v in ipairs(p134._queuedFinally) do
		coroutine.wrap(v)(p134._status)
	end

	p134._queuedFinally = nil
	p134._queuedReject = nil
	p134._queuedResolve = nil

	if not t6.TEST then
		p134._parent = nil
		p134._consumers = nil
	end

	task.defer(coroutine.close, p134._thread)
end
function t6.prototype.now(p135, p136) -- line: 1938
	-- upvalues: t6 (copy), t3 (ref)
	local trace = debug.traceback(nil, 2)

	if p135._status == t6.Status.Resolved then
		return p135:_andThen(trace, function(...) -- line: 1941
			return ...
		end)
	end

	return t6.reject(p136 == nil and t3.new({
		error = "This Promise was not resolved in time for :now()",
		kind = t3.Kind.NotResolvedInTime,
		context = ":now() was called at:\n\n" .. trace
	}) or p136)
end
function t6.retry(p137, p138, ...) -- line: 1983
	-- upvalues: t6 (copy)
	local g224 = nil
	local mt = nil
	local v223 = nil

	if type(p137) == "function" then
		v223 = true
		g224 = true
	end

	repeat
		if g224 or (g224 or type(p137) == "table") then
			if not g224 then
				if not g224 then
					mt = getmetatable(p137)
				end
			end

			if g224 or (g224 or mt and type((rawget(mt, "__call"))) == "function") then
				if not g224 then
					if not g224 then
						v223 = true
					end
				end

				g224 = false
				assert(v223, "Parameter #1 to Promise.retry must be a function")
				assert(type(p138) == "number", "Parameter #2 to Promise.retry must be a number")

				local t18 = { ... }
				local v227 = select("#", ...)

				return t6.resolve(p137(...)):catch(function(...) -- line: 1989
					-- upvalues: p138 (copy), t6 (copy), p137 (copy), t18 (copy), v227 (copy)
					if p138 > 0 then
						return t6.retry(p137, p138 - 1, unpack(t18, 1, v227))
					end

					return t6.reject(...)
				end)
			end
		end

		v223 = false
		g224 = true
	until not g224
end
function t6.retryWithDelay(p139, p140, p141, ...) -- line: 2011
	-- upvalues: t6 (copy)
	local g232 = nil
	local mt = nil
	local v231 = nil

	if type(p139) == "function" then
		v231 = true
		g232 = true
	end

	repeat
		if g232 or (g232 or type(p139) == "table") then
			if not g232 then
				if not g232 then
					mt = getmetatable(p139)
				end
			end

			if g232 or (g232 or mt and type((rawget(mt, "__call"))) == "function") then
				if not g232 then
					if not g232 then
						v231 = true
					end
				end

				g232 = false
				assert(v231, "Parameter #1 to Promise.retry must be a function")
				assert(type(p140) == "number", "Parameter #2 (times) to Promise.retry must be a number")
				assert(type(p141) == "number", "Parameter #3 (seconds) to Promise.retry must be a number")

				local t19 = { ... }
				local v235 = select("#", ...)

				return t6.resolve(p139(...)):catch(function(...) -- line: 2018
					-- upvalues: p140 (copy), t6 (copy), p141 (copy), p139 (copy), t19 (copy), v235 (copy)
					if p140 > 0 then
						t6.delay(p141):await()

						return t6.retryWithDelay(p139, p140 - 1, p141, unpack(t19, 1, v235))
					end

					return t6.reject(...)
				end)
			end
		end

		v231 = false
		g232 = true
	until not g232
end
function t6.fromEvent(p142, p143) -- line: 2053
	-- upvalues: t6 (copy)
	local u238 = p143 or function() -- line: 2054
		return true
	end

	return t6._new(debug.traceback(nil, 2), function(p144, _, p146) -- line: 2058
		-- upvalues: p142 (copy), u238 (ref)
		local u358 = nil
		local u359 = false

		local function disconnect() -- line: 2062
			-- upvalues: u358 (ref)
			u358:Disconnect()
			u358 = nil
		end

		u358 = p142:Connect(function(...) -- line: 2071
			-- upvalues: u238 (ref), p144 (copy), u358 (ref), u359 (ref)
			local v405 = u238(...)

			if v405 == true then
				p144(...)

				if u358 then
					u358:Disconnect()
					u358 = nil

					return
				end

				u359 = true

				return
			end

			if type(v405) ~= "boolean" then
				error("Promise.fromEvent predicate should always return a boolean")
			end
		end)

		if u359 and u358 then
			return disconnect()
		end

		p146(disconnect)
	end)
end
function t6.onUnhandledRejection(p147) -- line: 2105
	-- upvalues: t6 (copy)
	table.insert(t6._unhandledRejectionCallbacks, p147)

	return function() -- line: 2108
		-- upvalues: t6 (copy), p147 (copy)
		local v361 = table.find(t6._unhandledRejectionCallbacks, p147)

		if v361 then
			table.remove(t6._unhandledRejectionCallbacks, v361)
		end
	end
end

return t6
