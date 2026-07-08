local ParentParent = script.Parent.Parent.Parent.Parent
local Object = require(ParentParent.LuauPolyfill).Object
local t1 = {}
local v4 = require(ParentParent.React).createContext(nil)

if _G.__DEV__ then
	v4.displayName = "ScrollViewContext"
end

t1.default = v4
t1.HORIZONTAL = Object.freeze({
	horizontal = true
})
t1.VERTICAL = Object.freeze({
	horizontal = false
})

return t1
