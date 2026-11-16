local CaptureService = game:GetService("CaptureService")

local function getCaptureSize(p)
	local success, result = pcall(function()
		return CaptureService:GetCaptureSizeAsync(p)
	end)

	if success and result ~= Vector2.new(0, 0) then
		return result
	end

	return nil
end

return getCaptureSize
