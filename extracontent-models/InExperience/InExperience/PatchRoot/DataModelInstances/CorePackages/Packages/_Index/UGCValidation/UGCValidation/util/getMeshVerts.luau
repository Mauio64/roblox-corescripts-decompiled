local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local pcallDeferred = require(ParentParent.util.pcallDeferred)

local function getVerts(p1, p2) -- line: 12
	-- upvalues: pcallDeferred (copy), UGCValidationService (copy)
	local isServer = p2.isServer
	local v8, v9 = pcallDeferred(function() -- line: 18
		-- upvalues: UGCValidationService (copy), p1 (copy)
		return UGCValidationService:GetEditableMeshVerts(p1.editableMesh)
	end, p2)

	if not v8 then
		local v10 = "Failed to read mesh: " .. p1.fullName

		if isServer then
			error(v10)
		end

		return false, { v10 }
	end

	return true, nil, v9
end

return getVerts
