local Markdown = script:FindFirstAncestor("Markdown")
local parent = Markdown.Parent
local Children = require(script.Parent.Children)
require(parent.CommonMark)
local ListMarkers = require(script.Parent.ListMarkers)
require(script.Parent.Registry)
local RendererNodes = require(script.Parent.RendererNodes)
require(Markdown.Types)

local frozen = table.freeze({})

local function codeLines(value: string?)
	local v = value or ""

	if string.sub(v, -1) == "\n" then
		v = string.sub(v, 1, -2)
	end

	return string.split(v, "\n")
end

local function pushInOrder(list, list2) -- 3 equivalent calls inferred from this helper
	for i = #list2, 1, -1 do
		table.insert(list, list2[i])
	end
end

local function beginLine(state, entry)
	local out = state._out
	local v = {
		entry = entry,
		mark = #out.children,
		startedBefore = state._startedLine,
		contentStart = 0
	}

	if state._startedLine then
		RendererNodes.append(out, "BREAK")

		if entry.separator == "paragraph" then
			RendererNodes.append(out, "BREAK")
		end
	end

	state._startedLine = true

	if entry.prefix ~= nil then
		RendererNodes.appendText(out, entry.prefix)
	end

	local contentStart

	if entry.prefix == nil then
		contentStart = #out.children
	else
		contentStart = v.mark
	end

	v.contentStart = contentStart
	return v
end

local function endLine(state, data) -- 6 equivalent calls inferred from this helper
	local children = state._out.children

	if #children > data.contentStart then
		state._drew[data.entry.top] = true
		return
	end

	for i = #children, data.mark + 1, -1 do
		children[i] = nil
	end

	state._startedLine = data.startedBefore
end

local FlattenBlocks = {}

function FlattenBlocks.start(units, out, registry, p)
	local v = {}
	local stack = {}

	for k, item in units do
		table.insert(v, { unit = item, separator = "paragraph", level = 0, top = k })
	end

	pushInOrder(stack, v) -- inferred equivalent call
	return {
		_units = units,
		_out = out,
		_registry = registry,
		_drop = p or frozen,
		_stack = stack,
		_startedLine = #out.children > 0,
		_drew = {},
		_openLine = nil
	}
end

function FlattenBlocks.resume(state)
	local openLine = state._openLine

	if openLine ~= nil then
		state._openLine = nil
		endLine(state, openLine) -- inferred equivalent call
	end

	local out = state._out
	local stack = state._stack

	while #stack > 0 do
		local entry = table.remove(stack)
		local block = entry.unit.block
		local kind

		if block ~= nil then
			kind = block.kind
		end

		if block == nil then
			state._openLine = beginLine(state, entry)
			return entry.unit.inlines or {}, nil
		end

		if state._drop[block.kind] then
			continue
		end

		if kind == "Paragraph" or kind == "Heading" then
			state._openLine = beginLine(state, entry)
			return nil, block
		end

		if kind == "FencedCodeBlock" or kind == "IndentedCodeBlock" then
			local v = beginLine(state, entry)
			local literal = block.literal or ""

			if string.sub(literal, -1) == "\n" then
				literal = string.sub(literal, 1, -2)
			end

			for k, v2 in string.split(literal, "\n") do
				if k > 1 then
					RendererNodes.append(out, "BREAK")
				end

				if v2 ~= "" then
					RendererNodes.appendText(out, v2)
				end
			end

			endLine(state, v) -- inferred equivalent call
		elseif kind == "HtmlBlock" then
			local v = beginLine(state, entry)
			local literal = block.literal

			if literal ~= nil and literal ~= "" then
				RendererNodes.appendText(out, literal)
			end

			endLine(state, v) -- inferred equivalent call
		elseif kind == "ThematicBreak" then
			local v = beginLine(state, entry)
			RendererNodes.appendText(out, "---")
			endLine(state, v) -- inferred equivalent call
		elseif kind == "BulletList" or kind == "OrderedList" then
			local v = entry.separator

			if entry.prefix ~= nil then
				endLine(state, beginLine(state, entry)) -- inferred equivalent call
				v = "line"
			end

			local v2 = string.rep("  ", entry.level)
			local bulletPrefix = ListMarkers.bulletPrefix(block)
			local v3 = ListMarkers.startNumber(block)
			local v4 = {}

			for _, unit in Children.units(block, state._registry, true) do
				local prefix

				if not (unit.block == nil or unit.block.kind ~= "ListItem") then
					if v3 == nil then
						prefix = v2 .. bulletPrefix
					else
						prefix = `{v2}{ListMarkers.orderedPrefix(v3)}. `
						v3 += 1
					end
				end

				table.insert(v4, {
					unit = unit,
					separator = #v4 ~= 0 and "line" or v,
					prefix = prefix,
					level = entry.level,
					top = entry.top
				})
			end

			pushInOrder(stack, v4) -- inferred equivalent call
		else
			local units = Children.units(block, state._registry, false)

			if #units == 0 then
				endLine(state, beginLine(state, entry)) -- inferred equivalent call
			end

			local level

			if kind == "ListItem" then
				level = entry.level + 1
			else
				level = entry.level
			end

			local v = kind == "ListItem" and "line" or "paragraph"
			local v2 = {}

			for k, unit in units do
				local separator

				if k == 1 then
					separator = entry.separator
				else
					separator = v
				end

				local prefix

				if k == 1 then
					prefix = entry.prefix
				end

				local v3 = {
					unit = unit,
					separator = separator,
					prefix = prefix,
					level = level,
					top = entry.top
				}
				table.insert(v2, v3)
			end

			pushInOrder(stack, v2) -- inferred equivalent call
		end
	end

	return nil, nil
end

function FlattenBlocks.drawnUnits(p)
	local units = {}

	for k, unit in p._units do
		if p._drew[k] then
			table.insert(units, unit)
		end
	end

	return units
end

return FlattenBlocks
