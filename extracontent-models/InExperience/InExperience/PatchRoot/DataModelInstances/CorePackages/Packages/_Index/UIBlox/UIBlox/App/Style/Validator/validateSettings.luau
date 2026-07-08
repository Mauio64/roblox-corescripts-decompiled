local ParentParent = script.Parent.Parent.Parent.Parent.Parent
local v2 = require(ParentParent.UIBlox.Core.Utility.GetEngineFeatureSafe)("EnablePreferredTextSizeSetting")
local t = require(ParentParent.t)

return (t.strictInterface({
	PreferredTransparency = t.optional(t.number),
	ReducedMotion = t.optional(t.boolean),
	PreferredTextSize = if not v2 then nil else t.optional(t.enum(Enum.PreferredTextSize)),
	Scale = t.optional(t.number)
}))
