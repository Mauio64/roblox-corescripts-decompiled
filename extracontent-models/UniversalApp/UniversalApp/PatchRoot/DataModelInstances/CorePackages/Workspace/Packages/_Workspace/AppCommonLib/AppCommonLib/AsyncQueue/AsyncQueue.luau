local Parent = script:FindFirstAncestor("AppCommonLib").Parent
local Promise = require(Parent.Promise)

require(script.Parent.AsyncQueueTypes)

local t1 = {}

t1.__index = t1

function t1.new() -- line: 26
	-- upvalues: Promise (copy), t1 (copy)
	local t2 = {
		head = Promise.resolve()
	}

	setmetatable(t2, t1)

	return t2
end
function t1.request(t3: {[any]: any}, p1: ((...any) -> ...any)) -- line: 34
	-- upvalues: Promise (copy)
	local BindableEvent = Instance.new("BindableEvent")
	local u8 = false
	local u9 = false

	t3.head = t3.head:andThen(function() -- line: 39
		-- upvalues: Promise (copy), u8 (ref), p1 (copy), u9 (ref), BindableEvent (copy)
		return Promise.new(function(resolve) -- line: 40
			-- upvalues: u8 (ref), p1 (copy), u9 (ref), BindableEvent (copy)
			if not u8 then
				pcall(p1)
			end

			if not u8 then
				u9 = true
				BindableEvent.Event:Wait()
			end

			BindableEvent:Destroy()
			resolve()
		end)
	end)

	local function release() -- line: 53
		-- upvalues: u9 (ref), BindableEvent (copy), u8 (ref)
		if u9 then
			BindableEvent:Fire()

			return
		end

		u8 = true
	end

	return release
end

return t1
