local HttpService = game:GetService("HttpService")
local json = HttpService:JSONEncode((require(script.Parent.null)))

local function stringify(p1) -- line: 5
	-- upvalues: HttpService (copy), json (copy)
	return (HttpService:JSONEncode(p1):gsub(json, "null"))
end

return stringify
