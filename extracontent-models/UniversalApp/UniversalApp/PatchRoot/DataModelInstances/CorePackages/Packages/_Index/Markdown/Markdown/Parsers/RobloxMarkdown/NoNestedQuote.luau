local parent = script:FindFirstAncestor("Markdown").Parent
local CommonMark = require(parent.CommonMark)

local factory = CommonMark.Internal.BlockQuoteParser.Factory.new()

local function isInsideBlockQuote(object): boolean
	while object ~= nil do
		if object.kind == "BlockQuote" then
			return true
		end

		object = object:getParent()
	end

	return false
end

local class = {}
class.__index = class

function class.new()
	return (setmetatable({}, class))
end

function class:tryStart(p, object)
	local v = factory:tryStart(p, object)

	if v == nil then
		return nil
	end

	local block = object:getMatchedBlockParser():getBlock()
	local v2

	while true do
		if block == nil then
			v2 = false
			break
		end

		if block.kind == "BlockQuote" then
			v2 = true
			break
		end

		block = block:getParent()
	end

	return if not v2 then v else nil
end

return {
	["Factory"] = class,
	extension = function()
		return {
			extendParser = function(object)
				object:customBlockParserFactory(class.new())
			end
		}
	end
}
