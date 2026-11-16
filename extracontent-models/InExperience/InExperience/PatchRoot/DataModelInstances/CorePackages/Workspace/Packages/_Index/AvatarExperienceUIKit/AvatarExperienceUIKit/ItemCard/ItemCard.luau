local AvatarExperienceUIKit = script:FindFirstAncestor("AvatarExperienceUIKit")
local parent = AvatarExperienceUIKit.Parent
local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local UIBlox = require(parent.UIBlox)
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind
require(AvatarExperienceUIKit.BackgroundLayers.BackgroundLayers)
local ItemCardBackgroundsWrapper = require(script.Parent.ItemCardBackgroundsWrapper)

return (React.forwardRef(function(props, ref)
	local selectionImageObject = useSelectionCursor(CursorKind.RoundedRect)
	local v = useTokens()
	local createElement = React.createElement

	local v2 = {}
	v2.Selectable = props.Selectable
	v2.SelectionImageObject = selectionImageObject
	v2.Text = ""
	v2.AutoButtonColor = false
	v2.BackgroundTransparency = 1
	v2.BorderSizePixel = 0
	local activated = React.Event.Activated
	local v3

	if not props.isDisabled then
		v3 = props.onActivated
	end

	v2[activated] = v3
	v2.ref = ref
	v2.Size = props.Size
	v2.AutomaticSize = props.AutomaticSize
	v2.LayoutOrder = props.LayoutOrder
	v2.SelectionGroup = true
	v2[React.Change.AbsoluteSize] = props.onAbsoluteSizeChanged
	v2[React.Tag] = props.tag
	local v4

	if props.backgroundLayers == nil or not (#props.backgroundLayers > 0) then
		v4 = {
			ItemCardListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, v.Gap.Small)
			}),
			ItemCardHeaderSlot = props.headerSlot,
			ItemCardFooterSlot = props.footerSlot
		}
	else
		v4 = {
			BackgroundsWrapper = React.createElement(ItemCardBackgroundsWrapper, {
				backgroundLayers = props.backgroundLayers,
				imageScaleType = props.imageScaleType,
				headerSlot = props.headerSlot,
				footerSlot = props.footerSlot
			}),
			SelectedBorder = 0
		}
		local selectedBorder

		if props.showSelectionBorderWithBackground then
			selectedBorder = React.createElement(View, {
				tag = "size-full stroke-standard stroke-system-contrast radius-medium",
				testId = "card-selection-stroke",
				ZIndex = 2
			})
		end

		v4.SelectedBorder = selectedBorder
	end

	return createElement("TextButton", v2, v4)
end))
