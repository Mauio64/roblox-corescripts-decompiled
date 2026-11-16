local parent = script.Parent.Parent.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)
local Object = LuauPolyfill.Object

local React = require(parent.React)

local context = React.createContext(nil)

if _G.__DEV__ then
	context.displayName = "ScrollViewContext"
end

return {
	["default"] = context,
	HORIZONTAL = Object.freeze({ horizontal = true }),
	VERTICAL = Object.freeze({ horizontal = false })
}
