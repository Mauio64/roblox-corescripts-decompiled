require(script.Parent.ReactInternalTypes)

local ReactFiberStacknew = require(script.Parent["ReactFiberStack.new"])

local createCursor = ReactFiberStacknew.createCursor
local push = ReactFiberStacknew.push
local pop = ReactFiberStacknew.pop

local cursor = createCursor(0)
local New = {}
New.InvisibleParentSuspenseContext = 1
New.ForceSuspenseFallback = 2
New.suspenseStackCursor = cursor

function New.hasSuspenseContext(p: number, p2: number): boolean
	return bit32.band(p, p2) ~= 0
end

function New.setDefaultShallowSuspenseContext(p: number)
	return (bit32.band(p, 1))
end

function New.setShallowSuspenseContext(p: number, p2: number)
	return (bit32.bor(bit32.band(p, 1), p2))
end

function New.addSubtreeSuspenseContext(p: number, p2: number)
	return (bit32.bor(p, p2))
end

function New.pushSuspenseContext(p, p2: number)
	push(cursor, p2, p)
end

function New.popSuspenseContext(p)
	pop(cursor, p)
end

return New
