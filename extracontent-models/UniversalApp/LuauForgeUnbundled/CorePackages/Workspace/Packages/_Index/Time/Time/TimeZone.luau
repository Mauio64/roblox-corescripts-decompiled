local object = setmetatable({}, {
	__index = function(p2, p3)
		error(("Invalid TimeZone \"%s\""):format((tostring(p3))), 2)
	end
})

object.UTC = -2
object.Current = -1

return object
