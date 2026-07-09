local Parent = script:FindFirstAncestor("AuthCommon").Parent
local Url = require(Parent.Http).Url

return function(p1, s1: string) -- line: 10
	-- upvalues: Url (copy)
	return p1(string.format("%sv2/games/%s/media", Url.GAME_URL, s1), "GET")
end
