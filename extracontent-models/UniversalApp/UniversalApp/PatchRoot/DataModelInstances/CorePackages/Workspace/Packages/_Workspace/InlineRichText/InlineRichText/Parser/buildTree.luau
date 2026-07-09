local InlineRichText = script:FindFirstAncestor("InlineRichText")
local InlineRichTextParent = InlineRichText.Parent

require(InlineRichText.Types)

local v3 = require(InlineRichText.Logger):new(script.Name)
local Cryo = require(InlineRichTextParent.Cryo)
local NodeConfig = require(InlineRichText.NodeConfig)
local NodeStack = require(InlineRichText.Parser.NodeStack)
local NodeType = require(InlineRichText.Enums.NodeType)
local TokenName = require(InlineRichText.Enums.TokenName)
local t1 = {
	[TokenName.Text] = function(p1, p2, _) -- line: 16
		-- upvalues: NodeType (copy), v3 (copy)
		local v14 = p1:peek()

		if not v14 or v14.type ~= NodeType.Plaintext then
			local _, v16 = p1:pushDefault(NodeType.Plaintext)

			if not v16 then
				v3:error("Failed to push default plaintext node to add text to")

				return nil
			end
		end

		local v17 = p1:peek()

		v17.text = `{ v17.text }{ p2.text }`
	end,
	[TokenName.Break] = function(p4, _, _) -- line: 30
		-- upvalues: NodeType (copy), v3 (copy), Cryo (copy), NodeConfig (copy)
		local v21, v22 = p4:push({
			name = "BREAK",
			text = "",
			type = NodeType.InlineCustom,
			children = {},
			attributes = {}
		})
		local _, v24 = p4:findAndClose("BREAK")

		if not v22 or not v24 then
			v3:error("Failed to push break node")

			return nil
		end

		for _, v26 in Cryo.List.reverse(v21) do
			local v27 = p4:peek()
			local v28 = v27 and NodeConfig.getByNode(v27)

			if not v28 then
				return
			end

			if not v28.children[v26.type] then
				continue
			end

			local _, v30 = p4:push(v26)

			if not v30 then
				v3:error(`Failed to re-open node { v26.name } after break`)

				return nil
			end
		end
	end,
	[TokenName.Open] = function(p7, p8, p9) -- line: 64
		-- upvalues: v3 (copy)
		local v34 = p9.TagAliases[p8.text] or p8.text
		local v35 = p9.TagConfigurations[v34]

		if not v35 then
			v3:error(`No configuration open tag name { v34 }`)

			return nil
		end

		local v36 = v35.OverrideName or v34
		local _, v38 = p7:push({
			text = "",
			type = v35.NodeType,
			name = v36,
			children = {},
			attributes = p8.attributes
		})

		if not v38 then
			v3:error(`Failed to push open tag { v36 }`)

			return nil
		end
	end,
	[TokenName.Close] = function(p10, p11, p12) -- line: 87
		-- upvalues: v3 (copy)
		local v42 = p12.TagAliases[p11.text] or p11.text
		local v43 = p12.TagConfigurations[v42]

		if not v43 then
			v3:error(`No configuration close tag name { v42 }`)

			return nil
		end

		local v44 = v43.OverrideName or v42
		local _, v46 = p10:findAndClose(v44)

		if not v46 then
			v3:error(`Failed to find and close tag { v44 }`)

			return nil
		end
	end
}

local function buildTree(t2: {[any]: any}, p13) -- line: 106
	-- upvalues: NodeStack (copy), t1 (copy), v3 (copy)
	local v49 = NodeStack.new()

	for _, v51 in t2 do
		local v52 = t1[v51.name]

		if not v52 then
			v3:error(`No processor for token name { v51.name }`)
		else
			v52(v49, v51, p13)
		end
	end

	return v49:buildRoot()
end

return buildTree
