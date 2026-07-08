require(script.Parent.types)

local function once(p1) -- line: 5
	local u5 = false

	local function notAgain() -- line: 7
		-- upvalues: u5 (ref), p1 (copy)
		if not u5 then
			u5 = true
			p1()
		end
	end

	return notAgain
end
local function disposeChildren(t1: {[any]: any}) -- line: 16
	local t2 = {}

	for i = #t1, 1, -1 do
		local v10 = t1[i]
		local ok, result = pcall(v10)

		if not ok then
			table.insert(t2, result)
		end
	end

	if #t2 > 0 then
		error(table.concat(t2, "\n"))
	end
end
local function createResource(p2: ((...any) -> ...any)) -- line: 32
	-- upvalues: disposeChildren (copy)
	local u14 = false
	local t3 = {}

	local function dispose() -- line: 37
		-- upvalues: u14 (ref), t3 (ref), disposeChildren (copy)
		if not u14 then
			u14 = true

			local v22 = t3

			t3 = {}
			disposeChildren(v22)
		end
	end
	local function capture(p3) -- line: 46
		-- upvalues: u14 (ref), t3 (ref)
		if not u14 then
			table.insert(t3, p3)

			return
		end

		error("attempted to track a child after the resource has been disposed")
	end
	local function own(p4, ...) -- line: 54
		-- upvalues: u14 (ref), t3 (ref)
		if not u14 then
			table.insert(t3, p4)
		else
			error("attempted to track a child after the resource has been disposed")
		end

		return ...
	end
	local function handleError(b1: boolean, ...) -- line: 59
		-- upvalues: u14 (ref), t3 (ref), disposeChildren (copy)
		if not b1 then
			if not u14 then
				u14 = true

				local v26 = t3

				t3 = {}
				disposeChildren(v26)
			end

			error((select(1, ...)))
		end

		return ...
	end

	local u20 = false

	local function notAgain() -- line: 7
		-- upvalues: u20 (ref), dispose (copy)
		if not u20 then
			u20 = true
			dispose()
		end
	end

	return notAgain, handleError(pcall(p2, own))
end

return createResource
