local parent = script.Parent.Parent
require(parent.LuauPolyfill)

require(script.Parent["flowtypes.roblox"])

return { DiscreteEvent = 0, UserBlockingEvent = 1, ContinuousEvent = 2 }
