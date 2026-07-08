local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Cryo = require(ParentParentParentParent.Cryo)

require(ParentParent.Style.StyleTypes)

local setDefault = require(ParentParentParent.Utility.setDefault)
local Constants = require(scriptParent.Constants)
local AspectRatioMode = require(scriptParent.Enum.AspectRatioMode)
local getAspectRatio = require(scriptParent.getAspectRatio)

return function(p1, p2, n1: number?, n2: number?, p3) -- line: 33
	-- upvalues: Cryo (copy), Constants (copy), setDefault (copy), AspectRatioMode (copy), getAspectRatio (copy)
	local v15 = Cryo.Dictionary.join(Constants.getDefaultStyleProps(p1), p3 or {})
	local v16 = setDefault(n2, Constants.DEFAULT_FOOTER_HEIGHT)
	local v17 = setDefault(n1, Constants.DEFAULT_TEXT_LINE_COUNT)
	local v18 = setDefault(p2, AspectRatioMode.Square)
	local topContentPadding = v15.topContentPadding
	local bottomContentPadding = v15.bottomContentPadding
	local contentTitleFont = v15.contentTitleFont
	local contentTitlePadding = v15.contentTitlePadding
	local selectionCursorPadding = v15.selectionCursorPadding
	local v24 = selectionCursorPadding.Left + selectionCursorPadding.Right + topContentPadding.Left + topContentPadding.Right
	local v25 = math.floor(v17 * contentTitleFont.RelativeSize * p1.Font.BaseSize + contentTitlePadding) + v16
	local v26 = topContentPadding.Top + topContentPadding.Bottom
	local v27 = bottomContentPadding.Top + bottomContentPadding.Bottom
	local v28 = selectionCursorPadding.Top + selectionCursorPadding.Bottom
	local v29 = v26 + v27 + v28
	local v30 = getAspectRatio(v18)
	local v31 = -1 * v24 * v30 + v25 + v29

	return UDim.new(v30, v31)
end
