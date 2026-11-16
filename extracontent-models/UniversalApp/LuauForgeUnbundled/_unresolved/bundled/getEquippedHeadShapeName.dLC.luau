local module = require("@luauforge/bundled/dLD")
require("@luauforge/bundled/dHT")
local module2 = require("@luauforge/bundled/dLo")

local constants = require("@luauforge/bundled/dLA").Constants

local function getEquippedHeadShapeName(p2, p3)
	local v5 = module(p2, p3)[1]

	if v5 then
		return (module2[tostring(v5)] or { name = nil }).name
	end

	if not p2 then
		return nil
	end

	local dynamicHead = constants.ASSET_TYPE_NAME_TO_ID_STRING.DynamicHead

	local v6 = dynamicHead and p2[dynamicHead]

	if v6 then
		for k, v7 in v6 do
			if v7 and v7.headShape then
				return v7.headShape
			end
		end
	end

	return nil
end

return getEquippedHeadShapeName
