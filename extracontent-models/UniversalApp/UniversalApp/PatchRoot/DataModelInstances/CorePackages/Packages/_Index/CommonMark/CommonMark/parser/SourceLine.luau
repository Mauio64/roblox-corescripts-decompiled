local CommonMark = script:FindFirstAncestor("CommonMark")
local SourceSpan = require(CommonMark.node.SourceSpan)

local sub = string.sub

local SourceLine = {}
SourceLine.__index = SourceLine

local function new(content: string, sourceSpan) -- 1 equivalent call inferred from this helper
	return (setmetatable({ _content = content, _sourceSpan = sourceSpan }, SourceLine))
end

function SourceLine.of(content: string, sourceSpan)
	return new(content, sourceSpan) -- inferred equivalent call
end

function SourceLine:getContent()
	return self._content
end

function SourceLine:getSourceSpan()
	return self._sourceSpan
end

function SourceLine:substring(p: number, p2: number)
	local content = self._content

	if p < 0 or p2 < p or #content < p2 then
		error(`begin {p}, end {p2}, length {#content}`)
	end

	local v = sub(content, p + 1, p2)
	local v2 = nil
	local sourceSpan = self._sourceSpan

	if sourceSpan ~= nil then
		local v3 = p2 - p

		if v3 ~= 0 then
			local v4 = sourceSpan:getColumnIndex() + p
			local v5 = sourceSpan:getInputIndex() + p
			v2 = SourceSpan.of(sourceSpan:getLineIndex(), v4, v5, v3)
		end
	end

	return SourceLine.of(v, v2)
end

return SourceLine
