local function pack(...)
	return select("#", ...), { ... }
end

local function wpcallPacked(callback, ...)
	local v5, v6 = pack(...)

	local v7, v8 = pack(xpcall(function()
		return callback(unpack(v6, 1, v5))
	end, debug.traceback))

	return v7, v8
end

local function createAdvancer(p2, callback, callback2)
	return function(...)
		local v5, v6 = wpcallPacked(p2, ...)

		if v6[1] then
			callback(unpack(v6, 2, v5))
		else
			callback2(unpack(v6, 2, v5))
		end
	end
end

local function isEmpty(items): boolean
	return next(items) == nil
end

local class = {}
class.__index = class

class.Status = { Started = "Started", Resolved = "Resolved", Rejected = "Rejected" }

function class.new(p2)
	local v5 = {
		_source = debug.traceback(),
		_type = "Promise",
		_status = class.Status.Started,
		_values = nil,
		_valuesLength = -1,
		_unhandledRejection = false,
		_queuedResolve = {},
		_queuedReject = {}
	}

	setmetatable(v5, class)

	local function resolve(...)
		v5:_resolve(...)
	end

	local function reject(...)
		v5:_reject(...)
	end

	local v6, v7 = wpcallPacked(p2, resolve, reject)
	local v8 = v7[1]
	local v9 = v7[2]

	if not v8 and v5._status == class.Status.Started then
		reject(v9)
	end

	return v5
end

function class.resolve(p2)
	return class.new(function(callback)
		callback(p2)
	end)
end

function class.reject(p2)
	return class.new(function(p3, callback)
		callback(p2)
	end)
end

function class.all(...)
	local v5 = { ... }

	if type(v5[1]) == "table" and v5[1]._type ~= "Promise" then
		v5 = v5[1]
	end

	return class.new(function(callback, callback2)
		local count = 0
		local flag = false
		local v6 = {}
		local count2 = 0

		for k in pairs(v5) do
			count += 1
		end

		local function promiseCompleted(p2, p3)
			if flag then
				return
			end

			v6[p2] = p3
			count2 += 1

			if count2 == count then
				callback(v6)
				flag = true
			end
		end

		if count == 0 then
			callback(v6)
			flag = true
		else
			for k, v7 in pairs(v5) do
				if v7._status == class.Status.Started then
					v7:andThen(function(p2)
						local v8 = k

						if flag then
							return
						end

						v6[v8] = p2
						count2 += 1

						if count2 == count then
							callback(v6)
							flag = true
						end
					end):catch(function(p2)
						flag = true
						callback2(p2)
					end)
				elseif v7._status == class.Status.Resolved then
					local v8 = unpack(v7._values)

					if not flag then
						v6[k] = v8
						count2 += 1

						if count2 == count then
							callback(v6)
							flag = true
						end
					end
				else
					v7:catch(function(p2)
						flag = true
						callback2(unpack(v7._values))
					end)
				end
			end
		end
	end)
end

function class:is(): boolean
	if type(self) == "table" then
		return self._type == "Promise"
	end

	return false
end

function class.promisify(callback)
	return function(...)
		local v5 = { ... }
		local v6 = select("#", ...)

		return class.new(function(callback2, callback3)
			spawn(function()
				local success, result = pcall(callback, unpack(v5, 1, v6))

				if success then
					callback2(result)
				else
					callback3(result)
				end
			end)
		end)
	end
end

function class:getStatus()
	return self._status
end

function class:andThen(p2, p3)
	self._unhandledRejection = false

	return class.new(function(callback, callback2)
		local v5

		if p2 then
			local v6 = p2

			v5 = function(...)
				local v7, v8 = wpcallPacked(v6, ...)

				if v8[1] then
					callback(unpack(v8, 2, v7))
				else
					callback2(unpack(v8, 2, v7))
				end
			end
		else
			v5 = callback
		end

		local v6

		if p3 then
			local v7 = p3

			v6 = function(...)
				local v8, v9 = wpcallPacked(v7, ...)

				if v9[1] then
					callback(unpack(v9, 2, v8))
				else
					callback2(unpack(v9, 2, v8))
				end
			end
		else
			v6 = callback2
		end

		if self._status == class.Status.Started then
			table.insert(self._queuedResolve, v5)
			table.insert(self._queuedReject, v6)
		elseif self._status == class.Status.Resolved then
			v5(unpack(self._values, 1, self._valuesLength))
		elseif self._status == class.Status.Rejected then
			v6(unpack(self._values, 1, self._valuesLength))
		end
	end)
end

function class:catch(p2)
	return self:andThen(nil, p2)
end

function class:await()
	self._unhandledRejection = false

	if self._status == class.Status.Started then
		local v5 = nil
		local v6 = nil
		local bindableEvent = Instance.new("BindableEvent")

		self:andThen(function(...)
			v5 = { ... }
			v6 = select("#", ...)
			bindableEvent:Fire(true)
		end, function(...)
			v5 = { ... }
			v6 = select("#", ...)
			bindableEvent:Fire(false)
		end)

		local v7 = bindableEvent.Event:Wait()
		bindableEvent:Destroy()

		return v7, unpack(v5, 1, v6)
	end

	if self._status == class.Status.Resolved then
		return true, unpack(self._values, 1, self._valuesLength)
	end

	if self._status == class.Status.Rejected then
		return false, unpack(self._values, 1, self._valuesLength)
	end
end

function class:_resolve(...)
	if self._status ~= class.Status.Started then
		return
	end

	local v5 = select("#", ...)

	if class.is((...)) then
		if v5 > 1 then
			local formatted = ("When returning a Promise from andThen, extra arguments are discarded! See:\n\n%s"):format(self._source)

			warn(formatted)
		end

		(...):andThen(function(...)
			self:_resolve(...)
		end, function(...)
			self:_reject(...)
		end)
	else
		self._status = class.Status.Resolved
		self._values = { ... }
		self._valuesLength = v5

		for i, v6 in ipairs(self._queuedResolve) do
			v6(...)
		end
	end
end

function class:_reject(...)
	if self._status ~= class.Status.Started then
		return
	end

	self._status = class.Status.Rejected
	self._values = { ... }
	self._valuesLength = select("#", ...)

	local queuedReject = self._queuedReject

	if next(queuedReject) == nil then
		self._unhandledRejection = true
		local v5 = tostring((...))

		spawn(function()
			if not self._unhandledRejection then
				return
			end

			local formatted = ("Unhandled promise rejection:\n\n%s\n\n%s"):format(v5, self._source)
			warn(formatted)
		end)
	else
		for i, v5 in ipairs(self._queuedReject) do
			v5(...)
		end
	end
end

return class
