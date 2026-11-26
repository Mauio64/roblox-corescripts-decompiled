local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/dependencies")

local roact = dependencies.Roact
local react = dependencies.React
local uiBlox = dependencies.UIBlox
local socialLibraries = dependencies.SocialLibraries

local imageSetLabel = uiBlox.Core.ImageSet.ImageSetLabel
local iconSize = uiBlox.App.Constant.IconSize
local callbackInputBox = socialLibraries.Components.CallbackInputBox
local images = uiBlox.App.ImageSet.Images
local TextKeys = require("@game/CorePackages/Workspace/Packages/_Index/ContactImporter/ContactImporter/Common/TextKeys")
local useStyle = dependencies.useStyle

local useLocalization = dependencies.useLocalization

local iconscommonsearch = images["icons/common/search"]
local iconsactionseditclear_small = images["icons/actions/edit/clear_small"]

function LUAUFORGE_MODULE_GLOBALS_cwz_ContactsListSearchBar(props)
	local v5 = useLocalization({ searchContacts = TextKeys.SEARCH_CONTACTS })

	local v6 = useStyle()

	local state, setState = react.useState(false)

	local createElement = roact.createElement
	local v8 = {
		BackgroundTransparency = v6.Theme.BackgroundMuted.Transparency,
		BorderSizePixel = 0,
		BackgroundColor3 = v6.Theme.BackgroundMuted.Color,
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
	local v10 = {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = 0,
		Transparency = 0,
		Thickness = 1
	}
	local v11 = if state then v6.Theme.SecondaryOnHover.Color else v6.Theme.Divider.Color
	v10.Color = v11

	local v12 = if state then v6.Theme.SecondaryOnHover.Transparency else v6.Theme.Divider.Transparency
	v10.Transparency = v12
	children.Border = createElement2("UIStroke", v10)

	children.padding = roact.createElement("UIPadding", {
		PaddingLeft = UDim.new(0, 13),
		PaddingRight = UDim.new(0, 13)
	})

	children.icon = roact.createElement(imageSetLabel, {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, iconSize.Small, 0, iconSize.Small),
		Image = iconscommonsearch,
		ImageColor3 = v6.Theme.IconEmphasis.Color,
		LayoutOrder = 1
	})

	children.searchBarWrapper = roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		Size = UDim2.new(1, -iconSize.Small, 0, props.height)
	}, {
		searchBar = roact.createElement(callbackInputBox, {
			clearIcon = iconsactionseditclear_small,
			clearIconColor3 = v6.Theme.IconEmphasis.Color,
			clearIconTransparency = v6.Theme.IconEmphasis.Transparency,
			clearButtonSize = iconSize.Small,
			clearButtonDisabled = false,
			focusChangedCallback = setState,
			inputTextColor3 = v6.Theme.TextEmphasis.Color,
			inputTextTransparency = v6.Theme.TextEmphasis.Transparency,
			placeholderText = v5.searchContacts,
			placeholderTextColor3 = v6.Theme.TextMuted.Color,
			placeholderTextTransparency = v6.Theme.TextMuted.Transparency,
			inputTextXAlignment = Enum.TextXAlignment.Left,
			textChangedCallback = props.textChangeCallback
		})
	})
	return createElement("Frame", v8, children)
end

return LUAUFORGE_MODULE_GLOBALS_cwz_ContactsListSearchBar
