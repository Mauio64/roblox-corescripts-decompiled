local parent = script:FindFirstAncestor("Markdown").Parent
require(parent.CommonMark)
local FormattingTag = require(script.Parent.FormattingTag)

local tags = FormattingTag.TAGS

local FormattingTagPostProcessor = {}
FormattingTagPostProcessor.__index = FormattingTagPostProcessor

function FormattingTagPostProcessor.new(maxNesting: number?)
	return (setmetatable({ _maxNesting = maxNesting }, FormattingTagPostProcessor))
end

local function tagOf(p) -- 1 equivalent call inferred from this helper
	if p.kind == "FormattingTagText" or p.kind == "HtmlInline" then
		return tags[p.literal]
	end

	return nil
end

local function containersTopDown(p)
	local result = { [p] = 0 }
	local firstChilds = { p }
	local result2 = {}

	while #firstChilds > 0 do
		local v = table.remove(firstChilds)

		if v:getFirstChild() == nil then
			continue
		end

		table.insert(result2, v)
		local firstChild = v:getFirstChild()

		while firstChild do
			result[firstChild] = result[v] + (firstChild.isBlock and 0 or 1)
			table.insert(firstChilds, firstChild)
			firstChild = firstChild:getNext()
		end
	end

	return result2, result
end

local function wrap(object, object2, name, p, p2: number?): boolean
	local nextNode = object:getNext()
	local maxValue = 0

	while nextNode ~= object2 do
		maxValue = math.max(maxValue, p[nextNode] or 0)
		nextNode = nextNode:getNext()
	end

	if p2 ~= nil and p2 <= maxValue then
		return false
	end

	local v = FormattingTag.new(name)
	object:insertBefore(v)
	local v2 = object:getNext()

	while v2 ~= object2 do
		local nextNode2 = v2:getNext()
		v:appendChild(v2)
		v2 = nextNode2
	end

	object:unlink()
	object2:unlink()
	p[v] = maxValue + 1
	return true
end

local function pairChildren(object, p, p2: number?)
	local v = object:getFirstChild()
	local v2 = { b = {}, i = {}, u = {}, s = {} }
	local v3 = {}
	local v4 = {}

	while v ~= nil do
		local nextNode = v:getNext()
		local v5 = tagOf(v) -- inferred equivalent call

		if v5 ~= nil then
			local v6 = v2[v5.name]

			if v5.closing then
				local v7 = v6[#v6]

				if v7 ~= nil then
					local v8 = v3[v7]

					for i = #v3, v7, -1 do
						table.remove(v2[v4[i]])
						v3[i] = nil
						v4[i] = nil
					end

					if not wrap(v8, v, v5.name, p, p2) then
						for i = #v3, 1, -1 do
							table.remove(v2[v4[i]])
							v3[i] = nil
							v4[i] = nil
						end
					end
				end
			else
				table.insert(v3, v)
				table.insert(v4, v5.name)
				table.insert(v6, #v3)
			end
		end

		v = nextNode
	end
end

function FormattingTagPostProcessor:process(p)
	local v, v2 = containersTopDown(p)
	local maxNesting = self._maxNesting
	local v3 = {}

	for i = #v, 1, -1 do
		local v4 = v[i]
		local v5

		if maxNesting ~= nil then
			v5 = maxNesting - v2[v4]
		end

		pairChildren(v4, v3, v5)

		if v4.isBlock then
			continue
		end

		local firstChild = v4:getFirstChild()
		local maxValue = 0

		while firstChild ~= nil do
			maxValue = math.max(maxValue, v3[firstChild] or 0)
			firstChild = firstChild:getNext()
		end

		v3[v4] = maxValue + 1
	end

	return p
end

return FormattingTagPostProcessor
