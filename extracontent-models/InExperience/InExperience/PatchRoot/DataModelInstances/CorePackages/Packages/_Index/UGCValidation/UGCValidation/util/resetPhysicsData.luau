local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local Analytics = require(ParentParent.Analytics)
local getFIntUGCValidationPartMaxMass = require(ParentParent.flags.getFIntUGCValidationPartMaxMass)

local function resetPhysicsData(t1: {[any]: any}, p1) -- line: 14
	-- upvalues: UGCValidationService (copy), Analytics (copy), getFIntUGCValidationPartMaxMass (copy)
	local timestamp = tick()

	if not game:GetEngineFeature("EngineResetCollisionFidelity") then
		return false, "EngineResetCollisionFidelity is not enabled"
	end

	local v9 = not not p1.bypassFlags and p1.bypassFlags.skipPhysicsDataReset

	for _, v11 in t1 do
		local descendants = v11:GetDescendants()

		table.insert(descendants, 1, v11)

		for _, v14 in descendants do
			if not v14:IsA("MeshPart") or v9 then
				continue
			end

			if not pcall(function() -- line: 31
				-- upvalues: UGCValidationService (copy), v14 (copy)
				UGCValidationService:ResetCollisionFidelity(v14, v14.CollisionFidelity)
			end) then
				if p1.isServer then
					error("Failed to load mesh data")
				end

				Analytics.reportFailure(Analytics.ErrorType.resetPhysicsData_FailedToLoadMesh, nil, p1)

				return false, "Failed to load mesh data"
			end

			if v14:GetMass() > getFIntUGCValidationPartMaxMass() then
				Analytics.reportFailure(Analytics.ErrorType.resetPhysicsData_LargeMass, nil, p1)

				return false, string.format("%s has a mass of %d while the limit is %d.", v14.Name, v14:GetMass(), getFIntUGCValidationPartMaxMass())
			end
		end
	end

	Analytics.recordScriptTime(script.Name, timestamp, p1)

	return true
end

return resetPhysicsData
