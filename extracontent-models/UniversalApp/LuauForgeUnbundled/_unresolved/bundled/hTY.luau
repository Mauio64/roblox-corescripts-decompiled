local module = require("@luauforge/bundled/hTZ")

return function(p2, p3)
	local v5 = p2 or Enum.ConnectionState.Connected

	if p3.type == module.name then
		v5 = p3.connectionState
	end

	return v5
end
