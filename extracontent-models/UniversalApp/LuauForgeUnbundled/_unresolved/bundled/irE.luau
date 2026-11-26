local v5 = {
	FailedToRead = "Failed to read selected text.",
	SystemEnabled = "Read aloud is enabled."
}

setmetatable(v5, {
	__index = function(p2, p3)
		error(string.format("%q is not a valid system text key", (tostring(p3))), 2)
	end
})

return v5
