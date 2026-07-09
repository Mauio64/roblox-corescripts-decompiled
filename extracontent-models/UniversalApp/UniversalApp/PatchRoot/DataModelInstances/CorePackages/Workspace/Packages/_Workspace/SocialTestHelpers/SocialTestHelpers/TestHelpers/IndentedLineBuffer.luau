local t1 = {}

t1.__index = t1

function t1.new() -- line: 16
	-- upvalues: t1 (copy)
	local t2 = {
		linePrefix = "",
		lines = {}
	}

	setmetatable(t2, t1)

	return t2
end
function t1.addLine(t3: {[any]: any}, s1: string?) -- line: 28
	table.insert(t3.lines, t3.linePrefix .. (s1 or ""))
end
function t1.indent(p1) -- line: 32
	p1.linePrefix = p1.linePrefix .. "   "
end
function t1.unindent(p2) -- line: 36
	p2.linePrefix = p2.linePrefix:sub(1 + ("   "):len())
end
function t1.__tostring(p3) -- line: 40
	return table.concat(p3.lines, "\n") .. "\n"
end

return t1
