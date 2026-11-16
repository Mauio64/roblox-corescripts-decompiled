local parent = script.Parent
local parent2 = parent.Parent.Parent.Parent
local parent3 = parent2.Parent
local parent4 = parent3.Parent
local Cryo = require(parent4.Cryo)

require(parent2.Style.StyleTypes)
local setDefault = require(parent3.Utility.setDefault)
local Constants = require(parent.Constants)
local AspectRatioMode = require(parent.Enum.AspectRatioMode)
local getAspectRatio = require(parent.getAspectRatio)

return function(p, p2, p3: number?, p4: number?, options)
	local joined = Cryo.Dictionary.join(Constants.getDefaultStyleProps(p), options or {})
	local v = setDefault(p4, Constants.DEFAULT_FOOTER_HEIGHT)
	local v2 = setDefault(p3, Constants.DEFAULT_TEXT_LINE_COUNT)
	local v3 = setDefault(p2, AspectRatioMode.Square)
	local topContentPadding = joined.topContentPadding
	local bottomContentPadding = joined.bottomContentPadding
	local contentTitleFont = joined.contentTitleFont
	local contentTitlePadding = joined.contentTitlePadding
	local selectionCursorPadding = joined.selectionCursorPadding
	local v4 = selectionCursorPadding.Left + selectionCursorPadding.Right + topContentPadding.Left + topContentPadding.Right

	local v5 = math.floor(v2 * contentTitleFont.RelativeSize * p.Font.BaseSize + contentTitlePadding) + v
	local v6 = topContentPadding.Top + topContentPadding.Bottom
	local v7 = bottomContentPadding.Top + bottomContentPadding.Bottom
	local v8 = selectionCursorPadding.Top + selectionCursorPadding.Bottom
	local v9 = v6 + v7 + v8
	local aspectRatio = getAspectRatio(v3)
	local v10 = -1 * v4 * aspectRatio + v5 + v9
	return UDim.new(aspectRatio, v10)
end
