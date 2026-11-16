local parent = script.Parent.Parent.Parent
local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object
local NavigationSymbol = require(script.Parent.Parent.NavigationSymbol)

local jumpTo = NavigationSymbol("JUMP_TO")

local SwitchActions = { JumpTo = jumpTo }

setmetatable(SwitchActions, {
	__index = function(_, p)
		error(("%q is not a valid member of SwitchActions"):format((tostring(p))), 2)
	end
})

function SwitchActions.jumpTo(p)
	local v = { type = jumpTo, preserveFocus = true }

	if p then
		return (Object.assign(v, p))
	end

	return v
end

return SwitchActions
