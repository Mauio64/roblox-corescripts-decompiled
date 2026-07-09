return function(p1, p2, p3, p4) -- line: 1
	if p1 then
		if p2 == "Muted" or p2 == "LOCAL_MUTED" then
			return p1("Muted", p4)
		end

		if p2 == "Connecting" then
			return p1("Connecting", p4)
		end

		if p2 == "Inactive" then
			return p1("Unmuted0", p4)
		end

		if p2 == "Talking" then
			return p1("Unmuted" .. tostring(math.floor(0.5 + 5 * p3) * 20), p4)
		end

		return p1("Error", p4)
	end

	return ""
end
