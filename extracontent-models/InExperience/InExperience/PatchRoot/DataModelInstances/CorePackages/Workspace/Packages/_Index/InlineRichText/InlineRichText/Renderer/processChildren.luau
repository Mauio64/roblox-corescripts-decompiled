local InlineRichText = script:FindFirstAncestor("InlineRichText")
local parent = InlineRichText.Parent
local Logger = require(InlineRichText.Logger)
local v = Logger:new(script.Name)

local Cryo = require(parent.Cryo)
require(InlineRichText.Types)
local NodeType = require(InlineRichText.Enums.NodeType)
local NodeRenderers = script.Parent.NodeRenderers
local PlaintextRenderer = require(NodeRenderers.PlaintextRenderer)
local EngineTagRenderer = require(NodeRenderers.EngineTagRenderer)
local InlineCustomRenderer = require(NodeRenderers.InlineCustomRenderer)
local NodeConfig = require(InlineRichText.NodeConfig)

local v2 = {
	[NodeType.Plaintext] = PlaintextRenderer,
	[NodeType.EngineTag] = EngineTagRenderer,
	[NodeType.InlineCustom] = InlineCustomRenderer
}

local function processChildren(data, p)
	local result = {}
	local v3 = NodeConfig.getByNode(data)

	if not v3 then
		v:warning(`Node {data.name}: No config found for node type {data.type}`)
		return result
	end

	local mapped = Cryo.List.map(data.children, function(p2)
		local v4 = NodeConfig.getByNode(p2)

		if not v4 then
			v:warning(`Node {p2.name}: No config found for node {p2.name} type {p2.type}`)
			return {}
		end

		if not v3.children[p2.type] then
			v:warning(`Node {p2.name}: Node type {p2.type} is not a valid child of node {data.name} type {data.type}`)

			return {}
		end

		local v5 = v2[p2.type]

		if not v5 then
			v:warning(`Node {p2.name}: No renderer found for type {p2.type}`)
			return {}
		end

		local v6 = v5(p2, p)
		local selected = typeof(v6) ~= "table" and { v6 } or v6

		if Cryo.List.foldLeft(selected, function(p3, p4)
			return p3 and v4.validateRenderResult(p4)
		end, true) then
			return selected
		end

		v:warning(`Node {p2.name}: Rendered result is not valid for type {p2.type}`)
		return {}
	end)

	for _, v4 in mapped do
		for _, v5 in v4 do
			table.insert(result, v5)
		end
	end

	return result
end

return processChildren
