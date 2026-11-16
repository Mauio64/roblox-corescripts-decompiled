local InlineRichText = script:FindFirstAncestor("InlineRichText")
local parent = InlineRichText.Parent
local RunService = game:GetService("RunService")

require(InlineRichText.Types)
local NodeType = require(InlineRichText.Enums.NodeType)
local Logger = require(InlineRichText.Logger)
local v = Logger:new(script.Name)
local Cryo = require(parent.Cryo)
local isDescendant = require(InlineRichText.Utils.isDescendant)
local ReactIs = require(parent.ReactIs)

local InlineLayout = require(parent.InlineLayout)
local isInlineElement = InlineLayout.Utils.isInlineElement

local isStudio = RunService:IsStudio()

local v2 = {
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
v2.children = inlineCustomSet
function v2.validateRenderResult(p)
	return ReactIs.isElement(p)
end

local InlineCustom = NodeType.InlineCustom
local v4 = {
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
v4.children = set

function v4.validateRenderResult(p)
	return isInlineElement(p)
end

local v3 = { [InlineCustom] = v4 }

local EngineTag = NodeType.EngineTag
local v5 = { defaultParent = NodeType.InlineCustom, children = 0, validateRenderResult = 0 }

local set2 = { [NodeType.EngineTag] = true, [NodeType.Plaintext] = true }
v5.children = set2

function v5.validateRenderResult(_): boolean
	return true
end

v3[EngineTag] = v5

v3[NodeType.Plaintext] = {
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
	validateRenderResult = function(_): boolean
		return true
	end
}

local v6 = Cryo.Dictionary.union(v3, { [NodeType.Root] = v2 })

local function getByType(kind) -- 1 equivalent call inferred from this helper
	local v7 = v6[kind]

	if v7 then
		return v7
	end

	v:error(`getByType: No config found for node type {kind}`)
	return nil
end

local function getByNode(p)
	if not p then
		v:error("getByNode: No node provided")
		return nil
	end

	return getByType(p.type) -- inferred equivalent call
end

local function fn(p, p2)
	return isDescendant(v6, "InlineRichTextNodeConfigGraph", p.type, p2.type)
end

if _G.__DEV__ or isStudio then
	for k, v7 in v3 do
		if not isDescendant(v6, "InlineRichTextNodeConfigGraph", NodeType.Root, k) then
			error(`NodeConfigNonRoot: Node type {k} does not descend from the root node`)
		end

		if isDescendant(v6, "InlineRichTextNodeConfigGraph", k, NodeType.Root) then
			error(`NodeConfigNonRoot: Node type {k} descends from the root node`)
		end

		if v7.getDefault and v7.getDefault().type ~= k then
			error(`NodeConfigNonRoot: Node type {k} getDefault function returns a node with type {v7.getDefault().type} instead of {k}`)
		end

		if not v7.defaultParent then
			error(`NodeConfigNonRoot: Node type {k} has no defaultParent`)
		end

		if not v6[v7.defaultParent].getDefault then
			error(`NodeConfigNonRoot: Node type {v7.defaultParent} has no getDefault function, but {k} has it as its defaultParent`)
		end
	end
end

return { getByType = getByType, getByNode = getByNode, isDescendant = fn }
