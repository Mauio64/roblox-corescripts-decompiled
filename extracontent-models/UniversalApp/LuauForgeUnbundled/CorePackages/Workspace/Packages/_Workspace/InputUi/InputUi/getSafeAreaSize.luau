local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/ArgCheck")
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/Display")
local fFlagExtendScrollingFramesBySafeInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/InputUi/SharedFlags").FFlagExtendScrollingFramesBySafeInsets

local function getSafeAreaSize(p2, data, p3)
	assert(typeof(p2) == "Vector2", "getSafeAreaSize expects screenSize to be a Vector2")
	assert(type(data) == "table", "getSafeAreaSize expects guiInset to be a table")
	ArgCheck.isNonNegativeNumber(data.left, "getSafeAreaSize: guiInset.left")
	ArgCheck.isNonNegativeNumber(data.right, "getSafeAreaSize: guiInset.right")
	ArgCheck.isNonNegativeNumber(data.top, "getSafeAreaSize: guiInset.top")
	ArgCheck.isNonNegativeNumber(data.bottom, "getSafeAreaSize: guiInset.bottom")

	local v5 = p2.X - data.left - data.right
	local v6 = p2.Y - data.top - data.bottom

	if not p3 and fFlagExtendScrollingFramesBySafeInsets then
		local deviceSafePadding = Display.GetDisplayStore().getDeviceSafePadding()
		v5 -= deviceSafePadding.left + deviceSafePadding.right
		v6 -= deviceSafePadding.top + deviceSafePadding.bottom
	end

	ArgCheck.isNonNegativeNumber(v5, "getSafeAreaSize: safeAreaWidth")
	ArgCheck.isNonNegativeNumber(v6, "getSafeAreaSize: safeAreaHeight")
	return UDim2.new(0, v5, 0, v6)
end

return getSafeAreaSize
