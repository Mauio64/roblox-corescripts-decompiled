local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)

return t.interface({
	version = t.string,
	order = t.optional(t.number),
	type = t.optional(t.enum(Enum.AccessoryType)),
	isLayered = t.optional(t.boolean)
})
