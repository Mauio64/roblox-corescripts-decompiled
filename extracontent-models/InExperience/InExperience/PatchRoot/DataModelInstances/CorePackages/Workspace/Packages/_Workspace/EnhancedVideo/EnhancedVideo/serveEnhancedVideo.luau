local parent = script.Parent.Parent

local Http = require(parent.Http)
local Url = Http.Url

return function(callback, p: number)
	return callback(`{Url.APIS_URL}enhanced-video-experience-service/v1/serve-enhanced-video?universeId={p}`, "GET")
end
