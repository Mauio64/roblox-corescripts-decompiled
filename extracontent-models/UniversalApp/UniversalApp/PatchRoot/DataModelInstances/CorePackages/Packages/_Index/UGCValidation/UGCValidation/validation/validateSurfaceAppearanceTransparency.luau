local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local validateTextureTransparency = require(ParentParent.validation.validateTextureTransparency)
local FailureReasonsAccumulator = require(ParentParent.util.FailureReasonsAccumulator)
local getEditableImageFromContext = require(ParentParent.util.getEditableImageFromContext)
local ParseContentIds = require(ParentParent.util.ParseContentIds)
local t1 = {
	ColorMap = true,
	NormalMap = true
}

local function validateSurfaceAppearanceTransparency(p1, p2) -- line: 22
	-- upvalues: FailureReasonsAccumulator (copy), Analytics (copy), ParseContentIds (copy), Constants (copy), t1 (copy), getEditableImageFromContext (copy), validateTextureTransparency (copy)
	local timestamp = tick()
	local descendants = p1:GetDescendants()

	table.insert(descendants, p1)

	local v14 = FailureReasonsAccumulator.new()

	for _, v16 in descendants do
		if v16:IsA("MeshPart") then
			local SurfaceAppearance = v16:FindFirstChildWhichIsA("SurfaceAppearance")

			if SurfaceAppearance then
				if SurfaceAppearance.AlphaMode ~= Enum.AlphaMode.Overlay then
					Analytics.reportFailure(Analytics.ErrorType.validateSurfaceAppearances_InvalidAlphaMode, nil, p2)
					v14:updateReasons(false, { `SurfaceAppearance ({ v16:GetFullName() }) has an invalid AlphaMode. Expected Enum.AlphaMode.Overlay` })
				end

				for _, v19 in (ParseContentIds.parse(SurfaceAppearance, Constants.TEXTURE_CONTENT_ID_FIELDS, p2)) do
					if not t1[v19.fieldName] then
						continue
					end

					local t2 = {
						fullName = v19.instance:GetFullName(),
						fieldName = v19.fieldName,
						contentId = v19.instance[v19.fieldName]
					}
					local v21, v22 = getEditableImageFromContext(v19.instance, v19.fieldName, p2)

					if not v21 then
						return false, { "Failed to load texture data" }
					end

					t2.editableImage = v22
					v14:updateReasons(validateTextureTransparency(t2, p2))
				end
			end
		end
	end

	Analytics.recordScriptTime(script.Name, timestamp, p2)

	return v14:getFinalResults()
end

return validateSurfaceAppearanceTransparency
