local Markdown = script:FindFirstAncestor("Markdown")
local parent = Markdown.Parent
require(script.Parent.AdapterTypes)
local Children = require(script.Parent.Children)
require(parent.CommonMark)
local FlattenBlocks = require(script.Parent.FlattenBlocks)
local Passes = require(script.Parent.Passes)
require(script.Parent.Registry)
local RendererNodes = require(script.Parent.RendererNodes)
require(Markdown.Types)

local function newToken(p) -- 7 equivalent calls inferred from this helper
	p.lastToken += 1
	return p.lastToken
end

local function append(p, p2, p3: string, p4)
	local v = RendererNodes.append(p2, p3, p4)

	if not RendererNodes.isInline(v) then
		p.depths[v] = (p.depths[p2] or 0) + 1

		if Passes.isDroppable(p3) then
			p.droppable[v] = p2
		end
	end

	return v
end

local function emitText(state, p, p2: string, lastTextToken: number)
	if p2 == "" then
		return
	end

	local lastText = state.lastText

	if lastText ~= nil and state.lastTextToken == lastTextToken and state.registry.passes.mergeText then
		local children = p.children

		if children[#children] == lastText then
			local textPart = state.textParts[lastText]

			if textPart == nil then
				state.textParts[lastText] = { lastText.text, p2 }
			else
				table.insert(textPart, p2)
			end

			return
		end
	end

	state.lastText = RendererNodes.appendText(p, p2)
	state.lastTextToken = lastTextToken
end

local function inlineChainFrame(firstChild, into, token: number, depth: number) -- 5 equivalent calls inferred from this helper
	return {
		kind = "inlines",
		into = into,
		cursor = firstChild,
		index = 0,
		token = token,
		depth = depth
	}
end

local function hasBlockChild(object): boolean
	local firstChild = object:getFirstChild()

	while firstChild ~= nil do
		if firstChild.isBlock then
			return true
		end

		firstChild = firstChild:getNext()
	end

	return false
end

local function childrenFrame(p, node, into, p2: number?, p3: number)
	if RendererNodes.holdsBlocks(into) then
		return {
			kind = "units",
			into = into,
			units = Children.units(node, p.registry, false),
			index = 0
		}
	end

	if not RendererNodes.isInline(into) then
		local firstChild = node:getFirstChild()
		local flag

		while true do
			if firstChild == nil then
				flag = false
				break
			end

			if firstChild.isBlock then
				flag = true
				break
			end

			firstChild = firstChild:getNext()
		end

		if flag then
			return {
				kind = "flatten",
				into = into,
				node = node,
				index = 0,
				inlineOnly = p.registry.blockInText == "drop"
			}
		end
	end

	local firstChild = node:getFirstChild()

	if not p2 then
		p2 = newToken(p) -- inferred equivalent call
	end

	return inlineChainFrame(firstChild, into, p2, p.depths[into] or p3) -- inferred equivalent call
end

local class = {}
class.__index = class

local function newContext(run, parent2, token: number?, depth: number) -- 1 equivalent call inferred from this helper
	local v = {
		parent = parent2,
		depth = depth,
		isFirstTopLevel = parent2 == run.root and #parent2.children == 0,
		options = run.options,
		_run = run,
		_token = token,
		_pending = nil,
		_closed = false
	}
	return (setmetatable(v, class))
end

local function schedule(state, p) -- 4 equivalent calls inferred from this helper
	if state._closed then
		error("An adapter context schedules work only while its handler runs")
	end

	local pending = state._pending

	if pending == nil then
		state._pending = { p }
	else
		table.insert(pending, p)
	end
end

local function tokenOf(state)
	local token = state._token

	if token ~= nil then
		return token
	end

	local token2 = newToken(state._run) -- inferred equivalent call
	state._token = token2
	return token2
end

function class:block(p: string, p2)
	return append(self._run, self.parent, p, p2)
end

function class:append(p, p2: string, p3)
	return append(self._run, p, p2, p3)
end

function class:text(p: string)
	if RendererNodes.holdsBlocks(self.parent) then
		error(`ctx:text needs an inline target, not {self.parent.name}`)
	end

	local run = self._run
	local parent2 = self.parent
	local token = self._token

	if token == nil then
		token = newToken(self._run) -- inferred equivalent call
		self._token = token
	end

	emitText(run, parent2, p, token)
end

function class:adaptChildrenOf(node, p)
	schedule(self, childrenFrame(self._run, node, p or self.parent, self._token, self.depth)) -- inferred equivalent call
end

function class:adaptInlinesOf(object, into)
	local firstChild = object:getFirstChild()
	local token = self._token

	if token == nil then
		token = newToken(self._run) -- inferred equivalent call
		self._token = token
	end

	schedule(self, inlineChainFrame(firstChild, into, token, self._run.depths[into] or self.depth)) -- inferred equivalent call
end

function class.flatten(state, node, into, options)
	schedule(state, { -- inferred equivalent call
		kind = "flatten",
		into = into,
		node = node,
		options = options,
		index = 0
	})
end

function class.childrenOf(_, object)
	local v = object:getFirstChild()
	return function()
		local v2 = v

		if v2 ~= nil then
			v = v2:getNext()
		end

		return v2
	end
end

function class:plainText(object)
	local registry = self._run.registry

	local v = object:getFirstChild()
	local v2 = {}

	while v ~= nil do
		local v3 = registry.inline[v.kind] or registry.unknownInline
		local flag = false

		if v3.form == "text" then
			table.insert(v2, v3.text(v))
		elseif v3.form ~= "drop" then
			local v4 = v.kind == "HardLineBreak" and "\n" or v.literal

			if type(v4) == "string" then
				table.insert(v2, v4)
			end

			flag = true
		end

		local v4

		if flag then
			v4 = v:getFirstChild()
		end

		if v4 == nil then
			while v ~= object and v:getNext() == nil do
				v = v:getParent()
			end

			if v == object then
				v = nil
			else
				v = v:getNext()
			end
		else
			v = v4
		end
	end

	return table.concat(v2)
end

function class:gap(kind, node)
	table.insert(self._run.gaps, { kind = kind, node = node })
end

function class:_units(p, flag: boolean)
	return Children.units(p, self._run.registry, flag)
end

function class._flattenUnits(state, units, into, options, node)
	schedule(state, { -- inferred equivalent call
		kind = "flatten",
		into = into,
		units = units,
		options = options,
		node = node,
		index = 0
	})
end

local function callHandler(run, handler, p, parent2, token: number?, depth: number)
	local context = newContext(run, parent2, token, depth) -- inferred equivalent call
	handler(p, context)
	context._closed = true
	local pending = context._pending

	if pending ~= nil then
		for i = #pending, 1, -1 do
			table.insert(run.stack, pending[i])
		end
	end
end

local function adaptUnit(run, unit, into)
	local block = unit.block

	if block == nil then
		local into2 = append(run, into, "PARAGRAPH")
		local stack = run.stack
		local v = {
			kind = "inlines",
			into = into2,
			list = unit.inlines,
			index = 0,
			token = newToken(run), -- inferred equivalent call
			depth = run.depths[into2]
		}
		table.insert(stack, v)
	else
		local registry = run.registry
		local v = registry.block[block.kind] or registry.unknownBlock

		if v.form == "as" then
			local v2

			if v.attributes ~= nil then
				v2 = v.attributes(block)
			end

			local into2 = append(run, into, v.as, v2)
			table.insert(run.stack, (childrenFrame(run, block, into2, nil, run.depths[into2])))
		elseif v.form == "handler" then
			callHandler(run, v.handler, block, into, nil, run.depths[into] or 0)
		end
	end
end

local function adaptInline(run, object, data)
	local registry = run.registry
	local v = registry.inline[object.kind] or registry.unknownInline
	local form = v.form
	local into = data.into
	local token = data.token

	if form == "text" then
		emitText(run, into, v.text(object), token)
	elseif form == "style" then
		local into2 = append(run, into, "STYLED_TEXT", { style = v.style })
		local firstChild = object:getFirstChild()

		if firstChild ~= nil then
			table.insert(run.stack, inlineChainFrame(firstChild, into2, token, data.depth)) -- inferred equivalent call
		end
	elseif form == "children" then
		local firstChild = object:getFirstChild()

		if firstChild ~= nil then
			table.insert(run.stack, inlineChainFrame(firstChild, into, token, data.depth)) -- inferred equivalent call
		end
	elseif form == "handler" then
		callHandler(run, v.handler, object, into, token, data.depth)
	end
end

local frozen = table.freeze({})

local function startFlatten(p, state)
	local options = state.options or frozen
	local units = state.units or Children.units(state.node, p.registry, false)
	local except = options.except
	local units2

	if except == nil and not state.inlineOnly then
		units2 = units
	else
		units2 = {}
		local afterExcept = {}
		local v = false

		for _, unit in units do
			if except == nil or unit.block ~= except then
				if not state.inlineOnly or unit.block == nil then
					table.insert(units2, unit)
					afterExcept[unit] = v
				end
			else
				v = true
			end
		end

		state.afterExcept = afterExcept
	end

	state.flattening = FlattenBlocks.start(units2, state.into, p.registry, options.drop)
end

local function finishFlatten(p, data)
	local gap = (data.options or frozen).gap

	if gap == nil then
		return
	end

	local drawnUnits = FlattenBlocks.drawnUnits(data.flattening)
	local v

	if #drawnUnits > 1 then
		v = true
	elseif #drawnUnits == 1 then
		v = not Children.isParagraphLike(drawnUnits[1])
	else
		v = false
	end

	local afterExcept = data.afterExcept

	if afterExcept ~= nil then
		for _, drawnUnit in drawnUnits do
			v = v or afterExcept[drawnUnit] == true
		end
	end

	if v then
		local v2 = { kind = gap, node = data.node }
		table.insert(p.gaps, v2)
	end
end

local function stepFlatten(p, p2)
	if p2.flattening == nil then
		startFlatten(p, p2)
	end

	local list, v = FlattenBlocks.resume(p2.flattening)

	if list == nil and v == nil then
		table.remove(p.stack)
		finishFlatten(p, p2)
	else
		local into = p2.into
		local depth = p.depths[into] or 0

		if list == nil then
			local stack = p.stack
			local firstChild = v:getFirstChild()
			table.insert(stack, inlineChainFrame(firstChild, into, newToken(p), depth)) -- inferred equivalent call
		else
			local stack = p.stack
			local v2 = {
				kind = "inlines",
				into = into,
				list = list,
				index = 0,
				token = newToken(p), -- inferred equivalent call
				depth = depth
			}
			table.insert(stack, v2)
		end
	end
end

local function drain(run)
	local stack = run.stack

	while #stack > 0 do
		local v = stack[#stack]
		local kind = v.kind

		if kind == "units" then
			v.index += 1
			local unit = v.units[v.index]

			if unit == nil then
				table.remove(stack)
			else
				adaptUnit(run, unit, v.into)
			end
		elseif kind == "inlines" then
			local list = v.list
			local v2

			if list == nil then
				v2 = v.cursor

				if v2 ~= nil then
					v.cursor = v2:getNext()
				end
			else
				v.index += 1
				v2 = list[v.index]
			end

			if v2 == nil then
				stack[#stack] = nil
			else
				adaptInline(run, v2, v)
			end
		else
			stepFlatten(run, v)
		end
	end
end

local frozen2 = table.freeze({})
return {
	adapt = function(registry, node, p)
		local root = RendererNodes.create("ROOT")
		root.index = 1
		root.offset = 1
		local run = {
			registry = registry,
			root = root,
			stack = {},
			gaps = {},
			options = p or frozen2,
			lastText = nil,
			lastTextToken = 0,
			textParts = {},
			droppable = {},
			depths = { [root] = 0 },
			lastToken = 0
		}

		table.insert(run.stack, (childrenFrame(run, node, root, nil, 0)))
		drain(run)
		Passes.finish(run.textParts, run.droppable, registry.passes)
		return root, run.gaps
	end
}
