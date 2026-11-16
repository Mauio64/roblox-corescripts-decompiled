local Position = {}
Position.__index = Position

function Position.new(lineIndex: number, p: number)
	return (setmetatable({ lineIndex = lineIndex, index = p }, Position))
end

function Position.equals(p, p2): boolean
	return p == p2 or p2 ~= nil and p.lineIndex == p2.lineIndex and p.index == p2.index
end

local function compare(p: number, p2: number): number -- 2 equivalent calls inferred from this helper
	if p < p2 then
		return -1
	end

	return if p == p2 then 0 else 1
end

function Position.compareTo(p, p2)
	local v = compare(p.lineIndex, p2.lineIndex) -- inferred equivalent call

	if v ~= 0 then
		return v
	end

	return compare(p.index, p2.index) -- inferred equivalent call
end

return Position
