local parent = script.Parent.Parent.Parent.Parent.Parent
local GetEngineFeatureSafe = require(parent.UIBlox.Core.Utility.GetEngineFeatureSafe)
local engineFeatureSafe = GetEngineFeatureSafe("EnablePreferredTextSizeSetting")

local t = require(parent.t)

local strictInterface = t.strictInterface
local v = {
	PreferredTransparency = t.optional(t.number),
	ReducedMotion = t.optional(t.boolean),
	PreferredTextSize = 0,
	Scale = 0
}
local preferredTextSize

if engineFeatureSafe then
	preferredTextSize = t.optional(t.enum(Enum.PreferredTextSize))
end

v.PreferredTextSize = preferredTextSize

v.Scale = t.optional(t.number)
return (strictInterface(v))
