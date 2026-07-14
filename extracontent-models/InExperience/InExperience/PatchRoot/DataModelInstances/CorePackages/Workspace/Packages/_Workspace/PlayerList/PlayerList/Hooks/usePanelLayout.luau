local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Foundation = require(ParentParentParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useScaledValue = Foundation.Hooks.useScaledValue
local Constants = require(ParentParent.Common.Constants)
local computeMobilePanelSize = require(ParentParent.Common.computeMobilePanelSize)
local useViewportSize = require(ParentParent.Hooks.useViewportSize)

local function usePanelLayout(b1: boolean, n1: number, b2: boolean?) -- line: 24
	-- upvalues: useViewportSize (copy), useTokens (copy), Constants (copy), useScaledValue (copy), computeMobilePanelSize (copy)
	local v13 = useViewportSize()
	local v14 = useTokens()
	local UIScale = v14.Config.UI.Scale
	local v16 = Constants.HEADER_HEIGHT * UIScale
	local v17 = Constants.COLUMN_HEADER_HEIGHT * UIScale
	local v18 = Constants.ROW_HEIGHT * UIScale
	local v19 = Constants.ROW_PITCH * UIScale
	local v20 = Constants.STAT_COLUMN_WIDTH * UIScale
	local v21 = Constants.PEOPLE_MIN_WIDTH * UIScale
	local Size_200 = v14.Size.Size_200
	local v23 = useScaledValue(Constants.PANEL_SIZE_MIN_CAP)
	local v24 = useScaledValue(Constants.PANEL_SIZE_MAX_CAP)
	local v25 = if not b1 then Constants.DESKTOP_MAX_STAT_COLUMNS else Constants.MOBILE_MAX_STAT_COLUMNS
	local v26 = v21 + math.min(n1, v25) * v20
	local X, Y

	if b1 then
		local v27 = computeMobilePanelSize(v13, v23, v24)

		X = v27.X
		Y = v27.Y
	else
		X = if not b2 then 2 * Size_200 + v26 else 320 * UIScale
		Y = math.max(v13.Y * 0.5, v16 + v17 + 2 * v19)
	end

	return {
		panelWidth = X,
		panelHeight = Y,
		headerHeight = v16,
		columnHeaderHeight = v17,
		rowHeight = v18,
		statWidth = v20,
		maxStatColumns = v25
	}
end

return usePanelLayout
