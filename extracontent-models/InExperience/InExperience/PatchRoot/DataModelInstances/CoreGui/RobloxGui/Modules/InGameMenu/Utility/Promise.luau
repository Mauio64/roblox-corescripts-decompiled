local function pack(...) -- line: 13
	return select("#", ...), { ... }
end
local function wpcallPacked(p1, ...) -- line: 26
	-- upvalues: pack (copy)
	local v18, v19 = pack(...)
	local v20, v21 = pack(xpcall(function() -- line: 29
		-- upvalues: p1 (copy), v19 (copy), v18 (copy)
		return p1(unpack(v19, 1, v18))
	end, debug.traceback))

	return v20, v21
end
local function createAdvancer(p2, p3, p4) -- line: 49
	-- upvalues: wpcallPacked (copy)
	return function(...) -- line: 50
		-- upvalues: wpcallPacked (copy), p2 (copy), p3 (copy), p4 (copy)
		local v66, v67 = wpcallPacked(p2, ...)

		if v67[1] then
			p3(unpack(v67, 2, v66))

			return
		end

		p4(unpack(v67, 2, v66))
	end
end
local function isEmpty(p5) -- line: 62
	return next(p5) == nil
end
local function createSymbol(p6) -- line: 66
	assert(type(p6) == "string", "createSymbol requires `name` to be a string.")

	local v27 = newproxy(true)

	getmetatable(v27).__tostring = function() -- line: 71
		-- upvalues: p6 (copy)
		return ("Symbol(%s)"):format(p6)
	end

	return v27
end

assert(true, "createSymbol requires `name` to be a string.")

local v6 = newproxy(true)
local s1 = "PromiseMarker"

getmetatable(v6).__tostring = function() -- line: 71
	-- upvalues: s1 (copy)
	return ("Symbol(%s)"):format(s1)
end

local v8 = v6
local t1 = {
	prototype = {}
}

t1.__index = t1.prototype

local t2 = {}

assert(true, "createSymbol requires `name` to be a string.")

local v11 = newproxy(true)
local s2 = "Started"

getmetatable(v11).__tostring = function() -- line: 71
	-- upvalues: s2 (copy)
	return ("Symbol(%s)"):format(s2)
end
t2.Started = v11
assert(true, "createSymbol requires `name` to be a string.")

local v13 = newproxy(true)
local s3 = "Resolved"

getmetatable(v13).__tostring = function() -- line: 71
	-- upvalues: s3 (copy)
	return ("Symbol(%s)"):format(s3)
end
t2.Resolved = v13
assert(true, "createSymbol requires `name` to be a string.")

local v15 = newproxy(true)
local s4 = "Rejected"

getmetatable(v15).__tostring = function() -- line: 71
	-- upvalues: s4 (copy)
	return ("Symbol(%s)"):format(s4)
end
t2.Rejected = v15
t1.Status = t2

function t1.new(p7) -- line: 114
	-- upvalues: v8 (copy), t1 (copy), wpcallPacked (copy)
	local t3 = {
		_source = debug.traceback(),
		[v8] = true,
		_status = t1.Status.Started,
		_values = nil,
		_valuesLength = -1,
		_unhandledRejection = false,
		_queuedResolve = {},
		_queuedReject = {}
	}

	setmetatable(t3, t1)

	local function resolve(...) -- line: 142
		-- upvalues: t3 (copy)
		t3:_resolve(...)
	end
	local function reject(...) -- line: 146
		-- upvalues: t3 (copy)
		t3:_reject(...)
	end

	local _, v33 = wpcallPacked(p7, resolve, reject)
	local v34 = v33[1]
	local v35 = v33[2]

	if not v34 and t3._status == t1.Status.Started then
		reject(v35)
	end

	return t3
end
function t1.resolve(p8) -- line: 164
	-- upvalues: t1 (copy)
	return t1.new(function(p9) -- line: 165
		-- upvalues: p8 (copy)
		p9(p8)
	end)
end
function t1.reject(p10) -- line: 173
	-- upvalues: t1 (copy)
	return t1.new(function(_, p12) -- line: 174
		-- upvalues: p10 (copy)
		p12(p10)
	end)
end
function t1.all(p13) -- line: 184
	-- upvalues: t1 (copy)
	if type(p13) ~= "table" then
		error("Please pass a list of promises to Promise.all", 2)
	end

	if #p13 == 0 then
		return t1.resolve({})
	end

	for i = 1, #p13 do
		if not t1.is(p13[i]) then
			error(("Non-promise value passed into Promise.all at index #%d"):format(i), 2)
		end
	end

	return t1.new(function(p14, p15) -- line: 202
		-- upvalues: p13 (copy)
		local t4 = {}
		local n1 = 0

		local function resolveOne(p16, ...) -- line: 211
			-- upvalues: t4 (copy), n1 (ref), p13 (copy), p14 (copy)
			t4[p16] = ...
			n1 += 1

			if n1 == #p13 then
				p14(t4)
			end
		end

		for i = 1, #p13 do
			p13[i]:andThen(function(...) -- line: 224
				-- upvalues: resolveOne (copy), i (copy)
				resolveOne(i, ...)
			end, function(...) -- line: 227
				-- upvalues: p15 (copy)
				p15(...)
			end)
		end
	end)
