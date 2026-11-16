local mrRouterHeaders = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedUtilities/Http").MrRouterHeaders

local function buildSduiRequestHeaders(accept, contentType)
	local v5 = {}
	v5.Accept = accept

	if contentType ~= nil then
		v5["Content-Type"] = contentType
	end

	return mrRouterHeaders.injectMrRouterHeaders(v5)
end

return buildSduiRequestHeaders
