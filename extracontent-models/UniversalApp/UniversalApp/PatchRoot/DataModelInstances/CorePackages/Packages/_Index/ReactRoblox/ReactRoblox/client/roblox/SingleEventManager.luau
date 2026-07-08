local ParentParent = script.Parent.Parent.Parent.Parent
local console = require(ParentParent.Shared).console
local _ = {
	Disabled = "Disabled",
	Suspended = "Suspended",
	Enabled = "Enabled"
}
local t1 = {}

t1.__index = t1

function t1.new(p1) -- line: 49
	-- upvalues: t1 (copy)
	return (setmetatable({
		_status = "Disabled",
		_isResuming = false,
		_suspendedEventQueue = {},
		_connections = {},
		_listeners = {},
		_instance = p1
	}, t1))
end
function t1.connectEvent(p2, p3, p4) -- line: 77
	p2:_connect(p3, p2._instance[p3], p4)
end
function t1.connectPropertyChange(p5, p6, p7) -- line: 81
	local ok, result = pcall(p5._instance.GetPropertyChangedSignal, p5._instance, p6)

	if not ok then
		error(string.format("Cannot get changed signal on property %q: %s", tostring(p6), result), 0)
	end

	p5:_connect("Change." .. p6, result, p7)
end
function t1._connect(p8, p9, p10, p11) -- line: 99
	if p11 == nil then
		if p8._connections[p9] ~= nil then
			p8._connections[p9]:Disconnect()
			p8._connections[p9] = nil
		end

		p8._listeners[p9] = nil

		return
	end

	if p8._connections[p9] == nil then
		p8._connections[p9] = p10:Connect(function(...) -- line: 110
			-- upvalues: p8 (copy), p9 (copy)
			if p8._status == "Enabled" then
				p8._listeners[p9](p8._instance, ...)

				return
			end

			if p8._status == "Suspended" then
				local v27 = select("#", ...)

				table.insert(p8._suspendedEventQueue, {
					p9,
					v27,
					...
				})
			end
		end)
	end

	p8._listeners[p9] = p11
end
function t1.suspend(p12) -- line: 130
	p12._status = "Suspended"
end
function t1.resume(p13) -- line: 134
	-- upvalues: console (copy)
	if p13._isResuming then
		return
	end

	p13._isResuming = true

	for _, v21 in p13._suspendedEventQueue do
		local v22 = p13._listeners[v21[1]]
		local v23 = v21[2]

		if v22 ~= nil then
			local co = coroutine.create(v22)
			local ok, result = coroutine.resume(co, p13._instance, unpack(v21, 3, 2 + v23))

			if not ok then
				console.warn("%s", result)
			end
		end
	end

	p13._isResuming = false
	p13._status = "Enabled"
	table.clear(p13._suspendedEventQueue)
end

return t1