end
function t1.is(p17) -- line: 238
	-- upvalues: v8 (copy)
	if type(p17) ~= "table" then
		return false
	end

	return p17[v8] == true
end
function t1.prototype.getStatus(p18) -- line: 246
	return p18._status
end
function t1.prototype.andThen(p19, p20, p21) -- line: 255
	-- upvalues: t1 (copy), wpcallPacked (copy)
	p19._unhandledRejection = false

	return t1.new(function(p22, p23) -- line: 259
		-- upvalues: p20 (copy), wpcallPacked (copy), p21 (copy), p19 (copy), t1 (copy)
		local v79 = p22

		if p20 then
			local v80 = p20

			function v79(...) -- line: 50
				-- upvalues: wpcallPacked (copy), v80 (copy), p22 (copy), p23 (copy)
				local v89, v90 = wpcallPacked(v80, ...)

				if v90[1] then
					p22(unpack(v90, 2, v89))

					return
				end

				p23(unpack(v90, 2, v89))
			end
		end

		local v81 = p23

		if p21 then
			local v82 = p21

			function v81(...) -- line: 50
				-- upvalues: wpcallPacked (copy), v82 (copy), p22 (copy), p23 (copy)
				local v91, v92 = wpcallPacked(v82, ...)

				if v92[1] then
					p22(unpack(v92, 2, v91))

					return
				end

				p23(unpack(v92, 2, v91))
			end
		end

		if p19._status == t1.Status.Started then
			table.insert(p19._queuedResolve, v79)
			table.insert(p19._queuedReject, v81)

			return
		end

		if p19._status == t1.Status.Resolved then
			v79(unpack(p19._values, 1, p19._valuesLength))

			return
		end

		if p19._status == t1.Status.Rejected then
			v81(unpack(p19._values, 1, p19._valuesLength))
		end
	end)
end
function t1.prototype.catch(p24, p25) -- line: 290
	return p24:andThen(nil, p25)
end
function t1.prototype.await(p26) -- line: 299
	-- upvalues: t1 (copy), pack (copy)
	p26._unhandledRejection = false

	if p26._status == t1.Status.Started then
		local u48 = nil
		local u49 = nil
		local BindableEvent = Instance.new("BindableEvent")

		p26:andThen(function(...) -- line: 308
			-- upvalues: u49 (ref), u48 (ref), pack (copy), BindableEvent (copy)
			local v83, v84 = pack(...)

			u49 = v83
			u48 = v84
			BindableEvent:Fire(true)
		end, function(...) -- line: 312
			-- upvalues: u49 (ref), u48 (ref), pack (copy), BindableEvent (copy)
			local v85, v86 = pack(...)

			u49 = v85
			u48 = v86
			BindableEvent:Fire(false)
		end)

		local v51 = BindableEvent.Event:Wait()

		BindableEvent:Destroy()

		return v51, unpack(u48, 1, u49)
	end

	if p26._status == t1.Status.Resolved then
		return true, unpack(p26._values, 1, p26._valuesLength)
	end

	if p26._status == t1.Status.Rejected then
		return false, unpack(p26._values, 1, p26._valuesLength)
	end

	error("Promise had an invalid status.")
end
function t1.prototype._unwrap(p27) -- line: 338
	-- upvalues: t1 (copy)
	if p27._status == t1.Status.Started then
		error("Promise has not resolved or rejected.", 2)
	end

	return p27._status == t1.Status.Resolved, unpack(p27._values, 1, p27._valuesLength)
end
function t1.prototype._resolve(p28, ...) -- line: 348
	-- upvalues: t1 (copy), pack (copy)
	if p28._status ~= t1.Status.Started then
		return
	end

	if t1.is((...)) then
		if select("#", ...) > 1 then
			local v54 = ("When returning a Promise from andThen, extra arguments are discarded! See:\n\n%s"):format(p28._source)

			warn(v54)
		end;

		(...):andThen(function(...) -- line: 367
			-- upvalues: p28 (copy)
			p28:_resolve(...)
		end, function(...) -- line: 370
			-- upvalues: p28 (copy)
			p28:_reject(...)
		end)

		return
	end

	p28._status = t1.Status.Resolved

	local v55, v56 = pack(...)

	p28._valuesLength = v55
	p28._values = v56

	for _, v in ipairs(p28._queuedResolve) do
		v(...)
	end
end
function t1.prototype._reject(p29, ...) -- line: 387
	-- upvalues: t1 (copy), pack (copy)
	if p29._status ~= t1.Status.Started then
		return
	end

	p29._status = t1.Status.Rejected

	local v60, v61 = pack(...)

	p29._valuesLength = v60
	p29._values = v61

	local _queuedReject = p29._queuedReject

	if next(_queuedReject) ~= nil then
		for _, v in ipairs(p29._queuedReject) do
			v(...)
		end

		return
	end

	p29._unhandledRejection = true

	local str = tostring((...))

	spawn(function() -- line: 410
		-- upvalues: p29 (copy), str (copy)
		if not p29._unhandledRejection then
			return
		end

		local v87 = ("Unhandled promise rejection:\n\n%s\n\n%s"):format(str, p29._source)

		warn(v87)
	end)
end

return t1
