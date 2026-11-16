local CommonMark = script:FindFirstAncestor("CommonMark")
local SourceSpan = require(CommonMark.node.SourceSpan)

local SourceSpans = {}
SourceSpans.__index = SourceSpans

function SourceSpans.new()
	return (setmetatable({ _sourceSpans = nil }, SourceSpans))
end

function SourceSpans.empty()
	return SourceSpans.new()
end

function SourceSpans:getSourceSpans()
	if self._sourceSpans == nil then
		return {}
	end

	return self._sourceSpans
end

function SourceSpans:addAllFrom(list)
	for _, item in ipairs(list) do
		self:addAll(item:getSourceSpans())
	end
end

function SourceSpans:addAll(list)
	if #list == 0 then
		return
	end

	if self._sourceSpans == nil then
		self._sourceSpans = {}
	end

	local sourceSpans = self._sourceSpans

	if #sourceSpans == 0 then
		table.move(list, 1, #list, 1, sourceSpans)
		return
	end

	local v = #sourceSpans - 1
	local sourceSpan = sourceSpans[v + 1]
	local item = list[1]

	if sourceSpan:getInputIndex() + sourceSpan:getLength() ~= item:getInputIndex() then
		table.move(list, 1, #list, #sourceSpans + 1, sourceSpans)

		return
	end

	sourceSpans[v + 1] = SourceSpan.of(
		sourceSpan:getLineIndex(),
		sourceSpan:getColumnIndex(),
		sourceSpan:getInputIndex(),
		sourceSpan:getLength() + item:getLength()
	)
	table.move(list, 2, #list, #sourceSpans + 1, sourceSpans)
end

return SourceSpans
