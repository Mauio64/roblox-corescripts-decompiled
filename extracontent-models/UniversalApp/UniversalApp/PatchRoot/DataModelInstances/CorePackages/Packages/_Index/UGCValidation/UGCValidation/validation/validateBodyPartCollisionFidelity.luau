local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)

require(ParentParent.util.Types)

local v3 = game:DefineFastString("UGCValidationBodyPartCollisionFidelity", "Default")

local function validateBodyPartCollisionFidelity(p1, p2) -- line: 10
	-- upvalues: v3 (copy), Analytics (copy)
	local descendants = p1:GetDescendants()

	table.insert(descendants, 1, p1)

	local Default = Enum.CollisionFidelity.Default

	pcall(function() -- line: 18
		-- upvalues: Default (ref), v3 (copy)
		Default = Enum.CollisionFidelity[v3]
	end)

	local t1 = {}

	for _, v11 in descendants do
		if v11:IsA("MeshPart") and v11.CollisionFidelity ~= Default then
			table.insert(t1, `Expected { v11:GetFullName() }.CollisionFidelity to be { Default.Name }`)
		end
	end

	if #t1 == 0 then
		return true
	end

	Analytics.reportFailure(Analytics.ErrorType.validateBodyPartCollisionFidelity, nil, p2)

	return false, t1
end

return validateBodyPartCollisionFidelity
