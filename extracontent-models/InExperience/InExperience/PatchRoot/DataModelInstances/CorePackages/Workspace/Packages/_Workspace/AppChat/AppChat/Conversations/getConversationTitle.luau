return function(t1: {[any]: any}?) -- line: 1
	if t1 then
		local v2 = t1.title or t1.titleForViewer

		if v2 then
			return (string.gsub(tostring(v2), "\n", ""))
		end
	end

	return ""
end
