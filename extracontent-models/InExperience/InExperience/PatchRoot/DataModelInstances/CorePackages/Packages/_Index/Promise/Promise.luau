local t1 = {
	__mode = "k"
}
local ok, result = pcall(game.DefineFastFlag, game, "ReducePromiseTaskDefer", false)

if not ok then
	result = false
end

local function isCallable(p1) -- line: 16
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
local function makeEnum(p2, p3) -- line: 34
	local t2 = {}

	for _, v in ipairs(p3) do
		t2[v] = v
	end

	return (setmetatable(t2, {
		__index = function(_, p5) -- line: 42
			-- upvalues: p2 (copy)
			error(string.format("%s is not in %s!", p5, p2), 2)
		end,
		__newindex = function() -- line: 45
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

function t3.new(p6, p7) -- line: 70
	-- upvalues: t3 (ref)
	local v30 = p6 or {}

	return (setmetatable({
		error = tostring(v30.error) or "[This error has no error text.]",
		trace = v30.trace,
		context = v30.context,
		kind = v30.kind,
		parent = p7,
		createdTick = os.clock(),
		createdTrace = debug.traceback()
	}, t3))
end
function t3.is(p8) -- line: 83
	if type(p8) == "table" then
		local mt = getmetatable(p8)

		if type(mt) == "table" then
			return rawget(p8, "error") ~= nil and type((rawget(mt, "extend"))) == "function"
		end
	end

	return false
end
function t3.isKind(p9, p10) -- line: 95
	-- upvalues: t3 (ref)
	assert(p10 ~= nil, "Argument #2 to Promise.Error.isKind must not be nil")

	return t3.is(p9) and p10 == p9.kind
end
function t3.extend(p11, p12) -- line: 101
	-- upvalues: t3 (ref)
	local v37 = p12 or {}

	v37.kind = v37.kind or p11.kind

	return t3.new(v37, p11)
end
function t3.getErrorChain(p13) -- line: 109
	local t4 = { p13 }

	while t4[#t4].parent do
		table.insert(t4, t4[#t4].parent)
	end

	return t4
end
function t3.__tostring(p14) -- line: 119
	local t5 = { string.format("-- Promise.Error(%s) --", p14.kind or "?") }

	for _, v in ipairs(p14:getErrorChain()) do
		table.insert(t5, table.concat({
			v.trace or v.error,
			v.context
		}, "\n"))
	end

	return table.concat(t5, "\n")
end

local function pack(...) -- line: 143
	return select("#", ...), { ... }
end
local function packResult(p15, ...) -- line: 150
	return p15, select("#", ...), { ... }
end
local function makeErrorHandler(p16) -- line: 154
	-- upvalues: t3 (ref)
	assert(p16 ~= nil, "traceback is nil")

	return function(p17) -- line: 157
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
local function runExecutor(p18, p19, ...) -- line: 177
	-- upvalues: packResult (copy), t3 (ref)
	local v48 = packResult
	local _xpcall = xpcall

	assert(p18 ~= nil, "traceback is nil")

	return v48(_xpcall(p19, function(p20) -- line: 157
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
local function createAdvancer(p21, p22, p23, p24) -- line: 185
	-- upvalues: runExecutor (copy)
	return function(...) -- line: 186
		-- upvalues: runExecutor (copy), p21 (copy), p22 (copy), p23 (copy), p24 (copy)
		local v252, v253, v254 = runExecutor(p21, p22, ...)

		if v252 then
			p23(unpack(v254, 1, v253))

			return
		end

		p24(v254[1])
	end
end
local function isEmpty(p25) -- line: 197
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

function t6._new(p26, p27, p28) -- line: 236
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

	local function resolve(...) -- line: 284
		-- upvalues: t7 (copy)
		t7:_resolve(...)
	end
	local function reject(...) -- line: 288
		-- upvalues: t7 (copy)
		t7:_reject(...)
	end
	local function onCancel(p29) -- line: 292
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

	t7._thread = coroutine.create(function() -- line: 304
		-- upvalues: runExecutor (copy), t7 (copy), p27 (copy), resolve (copy), reject (copy), onCancel (copy)
		local v256, _, v258 = runExecutor(t7._source, p27, resolve, reject, onCancel)

		if not v256 then
			reject(v258[1])
		end
	end)
	task.spawn(t7._thread)

	return t7
end
function t6.new(p30) -- line: 355
	-- upvalues: t6 (copy)
	return t6._new(debug.traceback(nil, 2), p30)
end
function t6.__tostring(p31) -- line: 359
	return string.format("Promise(%s)", p31._status)
end
function t6.defer(p32) -- line: 381
	-- upvalues: t6 (copy), runExecutor (copy)
	local trace = debug.traceback(nil, 2)

	return (t6._new(trace, function(p33, p34, p35) -- line: 384
		-- upvalues: t6 (copy), runExecutor (copy), trace (copy), p32 (copy)
		local connection = nil

		connection = t6._timeEvent:Connect(function() -- line: 386
			-- upvalues: connection (ref), runExecutor (copy), trace (copy), p32 (copy), p33 (copy), p34 (copy), p35 (copy)
			connection:Disconnect()

			local v370, _, v372 = runExecutor(trace, p32, p33, p34, p35)

			if not v370 then
				p34(v372[1])
			end
		end)
	end))
end

t6.async = t6.defer

function t6.resolve(...) -- line: 424
	-- upvalues: pack (copy), t6 (copy)
	local v66, v67 = pack(...)

	return t6._new(debug.traceback(nil, 2), function(p36) -- line: 426
		-- upvalues: v67 (copy), v66 (copy)
		p36(unpack(v67, 1, v66))
	end)
end
function t6.reject(...) -- line: 441
	-- upvalues: pack (copy), t6 (copy)
	local v68, v69 = pack(...)

	return t6._new(debug.traceback(nil, 2), function(_, p38) -- line: 443
		-- upvalues: v69 (copy), v68 (copy)
		p38(unpack(v69, 1, v68))
	end)
end
function t6._try(p39, p40, ...) -- line: 452
	-- upvalues: pack (copy), t6 (copy)
	local v72, v73 = pack(...)

	return t6._new(p39, function(p41) -- line: 455
		-- upvalues: p40 (copy), v73 (copy), v72 (copy)
		p41(p40(unpack(v73, 1, v72)))
	end)
end
function t6.try(p42, ...) -- line: 483
	-- upvalues: t6 (copy)
	return t6._try(debug.traceback(nil, 2), p42, ...)
end
function t6._all(p43, p44, p45) -- line: 492
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

	return t6._new(p43, function(p46, p47, p48) -- line: 510
		-- upvalues: p45 (copy), p44 (copy)
		local t8 = {}
		local t9 = {}
		local n1 = 0
		local n2 = 0
		local u274 = false

		local function cancel() -- line: 521
			-- upvalues: t9 (copy)
			for _, v in ipairs(t9) do
				v:cancel()
			end
		end
		local function resolveOne(p49, ...) -- line: 528
			-- upvalues: u274 (ref), n1 (ref), p45 (copy), t8 (copy), p44 (copy), p46 (copy), t9 (copy)
			if u274 then
				return
			end

			n1 += 1

			if p45 == nil then
				t8[p49] = ...
			else
				t8[n1] = ...
			end

			if n1 >= (p45 or #p44) then
				u274 = true
				p46(t8)

				for _, v in ipairs(t9) do
					v:cancel()
				end
			end
		end

		p48(cancel)

		for i, v in ipairs(p44) do
			t9[i] = v:andThen(function(...) -- line: 553
				-- upvalues: resolveOne (copy), i (copy)
				resolveOne(i, ...)
			end, function(...) -- line: 555
				-- upvalues: n2 (ref), p45 (copy), p44 (copy), t9 (copy), u274 (ref), p47 (copy)
				n2 += 1

				if p45 == nil or #p44 - n2 < p45 then
					for _, v2 in ipairs(t9) do
						v2:cancel()
					end

					u274 = true
					p47(...)
				end
			end)
		end

		if u274 then
			for _, v in ipairs(t9) do
				v:cancel()
			end
		end
	end)
end
function t6.all(...) -- line: 597
	-- upvalues: t6 (copy)
	local t10 = { ... }

	if type(t10[1]) == "table" and not t6.is(t10[1]) then
		t10 = t10[1]
	end

	return t6._all(debug.traceback(nil, 2), t10)
end
function t6.fold(p50, p51, p52) -- line: 634
	-- upvalues: t6 (copy)
	assert(type(p50) == "table", "Bad argument #1 to Promise.fold: must be a table")

	local g85 = nil
	local mt = nil
	local v84 = nil

	if type(p51) == "function" then
		v84 = true
		g85 = true
	end

	repeat
		if g85 or (g85 or type(p51) == "table") then
			if not g85 then
				if not g85 then
					mt = getmetatable(p51)
				end
			end

			if g85 or (g85 or mt and type((rawget(mt, "__call"))) == "function") then
				if not g85 then
					if not g85 then
						v84 = true
					end
				end

				g85 = false
				assert(v84, "Bad argument #2 to Promise.fold: must be a function")

				local u87 = t6.resolve(p52)

				return t6.each(p50, function(p53, p54) -- line: 639
					-- upvalues: u87 (ref), p51 (copy)
					u87 = u87:andThen(function(p55) -- line: 640
						-- upvalues: p51 (copy), p53 (copy), p54 (copy)
						return p51(p55, p53, p54)
					end)
				end):andThen(function() -- line: 643
					-- upvalues: u87 (ref)
					return u87
				end)
			end
		end

		v84 = false
		g85 = true
	until not g85
end
function t6.some(p56, p57) -- line: 667
	-- upvalues: t6 (copy)
	assert(type(p57) == "number", "Bad argument #2 to Promise.some: must be a number")

	return t6._all(debug.traceback(nil, 2), p56, p57)
end
function t6.any(p58) -- line: 691
	-- upvalues: t6 (copy)
	return t6._all(debug.traceback(nil, 2), p58, 1):andThen(function(p59) -- line: 692
		return p59[1]
	end)
end
function t6.allSettled(p60) -- line: 713
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

	return t6._new(debug.traceback(nil, 2), function(p61, _, p63) -- line: 731
		-- upvalues: p60 (copy)
		local t11 = {}
		local t12 = {}
		local n3 = 0

		local function resolveOne(p64, ...) -- line: 741
			-- upvalues: n3 (ref), t11 (copy), p60 (copy), p61 (copy)
			n3 += 1
			t11[p64] = ...

			if n3 >= #p60 then
				p61(t11)
			end
		end

		p63(function() -- line: 751
			-- upvalues: t12 (copy)
			for _, v in ipairs(t12) do
				v:cancel()
			end
		end)

		for i, v in ipairs(p60) do
			t12[i] = v:finally(function(...) -- line: 760
				-- upvalues: resolveOne (copy), i (copy)
				resolveOne(i, ...)
			end)
		end
	end)
end
function t6.race(p65) -- line: 791
	-- upvalues: t6 (copy)
	assert(type(p65) == "table", string.format("Please pass a list of promises to %s", "Promise.race"))

	for k, v in pairs(p65) do
		assert(t6.is(v), string.format("Non-promise value passed into %s at index %s", "Promise.race", (tostring(k))))
	end

	return t6._new(debug.traceback(nil, 2), function(p66, p67, p68) -- line: 798
		-- upvalues: p65 (copy)
		local t13 = {}
		local u297 = false

		local function cancel() -- line: 802
			-- upvalues: t13 (copy)
			for _, v in ipairs(t13) do
				v:cancel()
			end
		end
		local function finalize(p69) -- line: 808
			-- upvalues: t13 (copy), u297 (ref)
			return function(...) -- line: 809
				-- upvalues: t13 (copy), u297 (ref), p69 (copy)
				for _, v in ipairs(t13) do
					v:cancel()
				end

				u297 = true

				return p69(...)
			end
		end

		if p68(function(...) -- line: 809
			-- upvalues: t13 (copy), u297 (ref), p67 (copy)
			for _, v in ipairs(t13) do
				v:cancel()
			end

			u297 = true

			return p67(...)
		end) then
			return
		end

		for i, v in ipairs(p65) do
			t13[i] = v:andThen(function(...) -- line: 809
				-- upvalues: t13 (copy), u297 (ref), p66 (copy)
				for _, v3 in ipairs(t13) do
					v3:cancel()
				end

				u297 = true

				return p66(...)
			end, function(...) -- line: 809
				-- upvalues: t13 (copy), u297 (ref), p67 (copy)
				for _, v4 in ipairs(t13) do
					v4:cancel()
				end

				u297 = true

				return p67(...)
			end)
		end

		if u297 then
			for _, v in ipairs(t13) do
				v:cancel()
			end
		end
	end)
end
function t6.each(p70, p71) -- line: 886
	-- upvalues: t6 (copy), t3 (ref)
	assert(type(p70) == "table", string.format("Please pass a list of promises to %s", "Promise.each"))

	local g100 = nil
	local mt = nil
	local v99 = nil

	if type(p71) == "function" then
		v99 = true
		g100 = true
	end

	repeat
		if g100 or (g100 or type(p71) == "table") then
			if not g100 then
				if not g100 then
					mt = getmetatable(p71)
				end
			end

			if g100 or (g100 or mt and type((rawget(mt, "__call"))) == "function") then
				if not g100 then
					if not g100 then
						v99 = true
					end
				end

				g100 = false
				assert(v99, string.format("Please pass a handler function to %s!", "Promise.each"))

				return t6._new(debug.traceback(nil, 2), function(p72, p73, p74) -- line: 890
					-- upvalues: p70 (copy), t6 (copy), t3 (ref), p71 (copy)
					local t14 = {}
					local t15 = {}
					local u309 = false

					local function cancel() -- line: 896
						-- upvalues: t15 (copy)
						for _, v in ipairs(t15) do
							v:cancel()
						end
					end

					p74(function() -- line: 902
						-- upvalues: u309 (ref), t15 (copy)
						u309 = true

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

							local v318 = v:andThen(function(...) -- line: 935
								return ...
							end)

							table.insert(t15, v318)
							t16[i] = v318

							continue
						end

						t16[i] = v
					end

					for i, v in ipairs(t16) do
						local v321 = v

						if t6.is(v321) then
							local v322

							v322, v321 = v321:await()

							if not v322 then
								for _, v7 in ipairs(t15) do
									v7:cancel()
								end

								return p73(v321)
							end
						end

						if u309 then
							return
						end

						local v325 = t6.resolve(p71(v321, i))

						table.insert(t15, v325)

						local v326, v327 = v325:await()

						if not v326 then
							for _, v8 in ipairs(t15) do
								v8:cancel()
							end

							return p73(v327)
						end

						t14[i] = v327
					end

					p72(t14)
				end)
			end
		end

		v99 = false
		g100 = true
	until not g100
end
function t6.is(p75) -- line: 985
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

	local v106 = rawget(rawget(mt, "__index"), "andThen")
	local g108 = nil
	local mt3 = nil
	local v107 = nil

	if type(v106) == "function" then
		v107 = true
		g108 = true
	end

	repeat
		if g108 or (g108 or type(v106) == "table") then
			if not g108 then
				if not g108 then
					mt3 = getmetatable(v106)
				end
			end

			if g108 or (g108 or mt3 and type((rawget(mt3, "__call"))) == "function") then
				if not g108 then
					if not g108 then
						v107 = true
					end
				end

				g108 = false

				if v107 then
					return true
				end

				return false
			end
		end

		v107 = false
		g108 = true
	until not g108
end
function t6.promisify(p76) -- line: 1034
	-- upvalues: t6 (copy)
	return function(...) -- line: 1035
		-- upvalues: t6 (copy), p76 (copy)
		return t6._try(debug.traceback(nil, 2), p76, ...)
	end
end

local u14 = nil
local u15 = nil

function t6.delay(p77) -- line: 1065
	-- upvalues: t6 (copy), u15 (ref), u14 (ref)
	assert(type(p77) == "number", "Bad argument #1 to Promise.delay, must be a number.")

	if not (p77 >= 0.016666666666666666) or p77 == 1e999 then
		p77 = 0.016666666666666666
	end

	return t6._new(debug.traceback(nil, 2), function(p78, _, p80) -- line: 1073
		-- upvalues: t6 (copy), p77 (ref), u15 (ref), u14 (ref)
		local v333 = t6._getTime()
		local v334 = v333 + p77
		local t17 = {
			resolve = p78,
			startTime = v333,
			endTime = v334
		}

		if u15 == nil then
			u14 = t17
			u15 = t6._timeEvent:Connect(function() -- line: 1085
				-- upvalues: t6 (copy), u14 (ref), u15 (ref)
				local v397 = t6._getTime()

				while u14 ~= nil and v397 > u14.endTime do
					local v398 = u14

					u14 = v398.next

					if u14 == nil then
						u15:Disconnect()
						u15 = nil
					else
						u14.previous = nil
					end

					v398.resolve(t6._getTime() - v398.startTime)
				end
			end)
		elseif v334 > u14.endTime then
			local v336 = u14
			local next2 = v336.next

			while next2 ~= nil and v334 > next2.endTime do
				v336 = next2
				next2 = v336.next
			end

			v336.next = t17
			t17.previous = v336

			if next2 ~= nil then
				t17.next = next2
				next2.previous = t17
			end
		else
			t17.next = u14
			u14.previous = t17
			u14 = t17
		end

		p80(function() -- line: 1130
			-- upvalues: t17 (copy), u14 (ref), u15 (ref)
			local next3 = t17.next

			if u14 == t17 then
				if next3 == nil then
					u15:Disconnect()
					u15 = nil
				else
					next3.previous = nil
				end

				u14 = next3

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
function t6.prototype.timeout(p81, p82, p83) -- line: 1194
	-- upvalues: t6 (copy), t3 (ref)
	local trace = debug.traceback(nil, 2)

	return t6.race({
		t6.delay(p82):andThen(function() -- line: 1198
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
function t6.prototype.getStatus(p84) -- line: 1218
	return p84._status
end
function t6.prototype._andThen(p85, p86, p87, p88) -- line: 1227
	-- upvalues: t6 (copy), runExecutor (copy), t3 (ref)
	p85._unhandledRejection = false

	return t6._new(p86, function(p89, p90) -- line: 1231
		-- upvalues: p87 (copy), p86 (copy), runExecutor (copy), p88 (copy), p85 (copy), t6 (copy), t3 (ref)
		local v340 = p89

		if p87 then
			local v341 = p86
			local v342 = p87

			function v340(...) -- line: 186
				-- upvalues: runExecutor (copy), v341 (copy), v342 (copy), p89 (copy), p90 (copy)
				local v401, v402, v403 = runExecutor(v341, v342, ...)

				if v401 then
					p89(unpack(v403, 1, v402))

					return
				end

				p90(v403[1])
			end
		end

		local v343 = p90

		if p88 then
			local v344 = p86
			local v345 = p88

			function v343(...) -- line: 186
				-- upvalues: runExecutor (copy), v344 (copy), v345 (copy), p89 (copy), p90 (copy)
				local v404, v405, v406 = runExecutor(v344, v345, ...)

				if v404 then
					p89(unpack(v406, 1, v405))

					return
				end

				p90(v406[1])
			end
		end

		if p85._status == t6.Status.Started then
			table.insert(p85._queuedResolve, v340)
			table.insert(p85._queuedReject, v343)

			return
		end

		if p85._status == t6.Status.Resolved then
			v340(unpack(p85._values, 1, p85._valuesLength))

			return
		end

		if p85._status == t6.Status.Rejected then
			v343(unpack(p85._values, 1, p85._valuesLength))

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
function t6.prototype.andThen(p91, p92, p93) -- line: 1288
	local v125 = true
	local g129 = nil
	local g126

	if p92 ~= nil then
		g126 = nil

		if type(p92) == "function" then
			v125 = true
			g126 = true
		end

		if not g126 then
			if type(p92) == "table" then
				local mt = getmetatable(p92)

				if mt and type((rawget(mt, "__call"))) == "function" then
					v125 = true
					g126 = true
				end
			end

			if not g126 then
				v125 = false
				g126 = true
			end
		end
	end

	g126 = false
	assert(v125, string.format("Please pass a handler function to %s!", "Promise:andThen"))

	local v128 = true

	if p93 ~= nil then
		if type(p93) == "function" then
			v128 = true
			g129 = true
		end

		if not g129 then
			if type(p93) == "table" then
				local mt = getmetatable(p93)

				if mt and type((rawget(mt, "__call"))) == "function" then
					v128 = true
					g129 = true
				end
			end

			if not g129 then
				v128 = false
				g129 = true
			end
		end
	end

	g129 = false
	assert(v128, string.format("Please pass a handler function to %s!", "Promise:andThen"))

	return p91:_andThen(debug.traceback(nil, 2), p92, p93)
end
function t6.prototype.andThenAsync(p94, p95, p96) -- line: 1316
	-- upvalues: pack (copy), t6 (copy)
	local v134 = true
	local g138 = nil
	local g135

	if p95 ~= nil then
		g135 = nil

		if type(p95) == "function" then
			v134 = true
			g135 = true
		end

		if not g135 then
			if type(p95) == "table" then
				local mt = getmetatable(p95)

				if mt and type((rawget(mt, "__call"))) == "function" then
					v134 = true
					g135 = true
				end
			end

			if not g135 then
				v134 = false
				g135 = true
			end
		end
	end

	g135 = false
	assert(v134, string.format("Please pass a handler function to %s!", "Promise:andThenAsync"))

	local v137 = true

	if p96 ~= nil then
		if type(p96) == "function" then
			v137 = true
			g138 = true
		end

		if not g138 then
			if type(p96) == "table" then
				local mt = getmetatable(p96)

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
	assert(v137, string.format("Please pass a handler function to %s!", "Promise:andThenAsync"))

	return p94:_andThen(debug.traceback(nil, 2), function(...) -- line: 1323
		-- upvalues: pack (copy), t6 (copy)
		local v346, v347 = pack(...)

		return t6.defer(function(p97) -- line: 1325
			-- upvalues: v347 (copy), v346 (copy)
			p97(unpack(v347, 1, v346))
		end)
	end, function(...) -- line: 1329
		-- upvalues: pack (copy), t6 (copy)
		local v348, v349 = pack(...)

		return t6.defer(function(_, p99) -- line: 1331
			-- upvalues: v349 (copy), v348 (copy)
			p99(unpack(v349, 1, v348))
		end)
	end):andThen(p95, p96)
end
function t6.prototype.catch(p100, p101) -- line: 1358
	local v142 = true
	local g143

	if p101 ~= nil then
		g143 = nil

		if type(p101) == "function" then
			v142 = true
			g143 = true
		end

		if not g143 then
			if type(p101) == "table" then
				local mt = getmetatable(p101)

				if mt and type((rawget(mt, "__call"))) == "function" then
					v142 = true
					g143 = true
				end
			end

			if not g143 then
				v142 = false
				g143 = true
			end
		end
	end

	g143 = false
	assert(v142, string.format("Please pass a handler function to %s!", "Promise:catch"))

	return p100:_andThen(debug.traceback(nil, 2), nil, p101)
end
function t6.prototype.tap(p102, p103) -- line: 1379
	-- upvalues: t6 (copy), pack (copy)
	local g148 = nil
	local mt = nil
	local v147 = nil

	if type(p103) == "function" then
		v147 = true
		g148 = true
	end

	repeat
		if g148 or (g148 or type(p103) == "table") then
			if not g148 then
				if not g148 then
					mt = getmetatable(p103)
				end
			end

			if g148 or (g148 or mt and type((rawget(mt, "__call"))) == "function") then
				if not g148 then
					if not g148 then
						v147 = true
					end
				end

				g148 = false
				assert(v147, string.format("Please pass a handler function to %s!", "Promise:tap"))

				return p102:_andThen(debug.traceback(nil, 2), function(...) -- line: 1381
					-- upvalues: p103 (copy), t6 (copy), pack (copy)
					local v350 = p103(...)

					if t6.is(v350) then
						local v351, v352 = pack(...)

						return v350:andThen(function() -- line: 1386
							-- upvalues: v352 (copy), v351 (copy)
							return unpack(v352, 1, v351)
						end)
					end

					return ...
				end)
			end
		end

		v147 = false
		g148 = true
	until not g148
end
function t6.prototype.andThenCall(p104, p105, ...) -- line: 1414
	-- upvalues: pack (copy)
	local g153 = nil
	local mt = nil
	local v152 = nil

	if type(p105) == "function" then
		v152 = true
		g153 = true
	end

	repeat
		if g153 or (g153 or type(p105) == "table") then
			if not g153 then
				if not g153 then
					mt = getmetatable(p105)
				end
			end

			if g153 or (g153 or mt and type((rawget(mt, "__call"))) == "function") then
				if not g153 then
					if not g153 then
						v152 = true
					end
				end

				g153 = false
				assert(v152, string.format("Please pass a handler function to %s!", "Promise:andThenCall"))

				local v155, v156 = pack(...)

				return p104:_andThen(debug.traceback(nil, 2), function() -- line: 1417
					-- upvalues: p105 (copy), v156 (copy), v155 (copy)
					return p105(unpack(v156, 1, v155))
				end)
			end
		end

		v152 = false
		g153 = true
	until not g153
end
function t6.prototype.andThenReturn(p106, ...) -- line: 1444
	-- upvalues: pack (copy)
	local v158, v159 = pack(...)

	return p106:_andThen(debug.traceback(nil, 2), function() -- line: 1446
		-- upvalues: v159 (copy), v158 (copy)
		return unpack(v159, 1, v158)
	end)
end
function t6.prototype.cancel(p107) -- line: 1462
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
function t6.prototype._consumerCancelled(p108, p109) -- line: 1490
	-- upvalues: t6 (copy)
	if p108._status ~= t6.Status.Started then
		return
	end

	p108._consumers[p109] = nil

	if next(p108._consumers) == nil then
		p108:cancel()
	end
end
function t6.prototype._finally(p110, p111, p112, p113) -- line: 1506
	-- upvalues: t6 (copy), runExecutor (copy)
	if not p113 then
		p110._unhandledRejection = false
	end

	return t6._new(p111, function(p114, p115) -- line: 1512
		-- upvalues: p112 (copy), p111 (copy), runExecutor (copy), p113 (copy), p110 (copy), t6 (copy)
		local v355 = p114

		if p112 then
			local v356 = p111
			local v357 = p112

			function v355(...) -- line: 186
				-- upvalues: runExecutor (copy), v356 (copy), v357 (copy), p114 (copy), p115 (copy)
				local v410, v411, v412 = runExecutor(v356, v357, ...)

				if v410 then
					p114(unpack(v412, 1, v411))

					return
				end

				p115(v412[1])
			end
		end

		if p113 then
			local v358 = v355

			function v355(...) -- line: 1520
				-- upvalues: p110 (copy), t6 (copy), p114 (copy), v358 (copy)
				if p110._status == t6.Status.Rejected then
					return p114(p110)
				end

				return v358(...)
			end
		end

		if p110._status == t6.Status.Started then
			table.insert(p110._queuedFinally, v355)

			return
		end

		v355(p110._status)
	end, p110)
end
function t6.prototype.finally(p116, p117) -- line: 1588
	local v170 = true
	local g171

	if p117 ~= nil then
		g171 = nil

		if type(p117) == "function" then
			v170 = true
			g171 = true
		end

		if not g171 then
			if type(p117) == "table" then
				local mt = getmetatable(p117)

				if mt and type((rawget(mt, "__call"))) == "function" then
					v170 = true
					g171 = true
				end
			end

			if not g171 then
				v170 = false
				g171 = true
			end
		end
	end

	g171 = false
	assert(v170, string.format("Please pass a handler function to %s!", "Promise:finally"))

	return p116:_finally(debug.traceback(nil, 2), p117)
end
function t6.prototype.finallyCall(p118, p119, ...) -- line: 1602
	-- upvalues: pack (copy)
	local g176 = nil
	local mt = nil
	local v175 = nil

	if type(p119) == "function" then
		v175 = true
		g176 = true
	end

	repeat
		if g176 or (g176 or type(p119) == "table") then
			if not g176 then
				if not g176 then
					mt = getmetatable(p119)
				end
			end

			if g176 or (g176 or mt and type((rawget(mt, "__call"))) == "function") then
				if not g176 then
					if not g176 then
						v175 = true
					end
				end

				g176 = false
				assert(v175, string.format("Please pass a handler function to %s!", "Promise:finallyCall"))

				local v178, v179 = pack(...)

				return p118:_finally(debug.traceback(nil, 2), function() -- line: 1605
					-- upvalues: p119 (copy), v179 (copy), v178 (copy)
					return p119(unpack(v179, 1, v178))
				end)
			end
		end

		v175 = false
		g176 = true
	until not g176
end
function t6.prototype.finallyReturn(p120, ...) -- line: 1628
	-- upvalues: pack (copy)
	local v181, v182 = pack(...)

	return p120:_finally(debug.traceback(nil, 2), function() -- line: 1630
		-- upvalues: v182 (copy), v181 (copy)
		return unpack(v182, 1, v181)
	end)
end
function t6.prototype.done(p121, p122) -- line: 1638
	local v185 = true
	local g186

	if p122 ~= nil then
		g186 = nil

		if type(p122) == "function" then
			v185 = true
			g186 = true
		end

		if not g186 then
			if type(p122) == "table" then
				local mt = getmetatable(p122)

				if mt and type((rawget(mt, "__call"))) == "function" then
					v185 = true
					g186 = true
				end
			end

			if not g186 then
				v185 = false
				g186 = true
			end
		end
	end

	g186 = false
	assert(v185, string.format("Please pass a handler function to %s!", "Promise:done"))

	return p121:_finally(debug.traceback(nil, 2), p122, true)
end
function t6.prototype.doneCall(p123, p124, ...) -- line: 1649
	-- upvalues: pack (copy)
	local g191 = nil
	local mt = nil
	local v190 = nil

	if type(p124) == "function" then
		v190 = true
		g191 = true
	end

	repeat
		if g191 or (g191 or type(p124) == "table") then
			if not g191 then
				if not g191 then
					mt = getmetatable(p124)
				end
			end

			if g191 or (g191 or mt and type((rawget(mt, "__call"))) == "function") then
				if not g191 then
					if not g191 then
						v190 = true
					end
				end

				g191 = false
				assert(v190, string.format("Please pass a handler function to %s!", "Promise:doneCall"))

				local v193, v194 = pack(...)

				return p123:_finally(debug.traceback(nil, 2), function() -- line: 1652
					-- upvalues: p124 (copy), v194 (copy), v193 (copy)
					return p124(unpack(v194, 1, v193))
				end, true)
			end
		end

		v190 = false
		g191 = true
	until not g191
end
function t6.prototype.doneReturn(p125, ...) -- line: 1660
	-- upvalues: pack (copy)
	local v196, v197 = pack(...)

	return p125:_finally(debug.traceback(nil, 2), function() -- line: 1662
		-- upvalues: v197 (copy), v196 (copy)
		return unpack(v197, 1, v196)
	end, true)
end
function t6.prototype.awaitStatus(p126) -- line: 1674
	-- upvalues: t6 (copy)
	p126._unhandledRejection = false

	if p126._status == t6.Status.Started then
		local thread = coroutine.running()

		p126:finally(function() -- line: 1680
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

local function awaitHelper(p127, ...) -- line: 1696
	-- upvalues: t6 (copy)
	return p127 == t6.Status.Resolved, ...
end

function t6.prototype.await(p128) -- line: 1721
	-- upvalues: awaitHelper (copy)
	return awaitHelper(p128:awaitStatus())
end

local function expectHelper(p129, ...) -- line: 1725
	-- upvalues: t6 (copy)
	if p129 ~= t6.Status.Resolved then
		error(if ... ~= nil then ... else "Expected Promise rejected with no value.", 3)
	end

	return ...
end

function t6.prototype.expect(p130) -- line: 1758
	-- upvalues: expectHelper (copy)
	return expectHelper(p130:awaitStatus())
end

t6.prototype.awaitValue = t6.prototype.expect

function t6.prototype._unwrap(p131) -- line: 1772
	-- upvalues: t6 (copy)
	if p131._status == t6.Status.Started then
		error("Promise has not resolved or rejected.", 2)
	end

	return p131._status == t6.Status.Resolved, unpack(p131._values, 1, p131._valuesLength)
end
function t6.prototype._resolve(p132, ...) -- line: 1782
	-- upvalues: t6 (copy), t3 (ref), pack (copy)
	if p132._status ~= t6.Status.Started then
		if t6.is((...)) then
			(...):_consumerCancelled(p132)
		end

		return
	end

	if t6.is((...)) then
		if select("#", ...) > 1 then
			local v206 = string.format("When returning a Promise from andThen, extra arguments are discarded! See:\n\n%s", p132._source)

			warn(v206)
		end

		local v207 = ...
		local v208 = v207:andThen(function(...) -- line: 1803
			-- upvalues: p132 (copy)
			p132:_resolve(...)
		end, function(...) -- line: 1805
			-- upvalues: v207 (copy), t3 (ref), p132 (copy)
			local v359 = v207._values[1]

			if v207._error then
				v359 = t3.new({
					context = "[No stack trace available as this Promise originated from an older version of the Promise library (< v2)]",
					error = v207._error,
					kind = t3.Kind.ExecutionError
				})
			end

			if t3.isKind(v359, t3.Kind.ExecutionError) then
				return p132:_reject(v359:extend({
					error = "This Promise was chained to a Promise that errored.",
					trace = "",
					context = string.format("The Promise at:\n\n%s\n...Rejected because it was chained to the following Promise, which encountered an error:\n", p132._source)
				}))
			end

			p132:_reject(...)
		end)

		if v208._status == t6.Status.Cancelled then
			p132:cancel()

			return
		end

		if v208._status == t6.Status.Started then
			p132._parent = v208
			v208._consumers[p132] = true
		end

		return
	end

	p132._status = t6.Status.Resolved

	local v209, v210 = pack(...)

	p132._valuesLength = v209
	p132._values = v210

	for _, v in ipairs(p132._queuedResolve) do
		coroutine.wrap(v)(...)
	end

	p132:_finalize()
end
function t6.prototype._reject(p133, ...) -- line: 1853
	-- upvalues: t6 (copy), pack (copy)
	if p133._status ~= t6.Status.Started then
		return
	end

	p133._status = t6.Status.Rejected

	local v214, v215 = pack(...)

	p133._valuesLength = v214
	p133._values = v215

	local _queuedReject = p133._queuedReject

	if next(_queuedReject) ~= nil then
		for _, v in ipairs(p133._queuedReject) do
			coroutine.wrap(v)(...)
		end
	else
		local str = tostring((...))

		coroutine.wrap(function() -- line: 1875
			-- upvalues: t6 (copy), p133 (copy), str (copy)
			t6._timeEvent:Wait()

			if not p133._unhandledRejection then
				return
			end

			local v360 = string.format("Unhandled Promise rejection:\n\n%s\n\n%s", str, p133._source)

			for _, v in ipairs(t6._unhandledRejectionCallbacks) do
				task.spawn(v, p133, unpack(p133._values, 1, p133._valuesLength))
			end

			if t6.TEST then
				return
			end

			warn(v360)
		end)()
	end

	p133:_finalize()
end

local t18 = {}
local u19 = nil

local function closeThreads() -- line: 1906
	-- upvalues: u19 (ref), t18 (ref)
	u19 = nil

	local v220 = t18

	t18 = {}

	for _, v222 in v220 do
		coroutine.close(v222)
	end
end

function t6.prototype._finalize(p134) -- line: 1920
	-- upvalues: t6 (copy), result (ref), t18 (ref), u19 (ref), closeThreads (copy)
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

	if result then
		table.insert(t18, p134._thread)

		if not u19 then
			u19 = task.defer(closeThreads)

			return
		end
	else
		task.defer(coroutine.close, p134._thread)
	end
end
function t6.prototype.now(p135, p136) -- line: 1965
	-- upvalues: t6 (copy), t3 (ref)
	local trace = debug.traceback(nil, 2)

	if p135._status == t6.Status.Resolved then
		return p135:_andThen(trace, function(...) -- line: 1968
			return ...
		end)
	end

	return t6.reject(p136 == nil and t3.new({
		error = "This Promise was not resolved in time for :now()",
		kind = t3.Kind.NotResolvedInTime,
		context = ":now() was called at:\n\n" .. trace
	}) or p136)
end
function t6.retry(p137, p138, ...) -- line: 2010
	-- upvalues: t6 (copy)
	local g232 = nil
	local mt = nil
	local v231 = nil

	if type(p137) == "function" then
		v231 = true
		g232 = true
	end

	repeat
		if g232 or (g232 or type(p137) == "table") then
			if not g232 then
				if not g232 then
					mt = getmetatable(p137)
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
				assert(type(p138) == "number", "Parameter #2 to Promise.retry must be a number")

				local t19 = { ... }
				local v235 = select("#", ...)

				return t6.resolve(p137(...)):catch(function(...) -- line: 2016
					-- upvalues: p138 (copy), t6 (copy), p137 (copy), t19 (copy), v235 (copy)
					if p138 > 0 then
						return t6.retry(p137, p138 - 1, unpack(t19, 1, v235))
					end

					return t6.reject(...)
				end)
			end
		end

		v231 = false
		g232 = true
	until not g232
end
function t6.retryWithDelay(p139, p140, p141, ...) -- line: 2038
	-- upvalues: t6 (copy)
	local g240 = nil
	local mt = nil
	local v239 = nil

	if type(p139) == "function" then
		v239 = true
		g240 = true
	end

	repeat
		if g240 or (g240 or type(p139) == "table") then
			if not g240 then
				if not g240 then
					mt = getmetatable(p139)
				end
			end

			if g240 or (g240 or mt and type((rawget(mt, "__call"))) == "function") then
				if not g240 then
					if not g240 then
						v239 = true
					end
				end

				g240 = false
				assert(v239, "Parameter #1 to Promise.retry must be a function")
				assert(type(p140) == "number", "Parameter #2 (times) to Promise.retry must be a number")
				assert(type(p141) == "number", "Parameter #3 (seconds) to Promise.retry must be a number")

				local t20 = { ... }
				local v243 = select("#", ...)

				return t6.resolve(p139(...)):catch(function(...) -- line: 2045
					-- upvalues: p140 (copy), t6 (copy), p141 (copy), p139 (copy), t20 (copy), v243 (copy)
					if p140 > 0 then
						t6.delay(p141):await()

						return t6.retryWithDelay(p139, p140 - 1, p141, unpack(t20, 1, v243))
					end

					return t6.reject(...)
				end)
			end
		end

		v239 = false
		g240 = true
	until not g240
end
function t6.fromEvent(p142, p143) -- line: 2080
	-- upvalues: t6 (copy)
	local u246 = p143 or function() -- line: 2081
		return true
	end

	return t6._new(debug.traceback(nil, 2), function(p144, _, p146) -- line: 2085
		-- upvalues: p142 (copy), u246 (ref)
		local u366 = nil
		local u367 = false

		local function disconnect() -- line: 2089
			-- upvalues: u366 (ref)
			u366:Disconnect()
			u366 = nil
		end

		u366 = p142:Connect(function(...) -- line: 2098
			-- upvalues: u246 (ref), p144 (copy), u366 (ref), u367 (ref)
			local v413 = u246(...)

			if v413 == true then
				p144(...)

				if u366 then
					u366:Disconnect()
					u366 = nil

					return
				end

				u367 = true

				return
			end

			if type(v413) ~= "boolean" then
				error("Promise.fromEvent predicate should always return a boolean")
			end
		end)

		if u367 and u366 then
			return disconnect()
		end

		p146(disconnect)
	end)
end
function t6.onUnhandledRejection(p147) -- line: 2132
	-- upvalues: t6 (copy)
	table.insert(t6._unhandledRejectionCallbacks, p147)

	return function() -- line: 2135
		-- upvalues: t6 (copy), p147 (copy)
		local v369 = table.find(t6._unhandledRejectionCallbacks, p147)

		if v369 then
			table.remove(t6._unhandledRejectionCallbacks, v369)
		end
	end
end

return t6
