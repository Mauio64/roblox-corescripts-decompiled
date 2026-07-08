require(script.Parent.ReactInternalTypes)

local lib = require(script.Parent["ReactFiberStack.new"])
local ReactFiberHostConfig = require(script.Parent.ReactFiberHostConfig)
local getChildHostContext = ReactFiberHostConfig.getChildHostContext
local getRootHostContext = ReactFiberHostConfig.getRootHostContext
local createCursor = lib.createCursor
local push = lib.push
local pop = lib.pop
local t1 = {}
local v9 = createCursor(t1)
local v10 = createCursor(t1)
local v11 = createCursor(t1)

function requiredContext(p1) -- line: 42
	return p1
end
function getRootHostContainer() -- line: 52
	-- upvalues: v11 (copy)
	return v11.current
end
function pushHostContainer(p2, p3) -- line: 59
	-- upvalues: push (copy), v11 (copy), v10 (copy), v9 (copy), t1 (copy), getRootHostContext (copy), pop (copy)
	push(v11, p3, p2)
	push(v10, p2, p2)
	push(v9, t1, p2)

	local v15 = getRootHostContext(p3)

	pop(v9, p2)
	push(v9, v15, p2)
end
function popHostContainer(p4) -- line: 79
	-- upvalues: pop (copy), v9 (copy), v10 (copy), v11 (copy)
	pop(v9, p4)
	pop(v10, p4)
	pop(v11, p4)
end
function getHostContext() -- line: 85
	-- upvalues: v9 (copy)
	return v9.current
end
function pushHostContext(p5) -- line: 92
	-- upvalues: v11 (copy), v9 (copy), getChildHostContext (copy), push (copy), v10 (copy)
	local v18 = requiredContext(v11.current)
	local v19 = requiredContext(v9.current)
	local v20 = getChildHostContext(v19, p5.type, v18)

	if v19 == v20 then
		return
	end

	push(v10, p5, p5)
	push(v9, v20, p5)
end
function popHostContext(p6) -- line: 108
	-- upvalues: v10 (copy), pop (copy), v9 (copy)
	if p6 ~= v10.current then
		return
	end

	pop(v9, p6)
	pop(v10, p6)
end

return {
	getHostContext = getHostContext,
	getRootHostContainer = getRootHostContainer,
	popHostContainer = popHostContainer,
	popHostContext = popHostContext,
	pushHostContainer = pushHostContainer,
	pushHostContext = pushHostContext
}
