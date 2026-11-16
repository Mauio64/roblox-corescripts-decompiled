local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.parser.delimiter.DelimiterProcessor)
require(CommonMark.parser.delimiter.DelimiterRun)
local Nodes = require(CommonMark.node.Nodes)
local SourceSpans = require(CommonMark.node.SourceSpans)

local EmphasisDelimiterProcessor = {}
EmphasisDelimiterProcessor.__index = EmphasisDelimiterProcessor

function EmphasisDelimiterProcessor.new(delimiterChar: number, data)
	local minLength = (data == nil or data.minLength == nil) and 1 or data.minLength

	if minLength ~= 1 and minLength ~= 2 then
		error(`EmphasisLikeDelimiterProcessor minLength must be 1 or 2, got {minLength}`)
	end

	local createEmphasis

	if data == nil or data.createEmphasis == nil then
		createEmphasis = Nodes.Emphasis
	else
		createEmphasis = data.createEmphasis
	end

	local createStrongEmphasis

	if data == nil or data.createStrongEmphasis == nil then
		createStrongEmphasis = Nodes.StrongEmphasis
	else
		createStrongEmphasis = data.createStrongEmphasis
	end

	return (setmetatable({
		_delimiterChar = delimiterChar,
		_minLength = minLength,
		_createEmphasis = createEmphasis,
		_createStrongEmphasis = createStrongEmphasis,
		_rejectsByMultipleOf3Rule = true
	}, EmphasisDelimiterProcessor))
end

function EmphasisDelimiterProcessor:getOpeningCharacter()
	return self._delimiterChar
end

function EmphasisDelimiterProcessor:getClosingCharacter()
	return self._delimiterChar
end

function EmphasisDelimiterProcessor:getMinLength()
	return self._minLength
end

function EmphasisDelimiterProcessor:process(object, object2)
	if
		(object:canClose() or object2:canOpen())
		and object2:originalLength() % 3 ~= 0
		and (object:originalLength() + object2:originalLength()) % 3 == 0
	then
		return 0
	end

	local v, v2

	if object:length() >= 2 and object2:length() >= 2 then
		v = self._createStrongEmphasis((string.char(self._delimiterChar, self._delimiterChar)))
		v2 = 2
	else
		v = self._createEmphasis((string.char(self._delimiterChar)))
		v2 = 1
	end

	local empty = SourceSpans.empty()
	empty:addAllFrom((object:getOpeners(v2)))

	local opener = object:getOpener()

	for k in Nodes.between(opener, object2:getCloser()) do
		v:appendChild(k)
		empty:addAll(k:getSourceSpans())
	end

	empty:addAllFrom((object2:getClosers(v2)))

	v:setSourceSpans(empty:getSourceSpans())
	opener:insertAfter(v)

	return v2
end

return EmphasisDelimiterProcessor
