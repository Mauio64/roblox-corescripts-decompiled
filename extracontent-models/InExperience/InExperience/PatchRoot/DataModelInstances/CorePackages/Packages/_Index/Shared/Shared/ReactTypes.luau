local ParentParent = script.Parent.Parent

require(ParentParent.LuauPolyfill)
require(script.Parent["flowtypes.roblox"])

return {
	DiscreteEvent = 0,
	UserBlockingEvent = 1,
	ContinuousEvent = 2
}
