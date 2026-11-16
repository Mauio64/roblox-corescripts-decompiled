local parent = script:FindFirstAncestor("Utils").Parent
local parent2 = parent.Parent
local NodeType = require(parent.Enums.NodeType)

local InlineLayout = require(parent2.InlineLayout)
local isInlineElement = InlineLayout.Utils.isInlineElement
local Dash = require(parent2.Dash)
local ReactIs = require(parent2.ReactIs)

local NodeTypeConfig = {
	[NodeType.Root] = {
		children = { [NodeType.Block] = true, [NodeType.TextBlock] = true },
		validateRenderResult = function(p)
			return p ~= nil and ReactIs.isElement(p)
		end
	}
}

local Block = NodeType.Block
NodeTypeConfig[Block] = {
	children = { [NodeType.Block] = true, [NodeType.TextBlock] = true },
	validateRenderResult = function(p)
		return p == nil or (ReactIs.isElement(p) or Dash.all(p, ReactIs.isElement))
	end
}

local TextBlock = NodeType.TextBlock
NodeTypeConfig[TextBlock] = {
	children = { [NodeType.InlineSpan] = true, [NodeType.InlineLeaf] = true },
	validateRenderResult = function(p)
		return p == nil or (ReactIs.isElement(p) or Dash.all(p, ReactIs.isElement))
	end
}

local InlineSpan = NodeType.InlineSpan
NodeTypeConfig[InlineSpan] = {
	children = { [NodeType.InlineSpan] = true, [NodeType.InlineLeaf] = true },
	validateRenderResult = function(p)
		return p == nil or (isInlineElement(p) or Dash.all(p, isInlineElement))
	end
}

NodeTypeConfig[NodeType.InlineLeaf] = {
	children = {},
	validateRenderResult = function(p)
		return p == nil or isInlineElement(p)
	end
}

return NodeTypeConfig
