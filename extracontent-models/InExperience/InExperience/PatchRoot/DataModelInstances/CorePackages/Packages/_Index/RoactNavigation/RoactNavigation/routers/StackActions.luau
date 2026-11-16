local parent = script.Parent.Parent
local parent2 = parent.Parent
local LuauPolyfill = require(parent2.LuauPolyfill)
local Object = LuauPolyfill.Object
local NavigationSymbol = require(parent.NavigationSymbol)

local pop = NavigationSymbol("POP")
local popToTop = NavigationSymbol("POP_TO_TOP")
local push = NavigationSymbol("PUSH")
local reset = NavigationSymbol("RESET")
local replace = NavigationSymbol("REPLACE")
local completeTransition = NavigationSymbol("COMPLETE_TRANSITION")

local StackActions = {
	Pop = pop,
	PopToTop = popToTop,
	Push = push,
	Reset = reset,
	Replace = replace,
	CompleteTransition = completeTransition
}

setmetatable(StackActions, {
	__index = function(_, p)
		error(("%q is not a valid member of StackActions"):format((tostring(p))), 2)
	end
})

function StackActions.pop(p)
	local v = { type = pop }

	if p then
		return (Object.assign(v, p))
	end

	return v
end

function StackActions.popToTop(p)
	local v = { type = popToTop }

	if p then
		return (Object.assign(v, p))
	end

	return v
end

function StackActions.push(p)
	local v = { type = push }

	if p then
		return (Object.assign(v, p))
	end

	return v
end

function StackActions.reset(p)
	local v = { type = reset }

	if p then
		return (Object.assign(v, p))
	end

	return v
end

function StackActions.replace(p)
	local v = { type = replace, preserveFocus = true }

	if p then
		return (Object.assign(v, p))
	end

	return v
end

function StackActions.completeTransition(p)
	local v = { type = completeTransition, preserveFocus = true }

	if p then
		return (Object.assign(v, p))
	end

	return v
end

return StackActions
