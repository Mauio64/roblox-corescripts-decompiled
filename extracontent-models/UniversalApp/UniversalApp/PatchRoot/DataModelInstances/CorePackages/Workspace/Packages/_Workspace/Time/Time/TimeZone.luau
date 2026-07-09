local self = setmetatable({}, {
	__index = function(_, p2) -- line: 2
		error(("Invalid TimeZone \"%s\""):format((tostring(p2))), 2)
	end
})

self.UTC = -2
self.Current = -1

return self
