local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent

require(parent.util.Types)
local pcallDeferred = require(parent.util.pcallDeferred)

local function getVerts(p, p2)
	local isServer = p2.isServer

	local v, v2 = pcallDeferred(function()
		return UGCValidationService:GetEditableMeshVerts(p.editableMesh)
	end, p2)

	if v then
		return true, nil, v2
	end

	local v3 = "Failed to read mesh: " .. p.fullName

	if isServer then
		error(v3)
	end

	return false, { v3 }
end

return getVerts
