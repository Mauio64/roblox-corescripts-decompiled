local ContactImporter = script:FindFirstAncestor("ContactImporter")
local dependencies = require(ContactImporter.dependencies)

local roact = dependencies.Roact
local react = dependencies.React
local uiBlox = dependencies.UIBlox
local socialLibraries = dependencies.SocialLibraries

local imageSetLabel = uiBlox.Core.ImageSet.ImageSetLabel
local iconSize = uiBlox.App.Constant.IconSize
local callbackInputBox = socialLibraries.Components.CallbackInputBox
local images = uiBlox.App.ImageSet.Images
local TextKeys = require(ContactImporter.Common.TextKeys)
local useStyle = dependencies.useStyle

local useLocalization = dependencies.useLocalization

local iconscommonsearch = images["icons/common/search"]
local iconsactionseditclear_small = images["icons/actions/edit/clear_small"]

function ContactsListSearchBar(props)
	local v = useLocalization({ searchContacts = TextKeys.SEARCH_CONTACTS })

	local v2 = useStyle()

	local state, setState = react.useState(false)

	local createElement = roact.createElement
	local v3 = {
		BackgroundTransparency = v2.Theme.BackgroundMuted.Transparency,
		BorderSizePixel = 0,
		BackgroundColor3 = v2.Theme.BackgroundMuted.Color,
		Size = UDim2.new(1, 0, 0, props.height),
		LayoutOrder = props.layoutOrder
	}
	local children = {
		layout = roact.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 4)
		}),
		BorderRadius = roact.createElement("UICorner", { CornerRadius = UDim.new(0, 4) }),
		Border = 0,
		padding = 0,
		icon = 0,
		searchBarWrapper = 0
	}

	local createElement2 = react.createElement
	local v4 = {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = 0,
		Transparency = 0,
		Thickness = 1
	}
	local color

	if state then
		color = v2.Theme.SecondaryOnHover.Color
	else
		color = v2.Theme.Divider.Color
	end

	v4.Color = color
	local transparency

	if state then
		transparency = v2.Theme.SecondaryOnHover.Transparency
	else
		transparency = v2.Theme.Divider.Transparency
	end

	v4.Transparency = transparency
	children.Border = createElement2("UIStroke", v4)

	children.padding = roact.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, 13),
		PaddingRight = UDim.new(0, 13)
	})

	children.icon = roact.createElement(imageSetLabel, {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, iconSize.Small, 0, iconSize.Small),
		Image = iconscommonsearch,
		ImageColor3 = v2.Theme.IconEmphasis.Color,
		LayoutOrder = 1
	})

	children.searchBarWrapper = roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = UDim2.new(1, -iconSize.Small, 0, props.height)
	}, {
		searchBar = roact.createElement(callbackInputBox, {
			clearIcon = iconsactionseditclear_small,
			clearIconColor3 = v2.Theme.IconEmphasis.Color,
			clearIconTransparency = v2.Theme.IconEmphasis.Transparency,
			clearButtonSize = iconSize.Small,
			clearButtonDisabled = false,
			focusChangedCallback = setState,
			inputTextColor3 = v2.Theme.TextEmphasis.Color,
			inputTextTransparency = v2.Theme.TextEmphasis.Transparency,
			placeholderText = v.searchContacts,
			placeholderTextColor3 = v2.Theme.TextMuted.Color,
			placeholderTextTransparency = v2.Theme.TextMuted.Transparency,
			inputTextXAlignment = Enum.TextXAlignment.Left,
			textChangedCallback = props.textChangeCallback
		})
	})
	return createElement("Frame", v3, children)
end

return ContactsListSearchBar
