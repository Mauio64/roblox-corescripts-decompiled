return function(s1: string) -- line: 1
	return (string.gsub(s1, "%p", {
		["<"] = "&lt;",
		[">"] = "&gt;",
		["&"] = "&amp;"
	}))
end
