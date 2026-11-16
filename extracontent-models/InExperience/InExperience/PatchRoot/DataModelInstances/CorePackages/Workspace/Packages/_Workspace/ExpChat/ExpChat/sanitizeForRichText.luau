return function(value: string)
	return (string.gsub(value, "%p", { ["<"] = "&lt;", [">"] = "&gt;", ["&"] = "&amp;" }))
end
