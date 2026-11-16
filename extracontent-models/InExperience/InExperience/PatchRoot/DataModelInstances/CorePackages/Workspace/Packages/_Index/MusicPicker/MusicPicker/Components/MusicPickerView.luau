local MusicPicker = script:FindFirstAncestor("MusicPicker")
local parent = MusicPicker.Parent

local BuilderIcons = require(parent.BuilderIcons)
local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Icon = Foundation.Icon
local IconButton = Foundation.IconButton
local Text = Foundation.Text
local View = Foundation.View
local useStyleTags = Foundation.Hooks.useStyleTags
local useTokens = Foundation.Hooks.useTokens

local MusicPickerList = require(MusicPicker.Components.MusicPickerList)
local MusicPickerTabStrip = require(MusicPicker.Components.MusicPickerTabStrip)
require(MusicPicker.Types.MusicPickerTypes)

local MagnifyingGlass = BuilderIcons.Icon.MagnifyingGlass
local x = BuilderIcons.Icon.X

local function findActiveTab(tabs, activeTabId: string?) -- 1 equivalent call inferred from this helper
	for _, item in tabs do
		if item.id == activeTabId then
			return item
		end
	end

	return if #tabs > 0 then tabs[1] else nil
end

local function MusicPickerView(props)
	local v = useTokens()
	local v2 = useStyleTags("fill size-0-full text-body-large text-align-x-left text-align-y-center text-no-wrap clip gui-object-defaults")

	local emphasis = v.Color.Content.Emphasis
	local v3

	if props.mode == "search" then
		v3 = React.createElement(MusicPickerList, {
			content = props.searchContent,
			onSelect = props.onSelect,
			LayoutOrder = 1
		})
	else
		local activeTab = findActiveTab(props.tabs, props.activeTabId) -- inferred equivalent call
		local children = {}

		if props.showTabs ~= false then
			children.TabStrip = React.createElement(MusicPickerTabStrip, {
				LayoutOrder = 1,
				tabs = props.tabs,
				activeTabId = props.activeTabId,
				onTabSelected = props.onTabSelected
			})
		end

		if activeTab ~= nil then
			children.Content = React.createElement(MusicPickerList, {
				content = activeTab.content,
				onSelect = props.onSelect,
				LayoutOrder = 2
			})
		end

		v3 = React.createElement(React.Fragment, nil, children)
	end

	local safeAreaInsets = props.safeAreaInsets
	local v4 = math.max(safeAreaInsets == nil and 0 or safeAreaInsets.left, v.Padding.XLarge)
	local v5 = math.max(safeAreaInsets == nil and 0 or safeAreaInsets.right, v.Padding.XLarge)
	local function onSearchTextChanged(p)
		props.onSearchChanged(p.Text)
	end
	local function onSearchFocusLost(_, flag: boolean)
		if flag then
			props.onSubmitSearch()
		end
	end

	return React.createElement(View, {
		onActivated = function() end,
		Size = UDim2.fromScale(1, 2 / 3),
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		tag = "col align-x-center align-y-top gap-small position-bottom-center anchor-bottom-center size-full-0 radius-medium bg-surface-100",
		ZIndex = 5,
		padding = {
			top = UDim.new(0, v.Padding.Medium),
			left = UDim.new(0, v4),
			right = UDim.new(0, v5)
		}
	}, {
		DragHandle = React.createElement(View, {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(32, 4),
			tag = "radius-circle bg-surface-300"
		}),
		ModalHeaderBar = React.createElement(
			View,
			{
				LayoutOrder = 2,
				tag = "row flex-x-between align-x-center align-y-center size-full-0 auto-y"
			},
			{
				Title = React.createElement(Text, {
					LayoutOrder = 1,
					tag = "auto-xy text-heading-small text-align-x-left text-align-y-top text-truncate-end content-emphasis",
					Text = props.titleText
				}),
				CloseButton = React.createElement(IconButton, {
					LayoutOrder = 2,
					icon = x,
					onActivated = props.onClose,
					size = Foundation.Enums.IconSize.Small,
					variant = Foundation.Enums.ButtonVariant.Utility
				})
			}
		),
		SearchBar = React.createElement(
			View,
			{
				cornerRadius = UDim.new(0.5, 0),
				LayoutOrder = 3,
				tag = "row align-y-center gap-large size-full-1000 padding-x-medium stroke-standard stroke-emphasis"
			},
			{
				SearchIcon = React.createElement(Icon, {
					name = MagnifyingGlass,
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
					[React.Tag] = v2,
					[React.Change.Text] = onSearchTextChanged,
					[React.Event.FocusLost] = onSearchFocusLost
				})
			}
		),
		Body = React.createElement(View, {
			LayoutOrder = 4,
			flexItem = { FlexMode = Enum.UIFlexMode.Shrink },
			tag = "col align-x-center align-y-top gap-xsmall size-full"
		}, v3)
	})
end

return MusicPickerView
