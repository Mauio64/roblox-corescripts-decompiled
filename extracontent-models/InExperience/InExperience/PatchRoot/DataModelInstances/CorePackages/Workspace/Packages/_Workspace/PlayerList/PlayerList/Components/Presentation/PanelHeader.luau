local ParentParent = script.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local IconButton = Foundation.IconButton

local function PanelHeader(t1: {[any]: any}) -- line: 10
	-- upvalues: React (copy), View (copy), FoundationText (copy), IconButton (copy), Foundation (copy)
	return React.createElement(View, {
		tag = "row flex-x-between align-y-center auto-y padding-x-large",
		Size = UDim2.new(1, 0, 0, t1.height),
		LayoutOrder = t1.layoutOrder
	}, {
		Title = React.createElement(FoundationText, {
			tag = "auto-xy text-label-medium content-emphasis",
			LayoutOrder = 1,
			Text = t1.title or "Leaderboard"
		}),
		CloseButton = React.createElement(IconButton, {
			LayoutOrder = 2,
			icon = {
				name = Foundation.Enums.IconName.X
			},
			size = Foundation.Enums.InputSize.XSmall,
			onActivated = t1.onClose
		})
	})
end

return React.memo(PanelHeader)
