local t1 = {
	FailedToRead = "Failed to read selected text.",
	SystemEnabled = "Read aloud is enabled."
}

setmetatable(t1, {
	__index = function(_, p2) -- line: 9
		error(string.format("%q is not a valid system text key", (tostring(p2))), 2)
	end
})

return t1
