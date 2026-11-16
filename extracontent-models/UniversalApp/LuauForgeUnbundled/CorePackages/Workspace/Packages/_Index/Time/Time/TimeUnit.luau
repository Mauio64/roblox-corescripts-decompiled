local object = setmetatable({}, {
	__index = function(p2, p3)
		error(("Invalid TimeUnit \"%s\""):format((tostring(p3))), 2)
	end
})

object.Seconds = "Seconds"
object.Minutes = "Minutes"
object.Hours = "Hours"
object.Days = "Days"
object.Months = "Months"
object.Years = "Years"

object.Weeks = "Weeks"

return object
