local CommonMark = script:FindFirstAncestor("CommonMark")
require(CommonMark.Extension)
local StrikethroughDelimiterProcessor = require(CommonMark.ext.gfm.strikethrough.internal.StrikethroughDelimiterProcessor)

local StrikethroughExtension = {}

local class = {}
class.__index = class

local function new(p)
	local requireTwoTildes = p._requireTwoTildes
	return {
		extendParser = function(object)
			object:customDelimiterProcessor(StrikethroughDelimiterProcessor.new(requireTwoTildes))
		end,
		extendHtmlRenderer = function(object)
			local StrikethroughHtmlNodeRenderer = require(CommonMark.ext.gfm.strikethrough.internal.StrikethroughHtmlNodeRenderer)

			object:nodeRendererFactory({
				create = function(_, p2)
					return StrikethroughHtmlNodeRenderer.new(p2)
				end
			})
		end
	}
end

function StrikethroughExtension.create()
	return StrikethroughExtension.builder():build()
end

function StrikethroughExtension.builder()
	return class.new()
end

function class.new()
	return (setmetatable({ _requireTwoTildes = false }, class))
end

function class:requireTwoTildes(requireTwoTildes: boolean)
	self._requireTwoTildes = requireTwoTildes
	return self
end

function class:build()
	return new(self)
end

StrikethroughExtension.Builder = class

return StrikethroughExtension
