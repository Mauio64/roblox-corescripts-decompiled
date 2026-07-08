local ParentParent = script.Parent.Parent
local Url = require(ParentParent.Http).Url

return function(p1, n1: number) -- line: 6
	-- upvalues: Url (copy)
	return p1(`{ Url.APIS_URL }enhanced-video-experience-service/v1/serve-enhanced-video?universeId={ n1 }`, "GET")
end
