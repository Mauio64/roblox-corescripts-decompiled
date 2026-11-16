local parent = script.Parent.Parent.Parent.Parent

local LuauPolyfill = require(parent.LuauPolyfill)

local slot = require(script.Parent.slot)
local slot2 = slot.Slot

local bind = slot2.bind
local Context = { ["Slot"] = slot2, bind = bind, noContext = slot2.noContext }

local setTimeout = LuauPolyfill.setTimeout
local function setTimeoutWithContext(callback, p: number)
	return setTimeout(bind(callback), p)
end

Context.setTimeout = setTimeoutWithContext

return Context
