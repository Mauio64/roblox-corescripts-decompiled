local Parent = script:FindFirstAncestor("Utils").Parent
local ParentParent = Parent.Parent
local NodeType = require(Parent.Enums.NodeType)
local isInlineElement = require(ParentParent.InlineLayout).Utils.isInlineElement
local Dash = require(ParentParent.Dash)
local ReactIs = require(ParentParent.ReactIs)

return {
	[NodeType.Root] = {
		children = {
			[NodeType.Block] = true,
			[NodeType.TextBlock] = true
		},
		validateRenderResult = function(p1) -- line: 20
			-- upvalues: ReactIs (copy)
			return p1 ~= nil and ReactIs.isElement(p1)
		end
	},
	[NodeType.Block] = {
		children = {
			[NodeType.Block] = true,
			[NodeType.TextBlock] = true
		},
		validateRenderResult = function(p2) -- line: 29
			-- upvalues: ReactIs (copy), Dash (copy)
			return p2 == nil or (ReactIs.isElement(p2) or Dash.all(p2, ReactIs.isElement))
		end
	},
	[NodeType.TextBlock] = {
		children = {
			[NodeType.InlineSpan] = true,
			[NodeType.InlineLeaf] = true
		},
		validateRenderResult = function(p3) -- line: 38
			-- upvalues: ReactIs (copy), Dash (copy)
			return p3 == nil or (ReactIs.isElement(p3) or Dash.all(p3, ReactIs.isElement))
		end
	},
	[NodeType.InlineSpan] = {
		children = {
			[NodeType.InlineSpan] = true,
			[NodeType.InlineLeaf] = true
		},
		validateRenderResult = function(p4) -- line: 47
			-- upvalues: isInlineElement (copy), Dash (copy)
			return p4 == nil or (isInlineElement(p4) or Dash.all(p4, isInlineElement))
		end
	},
	[NodeType.InlineLeaf] = {
		children = {},
		validateRenderResult = function(p5) -- line: 53
			-- upvalues: isInlineElement (copy)
			return p5 == nil or isInlineElement(p5)
		end
	}
}
