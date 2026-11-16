local HttpService = game:GetService("HttpService")
local null = require(script.Parent.null)
local jsonEncode = HttpService:JSONEncode(null)

local function stringify(p)
	return (HttpService:JSONEncode(p):gsub(jsonEncode, "null"))
end

return stringify
