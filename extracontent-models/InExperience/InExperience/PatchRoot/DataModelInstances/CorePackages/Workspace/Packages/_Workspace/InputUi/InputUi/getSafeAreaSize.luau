local parent = script.Parent.Parent

local ArgCheck = require(parent.ArgCheck)
local Display = require(parent.Display)
local SharedFlags = require(parent.SharedFlags)
local FFlagExtendScrollingFramesBySafeInsets = SharedFlags.FFlagExtendScrollingFramesBySafeInsets

local function getSafeAreaSize(p, data, flag: boolean?)
	assert(typeof(p) == "Vector2", "getSafeAreaSize expects screenSize to be a Vector2")
	assert(type(data) == "table", "getSafeAreaSize expects guiInset to be a table")
	ArgCheck.isNonNegativeNumber(data.left, "getSafeAreaSize: guiInset.left")
	ArgCheck.isNonNegativeNumber(data.right, "getSafeAreaSize: guiInset.right")
	ArgCheck.isNonNegativeNumber(data.top, "getSafeAreaSize: guiInset.top")
	ArgCheck.isNonNegativeNumber(data.bottom, "getSafeAreaSize: guiInset.bottom")

	local v = p.X - data.left - data.right
	local v2 = p.Y - data.top - data.bottom

	if not flag and FFlagExtendScrollingFramesBySafeInsets then
		local deviceSafePadding = Display.GetDisplayStore().getDeviceSafePadding()
		v -= deviceSafePadding.left + deviceSafePadding.right
		v2 -= deviceSafePadding.top + deviceSafePadding.bottom
	end

	ArgCheck.isNonNegativeNumber(v, "getSafeAreaSize: safeAreaWidth")
	ArgCheck.isNonNegativeNumber(v2, "getSafeAreaSize: safeAreaHeight")
	return UDim2.new(0, v, 0, v2)
end

return getSafeAreaSize
