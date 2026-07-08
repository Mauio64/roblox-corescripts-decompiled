local Parent = script:FindFirstAncestor("EditProfile").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local EnumsRadius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local Icon = Foundation.Icon
local FoundationText = Foundation.Text
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function EditComponentRow(t1: {[any]: any}) -- line: 26
	-- upvalues: useTokens (copy), React (copy), View (copy), FoundationText (copy), Skeleton (copy), EnumsRadius (copy), Icon (copy), IconName (copy), IconSize (copy)
	local v14 = useTokens()
	local v15 = string.gsub(t1.currentValue, "\n", " ")

	return React.createElement(View, {
		tag = "row size-full-1100 padding-medium align-y-center flex-x-between gap-medium",
		LayoutOrder = t1.layoutOrder,
		onActivated = t1.onActivated,
		ref = t1.forwardRef
	}, {
		TitleText = React.createElement(FoundationText, {
			tag = "text-title-medium content-emphasis auto-xy",
			LayoutOrder = 1,
			Text = t1.label
		}),
		EditButton = if not t1.shouldShimmer then React.createElement(View, {
			tag = "row size-0-full fill align-y-center align-x-right gap-xsmall",
			LayoutOrder = 2
		}, {
			CurrentText = React.createElement(View, {
				tag = "row size-0-full fill align-y-center align-x-right",
				LayoutOrder = 1
			}, { React.createElement(FoundationText, {
				tag = "text-body-small text-truncate-end size-0-full auto-x",
				Text = v15
			}) }),
			EditIcon = React.createElement(Icon, {
				LayoutOrder = 2,
				name = IconName.ChevronLargeRight,
				size = IconSize.Medium
			})
		}) else React.createElement(Skeleton, {
			LayoutOrder = 3,
			Size = UDim2.new(0.3, 0, 0, v14.Size.Size_400),
			radius = EnumsRadius.Medium
		})
	})
end

return EditComponentRow
