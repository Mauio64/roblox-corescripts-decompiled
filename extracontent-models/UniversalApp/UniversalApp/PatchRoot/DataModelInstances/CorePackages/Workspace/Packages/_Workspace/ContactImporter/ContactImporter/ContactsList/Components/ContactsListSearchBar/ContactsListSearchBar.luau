local ContactImporter = script:FindFirstAncestor("ContactImporter")
local dependencies = require(ContactImporter.dependencies)
local Roact = dependencies.Roact
local React = dependencies.React
local UIBlox = dependencies.UIBlox
local SocialLibraries = dependencies.SocialLibraries
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local IconSize = UIBlox.App.Constant.IconSize
local CallbackInputBox = SocialLibraries.Components.CallbackInputBox
local Images = UIBlox.App.ImageSet.Images
local TextKeys = require(ContactImporter.Common.TextKeys)
local useStyle = dependencies.useStyle
local useLocalization = dependencies.useLocalization
local v14 = Images["icons/common/search"]
local v15 = Images["icons/actions/edit/clear_small"]

function ContactsListSearchBar(t1: {[any]: any}) -- line: 29
	-- upvalues: useLocalization (copy), TextKeys (copy), useStyle (copy), React (copy), Roact (copy), ImageSetLabel (copy), IconSize (copy), v14 (copy), CallbackInputBox (copy), v15 (copy)
	local v17 = useLocalization({
		searchContacts = TextKeys.SEARCH_CONTACTS
	})
	local v18 = useStyle()
	local v19, v20 = React.useState(false)

	return Roact.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = v18.Theme.BackgroundMuted.Transparency,
		BackgroundColor3 = v18.Theme.BackgroundMuted.Color,
		Size = UDim2.new(1, 0, 0, t1.height),
		LayoutOrder = t1.layoutOrder
	}, {
		layout = Roact.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 4)
		}),
		BorderRadius = Roact.createElement("UICorner", {
			CornerRadius = UDim.new(0, 4)
		}),
		Border = React.createElement("UIStroke", {
			Thickness = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
			Color = if not v19 then v18.Theme.Divider.Color else v18.Theme.SecondaryOnHover.Color,
			Transparency = if not v19 then v18.Theme.Divider.Transparency else v18.Theme.SecondaryOnHover.Transparency
		}),
		padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 13),
			PaddingRight = UDim.new(0, 13)
		}),
		icon = Roact.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(0, IconSize.Small, 0, IconSize.Small),
			Image = v14,
			ImageColor3 = v18.Theme.IconEmphasis.Color
		}),
		searchBarWrapper = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, -IconSize.Small, 0, t1.height)
		}, {
			searchBar = Roact.createElement(CallbackInputBox, {
				clearButtonDisabled = false,
				clearIcon = v15,
				clearIconColor3 = v18.Theme.IconEmphasis.Color,
				clearIconTransparency = v18.Theme.IconEmphasis.Transparency,
				clearButtonSize = IconSize.Small,
				focusChangedCallback = v20,
				inputTextColor3 = v18.Theme.TextEmphasis.Color,
				inputTextTransparency = v18.Theme.TextEmphasis.Transparency,
				placeholderText = v17.searchContacts,
				placeholderTextColor3 = v18.Theme.TextMuted.Color,
				placeholderTextTransparency = v18.Theme.TextMuted.Transparency,
				inputTextXAlignment = Enum.TextXAlignment.Left,
				textChangedCallback = t1.textChangeCallback
			})
		})
	})
end

return ContactsListSearchBar
