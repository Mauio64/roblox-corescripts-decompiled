local ParentParent = script.Parent.Parent.Parent.Parent
local LuauPolyfill = require(ParentParent.LuauPolyfill)
local t1 = {}
local Slot = require(script.Parent.slot).Slot

t1.Slot = Slot

local bind = Slot.bind
local noContext = Slot.noContext

t1.bind = bind
t1.noContext = noContext

local setTimeout = LuauPolyfill.setTimeout

local function setTimeoutWithContext(p1: ((...any) -> ...any), n1: number) -- line: 27
	-- upvalues: setTimeout (copy), bind (copy)
	return setTimeout(bind(p1), n1)
end

t1.setTimeout = setTimeoutWithContext

return t1
