local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local React = require(ParentParentParent.React)
local Foundation = require(ParentParentParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local Constants = require(ParentParent.Common.Constants)

require(ParentParent.Common.computeStatColumns)

local ROW_FLEX_TAG = Constants.ROW_FLEX_TAG

local function ColumnHeaderRow(t1: {[any]: any}) -- line: 15
	-- upvalues: React (copy), View (copy), FoundationText (copy), ROW_FLEX_TAG (copy)
	local v11 = t1.statColumns or {}
	local t2 = {
		PeopleHeader = React.createElement(View, {
			LayoutOrder = 1,
			tag = "fill size-0-full clip"
		}, {
			Label = React.createElement(FoundationText, {
				Text = "People",
				tag = "size-full text-caption-small text-align-x-left content-emphasis"
			})
		})
	}

	for i, v in ipairs(v11) do
		t2[`StatHeader_{ v.name }`] = React.createElement(View, {
			tag = "clip",
			Size = UDim2.fromOffset(t1.statWidth, t1.headerHeight),
			LayoutOrder = i + 1
		}, {
			Label = React.createElement(FoundationText, {
				tag = "size-full text-caption-small text-align-x-left content-emphasis",
				Text = v.name
			})
		})
	end

	return React.createElement(View, {
		Size = UDim2.new(1, 0, 0, t1.headerHeight),
		LayoutOrder = t1.layoutOrder,
		tag = ROW_FLEX_TAG
	}, t2)
end

return React.memo(ColumnHeaderRow)
