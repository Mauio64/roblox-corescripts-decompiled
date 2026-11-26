local CommentsSheetSnapPoints = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Comments/Sheet/CommentsSheetSnapPoints")

local function getCommentsVideoLift(data, p2)
	if data.sheetInset <= 0 then
		return nil
	end

	if data.isKeyboardVisible and p2 ~= nil then
		return p2
	end

	local v5 = CommentsSheetSnapPoints[1] * data.overlayHeight

	if v5 <= 0 then
		return nil
	end

	return {
		progress = math.min(data.sheetInset / v5, 1),
		bandTop = data.overlayTop,
		bandBottom = data.overlayTop + data.overlayHeight - v5
	}
end

return getCommentsVideoLift
