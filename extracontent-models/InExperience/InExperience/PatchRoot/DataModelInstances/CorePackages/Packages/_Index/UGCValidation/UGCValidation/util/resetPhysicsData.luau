local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent

require(parent.util.Types)

local Analytics = require(parent.Analytics)

local getFIntUGCValidationPartMaxMass = require(parent.flags.getFIntUGCValidationPartMaxMass)

local function resetPhysicsData(items, p)
	local now = tick()

	if not game:GetEngineFeature("EngineResetCollisionFidelity") then
		return false, "EngineResetCollisionFidelity is not enabled"
	end

	local v

	if p.bypassFlags then
		v = p.bypassFlags.skipPhysicsDataReset
	else
		v = false
	end

	for _, folder in items do
		local descendants = folder:GetDescendants()
		table.insert(descendants, 1, folder)

		for _, part in descendants do
			if not part:IsA("MeshPart") or v then
				continue
			end

			local v2 = part

			if pcall(function()
				UGCValidationService:ResetCollisionFidelity(v2, v2.CollisionFidelity)
			end) then
				if part:GetMass() > getFIntUGCValidationPartMaxMass() then
					Analytics.reportFailure(Analytics.ErrorType.resetPhysicsData_LargeMass, nil, p)

					return
						false,
						string.format(
							"%s has a mass of %d while the limit is %d.",
							part.Name,
							part:GetMass(),
							getFIntUGCValidationPartMaxMass()
						)
				end
			else
				if p.isServer then
					error("Failed to load mesh data")
				end

				Analytics.reportFailure(Analytics.ErrorType.resetPhysicsData_FailedToLoadMesh, nil, p)

				return false, "Failed to load mesh data"
			end
		end
	end

	Analytics.recordScriptTime(script.Name, now, p)
	return true
end

return resetPhysicsData
