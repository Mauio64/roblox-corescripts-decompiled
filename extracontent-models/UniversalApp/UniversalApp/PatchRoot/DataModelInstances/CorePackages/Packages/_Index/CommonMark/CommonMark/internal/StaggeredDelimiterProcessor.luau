local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.parser.delimiter.DelimiterProcessor)
require(CommonMark.parser.delimiter.DelimiterRun)

local StaggeredDelimiterProcessor = {}
StaggeredDelimiterProcessor.__index = StaggeredDelimiterProcessor

function StaggeredDelimiterProcessor.new(delim: number)
	return (setmetatable(
		{ _delim = delim, _minLength = 0, _processors = {}, _rejectsByMultipleOf3Rule = false },
		StaggeredDelimiterProcessor
	))
end

function StaggeredDelimiterProcessor:getOpeningCharacter()
	return self._delim
end

function StaggeredDelimiterProcessor:getClosingCharacter()
	return self._delim
end

function StaggeredDelimiterProcessor:getMinLength()
	return self._minLength
end

function StaggeredDelimiterProcessor:add(object)
	local minLength = object:getMinLength()
	local v = false

	for i, processor in ipairs(self._processors) do
		local minLength2 = processor:getMinLength()

		if minLength2 < minLength then
			table.insert(self._processors, i, object)
			v = true
			break
		elseif minLength == minLength2 then
			local v2 = string.char(self._delim)
			error(`Cannot add two delimiter processors for char '{v2}' and minimum length {minLength}; ` .. `conflicting processors: {tostring(processor)}, {tostring(object)}`)
		end
	end

	if not v then
		table.insert(self._processors, object)
		self._minLength = minLength
	end

	local rejectsByMultipleOf3Rule = true

	for _, processor in ipairs(self._processors) do
		if processor._rejectsByMultipleOf3Rule ~= true then
			rejectsByMultipleOf3Rule = false
		end
	end

	self._rejectsByMultipleOf3Rule = rejectsByMultipleOf3Rule
end

function StaggeredDelimiterProcessor:findProcessor(p: number)
	for _, processor in ipairs(self._processors) do
		if processor:getMinLength() <= p then
			return processor
		end
	end

	return self._processors[1]
end

function StaggeredDelimiterProcessor:process(object, p)
	return self:findProcessor(object:length()):process(object, p)
end

return StaggeredDelimiterProcessor
