local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.node.Text)

local Delimiter = {}
Delimiter.__index = Delimiter

function Delimiter.new(characters, delimiterChar: number, canOpen: boolean, canClose: boolean, previous)
	return (setmetatable({
		characters = characters,
		delimiterChar = delimiterChar,
		_canOpen = canOpen,
		_canClose = canClose,
		previous = previous,
		next = nil,
		_originalLength = #characters
	}, Delimiter))
end

function Delimiter:canOpen()
	return self._canOpen
end

function Delimiter:canClose()
	return self._canClose
end

function Delimiter:length()
	return #self.characters
end

function Delimiter:originalLength()
	return self._originalLength
end

function Delimiter.getOpener(p)
	return p.characters[#p.characters]
end

function Delimiter.getCloser(p)
	return p.characters[1]
end

function Delimiter:getOpeners(p: number)
	if not (p >= 1 and p <= self:length()) then
		error(`length must be between 1 and {self:length()}, was {p}`)
	end

	return table.move(self.characters, #self.characters - p + 1, #self.characters, 1, {})
end

function Delimiter:getClosers(p: number)
	if not (p >= 1 and p <= self:length()) then
		error(`length must be between 1 and {self:length()}, was {p}`)
	end

	return table.move(self.characters, 1, p, 1, {})
end

return Delimiter
