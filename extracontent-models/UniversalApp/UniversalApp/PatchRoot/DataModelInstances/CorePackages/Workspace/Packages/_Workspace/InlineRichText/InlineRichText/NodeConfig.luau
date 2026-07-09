local InlineRichText = script:FindFirstAncestor("InlineRichText")
local InlineRichTextParent = InlineRichText.Parent
local RunService = game:GetService("RunService")

require(InlineRichText.Types)

local NodeType = require(InlineRichText.Enums.NodeType)
local v5 = require(InlineRichText.Logger):new(script.Name)
local Cryo = require(InlineRichTextParent.Cryo)
local isDescendant = require(InlineRichText.Utils.isDescendant)
local ReactIs = require(InlineRichTextParent.ReactIs)
local isInlineElement = require(InlineRichTextParent.InlineLayout).Utils.isInlineElement
local v10 = RunService:IsStudio()
local t1 = {
	getDefault = function() -- line: 50
		-- upvalues: NodeType (copy)
		return {
			name = "ROOT",
			text = "",
			type = NodeType.Root,
			children = {},
			attributes = {}
		}
	end,
	children = {
		[NodeType.InlineCustom] = true
	},
	validateRenderResult = function(p1) -- line: 60
		-- upvalues: ReactIs (copy)
		return ReactIs.isElement(p1)
	end
}
local t2 = {
	[NodeType.InlineCustom] = {
		defaultParent = NodeType.Root,
		getDefault = function() -- line: 67
			-- upvalues: NodeType (copy)
			return {
				name = "TEXT_SPAN",
				text = "",
				type = NodeType.InlineCustom,
				children = {},
				attributes = {}
			}
		end,
		children = {
			[NodeType.EngineTag] = true,
			[NodeType.Plaintext] = true
		},
		validateRenderResult = function(p2) -- line: 80
			-- upvalues: isInlineElement (copy)
			return isInlineElement(p2)
		end
	},
	[NodeType.EngineTag] = {
		defaultParent = NodeType.InlineCustom,
		children = {
			[NodeType.EngineTag] = true,
			[NodeType.Plaintext] = true
		},
		validateRenderResult = function(_) -- line: 91
			return true
		end
	},
	[NodeType.Plaintext] = {
		defaultParent = NodeType.InlineCustom,
		getDefault = function() -- line: 97
			-- upvalues: NodeType (copy)
			return {
				name = "TEXT",
				text = "",
				type = NodeType.Plaintext,
				children = {},
				attributes = {}
			}
		end,
		children = {},
		validateRenderResult = function(_) -- line: 107
			return true
		end
	}
}
local v13 = Cryo.Dictionary.union(t2, {
	[NodeType.Root] = t1
})

if _G.__DEV__ or v10 then
	for v14, v15 in t2 do
		if not isDescendant(v13, "InlineRichTextNodeConfigGraph", NodeType.Root, v14) then
			error(`NodeConfigNonRoot: Node type { v14 } does not descend from the root node`)
		end

		if isDescendant(v13, "InlineRichTextNodeConfigGraph", v14, NodeType.Root) then
			error(`NodeConfigNonRoot: Node type { v14 } descends from the root node`)
		end

		if v15.getDefault and v14 ~= v15.getDefault().type then
			error(`NodeConfigNonRoot: Node type { v14 } getDefault function returns a node with type { v15.getDefault().type } instead of { v14 }`)
		end

		if not v15.defaultParent then
			error(`NodeConfigNonRoot: Node type { v14 } has no defaultParent`)
		end

		if not v13[v15.defaultParent].getDefault then
			error(`NodeConfigNonRoot: Node type { v15.defaultParent } has no getDefault function, but { v14 } has it as its defaultParent`)
		end
	end
end

return {
	getByType = function(p5) -- line: 115
		-- upvalues: v13 (copy), v5 (copy)
		local v21 = v13[p5]

		if not v21 then
			v5:error(`getByType: No config found for node type { p5 }`)

			return nil
		end

		return v21
	end,
	getByNode = function(p6) -- line: 124
		-- upvalues: v5 (copy), v13 (copy)
		if not p6 then
			v5:error("getByNode: No node provided")

			return nil
		end

		local type = p6.type
		local v24 = v13[type]

		if not v24 then
			v5:error(`getByType: No config found for node type { type }`)

			return nil
		end

		return v24
	end,
	isDescendant = function(p7, p8) -- line: 133
		-- upvalues: isDescendant (copy), v13 (copy)
		return isDescendant(v13, "InlineRichTextNodeConfigGraph", p7.type, p8.type)
	end
}
