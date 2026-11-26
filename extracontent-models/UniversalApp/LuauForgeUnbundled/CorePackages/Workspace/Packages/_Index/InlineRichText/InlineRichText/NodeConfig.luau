local RunService = game:GetService("RunService")

require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Types")
local NodeType = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Enums/NodeType")
local v5 = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Logger"):new("NodeConfig")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/Cryo")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Utils/isDescendant")
local ReactIs = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/ReactIs")

local isInlineElement = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/InlineLayout").Utils.isInlineElement

local isStudio = RunService:IsStudio()

local v6 = {
	getDefault = function()
		return {
			name = "ROOT",
			text = "",
			type = NodeType.Root,
			children = {},
			attributes = {}
		}
	end,
	children = 0,
	validateRenderResult = 0
}

local inlineCustomSet = { [NodeType.InlineCustom] = true }
v6.children = inlineCustomSet
function v6.validateRenderResult(p2)
	return ReactIs.isElement(p2)
end

local inlineCustom = NodeType.InlineCustom
local v8 = {
	defaultParent = NodeType.Root,
	getDefault = function()
		return {
			name = "TEXT_SPAN",
			text = "",
			type = NodeType.InlineCustom,
			children = {},
			attributes = {}
		}
	end,
	children = 0,
	validateRenderResult = 0
}

local set = { [NodeType.EngineTag] = true, [NodeType.Plaintext] = true }
v8.children = set

function v8.validateRenderResult(p2)
	return isInlineElement(p2)
end

local v7 = { [inlineCustom] = v8 }

local engineTag = NodeType.EngineTag
local v9 = {
	defaultParent = NodeType.InlineCustom,
	children = 0,
	validateRenderResult = 0
}

local set2 = { [NodeType.EngineTag] = true, [NodeType.Plaintext] = true }
v9.children = set2

function v9.validateRenderResult(p2): boolean
	return true
end

v7[engineTag] = v9

v7[NodeType.Plaintext] = {
	defaultParent = NodeType.InlineCustom,
	getDefault = function()
		return {
			name = "TEXT",
			text = "",
			type = NodeType.Plaintext,
			children = {},
			attributes = {}
		}
	end,
	children = {},
	validateRenderResult = function(p2): boolean
		return true
	end
}

local v11 = Cryo.Dictionary.union(v7, { [NodeType.Root] = v6 })

local function getByType(p2)
	local v12 = v11[p2]

	if v12 then
		return v12
	end

	v5:error(`getByType: No config found for node type {p2}`)
	return nil
end

local function getByNode(p2)
	if not p2 then
		v5:error("getByNode: No node provided")
		return nil
	end

	local kind = p2.type
	local v12 = v11[kind]

	if v12 then
		return v12
	end

	v5:error(`getByType: No config found for node type {kind}`)
	return nil
end

local function fn(p2, p3)
	return module3(v11, "InlineRichTextNodeConfigGraph", p2.type, p3.type)
end

if _G.__DEV__ or isStudio then
	for k, v12 in v7 do
		if not module3(v11, "InlineRichTextNodeConfigGraph", NodeType.Root, k) then
			error(`NodeConfigNonRoot: Node type {k} does not descend from the root node`)
		end

		if module3(v11, "InlineRichTextNodeConfigGraph", k, NodeType.Root) then
			error(`NodeConfigNonRoot: Node type {k} descends from the root node`)
		end

		if v12.getDefault and v12.getDefault().type ~= k then
			error(`NodeConfigNonRoot: Node type {k} getDefault function returns a node with type {v12.getDefault().type} instead of {k}`)
		end

		if not v12.defaultParent then
			error(`NodeConfigNonRoot: Node type {k} has no defaultParent`)
		end

		if not v11[v12.defaultParent].getDefault then
			error(`NodeConfigNonRoot: Node type {v12.defaultParent} has no getDefault function, but {k} has it as its defaultParent`)
		end
	end
end

return { getByType = getByType, getByNode = getByNode, isDescendant = fn }
