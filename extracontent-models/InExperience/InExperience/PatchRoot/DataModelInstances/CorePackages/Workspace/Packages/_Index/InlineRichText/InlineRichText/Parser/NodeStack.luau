local InlineRichText = script:FindFirstAncestor("InlineRichText")
local InlineRichTextParent = InlineRichText.Parent

require(InlineRichText.Types)

local NodeType = require(InlineRichText.Enums.NodeType)
local v4 = require(InlineRichText.Logger):new(script.Name)
local Cryo = require(InlineRichTextParent.Cryo)
local NodeConfig = require(InlineRichText.NodeConfig)
local t1 = {}

t1.__index = t1

function t1.new() -- line: 42
	-- upvalues: t1 (copy)
	local self = setmetatable({}, t1)

	self.__stack = {}
	self.__index = 1

	return self
end
function t1.push(p1, p2) -- line: 51
	-- upvalues: NodeConfig (copy), v4 (copy), NodeType (copy), Cryo (copy)
	if not NodeConfig.getByNode(p2) then
		return {}, false
	end

	local v11 = p1:peek()
	local t2 = {}

	while v11 and not NodeConfig.isDescendant(v11, p2) do
		if not p1:__canCloseTop() then
			v4:error("push: Cannot closeAndReduce top node. Last item in stack is not the root node")

			return t2, false
		end

		local v13 = p1:__closeTopAndReduce()

		if not v13 then
			v4:error("push: Failed to closeAndReduce top node")

			return t2, false
		end

		v11 = p1:peek()
		table.insert(t2, v13)
	end

	if not v11 and p2.type == NodeType.Root then
		p1:__push(p2)

		return t2, true
	end

	local v14 = v11 and NodeConfig.getByNode(v11)

	if v14 and v14.children[p2.type] then
		p1:__push(p2)

		return t2, true
	end

	local v15 = NodeConfig.getByNode(p2)
	local v16 = v15 and v15.defaultParent

	if not v16 then
		v4:error(`push: No default parent found for node type { p2.type }`)

		return t2, false
	end

	local v17, v18 = p1:pushDefault(v16)
	local v19 = Cryo.List.join(t2, v17)

	if not v18 then
		return v19, false
	end

	p1:__push(p2)

	return v19, true
end
function t1.pushDefault(p3, p4) -- line: 102
	-- upvalues: NodeConfig (copy), v4 (copy)
	local v22 = NodeConfig.getByType(p4)

	if not v22 or not v22.getDefault then
		v4:error(`pushDefault: No config or getDefault function found for node type { p4 }`)

		return {}, false
	end

	return p3:push((v22.getDefault()))
end
function t1.findAndClose(p5, s1: string) -- line: 112
	-- upvalues: v4 (copy)
	if not p5:__has(s1) then
		return {}, false
	end

	local t3 = {}

	repeat
		if not p5:__canCloseTop() then
			return t3, false
		end

		local v26 = p5:__closeTopAndReduce()

		if not v26 then
			v4:error("findAndClose: Failed to closeAndReduce top node")

			return t3, false
		end

		table.insert(t3, v26)
	until s1 == v26.name

	return t3, true
end
function t1.buildRoot(p6) -- line: 135
	-- upvalues: v4 (copy), NodeType (copy)
	local g28 = nil

	repeat
		if not p6:__canCloseTop() then
			g28 = true
		end

		if g28 then
			break
		end
	until not p6:__closeTopAndReduce()

	if not g28 then
		v4:error("buildRoot: Failed to closeAndReduce top node")
	end

	g28 = false

	if #p6.__stack == 0 then
		p6:pushDefault(NodeType.Root)
	end

	local v29 = p6.__stack[1]

	if v29 and v29.type ~= NodeType.Root then
		v4:error("buildRoot: Last node on stack is not the root node")
	end

	return {
		name = "ROOT",
		text = "",
		type = NodeType.Root,
		children = v29.children,
		attributes = v29.attributes,
		index = v29.index
	}
end
function t1.peek(p7) -- line: 162
	return p7.__stack[#p7.__stack]
end
function t1.__push(p8, p9) -- line: 169
	-- upvalues: Cryo (copy)
	local v33 = Cryo.Dictionary.join(p9, {
		index = p8.__index
	})

	table.insert(p8.__stack, v33)
	p8.__index = p8.__index + 1

	return nil
end
function t1.__closeTopAndReduce(p10) -- line: 179
	-- upvalues: v4 (copy), Cryo (copy)
	local v35 = p10.__stack[#p10.__stack]
	local v36 = p10.__stack[#p10.__stack - 1]

	if not v35 or not v36 then
		v4:error("closeTop: No top or next node found")

		return nil
	end

	local v37 = Cryo.Dictionary.join(v36, {
		children = Cryo.List.join(v36.children, { v35 })
	})

	table.remove(p10.__stack, #p10.__stack)
	p10.__stack[#p10.__stack] = v37

	return {
		text = "",
		name = v35.name,
		type = v35.type,
		children = {},
		attributes = v35.attributes,
		index = v35.index
	}
end
function t1.__canCloseTop(p11) -- line: 202
	return #p11.__stack > 1
end
function t1.__has(p12, s2: string) -- line: 206
	-- upvalues: Cryo (copy)
	return Cryo.List.findWhere(p12.__stack, function(p13) -- line: 207
		-- upvalues: s2 (copy)
		return p13.name == s2
	end) ~= nil
end

return t1
