local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.internal.Delimiter)
require(CommonMark.parser.beta.Position)
require(CommonMark.node.Text)

local Bracket = {}
Bracket.__index = Bracket

local function new(markerNode, markerPosition, bracketNode, bracketPosition, contentPosition, previous, previousDelimiter) -- 2 equivalent calls inferred from this helper
	return (setmetatable({
		markerNode = markerNode,
		markerPosition = markerPosition,
		bracketNode = bracketNode,
		bracketPosition = bracketPosition,
		contentPosition = contentPosition,
		previous = previous,
		previousDelimiter = previousDelimiter,
		allowed = true,
		bracketAfter = false,
		contentNestingDepth = 0
	}, Bracket))
end

function Bracket.link(bracketNode, bracketPosition, contentPosition, previous, previousDelimiter)
	return new(nil, nil, bracketNode, bracketPosition, contentPosition, previous, previousDelimiter) -- inferred equivalent call
end

function Bracket.withMarker(markerNode, markerPosition, bracketNode, bracketPosition, contentPosition, previous, previousDelimiter)
	return new(markerNode, markerPosition, bracketNode, bracketPosition, contentPosition, previous, previousDelimiter) -- inferred equivalent call
end

return Bracket
