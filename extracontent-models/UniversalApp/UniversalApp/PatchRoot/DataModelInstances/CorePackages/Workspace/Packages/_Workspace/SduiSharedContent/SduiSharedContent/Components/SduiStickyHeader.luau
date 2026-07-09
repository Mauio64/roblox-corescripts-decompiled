local SduiSharedContent = script:FindFirstAncestor("SduiSharedContent")
local SduiSharedContentParent = SduiSharedContent.Parent
local React = require(SduiSharedContentParent.React)
local Foundation = require(SduiSharedContentParent.Foundation)
local View = Foundation.View
local Divider = Foundation.Divider
local EnumsOrientation = Foundation.Enums.Orientation

require(SduiSharedContentParent.SduiCompat)
require(SduiSharedContentParent.SduiCoreSystem)

local buildSduiFeedChildren = require(SduiSharedContent.Components.buildSduiFeedChildren)

local function SduiStickyHeader(t1: {[any]: any}) -- line: 35
	-- upvalues: buildSduiFeedChildren (copy), React (copy), Divider (copy), EnumsOrientation (copy), View (copy)
	local v11 = buildSduiFeedChildren({
		componentType = "StickyHeader",
		negateImpressionIndex = true,
		configs = t1.stickyItems,
		sduiContext = t1.sduiContext,
		debugName = t1.debugName or "StickyHeader",
		extraLocalProps = t1.extraLocalProps,
		impressionsTag = t1.impressionsTag,
		selectionBehaviorLeft = t1.selectionBehaviorLeft,
		selectionBehaviorRight = t1.selectionBehaviorRight
	})

	v11.StickyDivider = React.createElement(Divider, {
		LayoutOrder = 1e999,
		orientation = EnumsOrientation.Horizontal
	})

	return React.createElement(View, {
		tag = "size-full-0 auto-y",
		LayoutOrder = t1.layoutOrder or 1,
		ZIndex = t1.zIndex or 1
	}, {
		Content = React.createElement(View, {
			tag = t1.contentTag,
			Size = UDim2.fromScale(1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			backgroundStyle = t1.backgroundStyle,
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}
		}, {
			TopSpacer = if not t1.paddingTop or not (t1.paddingTop > 0) then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Size = UDim2.new(1, 0, 0, t1.paddingTop)
			}),
			StickyContent = React.createElement(View, {
				tag = "size-full-0 auto-y",
				LayoutOrder = 2,
				layout = {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, t1.gapBetweenItems)
				}
			}, v11),
			BottomSpacer = if not t1.paddingBottom or not (t1.paddingBottom > 0) then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, t1.paddingBottom)
			})
		})
	})
end

return React.memo(SduiStickyHeader)
