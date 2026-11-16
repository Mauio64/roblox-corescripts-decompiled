local self = setmetatable({}, {
	__index = function(_, p)
		error(("Invalid TimeZone \"%s\""):format((tostring(p))), 2)
	end
})

self.UTC = -2
self.Current = -1

return self
