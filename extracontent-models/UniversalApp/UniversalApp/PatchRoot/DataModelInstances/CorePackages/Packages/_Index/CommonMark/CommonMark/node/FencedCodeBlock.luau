local CommonMark = script:FindFirstAncestor("CommonMark")
local Node = require(CommonMark.node.Node)

local function checkFenceLengths(openingFenceLength: number?, closingFenceLength: number?) -- 2 equivalent calls inferred from this helper
	if openingFenceLength ~= nil and closingFenceLength ~= nil and closingFenceLength < openingFenceLength then
		error("fence lengths required to be: closingFenceLength >= openingFenceLength")
	end
end

local function getOpeningFenceLength(p)
	return p._openingFenceLength
end

local function setOpeningFenceLength(p, openingFenceLength: number?)
	if openingFenceLength ~= nil and openingFenceLength < 3 then
		error("openingFenceLength needs to be >= 3")
	end

	checkFenceLengths(openingFenceLength, p._closingFenceLength) -- inferred equivalent call
	p._openingFenceLength = openingFenceLength
end

local function getClosingFenceLength(p)
	return p._closingFenceLength
end

local function setClosingFenceLength(p, closingFenceLength: number?)
	if closingFenceLength ~= nil and closingFenceLength < 3 then
		error("closingFenceLength needs to be >= 3")
	end

	checkFenceLengths(p._openingFenceLength, closingFenceLength) -- inferred equivalent call
	p._closingFenceLength = closingFenceLength
end

local function FencedCodeBlock()
	local fencedCodeBlock = Node.new("FencedCodeBlock", true)
	fencedCodeBlock.fenceCharacter = nil
	fencedCodeBlock._openingFenceLength = nil
	fencedCodeBlock._closingFenceLength = nil
	fencedCodeBlock.fenceIndent = 0
	fencedCodeBlock.info = nil
	fencedCodeBlock.literal = nil
	fencedCodeBlock.getOpeningFenceLength = getOpeningFenceLength
	fencedCodeBlock.setOpeningFenceLength = setOpeningFenceLength
	fencedCodeBlock.getClosingFenceLength = getClosingFenceLength
	fencedCodeBlock.setClosingFenceLength = setClosingFenceLength
	return fencedCodeBlock
end

return FencedCodeBlock
