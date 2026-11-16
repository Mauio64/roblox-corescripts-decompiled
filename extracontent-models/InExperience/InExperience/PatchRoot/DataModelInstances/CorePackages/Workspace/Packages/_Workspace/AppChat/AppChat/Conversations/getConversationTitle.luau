return function(p)
	local title = p and (p.title or p.titleForViewer)

	if title then
		return (string.gsub(tostring(title), "\n", ""))
	end

	return ""
end
