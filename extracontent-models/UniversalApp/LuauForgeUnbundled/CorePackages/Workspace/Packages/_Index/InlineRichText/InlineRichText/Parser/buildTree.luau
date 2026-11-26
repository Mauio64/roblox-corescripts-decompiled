require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Types")
local v5 = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Logger"):new("buildTree")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/InlineRichText/Cryo")
local NodeConfig = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/NodeConfig")
local NodeStack = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Parser/NodeStack")
local NodeType = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Enums/NodeType")
local TokenName = require("@game/CorePackages/Workspace/Packages/_Index/InlineRichText/InlineRichText/Enums/TokenName")

local v6 = {
	[TokenName.Text] = function(object, p2, p3)
		local v7 = object:peek()

		if not v7 or v7.type ~= NodeType.Plaintext then
			local v8, v9 = object:pushDefault(NodeType.Plaintext)

			if not v9 then
				v5:error("Failed to push default plaintext node to add text to")
				return nil
			end
		end

		local v8 = object:peek()
		v8.text = `{v8.text}{p2.text}`
	end,
	[TokenName.Break] = function(object, p2, p3)
		local v7, v8 = object:push({
			type = NodeType.InlineCustom,
			name = "BREAK",
			text = "",
			children = {},
			attributes = {}
		})

		local close, v9 = object:findAndClose("BREAK")

		if not (v8 and v9) then
			v5:error("Failed to push break node")
			return nil
		end

		for k, v10 in Cryo.List.reverse(v7) do
			local v11 = object:peek()
			local v12 = v11 and NodeConfig.getByNode(v11)

			if not v12 then
				break
			end

			if not v12.children[v10.type] then
				continue
			end

			local v13, v14 = object:push(v10)

			if not v14 then
				v5:error(`Failed to re-open node {v10.name} after break`)
				return nil
			end
		end
	end,
	[TokenName.Open] = function(object, p2, p3)
		local v7 = p3.TagAliases[p2.text] or p2.text
		local tagConfiguration = p3.TagConfigurations[v7]

		if not tagConfiguration then
			v5:error(`No configuration open tag name {v7}`)
			return nil
		end

		local overrideName = tagConfiguration.OverrideName or v7

		local v8, v9 = object:push({
			type = tagConfiguration.NodeType,
			name = overrideName,
			text = "",
			children = {},
			attributes = p2.attributes
		})

		if v9 then
			return
		end

		v5:error(`Failed to push open tag {overrideName}`)
		return nil
	end,
	[TokenName.Close] = function(object, p2, p3)
		local v7 = p3.TagAliases[p2.text] or p2.text
		local tagConfiguration = p3.TagConfigurations[v7]

		if not tagConfiguration then
			v5:error(`No configuration close tag name {v7}`)
			return nil
		end

		local overrideName = tagConfiguration.OverrideName or v7

		local close, v8 = object:findAndClose(overrideName)

		if v8 then
			return
		end

		v5:error(`Failed to find and close tag {overrideName}`)
		return nil
	end
}

local function buildTree(items, p2)
	local v7 = NodeStack.new()

	for k, item in items do
		local v8 = v6[item.name]

		if v8 then
			v8(v7, item, p2)
		else
			v5:error(`No processor for token name {item.name}`)
		end
	end

	return v7:buildRoot()
end

return buildTree
