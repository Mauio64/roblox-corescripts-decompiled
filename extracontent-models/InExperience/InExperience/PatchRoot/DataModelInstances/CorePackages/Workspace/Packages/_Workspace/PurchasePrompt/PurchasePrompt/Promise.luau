local function pack(...)
	return select("#", ...), { ... }
end

local function wpcallPacked(callback, ...)
	local v, v2 = pack(...)

	local v3, v4 = pack(xpcall(function()
		return callback(unpack(v2, 1, v))
	end, debug.traceback))

	return v3, v4
end

local function createAdvancer(p, callback, callback2) -- 2 equivalent calls inferred from this helper
	return function(...)
		local v, v2 = wpcallPacked(p, ...)

		if v2[1] then
			callback(unpack(v2, 2, v))
		else
			callback2(unpack(v2, 2, v))
		end
	end
end

local function isEmpty(queuedReject): boolean -- 1 equivalent call inferred from this helper
	return next(queuedReject) == nil
end

local Promise = {}
Promise.__index = Promise

Promise.Status = { Started = "Started", Resolved = "Resolved", Rejected = "Rejected" }

function Promise.new(p)
	local v = {
		_source = debug.traceback(),
		_type = "Promise",
		_status = Promise.Status.Started,
		_values = nil,
		_valuesLength = -1,
		_unhandledRejection = false,
		_queuedResolve = {},
		_queuedReject = {}
	}

	setmetatable(v, Promise)

	local function resolve(...)
		v:_resolve(...)
	end

	local function reject(...)
		v:_reject(...)
	end

	local _, v2 = wpcallPacked(p, resolve, reject)
	local v3 = v2[1]
	local v4 = v2[2]

	if not v3 and v._status == Promise.Status.Started then
		reject(v4)
	end

	return v
end

function Promise.resolve(p)
	return Promise.new(function(callback)
		callback(p)
	end)
end

function Promise.reject(p)
	return Promise.new(function(_, callback)
		callback(p)
	end)
end

function Promise.all(...)
	local v = { ... }

	if type(v[1]) == "table" and v[1]._type ~= "Promise" then
		v = v[1]
	end

	return Promise.new(function(callback, callback2)
		local count = 0
		local flag = false
		local v2 = {}
		local count2 = 0

		for _ in pairs(v) do
			count += 1
		end

		local function promiseCompleted(k, p) -- 2 equivalent calls inferred from this helper
			if flag then
				return
			end

			v2[k] = p
			count2 += 1

			if count2 == count then
				callback(v2)
				flag = true
			end
		end

		if count == 0 then
			callback(v2)
			flag = true
		else
			for k, v3 in pairs(v) do
				if v3._status == Promise.Status.Started then
					v3:andThen(function(p)
						promiseCompleted(k, p) -- inferred equivalent call
					end):catch(function(p)
						flag = true
						callback2(p)
					end)
				elseif v3._status == Promise.Status.Resolved then
					promiseCompleted(k, unpack(v3._values)) -- inferred equivalent call
				else
					v3:catch(function(_)
						flag = true
						callback2(unpack(v3._values))
					end)
				end
			end
		end
	end)
end

function Promise:is(): boolean
	return type(self) == "table" and self._type == "Promise"
end

function Promise.promisify(callback)
	return function(...)
		local v = { ... }
		local v2 = select("#", ...)

		return Promise.new(function(callback2, callback3)
			spawn(function()
				local success, result = pcall(callback, unpack(v, 1, v2))

				if success then
					callback2(result)
				else
					callback3(result)
				end
			end)
		end)
	end
end

function Promise:getStatus()
	return self._status
end

function Promise:andThen(p, p2)
	self._unhandledRejection = false

	return Promise.new(function(callback, callback2)
		local v

		if p then
			v = createAdvancer(p, callback, callback2) -- inferred equivalent call
		else
			v = callback
		end

		local v2

		if p2 then
			v2 = createAdvancer(p2, callback, callback2) -- inferred equivalent call
		else
			v2 = callback2
		end

		if self._status == Promise.Status.Started then
			table.insert(self._queuedResolve, v)
			table.insert(self._queuedReject, v2)
		elseif self._status == Promise.Status.Resolved then
			v(unpack(self._values, 1, self._valuesLength))
		elseif self._status == Promise.Status.Rejected then
			v2(unpack(self._values, 1, self._valuesLength))
		end
	end)
end

function Promise:catch(p)
	return self:andThen(nil, p)
end

function Promise:await()
	self._unhandledRejection = false

	if self._status == Promise.Status.Started then
		local v = nil
		local v2 = nil
		local bindableEvent = Instance.new("BindableEvent")

		self:andThen(function(...)
			v = { ... }
			v2 = select("#", ...)
			bindableEvent:Fire(true)
		end, function(...)
			v = { ... }
			v2 = select("#", ...)
			bindableEvent:Fire(false)
		end)

		local v3 = bindableEvent.Event:Wait()
		bindableEvent:Destroy()

		return v3, unpack(v, 1, v2)
	end

	if self._status == Promise.Status.Resolved then
		return true, unpack(self._values, 1, self._valuesLength)
	end

	if self._status == Promise.Status.Rejected then
		return false, unpack(self._values, 1, self._valuesLength)
	end
end

function Promise:_resolve(...)
	if self._status ~= Promise.Status.Started then
		return
	end

	local valuesLength = select("#", ...)

	if Promise.is((...)) then
		if valuesLength > 1 then
			local formatted = ("When returning a Promise from andThen, extra arguments are discarded! See:\n\n%s"):format(self._source)

			warn(formatted)
		end

		(...):andThen(function(...)
			self:_resolve(...)
		end, function(...)
			self:_reject(...)
		end)
	else
		self._status = Promise.Status.Resolved
		self._values = { ... }
		self._valuesLength = valuesLength

		for _, v in ipairs(self._queuedResolve) do
			v(...)
		end
	end
end

function Promise:_reject(...)
	if self._status ~= Promise.Status.Started then
		return
	end

	self._status = Promise.Status.Rejected
	self._values = { ... }
	self._valuesLength = select("#", ...)

	if isEmpty(self._queuedReject) then -- inferred equivalent call
		self._unhandledRejection = true
		local v = tostring((...))

		spawn(function()
			if not self._unhandledRejection then
				return
			end

			local formatted = ("Unhandled promise rejection:\n\n%s\n\n%s"):format(v, self._source)
			warn(formatted)
		end)
	else
		for _, v in ipairs(self._queuedReject) do
			v(...)
		end
	end
end

return Promise
