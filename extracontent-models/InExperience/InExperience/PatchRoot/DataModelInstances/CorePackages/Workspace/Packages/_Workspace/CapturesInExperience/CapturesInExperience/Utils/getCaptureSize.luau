local CaptureService = game:GetService("CaptureService")

local function getCaptureSize(p1) -- line: 3
	-- upvalues: CaptureService (copy)
	local ok, result = pcall(function() -- line: 4
		-- upvalues: CaptureService (copy), p1 (copy)
		return CaptureService:GetCaptureSizeAsync(p1)
	end)

	if not ok or result == Vector2.new(0, 0) then
		return nil
	end

	return result
end

return getCaptureSize
