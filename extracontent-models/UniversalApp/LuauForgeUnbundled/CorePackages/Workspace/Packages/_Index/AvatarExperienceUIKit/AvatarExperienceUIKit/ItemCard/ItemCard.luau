local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/Foundation")
local useTokens = Foundation.Hooks.useTokens
local view = Foundation.View
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/UIBlox")
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local cursorKind = UIBlox.App.SelectionImage.CursorKind
require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/BackgroundLayers/BackgroundLayers")
local ItemCardBackgroundsWrapper = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceUIKit/AvatarExperienceUIKit/ItemCard/ItemCardBackgroundsWrapper")

return (React.forwardRef(function(props, ref)
	local v5 = useSelectionCursor(cursorKind.RoundedRect)
	local v6 = useTokens()
	local createElement = React.createElement

	local v8 = {}
	v8.Selectable = props.Selectable
	v8.SelectionImageObject = v5
	v8.Text = ""
	v8.AutoButtonColor = false
	v8.BackgroundTransparency = 1
	v8.BorderSizePixel = 0
	local activated = React.Event.Activated
	local v9 = if not props.isDisabled then props.onActivated else nil
	v8[activated] = v9
	v8.ref = ref
	v8.Size = props.Size
	v8.AutomaticSize = props.AutomaticSize
	v8.LayoutOrder = props.LayoutOrder
	v8.SelectionGroup = true
	v8[React.Change.AbsoluteSize] = props.onAbsoluteSizeChanged
	v8[React.Tag] = props.tag
	local v10

	if props.backgroundLayers == nil or not (#props.backgroundLayers > 0) then
		v10 = {
			ItemCardListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, v6.Gap.Small)
			}),
			ItemCardHeaderSlot = props.headerSlot,
			ItemCardFooterSlot = props.footerSlot
		}
	else
		v10 = {
			BackgroundsWrapper = React.createElement(ItemCardBackgroundsWrapper, {
				backgroundLayers = props.backgroundLayers,
				imageScaleType = props.imageScaleType,
				headerSlot = props.headerSlot,
				footerSlot = props.footerSlot
			}),
			SelectedBorder = 0
		}

		local v11 = if props.showSelectionBorderWithBackground then React.createElement(view, {
			tag = "size-full stroke-standard stroke-system-contrast radius-medium",
			testId = "card-selection-stroke",
			ZIndex = 2
		}) else nil
		v10.SelectedBorder = v11
	end

	return createElement("TextButton", v8, v10)
end))
