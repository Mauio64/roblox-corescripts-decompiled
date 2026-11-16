local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MusicPicker/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MusicPicker/React")

local scrollView = Foundation.ScrollView
local text = Foundation.Text
local view = Foundation.View
local scrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local useTokens = Foundation.Hooks.useTokens

require("@game/CorePackages/Workspace/Packages/_Index/MusicPicker/MusicPicker/Types/MusicPickerTypes")

local function TabPill(props)
	return React.createElement(view, {
		LayoutOrder = props.layoutOrder,
		onActivated = props.onActivated,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		tag = {
			["row align-x-center align-y-center auto-xy padding-x-medium padding-y-small radius-circle"] = true,
			["bg-contrast"] = props.isActive,
			["bg-surface-300"] = not props.isActive
		}
	}, {
		Label = React.createElement(text, {
			Text = props.label,
			tag = {
				["auto-xy text-title-medium"] = true,
				["content-inverse-emphasis"] = props.isActive,
				["content-default"] = not props.isActive
			}
		})
	})
end

local function MusicPickerTabStrip(props)
	local v5 = useTokens()
	local children = {}

	for k, tab in props.tabs do
		local id = tab.id
		children[id] = React.createElement(TabPill, {
			label = tab.label,
			isActive = props.activeTabId == id,
			layoutOrder = k,
			onActivated = function()
				props.onTabSelected(id)
			end
		})
	end

	return React.createElement(scrollView, {
		LayoutOrder = props.LayoutOrder,
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v5.Gap.Small),
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		scroll = {
			AutomaticSize = Enum.AutomaticSize.Y,
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			CanvasSize = UDim2.fromOffset(0, 0),
			ScrollingDirection = Enum.ScrollingDirection.X,
			scrollBarVisibility = scrollBarVisibility.None
		},
		tag = "size-full-0 auto-y padding-y-xsmall"
	}, children)
end

return MusicPickerTabStrip
