local t1 = {}
local n1 = 0

function t1.currentSession() -- line: 5
	-- upvalues: n1 (ref)
	return n1
end
function t1.cancelAll() -- line: 9
	-- upvalues: n1 (ref)
	n1 += 1
end

return t1
