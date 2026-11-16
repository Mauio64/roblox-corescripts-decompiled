local CommentsSheetSnapPoints = require(script.Parent.CommentsSheetSnapPoints)

local function getCommentsVideoLift(data, p)
	if data.sheetInset <= 0 then
		return nil
	end

	if data.isKeyboardVisible and p ~= nil then
		return p
	end

	local v = CommentsSheetSnapPoints[1] * data.overlayHeight

	if v <= 0 then
		return nil
	end

	return {
		progress = math.min(data.sheetInset / v, 1),
		bandTop = data.overlayTop,
		bandBottom = data.overlayTop + data.overlayHeight - v
	}
end

return getCommentsVideoLift
