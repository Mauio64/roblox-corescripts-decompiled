local ParentParent = script.Parent.Parent
local Analytics = require(ParentParent.Analytics)

require(ParentParent.util.Types)

local function getIsOpaque(p1) -- line: 10
	local v6 = p1:ReadPixelsBuffer(Vector2.new(0, 0), p1.Size)

	for i = 0, buffer.len(v6) - 1, 4 do
		if buffer.readu8(v6, i + 3) < 255 then
			return false
		end
	end

	return true
end
local function validateTextureTransparency(p2, p3) -- line: 22
	-- upvalues: Analytics (copy), getIsOpaque (copy)
	local timestamp = tick()

	if not p2.editableImage then
		Analytics.reportFailure(Analytics.ErrorType.validateTextureTransparency_InvalidTextureId, nil, p3)

		return false, { string.format("Invalid textureID used in mesh '%s'. Make sure the texture exists and try again.", p2.fullName) }
	end

	if not getIsOpaque(p2.editableImage) then
		Analytics.reportFailure(Analytics.ErrorType.validateTextureTransparency_TransparentTexture, nil, p3)

		return false, { string.format("Texture %s is not fully opaque. Please use an opaque texture.", p2.fullName) }
	end

	Analytics.recordScriptTime(script.Name, timestamp, p3)

	return true
end

return validateTextureTransparency
