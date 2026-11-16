return function(p2)
	local title = p2 and (p2.title or p2.titleForViewer)

	if title then
		return (string.gsub(tostring(title), "\n", ""))
	end

	return ""
end
