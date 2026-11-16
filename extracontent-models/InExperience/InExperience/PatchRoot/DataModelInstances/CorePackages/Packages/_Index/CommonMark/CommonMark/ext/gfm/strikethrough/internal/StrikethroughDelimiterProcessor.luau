local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.parser.delimiter.DelimiterProcessor)
require(CommonMark.parser.delimiter.DelimiterRun)
local Nodes = require(CommonMark.node.Nodes)
local SourceSpans = require(CommonMark.node.SourceSpans)
local Strikethrough = require(CommonMark.ext.gfm.strikethrough.Strikethrough)

local StrikethroughDelimiterProcessor = {}
StrikethroughDelimiterProcessor.__index = StrikethroughDelimiterProcessor

function StrikethroughDelimiterProcessor.new(flag: boolean?)
	return (setmetatable({
		_requireTwoTildes = flag == true
	}, StrikethroughDelimiterProcessor))
end

function StrikethroughDelimiterProcessor.getOpeningCharacter(_): number
	return 126
end

function StrikethroughDelimiterProcessor.getClosingCharacter(_): number
	return 126
end

function StrikethroughDelimiterProcessor:getMinLength(): number
	return if self._requireTwoTildes then 2 else 1
end

function StrikethroughDelimiterProcessor.process(_, object, object2)
	if object:length() ~= object2:length() or not (object:length() <= 2) then
		return 0
	end

	local opener = object:getOpener()

	local v = opener.literal

	if object:length() ~= 1 then
		v ..= v
	end

	local strikethrough = Strikethrough(v)

	local v2 = SourceSpans.new()
	v2:addAllFrom((object:getOpeners(object:length())))

	for k in Nodes.between(opener, object2:getCloser()) do
		strikethrough:appendChild(k)
		v2:addAll(k:getSourceSpans())
	end

	v2:addAllFrom((object2:getClosers(object2:length())))
	strikethrough:setSourceSpans(v2:getSourceSpans())

	opener:insertAfter(strikethrough)

	return object:length()
end

return StrikethroughDelimiterProcessor
