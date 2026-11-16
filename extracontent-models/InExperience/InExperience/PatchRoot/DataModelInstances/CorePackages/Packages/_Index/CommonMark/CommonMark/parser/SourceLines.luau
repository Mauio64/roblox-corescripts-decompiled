local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.parser.SourceLine)
require(CommonMark.node.SourceSpan)

local SourceLines = {}
SourceLines.__index = SourceLines

function SourceLines.new()
	return (setmetatable({ _lines = {} }, SourceLines))
end

function SourceLines.empty()
	return SourceLines.new()
end

function SourceLines.of(p)
	local v = SourceLines.new()
	v:addLine(p)
	return v
end

function SourceLines.ofList(list)
	local v = SourceLines.new()
	table.move(list, 1, #list, 1, v._lines)
	return v
end

function SourceLines:addLine(p)
	table.insert(self._lines, p)
end

function SourceLines:getLines()
	return self._lines
end

function SourceLines:isEmpty(): boolean
	return #self._lines == 0
end

function SourceLines:getContent()
	local v = table.create(#self._lines)

	for i, line in ipairs(self._lines) do
		v[i] = line:getContent()
	end

	return table.concat(v, "\n")
end

function SourceLines:getSourceSpans()
	local sourceSpans = {}

	for _, line in ipairs(self._lines) do
		local sourceSpan = line:getSourceSpan()

		if sourceSpan ~= nil then
			table.insert(sourceSpans, sourceSpan)
		end
	end

	return sourceSpans
end

return SourceLines
