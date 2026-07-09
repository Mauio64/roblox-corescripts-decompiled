local Parent = script:FindFirstAncestor("ExperienceSongsRodux").Parent
local Url = require(Parent.Http).Url

return function(p1, s1: string, n1: number?) -- line: 9
	-- upvalues: Url (copy)
	if s1 == "" then
		error("GetExperienceSongs: universeId cannot be an empty string")
	end

	local v6 = (not n1 or (not (n1 >= 0) or not (n1 <= 100))) and 20 or n1

	return p1(string.format("%smusic-discovery/v1/experience-songs?universe_id=%s&limit=%s", Url.APIS_URL, tostring(s1), (tostring(v6))), "GET")
end
