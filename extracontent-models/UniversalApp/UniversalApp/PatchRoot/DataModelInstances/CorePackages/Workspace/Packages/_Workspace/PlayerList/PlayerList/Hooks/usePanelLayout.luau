local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Foundation = require(ParentParentParent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useScaledValue = Foundation.Hooks.useScaledValue
local Constants = require(ParentParent.Common.Constants)
local computeMobilePanelSize = require(ParentParent.Common.computeMobilePanelSize)
local useViewportSize = require(ParentParent.Hooks.useViewportSize)

local function usePanelLayout(b1: boolean, n1: number) -- line: 22
	-- upvalues: useViewportSize (copy), useTokens (copy), Constants (copy), useScaledValue (copy), computeMobilePanelSize (copy)
	local v12 = useViewportSize()
	local v13 = useTokens()
	local UIScale = v13.Config.UI.Scale
	local v15 = Constants.HEADER_HEIGHT * UIScale
	local v16 = Constants.COLUMN_HEADER_HEIGHT * UIScale
	local v17 = Constants.ROW_HEIGHT * UIScale
	local v18 = Constants.ROW_PITCH * UIScale
	local v19 = Constants.STAT_COLUMN_WIDTH * UIScale
	local v20 = Constants.PEOPLE_MIN_WIDTH * UIScale
	local Size_200 = v13.Size.Size_200
	local v22 = useScaledValue(Constants.PANEL_SIZE_MIN_CAP)
	local v23 = useScaledValue(Constants.PANEL_SIZE_MAX_CAP)
	local v24 = if not b1 then Constants.DESKTOP_MAX_STAT_COLUMNS else Constants.MOBILE_MAX_STAT_COLUMNS
	local v25 = math.min(n1, v24)
	local X, Y

	if b1 then
		local v26 = computeMobilePanelSize(v12, v22, v23)

		X = v26.X
		Y = v26.Y
	else
		X = 2 * Size_200 + v20 + v25 * v19
		Y = math.max(v12.Y * 0.5, v15 + v16 + 2 * v18)
	end

	return {
		panelWidth = X,
		panelHeight = Y,
		headerHeight = v15,
		columnHeaderHeight = v16,
		rowHeight = v17,
		statWidth = v19,
		maxStatColumns = v24
	}
end

return usePanelLayout
