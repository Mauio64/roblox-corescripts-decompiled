return function(p)
	local title = p and (p.title or p.titleForViewer)

	if not title then
		return ""
	end

	local v = tostring(title)
	return string.gsub(v, "\n", "")
end
