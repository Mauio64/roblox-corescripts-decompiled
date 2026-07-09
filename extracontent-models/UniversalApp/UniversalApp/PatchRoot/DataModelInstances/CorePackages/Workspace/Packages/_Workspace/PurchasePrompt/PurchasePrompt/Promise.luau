local function pack(...) -- line: 12
	return select("#", ...), { ... }
end
local function wpcallPacked(p1, ...) -- line: 25
	-- upvalues: pack (copy)
	local v7, v8 = pack(...)
	local v9, v10 = pack(xpcall(function() -- line: 28
		-- upvalues: p1 (copy), v8 (copy), v7 (copy)
		return p1(unpack(v8, 1, v7))
	end, debug.traceback))

	return v9, v10
end
local function createAdvancer(p2, p3, p4) -- line: 48
	-- upvalues: wpcallPacked (copy)
	return function(...) -- line: 49
		-- upvalues: wpcallPacked (copy), p2 (copy), p3 (copy), p4 (copy)
		local v49, v50 = wpcallPacked(p2, ...)

		if v50[1] then
			p3(unpack(v50, 2, v49))

			return
		end

		p4(unpack(v50, 2, v49))
	end
end
local function isEmpty(p5) -- line: 61
	return next(p5) == nil
end

local t1 = {}

t1.__index = t1
t1.Status = {
	Started = "Started",
	Resolved = "Resolved",
	Rejected = "Rejected"
}

function t1.new(p6) -- line: 93
	-- upvalues: t1 (copy), wpcallPacked (copy)
	local t2 = {
		_type = "Promise",
		_values = nil,
		_valuesLength = -1,
		_unhandledRejection = false,
		_source = debug.traceback(),
		_status = t1.Status.Started,
		_queuedResolve = {},
		_queuedReject = {}
	}

	setmetatable(t2, t1)

	local function resolve(...) -- line: 121
		-- upvalues: t2 (copy)
		t2:_resolve(...)
	end
	local function reject(...) -- line: 125
		-- upvalues: t2 (copy)
		t2:_reject(...)
	end

	local _, v20 = wpcallPacked(p6, resolve, reject)
	local v21 = v20[1]
	local v22 = v20[2]

	if not v21 and t2._status == t1.Status.Started then
		reject(v22)
	end

	return t2
end
function t1.resolve(p7) -- line: 143
	-- upvalues: t1 (copy)
	return t1.new(function(p8) -- line: 144
		-- upvalues: p7 (copy)
		p8(p7)
	end)
end
function t1.reject(p9) -- line: 152
	-- upvalues: t1 (copy)
	return t1.new(function(_, p11) -- line: 153
		-- upvalues: p9 (copy)
		p11(p9)
	end)
end
function t1.all(...) -- line: 163
	-- upvalues: t1 (copy)
	local t3 = { ... }

	if type(t3[1]) == "table" and t3[1]._type ~= "Promise" then
		t3 = t3[1]
	end

	return t1.new(function(p12, p13) -- line: 172
		-- upvalues: t3 (ref), t1 (copy)
		local u56 = false
		local t4 = {}
		local n1 = 0
		local n2 = 0

		for _ in pairs(t3) do
			n2 += 1
		end

		local function promiseCompleted(p14, p15) -- line: 184
			-- upvalues: u56 (ref), t4 (copy), n1 (ref), n2 (ref), p12 (copy)
			if u56 then
				return
			end

			t4[p14] = p15
			n1 += 1

			if n1 == n2 then
				p12(t4)
				u56 = true
			end
		end

		if n2 == 0 then
			p12(t4)
			u56 = true

			return
		end

		for k, v in pairs(t3) do
			if v._status == t1.Status.Started then
				v:andThen(function(p16) -- line: 208
					-- upvalues: k (copy), u56 (ref), t4 (copy), n1 (ref), n2 (ref), p12 (copy)
					local v77 = k

					if u56 then
						return
					end

					t4[v77] = p16
					n1 += 1

					if n1 == n2 then
						p12(t4)
						u56 = true
					end
				end):catch(function(p17) -- line: 211
					-- upvalues: u56 (ref), p13 (copy)
					u56 = true
					p13(p17)
				end)
			elseif v._status == t1.Status.Resolved then
				local v64 = unpack(v._values)

				if not u56 then
					t4[k] = v64
					n1 += 1

					if n1 == n2 then
						p12(t4)
						u56 = true
					end
				end
			else
				v:catch(function(_) -- line: 224
					-- upvalues: u56 (ref), p13 (copy), v (copy)
					u56 = true
					p13(unpack(v._values))
				end)
			end
		end
	end)
end
function t1.is(p19) -- line: 236
	if type(p19) ~= "table" then
		return false
	end

	return p19._type == "Promise"
