local ParentParent = script.Parent.Parent
local ArgCheck = require(ParentParent.ArgCheck)
local Display = require(ParentParent.Display)
local FFlagExtendScrollingFramesBySafeInsets = require(ParentParent.SharedFlags).FFlagExtendScrollingFramesBySafeInsets

local function getSafeAreaSize(p1, p2) -- line: 8
	-- upvalues: ArgCheck (copy), FFlagExtendScrollingFramesBySafeInsets (copy), Display (copy)
	assert(typeof(p1) == "Vector2", "getSafeAreaSize expects screenSize to be a Vector2")
	assert(type(p2) == "table", "getSafeAreaSize expects guiInset to be a table")
	ArgCheck.isNonNegativeNumber(p2.left, "getSafeAreaSize: guiInset.left")
	ArgCheck.isNonNegativeNumber(p2.right, "getSafeAreaSize: guiInset.right")
	ArgCheck.isNonNegativeNumber(p2.top, "getSafeAreaSize: guiInset.top")
	ArgCheck.isNonNegativeNumber(p2.bottom, "getSafeAreaSize: guiInset.bottom")

	local v8 = p1.X - p2.left - p2.right
	local v9 = p1.Y - p2.top - p2.bottom

	if FFlagExtendScrollingFramesBySafeInsets then
		local v10 = Display.GetDisplayStore().getDeviceSafePadding()

		v8 -= v10.left + v10.right
		v9 -= v10.top + v10.bottom
	end

	ArgCheck.isNonNegativeNumber(v8, "getSafeAreaSize: safeAreaWidth")
	ArgCheck.isNonNegativeNumber(v9, "getSafeAreaSize: safeAreaHeight")

	return UDim2.new(0, v8, 0, v9)
end

return getSafeAreaSize
