local t1 = {}

t1.__index = t1

function t1.new(p1, p2) -- line: 4
	-- upvalues: t1 (copy)
	local t2 = {
		status = p1 or "",
		updateError = p2 or false
	}

	setmetatable(t2, {
		__index = t1
	})

	return t2
end
function t1.CheckForUpdate(p3, p4) -- line: 16
	if p3.updateError then
		error("Error: CheckForUpdate")
	end

	p4(p3.status)
end
function t1.PerformManagedUpdate(_) -- line: 24
end
function t1.CanPerformBinaryUpdate(_) -- line: 26
	return false
end

return t1
