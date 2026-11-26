local module = require("@luauforge/bundled/dLf")

local result = {}

for k, v5 in module do
	if type(v5) == "table" and v5.assetId then
		result[tostring(v5.assetId)] = v5
	end
end

return result
