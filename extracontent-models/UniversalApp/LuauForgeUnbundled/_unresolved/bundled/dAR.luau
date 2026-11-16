local url = require("@luauforge/bundled/dAN").Url

return function(callback, p2, p3)
	if p2 == "" then
		error("GetExperienceSongs: universeId cannot be an empty string")
	end

	local v5 = not (p3 and p3 >= 0 and p3 <= 100) and 20 or p3

	return callback(
		string.format(
			"%smusic-discovery/v1/experience-songs?universe_id=%s&limit=%s",
			url.APIS_URL,
			tostring(p2),
			(tostring(v5))
		),
		"GET"
	)
end
