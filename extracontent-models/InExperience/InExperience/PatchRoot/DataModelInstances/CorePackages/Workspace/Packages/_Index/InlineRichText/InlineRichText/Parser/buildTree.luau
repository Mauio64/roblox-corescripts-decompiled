local InlineRichText = script:FindFirstAncestor("InlineRichText")
local parent = InlineRichText.Parent
require(InlineRichText.Types)
local Logger = require(InlineRichText.Logger)
local v = Logger:new(script.Name)

local Cryo = require(parent.Cryo)
local NodeConfig = require(InlineRichText.NodeConfig)
local NodeStack = require(InlineRichText.Parser.NodeStack)
local NodeType = require(InlineRichText.Enums.NodeType)
local TokenName = require(InlineRichText.Enums.TokenName)

local v2 = {
	[TokenName.Text] = function(object, p, _)
		local v2 = object:peek()

		if not v2 or v2.type ~= NodeType.Plaintext then
			local _, v3 = object:pushDefault(NodeType.Plaintext)

			if not v3 then
				v:error("Failed to push default plaintext node to add text to")
				return nil
			end
		end

		local v3 = object:peek()
		v3.text = `{v3.text}{p.text}`
	end,
	[TokenName.Break] = function(object, _, _)
		local v2, v3 = object:push({
			type = NodeType.InlineCustom,
			name = "BREAK",
			text = "",
			children = {},
			attributes = {}
		})

		local _, v4 = object:findAndClose("BREAK")

		if not (v3 and v4) then
			v:error("Failed to push break node")
			return nil
		end

		for _, v5 in Cryo.List.reverse(v2) do
			local v6 = object:peek()
			local v7 = v6 and NodeConfig.getByNode(v6)

			if not v7 then
				break
			end

			if not v7.children[v5.type] then
				continue
			end

			local _, v8 = object:push(v5)

			if not v8 then
				v:error(`Failed to re-open node {v5.name} after break`)
				return nil
			end
		end
	end,
	[TokenName.Open] = function(object, p, p2)
		local v2 = p2.TagAliases[p.text] or p.text
		local tagConfiguration = p2.TagConfigurations[v2]

		if not tagConfiguration then
			v:error(`No configuration open tag name {v2}`)
			return nil
		end

		local overrideName = tagConfiguration.OverrideName or v2

		local _, v3 = object:push({
			type = tagConfiguration.NodeType,
			name = overrideName,
			text = "",
			children = {},
			attributes = p.attributes
		})

		if v3 then
			return
		end

		v:error(`Failed to push open tag {overrideName}`)
		return nil
	end,
	[TokenName.Close] = function(object, p, p2)
		local v2 = p2.TagAliases[p.text] or p.text
		local tagConfiguration = p2.TagConfigurations[v2]

		if not tagConfiguration then
			v:error(`No configuration close tag name {v2}`)
			return nil
		end

		local overrideName = tagConfiguration.OverrideName or v2

		local _, v3 = object:findAndClose(overrideName)

		if v3 then
			return
		end

		v:error(`Failed to find and close tag {overrideName}`)
		return nil
	end
}

local function buildTree(items, p)
	local v3 = NodeStack.new()

	for _, item in items do
		local v4 = v2[item.name]

		if v4 then
			v4(v3, item, p)
		else
			v:error(`No processor for token name {item.name}`)
		end
	end

	return v3:buildRoot()
end

return buildTree
