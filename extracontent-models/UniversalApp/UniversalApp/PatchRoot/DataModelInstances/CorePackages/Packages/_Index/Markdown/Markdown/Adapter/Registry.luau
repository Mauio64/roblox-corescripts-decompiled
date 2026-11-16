local parent = script:FindFirstAncestor("Markdown").Parent
require(script.Parent.AdapterTypes)
require(parent.CommonMark)

local frozen = table.freeze({ PARAGRAPH = true, HEADING = true, QUOTE = true })

local frozen2 = table.freeze({
	BOLD = true,
	BOLD_2 = true,
	ITALIC = true,
	ITALIC_2 = true,
	UNDERLINE = true,
	STRIKE = true,
	INLINE_CODE = true
})

local frozen3 = table.freeze({ form = "children" })
local frozen4 = table.freeze({ form = "drop" })

local function policyRule(p: string, p2: string)
	if p == "children" then
		return frozen3
	elseif p == "drop" then
		return frozen4
	end

	error(`{p2} must be "children" or "drop", not {p}`)
end

local function commonRule(p: string, handler)
	if handler == "children" then
		return frozen3
	elseif handler == "drop" then
		return frozen4
	end

	if type(handler) == "function" then
		return table.freeze({ form = "handler", handler = handler })
	end

	if type(handler) ~= "table" then
		error(`The rule for {p} must be "children", "drop", a function or a table`)
	end

	return nil
end

local function inlineRule(p: string, handler)
	local v = commonRule(p, handler)

	if v ~= nil then
		return v
	end

	if handler.style == nil then
		if type(handler.text) == "function" then
			return table.freeze({ form = "text", text = handler.text })
		end

		error(`The inline rule for {p} needs a style or a text function`)
	else
		if not frozen2[handler.style] then
			error(`The rule for {p} has an unknown style {handler.style}`)
		end

		return table.freeze({ form = "style", style = handler.style })
	end
end

local function blockRule(p: string, handler)
	local v = commonRule(p, handler)

	if v ~= nil then
		return v
	end

	if frozen[handler.as] then
		if handler.attributes ~= nil and type(handler.attributes) ~= "function" then
			error(`The block rule for {p} has attributes that aren't a function`)
		end
	else
		error(`The block rule for {p} needs \`as\` a renderer block name that holds its children (PARAGRAPH, HEADING or QUOTE), not {handler.as}`)
	end

	return table.freeze({ form = "as", as = handler.as, attributes = handler.attributes })
end

local class = {}
class.__index = class

function class.new()
	return (setmetatable({
		_registry = {
			inline = {},
			block = {},
			unknownInline = frozen3,
			unknownBlock = frozen3,
			blockInText = "flatten",
			passes = { mergeText = true, dropEmpty = true }
		}
	}, class))
end

function class:inline(p: string, handler)
	self._registry.inline[p] = inlineRule(p, handler)
end

function class:block(p: string, handler)
	self._registry.block[p] = blockRule(p, handler)
end

function class:fallback(data)
	local registry = self._registry

	if data.unknownInline ~= nil then
		local unknownInline = data.unknownInline
		local unknownInline2

		if unknownInline == "children" then
			unknownInline2 = frozen3
		elseif unknownInline == "drop" then
			unknownInline2 = frozen4
		else
			error(`unknownInline must be "children" or "drop", not {unknownInline}`)
		end

		registry.unknownInline = unknownInline2
	end

	if data.unknownBlock ~= nil then
		local unknownBlock = data.unknownBlock
		local unknownBlock2

		if unknownBlock == "children" then
			unknownBlock2 = frozen3
		elseif unknownBlock == "drop" then
			unknownBlock2 = frozen4
		else
			error(`unknownBlock must be "children" or "drop", not {unknownBlock}`)
		end

		registry.unknownBlock = unknownBlock2
	end

	local blockInText = data.blockInText

	if blockInText ~= nil then
		if blockInText ~= "flatten" and blockInText ~= "drop" then
			error(`blockInText must be "flatten" or "drop", not {blockInText}`)
		end

		registry.blockInText = blockInText
	end
end

function class:pass(p, flag: boolean)
	local passes = self._registry.passes

	if p == "mergeText" then
		passes.mergeText = flag
	elseif p == "dropEmpty" then
		passes.dropEmpty = flag
	else
		error(`Unknown adapter pass {p}`)
	end
end

return {
	build = function(callback, items)
		local v = class.new()

		callback(v)

		for _, item in items do
			local extendAdapter = item.extendAdapter

			if extendAdapter ~= nil then
				extendAdapter(v)
			end
		end

		local registry = v._registry
		table.freeze(registry.inline)
		table.freeze(registry.block)
		table.freeze(registry.passes)
		return table.freeze(registry)
	end
}
