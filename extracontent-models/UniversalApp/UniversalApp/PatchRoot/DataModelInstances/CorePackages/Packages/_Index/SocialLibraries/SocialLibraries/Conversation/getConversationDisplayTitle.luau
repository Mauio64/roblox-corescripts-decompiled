return function(p1) -- line: 1
	if p1 then
		local v2 = p1.title or p1.titleForViewer

		if v2 then
			local str = tostring(v2)

			return string.gsub(str, "\n", "")
		end
	end

	return ""
end
