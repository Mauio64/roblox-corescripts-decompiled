local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)

require(ParentParent.util.Types)

local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)

local function validateSurfaceAppearances(p1, p2) -- line: 13
	-- upvalues: FailureReasonsAccumulator (copy), Analytics (copy)
	local allowEditableInstances = p2.allowEditableInstances
	local descendants = p1:GetDescendants()

	table.insert(descendants, p1)

	local v9 = FailureReasonsAccumulator.new()

	for _, v in pairs(descendants) do
		if v:IsA("MeshPart") then
			local v12 = v.TextureID ~= ""

			if allowEditableInstances and not v12 then
				local TextureContent = v.TextureContent

				v12 = TextureContent.Uri ~= nil and TextureContent.Uri ~= "" or TextureContent.Object ~= nil
			end

			local SurfaceAppearance = v:FindFirstChildWhichIsA("SurfaceAppearance")

			if v12 then
				if SurfaceAppearance then
					Analytics.reportFailure(Analytics.ErrorType.validateSurfaceAppearances_MeshPartHasTexture, nil, p2)
					v9:updateReasons(false, { `TextureID and SurfaceAppearance are both defined for MeshPart ({ v:GetFullName() }). Publishing will only use SurfaceApperance.` })
				end
			elseif not SurfaceAppearance then
				Analytics.reportFailure(Analytics.ErrorType.validateSurfaceAppearances_MissingSurfaceAppearance, nil, p2)
				v9:updateReasons(false, { `({ v:GetFullName() }) has an empty TextureID and no child SurfaceAppearance instance. You need to define at least one of them.` })
			end
		end
	end

	return v9:getFinalResults()
end

return validateSurfaceAppearances
