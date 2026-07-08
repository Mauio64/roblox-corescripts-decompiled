local InlineRichText = script:FindFirstAncestor("InlineRichText")
local InlineRichTextParent = InlineRichText.Parent
local v3 = require(InlineRichText.Logger):new(script.Name)
local Cryo = require(InlineRichTextParent.Cryo)

require(InlineRichText.Types)

local NodeType = require(InlineRichText.Enums.NodeType)
local NodeRenderers = script.Parent.NodeRenderers
local PlaintextRenderer = require(NodeRenderers.PlaintextRenderer)
local EngineTagRenderer = require(NodeRenderers.EngineTagRenderer)
local InlineCustomRenderer = require(NodeRenderers.InlineCustomRenderer)
local NodeConfig = require(InlineRichText.NodeConfig)
local t1 = {
	[NodeType.Plaintext] = PlaintextRenderer,
	[NodeType.EngineTag] = EngineTagRenderer,
	[NodeType.InlineCustom] = InlineCustomRenderer
}

local function processChildren(p1, p2) -- line: 20
	-- upvalues: NodeConfig (copy), v3 (copy), Cryo (copy), t1 (copy)
	local t2 = {}
	local v16 = NodeConfig.getByNode(p1)

	if not v16 then
		v3:warning(`Node { p1.name }: No config found for node type { p1.type }`)

		return t2
	end

	for _, v18 in (Cryo.List.map(p1.children, function(p3) -- line: 28
		-- upvalues: NodeConfig (copy), v3 (copy), v16 (copy), p1 (copy), t1 (copy), p2 (copy), Cryo (copy)
		local v22 = NodeConfig.getByNode(p3)

		if not v22 then
			v3:warning(`Node { p3.name }: No config found for node { p3.name } type { p3.type }`)

			return {}
		end

		if not v16.children[p3.type] then
			v3:warning(`Node { p3.name }: Node type { p3.type } is not a valid child of node { p1.name } type { p1.type }`)

			return {}
		end

		local v23 = t1[p3.type]

		if v23 then
			local v24 = v23(p3, p2)

			if typeof(v24) ~= "table" then
				v24 = { v24 }
			end

			if not Cryo.List.foldLeft(v24, function(p4, p5) -- line: 49
				-- upvalues: v22 (copy)
				return p4 and v22.validateRenderResult(p5)
			end, true) then
				v3:warning(`Node { p3.name }: Rendered result is not valid for type { p3.type }`)

				return {}
			end

			return v24
		end

		v3:warning(`Node { p3.name }: No renderer found for type { p3.type }`)

		return {}
	end)) do
		for _, v20 in v18 do
			table.insert(t2, v20)
		end
	end

	return t2
end

return processChildren
