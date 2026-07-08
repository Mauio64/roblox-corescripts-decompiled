local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)

return t.union(t.instanceIsA("Player"), t.interface({
	UserId = t.integer,
	Name = t.string,
	DisplayName = t.string
}))
