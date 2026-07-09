local IndentedLineBuffer = require(script.Parent.IndentedLineBuffer)

local function dumpInstanceTree(p1, p2) -- line: 8
	-- upvalues: dumpInstanceTree (copy)
	if p1 == nil then
		p2:addLine("[nil Instance]")

		return
	end

	if p1.Name == nil then
		p2:addLine("[Invalid Instance]")

		return
	end

	p2:addLine(p1.Name)
	p2:indent()

	for _, child in ipairs(p1:GetChildren()) do
		dumpInstanceTree(child, p2)
	end

	p2:unindent()
end

return function(p3) -- line: 27
	-- upvalues: IndentedLineBuffer (copy), dumpInstanceTree (copy)
	local v8 = IndentedLineBuffer.new()

	dumpInstanceTree(p3, v8)

	return (tostring(v8))
end
