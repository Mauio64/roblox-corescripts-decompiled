return function(callback, p, p2, p3)
	if not callback then
		return ""
	end

	if p == "Muted" or p == "LOCAL_MUTED" then
		return callback("Muted", p3)
	end

	if p == "Connecting" then
		return callback("Connecting", p3)
	elseif p == "Inactive" then
		return callback("Unmuted0", p3)
	elseif p == "Talking" then
		return callback("Unmuted" .. tostring(math.floor(0.5 + 5 * p2) * 20), p3)
	end

	return callback("Error", p3)
end
