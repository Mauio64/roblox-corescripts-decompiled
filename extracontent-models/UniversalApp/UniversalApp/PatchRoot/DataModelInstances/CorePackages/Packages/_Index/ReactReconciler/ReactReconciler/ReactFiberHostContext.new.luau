require(script.Parent.ReactInternalTypes)

local ReactFiberStacknew = require(script.Parent["ReactFiberStack.new"])

local ReactFiberHostConfig = require(script.Parent.ReactFiberHostConfig)

local getChildHostContext = ReactFiberHostConfig.getChildHostContext
local getRootHostContext = ReactFiberHostConfig.getRootHostContext
local createCursor = ReactFiberStacknew.createCursor
local push = ReactFiberStacknew.push
local pop = ReactFiberStacknew.pop

local v = {}

local cursor = createCursor(v)
local cursor2 = createCursor(v)

local cursor3 = createCursor(v)

function requiredContext(p)
	return p
end

function getRootHostContainer()
	return cursor3.current
end

function pushHostContainer(p, p2)
	push(cursor3, p2, p)

	push(cursor2, p, p)

	push(cursor, v, p)
	local rootHostContext = getRootHostContext(p2)

	pop(cursor, p)
	push(cursor, rootHostContext, p)
end

function popHostContainer(p)
	pop(cursor, p)
	pop(cursor2, p)
	pop(cursor3, p)
end

function getHostContext()
	return cursor.current
end

function pushHostContext(p)
	local v2 = requiredContext(cursor3.current)
	local v3 = requiredContext(cursor.current)
	local childHostContext = getChildHostContext(v3, p.type, v2)

	if v3 == childHostContext then
		return
	end

	push(cursor2, p, p)
	push(cursor, childHostContext, p)
end

function popHostContext(p)
	if cursor2.current ~= p then
		return
	end

	pop(cursor, p)
	pop(cursor2, p)
end

return {
	getHostContext = getHostContext,
	getRootHostContainer = getRootHostContainer,
	popHostContainer = popHostContainer,
	popHostContext = popHostContext,
	pushHostContainer = pushHostContainer,
	pushHostContext = pushHostContext
}
