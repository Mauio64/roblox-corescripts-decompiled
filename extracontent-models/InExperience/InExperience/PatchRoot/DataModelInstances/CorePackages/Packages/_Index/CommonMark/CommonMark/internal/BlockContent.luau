local BlockContent = {}
BlockContent.__index = BlockContent

function BlockContent.new()
	return (setmetatable({ _sb = {}, _lineCount = 0 }, BlockContent))
end

function BlockContent.newString(p: string)
	return (setmetatable({
		_sb = { p },
		_lineCount = 0
	}, BlockContent))
end

function BlockContent:add(p: string)
	if self._lineCount ~= 0 then
		table.insert(self._sb, "\n")
	end

	table.insert(self._sb, p)
	self._lineCount += 1
end

function BlockContent:getString()
	return table.concat(self._sb)
end

return BlockContent
