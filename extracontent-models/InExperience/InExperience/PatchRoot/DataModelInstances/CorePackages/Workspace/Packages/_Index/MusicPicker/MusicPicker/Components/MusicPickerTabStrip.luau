local MusicPicker = script:FindFirstAncestor("MusicPicker")
local parent = MusicPicker.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local ScrollView = Foundation.ScrollView
local Text = Foundation.Text
local View = Foundation.View
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility
local useTokens = Foundation.Hooks.useTokens

require(MusicPicker.Types.MusicPickerTypes)

local function TabPill(props)
	return React.createElement(View, {
		LayoutOrder = props.layoutOrder,
		onActivated = props.onActivated,
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		tag = {
			["row align-x-center align-y-center auto-xy padding-x-medium padding-y-small radius-circle"] = true,
			["bg-contrast"] = props.isActive,
			["bg-surface-300"] = not props.isActive
		}
	}, {
		Label = React.createElement(Text, {
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
	local v = useTokens()
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

	return React.createElement(ScrollView, {
		LayoutOrder = props.LayoutOrder,
		layout = {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			Padding = UDim.new(0, v.Gap.Small),
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		scroll = {
			AutomaticSize = Enum.AutomaticSize.Y,
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			CanvasSize = UDim2.fromOffset(0, 0),
			ScrollingDirection = Enum.ScrollingDirection.X,
			scrollBarVisibility = ScrollBarVisibility.None
		},
		tag = "size-full-0 auto-y padding-y-xsmall"
	}, children)
end

return MusicPickerTabStrip
