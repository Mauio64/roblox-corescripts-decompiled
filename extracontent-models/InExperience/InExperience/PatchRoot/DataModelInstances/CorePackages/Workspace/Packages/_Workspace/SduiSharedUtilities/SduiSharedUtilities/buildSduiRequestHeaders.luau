local parent = script:FindFirstAncestor("SduiSharedUtilities").Parent
local Http = require(parent.Http)
local MrRouterHeaders = Http.MrRouterHeaders

local function buildSduiRequestHeaders(accept: string, contentType: string?)
	local v = {}
	v.Accept = accept

	if contentType ~= nil then
		v["Content-Type"] = contentType
	end

	return MrRouterHeaders.injectMrRouterHeaders(v)
end

return buildSduiRequestHeaders