end
function t1.promisify(p20) -- line: 247
	-- upvalues: t1 (copy)
	return function(...) -- line: 248
		-- upvalues: t1 (copy), p20 (copy)
		local t5 = { ... }
		local v66 = select("#", ...)

		return t1.new(function(p21, p22) -- line: 252
			-- upvalues: p20 (copy), t5 (copy), v66 (copy)
			spawn(function() -- line: 253
				-- upvalues: p20 (copy), t5 (copy), v66 (copy), p21 (copy), p22 (copy)
				local ok, result = pcall(p20, unpack(t5, 1, v66))

				if ok then
					p21(result)

					return
				end

				p22(result)
			end)
		end)
	end
end
function t1.getStatus(p23) -- line: 266
	return p23._status
end
function t1.andThen(p24, p25, p26) -- line: 274
	-- upvalues: t1 (copy), wpcallPacked (copy)
	p24._unhandledRejection = false

	return t1.new(function(p27, p28) -- line: 278
		-- upvalues: p25 (copy), wpcallPacked (copy), p26 (copy), p24 (copy), t1 (copy)
		local v69 = p27

		if p25 then
			local v70 = p25

			function v69(...) -- line: 49
				-- upvalues: wpcallPacked (copy), v70 (copy), p27 (copy), p28 (copy)
				local v82, v83 = wpcallPacked(v70, ...)

				if v83[1] then
					p27(unpack(v83, 2, v82))

					return
				end

				p28(unpack(v83, 2, v82))
			end
		end

		local v71 = p28

		if p26 then
			local v72 = p26

			function v71(...) -- line: 49
				-- upvalues: wpcallPacked (copy), v72 (copy), p27 (copy), p28 (copy)
				local v84, v85 = wpcallPacked(v72, ...)

				if v85[1] then
					p27(unpack(v85, 2, v84))

					return
				end

				p28(unpack(v85, 2, v84))
			end
		end

		if p24._status == t1.Status.Started then
			table.insert(p24._queuedResolve, v69)
			table.insert(p24._queuedReject, v71)

			return
		end

		if p24._status == t1.Status.Resolved then
			v69(unpack(p24._values, 1, p24._valuesLength))

			return
		end

		if p24._status == t1.Status.Rejected then
			v71(unpack(p24._values, 1, p24._valuesLength))
		end
	end)
end
function t1.catch(p29, p30) -- line: 309
	return p29:andThen(nil, p30)
end
function t1.await(p31) -- line: 317
	-- upvalues: t1 (copy)
	p31._unhandledRejection = false

	if p31._status == t1.Status.Started then
		local t6 = nil
		local u36 = nil
		local BindableEvent = Instance.new("BindableEvent")

		p31:andThen(function(...) -- line: 325
			-- upvalues: t6 (ref), u36 (ref), BindableEvent (copy)
			t6 = { ... }
			u36 = select("#", ...)
			BindableEvent:Fire(true)
		end, function(...) -- line: 329
			-- upvalues: t6 (ref), u36 (ref), BindableEvent (copy)
			t6 = { ... }
			u36 = select("#", ...)
			BindableEvent:Fire(false)
		end)

		local v38 = BindableEvent.Event:Wait()

		BindableEvent:Destroy()

		return v38, unpack(t6, 1, u36)
	end

	if p31._status == t1.Status.Resolved then
		return true, unpack(p31._values, 1, p31._valuesLength)
	end

	if p31._status == t1.Status.Rejected then
		return false, unpack(p31._values, 1, p31._valuesLength)
	end
end
function t1._resolve(p32, ...) -- line: 346
	-- upvalues: t1 (copy)
	if p32._status ~= t1.Status.Started then
		return
	end

	local v40 = select("#", ...)

	if t1.is((...)) then
		if v40 > 1 then
			local v41 = ("When returning a Promise from andThen, extra arguments are discarded! See:\n\n%s"):format(p32._source)

			warn(v41)
		end;

		(...):andThen(function(...) -- line: 363
			-- upvalues: p32 (copy)
			p32:_resolve(...)
		end, function(...) -- line: 365
			-- upvalues: p32 (copy)
			p32:_reject(...)
		end)

		return
	end

	p32._status = t1.Status.Resolved
	p32._values = { ... }
	p32._valuesLength = v40

	for _, v in ipairs(p32._queuedResolve) do
		v(...)
	end
end
function t1._reject(p33, ...) -- line: 382
	-- upvalues: t1 (copy)
	if p33._status ~= t1.Status.Started then
		return
	end

	p33._status = t1.Status.Rejected
	p33._values = { ... }
	p33._valuesLength = select("#", ...)

	local _queuedReject = p33._queuedReject

	if next(_queuedReject) ~= nil then
		for _, v in ipairs(p33._queuedReject) do
			v(...)
		end

		return
	end

	p33._unhandledRejection = true

	local str = tostring((...))

	spawn(function() -- line: 406
		-- upvalues: p33 (copy), str (copy)
		if not p33._unhandledRejection then
			return
		end

		local v73 = ("Unhandled promise rejection:\n\n%s\n\n%s"):format(str, p33._source)

		warn(v73)
	end)
end

return t1
