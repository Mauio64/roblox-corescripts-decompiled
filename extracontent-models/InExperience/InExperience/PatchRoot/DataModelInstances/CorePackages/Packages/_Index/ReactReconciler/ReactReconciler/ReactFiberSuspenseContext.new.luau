require(script.Parent.ReactInternalTypes)

local lib = require(script.Parent["ReactFiberStack.new"])
local createCursor = lib.createCursor
local push = lib.push
local pop = lib.pop
local t1 = {
	InvisibleParentSuspenseContext = 1,
	ForceSuspenseFallback = 2
}
local v6 = createCursor(0)

t1.suspenseStackCursor = v6

function t1.hasSuspenseContext(n1: number, n2: number) -- line: 59
	return bit32.band(n1, n2) ~= 0
end
function t1.setDefaultShallowSuspenseContext(n3: number) -- line: 66
	return (bit32.band(n3, 1))
end
function t1.setShallowSuspenseContext(n4: number, p1) -- line: 72
	return (bit32.bor(bit32.band(n4, 1), p1))
end
function t1.addSubtreeSuspenseContext(n5: number, p2) -- line: 82
	return (bit32.bor(n5, p2))
end
function t1.pushSuspenseContext(p3, n6: number) -- line: 89
	-- upvalues: push (copy), v6 (copy)
	push(v6, n6, p3)
end
function t1.popSuspenseContext(p4) -- line: 93
	-- upvalues: pop (copy), v6 (copy)
	pop(v6, p4)
end

return t1
