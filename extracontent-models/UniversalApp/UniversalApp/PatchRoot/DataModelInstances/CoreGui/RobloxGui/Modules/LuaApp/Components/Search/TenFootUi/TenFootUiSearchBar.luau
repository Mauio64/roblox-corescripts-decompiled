local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local debounce = require(Modules.LuaApp.Util.debounce)
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local Cryo = require(CorePackages.Packages.Cryo)
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local mapTypographyVariantToFontEnum = require(CorePackages.Workspace.Packages.Style).mapTypographyVariantToFontEnum
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local function TenFootUiSearchBar(t1: {[any]: any}) -- line: 31
	-- upvalues: useDesignTokens (copy), mapTypographyVariantToFontEnum (copy), FFlagRenameDeprecatedUIBloxTokens (copy), useLocalization (copy), useSelectionCursor (copy), CursorKind (copy), React (copy), Cryo (copy), debounce (copy), ImageSetLabel (copy), Images (copy)
	local v17 = useDesignTokens(function(p1) -- line: 32
		-- upvalues: mapTypographyVariantToFontEnum (copy), FFlagRenameDeprecatedUIBloxTokens (copy)
		return {
			textStyles = {
				Font = mapTypographyVariantToFontEnum(if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Typography.Body else p1.Typography.BodyLarge),
				TextSize = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.FontSize_200 else p1.FontSize.FontSize_500,
				TextColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Text.Emphasis else p1.Color.Content.Emphasis)).Color3,
				TextTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Text.Emphasis else p1.Color.Content.Emphasis)).Transparency
			},
			Search = p1.LuaApps.Search,
			cornerRadius = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Radius.Small else p1.Radius.Small,
			leftPadding = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Space_200 else p1.Size.Size_400,
			backgroundColor = ((if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Background.Default else p1.Color.Surface.Surface_0)).Color3,
			placeholderColor = ((if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Text.Default else p1.Color.Content.Default)).Color3,
			iconColor = ((if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Icon.Default else p1.Color.Content.Default)).Color3,
			iconTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Icon.Default else p1.Color.Content.Default)).Transparency
		}
	end)
	local v18 = useLocalization({
		searchPlaceholder = "CommonUI.Controls.Action.Search"
	})
	local v19 = t1.placeholderText or v18.searchPlaceholder
	local v20 = useSelectionCursor(CursorKind.RoundedRectNoInset)
	local onSubmitSearch = t1.onSubmitSearch
	local onFocused = t1.onFocused
	local v23 = v17.Search.SearchBoxIconPaddingLeft + v17.leftPadding

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(v17.Search.SearchHeadingScale, 0, 0, v17.Search.SearchBoxHeight),
		Position = UDim2.fromScale(1 - v17.Search.SearchHeadingScale, 0),
		LayoutOrder = t1.layoutOrder
	}, {
		SearchBox = React.createElement("TextBox", Cryo.Dictionary.join(v17.textStyles, {
			ClearTextOnFocus = false,
			Position = UDim2.new(0, 0, 0, 0),
			PlaceholderText = v19,
			Size = UDim2.new(1, 0, 0, v17.Search.SearchBoxHeight),
			Text = "",
			BackgroundColor3 = v17.backgroundColor,
			PlaceholderColor3 = v17.placeholderColor,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			SelectionImageObject = v20,
			[React.Event.Focused] = onFocused,
			[React.Event.FocusLost] = onSubmitSearch,
			[React.Change.Text] = debounce(function(p2) -- line: 107
				-- upvalues: onSubmitSearch (copy)
				onSubmitSearch(p2)
			end, 0.25),
			ref = t1.textBoxRef
		}), {
			SearchIcon = React.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				ImageColor3 = v17.iconColor,
				ImageTransparency = v17.iconTransparency,
				Position = UDim2.new(0, -v17.Search.SearchBoxIconSize - v17.leftPadding, 0.5, 0),
				Size = UDim2.fromOffset(v17.Search.SearchBoxIconSize, v17.Search.SearchBoxIconSize),
				Image = Images["icons/common/search"]
			}),
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v17.cornerRadius)
			}),
			UIPadding = React.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, v17.Search.SearchBoxIconPaddingVertical),
				PaddingLeft = UDim.new(0, v23),
				PaddingRight = UDim.new(0, v17.Search.SearchBoxIconPaddingRight),
				PaddingTop = UDim.new(0, v17.Search.SearchBoxIconPaddingVertical)
			})
		})
	})
end

return TenFootUiSearchBar
