local t1 = {}

t1.__index = t1

function t1.new() -- line: 4
	-- upvalues: t1 (copy)
	return (setmetatable({
		passed = true,
		reasons = {}
	}, t1))
end
function t1.updateReasons(t2: {[any]: any}, b1: boolean, t3: {[any]: any}?) -- line: 13
	if b1 then
		return
	end

	table.insert(t2.reasons, table.concat(t3, "\n"))
	t2.passed = false
end
function t1.getFinalResults(p1) -- line: 22
	if p1.passed then
		return true
	end

	return false, p1.reasons
end

return t1
