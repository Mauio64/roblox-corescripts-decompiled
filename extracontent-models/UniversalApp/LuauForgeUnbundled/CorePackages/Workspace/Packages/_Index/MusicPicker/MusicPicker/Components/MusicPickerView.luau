local BuilderIcons = require("@game/CorePackages/Workspace/Packages/_Workspace/MusicPicker/BuilderIcons")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/MusicPicker/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MusicPicker/React")

local icon = Foundation.Icon
local iconButton = Foundation.IconButton
local text = Foundation.Text
local view = Foundation.View
local useStyleTags = Foundation.Hooks.useStyleTags
local useTokens = Foundation.Hooks.useTokens

local MusicPickerList = require("@game/CorePackages/Workspace/Packages/_Index/MusicPicker/MusicPicker/Components/MusicPickerList")
local MusicPickerTabStrip = require("@game/CorePackages/Workspace/Packages/_Index/MusicPicker/MusicPicker/Components/MusicPickerTabStrip")
require("@game/CorePackages/Workspace/Packages/_Index/MusicPicker/MusicPicker/Types/MusicPickerTypes")

local magnifyingGlass = BuilderIcons.Icon.MagnifyingGlass
local x = BuilderIcons.Icon.X

local function findActiveTab(list, p2)
	for k, item in list do
		if item.id == p2 then
			return item
		end
	end

	if #list > 0 then
		return list[1]
	end

	return nil
end

local function MusicPickerView(props)
	local v5 = useTokens()
	local v6 = useStyleTags("fill size-0-full text-body-large text-align-x-left text-align-y-center text-no-wrap clip gui-object-defaults")

	local emphasis = v5.Color.Content.Emphasis
	local v7

	if props.mode == "search" then
		v7 = React.createElement(MusicPickerList, {
			content = props.searchContent,
			onSelect = props.onSelect,
			LayoutOrder = 1
		})
	else
		local tabs = props.tabs
		local activeTabId = props.activeTabId
		local flag = true
		local v8

		for k, tab in tabs do
			if tab.id == activeTabId then
				v8 = tab
				flag = false
				break
			end
		end

		if flag then
			v8 = if #tabs > 0 then tabs[1] else nil
		end

		local children = {}

		if props.showTabs ~= false then
			children.TabStrip = React.createElement(MusicPickerTabStrip, {
				LayoutOrder = 1,
				tabs = props.tabs,
				activeTabId = props.activeTabId,
				onTabSelected = props.onTabSelected
			})
		end

		if v8 ~= nil then
			children.Content = React.createElement(MusicPickerList, {
				content = v8.content,
				onSelect = props.onSelect,
				LayoutOrder = 2
			})
		end

		v7 = React.createElement(React.Fragment, nil, children)
	end

	local safeAreaInsets = props.safeAreaInsets
	local v8 = math.max(safeAreaInsets == nil and 0 or safeAreaInsets.left, v5.Padding.XLarge)
	local v9 = math.max(safeAreaInsets == nil and 0 or safeAreaInsets.right, v5.Padding.XLarge)
	local function onSearchTextChanged(p2)
		props.onSearchChanged(p2.Text)
	end
	local function onSearchFocusLost(p2, p3)
		if p3 then
			props.onSubmitSearch()
		end
	end

	return React.createElement(view, {
		onActivated = function() end,
		Size = UDim2.fromScale(1, 2 / 3),
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		tag = "col align-x-center align-y-top gap-small position-bottom-center anchor-bottom-center size-full-0 radius-medium bg-surface-100",
		ZIndex = 5,
		padding = {
			top = UDim.new(0, v5.Padding.Medium),
			left = UDim.new(0, v8),
			right = UDim.new(0, v9)
		}
	}, {
		DragHandle = React.createElement(view, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(32, 4),
			tag = "radius-circle bg-surface-300"
		}),
		ModalHeaderBar = React.createElement(
			view,
			{
				LayoutOrder = 2,
				tag = "row flex-x-between align-x-center align-y-center size-full-0 auto-y"
			},
			{
				Title = React.createElement(text, {
					LayoutOrder = 1,
					tag = "auto-xy text-heading-small text-align-x-left text-align-y-top text-truncate-end content-emphasis",
					Text = props.titleText
				}),
				CloseButton = React.createElement(iconButton, {
					LayoutOrder = 2,
					icon = x,
					onActivated = props.onClose,
					size = Foundation.Enums.IconSize.Small,
					variant = Foundation.Enums.ButtonVariant.Utility
				})
			}
		),
		SearchBar = React.createElement(
			view,
			{
				cornerRadius = UDim.new(0.5, 0),
				LayoutOrder = 3,
				tag = "row align-y-center gap-large size-full-1000 padding-x-medium stroke-standard stroke-emphasis"
			},
			{
				SearchIcon = React.createElement(icon, {
					name = magnifyingGlass,
					size = Foundation.Enums.IconSize.Medium,
					style = emphasis
				}),
				Input = React.createElement("TextBox", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					ClearTextOnFocus = false,
					MultiLine = false,
					PlaceholderColor3 = emphasis.Color3,
					PlaceholderText = props.searchPlaceholder,
					Text = props.searchText,
					TextColor3 = emphasis.Color3,
					TextTransparency = emphasis.Transparency,
					[React.Tag] = v6,
					[React.Change.Text] = onSearchTextChanged,
					[React.Event.FocusLost] = onSearchFocusLost
				})
			}
		),
		Body = React.createElement(view, {
			LayoutOrder = 4,
			flexItem = { FlexMode = Enum.UIFlexMode.Shrink },
			tag = "col align-x-center align-y-top gap-xsmall size-full"
		}, v7)
	})
end

return MusicPickerView
