local v5 = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Logger"):new("processChildren")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/Cryo")
require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Types")
local NodeType = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Enums/NodeType")

local PlaintextRenderer = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Renderer/NodeRenderers/PlaintextRenderer")
local EngineTagRenderer = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Renderer/NodeRenderers/EngineTagRenderer")
local InlineCustomRenderer = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Renderer/NodeRenderers/InlineCustomRenderer")
local NodeConfig = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/NodeConfig")

local modules = {
	[NodeType.Plaintext] = PlaintextRenderer,
	[NodeType.EngineTag] = EngineTagRenderer,
	[NodeType.InlineCustom] = InlineCustomRenderer
}

local function processChildren(data, p2)
	local result = {}
	local v6 = NodeConfig.getByNode(data)

	if not v6 then
		v5:warning(`Node {data.name}: No config found for node type {data.type}`)
		return result
	end

	local mapped = Cryo.List.map(data.children, function(p3)
		local v7 = NodeConfig.getByNode(p3)

		if not v7 then
			v5:warning(`Node {p3.name}: No config found for node {p3.name} type {p3.type}`)
			return {}
		end

		if not v6.children[p3.type] then
			v5:warning(`Node {p3.name}: Node type {p3.type} is not a valid child of node {data.name} type {data.type}`)

			return {}
		end

		local v8 = modules[p3.type]

		if not v8 then
			v5:warning(`Node {p3.name}: No renderer found for type {p3.type}`)
			return {}
		end

		local v9 = v8(p3, p2)
		local v10 = typeof(v9) ~= "table" and { v9 } or v9

		if Cryo.List.foldLeft(v10, function(p4, p5)
			return p4 and v7.validateRenderResult(p5)
		end, true) then
			return v10
		end

		v5:warning(`Node {p3.name}: Rendered result is not valid for type {p3.type}`)
		return {}
	end)

	for k, v7 in mapped do
		for k2, v8 in v7 do
			table.insert(result, v8)
		end
	end

	return result
end

return processChildren
