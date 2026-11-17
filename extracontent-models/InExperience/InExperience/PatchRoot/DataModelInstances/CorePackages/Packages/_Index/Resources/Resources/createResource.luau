require(script.Parent.types)

local function once(dispose) -- 1 equivalent call inferred from this helper
	local v = false
	local function notAgain()
		if not v then
			v = true
			dispose()
		end
	end
	return notAgain
end

local function disposeChildren(list)
	local v = {}

	for i = #list, 1, -1 do
		local success, result = pcall(list[i])

		if not success then
			table.insert(v, result)
		end
	end

	if #v > 0 then
		error(table.concat(v, "\n"))
	end
end

local function createResource(callback)
	local flag = false

	local v = {}

	local function dispose() -- 1 equivalent call inferred from this helper
		if not flag then
			flag = true
			local v2 = v
			v = {}
			disposeChildren(v2)
		end
	end

	local function capture(p) -- 1 equivalent call inferred from this helper
		if flag then
			error("attempted to track a child after the resource has been disposed")
		else
			table.insert(v, p)
		end
	end

	local function own(p, ...)
		capture(p) -- inferred equivalent call
		return ...
	end

	local function handleError(flag2: boolean, ...)
		if not flag2 then
			dispose() -- inferred equivalent call
			error((select(1, ...)))
		end

		return ...
	end

	return once(dispose), handleError(pcall(callback, own)) -- inferred equivalent call
end

return createResource
