local AvatarExperienceSearch = script:FindFirstAncestor("AvatarExperienceSearch")
local AvatarExperienceSearchParent = AvatarExperienceSearch.Parent
local React = require(AvatarExperienceSearchParent.React)
local UIBlox = require(AvatarExperienceSearchParent.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(AvatarExperienceSearchParent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local RoactGamepad = require(AvatarExperienceSearchParent.RoactGamepad)
local useDesignTokens = require(AvatarExperienceSearchParent.Style).useDesignTokens
local useLocalization = require(AvatarExperienceSearchParent.Localization).Hooks.useLocalization
local wasLastInputGamepad = require(AvatarExperienceSearchParent.RoactUtils).wasLastInputGamepad
local AXCommon = require(AvatarExperienceSearchParent.AXCommon)
local FlexLayout = require(AvatarExperienceSearch.Components.FlexLayout)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local useSelectionCursor = UIBlox.App.SelectionImage.useSelectionCursor
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local Focusable = RoactGamepad.Focusable
local AXRecentlyViewedSearchItemsIXPTest = AXCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest
local v19 = game:DefineFastFlag("AXFixConditionalUseRefSearchBar", false)
local t1 = {
	clear = Images["icons/actions/edit/clear_small"],
	search = Images["icons/common/search_small"]
}
local t2 = {
	cancelButtonText = "Feature.Catalog.Action.Cancel",
	placeholder = "Feature.Catalog.Search.Placeholder"
}

local function mapTokens(p1) -- line: 40
	-- upvalues: FFlagRenameDeprecatedUIBloxTokens (copy)
	return {
		borderRadius = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Radius.Medium else p1.Radius.Medium,
		cancelButtonPadding = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Space_100 else p1.Size.Size_200,
		defaultHeight = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Size_500 else p1.Size.Size_1000,
		font = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Typography.Body.Font else p1.Typography.BodyLarge.Font,
		iconAndTextInputMargin = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Space_200 else p1.Size.Size_400,
		iconOffsetX = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Size_150 else p1.Size.Size_300,
		iconSize = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Size_200 else p1.Size.Size_400,
		inputAndCancelButtonMargin = if not FFlagRenameDeprecatedUIBloxTokens then p1.Global.Space_100 else p1.Size.Size_200,
		inputBackgroundColor = ((if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Background.Contrast else p1.Color.Surface.Surface_100)).Color3,
		textIconColor = ((if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Text.Emphasis else p1.Color.Content.Emphasis)).Color3,
		textIconTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Color.Text.Emphasis else p1.Color.Content.Emphasis)).Transparency,
		textSize = if not FFlagRenameDeprecatedUIBloxTokens then p1.Semantic.Typography.Body.FontSize else p1.Typography.BodyLarge.FontSize
	}
end
local function SearchBar(t3: {[any]: any}, p2) -- line: 92
	-- upvalues: useLocalization (copy), t2 (copy), useDesignTokens (copy), mapTokens (copy), useSelectionCursor (copy), CursorKind (copy), React (copy), AXRecentlyViewedSearchItemsIXPTest (copy), v19 (copy), wasLastInputGamepad (copy), FlexLayout (copy), ImageSetLabel (copy), t1 (copy), Focusable (copy), ImageSetButton (copy)
	local v27 = useLocalization(t2)
	local v28 = useDesignTokens(mapTokens)
	local v29 = useSelectionCursor(CursorKind.InputFields)
	local v30 = useSelectionCursor(CursorKind.RoundedRect)
	local v31 = useSelectionCursor(CursorKind.RoundedRectNoInset)
	local v32, v33 = React.useState(t3.text and t3.text ~= "")
	local v34 = if not AXRecentlyViewedSearchItemsIXPTest.isEnabled() and not v19 then p2 or React.useRef(nil) else p2
	local v35 = React.useRef(nil)
	local v36 = React.useRef(nil)
	local v37 = React.useRef(false)
	local v38 = t3.height or v28.defaultHeight
	local v39 = t3.placeholder or v27.placeholder
	local v40 = v28.iconSize + 2 * v28.iconOffsetX
	local v41 = -v40 + (not v32 and 0 or -v40)
	local v42 = -(v28.iconSize + v28.iconOffsetX)

	React.useEffect(function() -- line: 117
		-- upvalues: t3 (copy), v19 (copy), v34 (copy), v37 (copy), wasLastInputGamepad (copy)
		if t3.autofocus and ((not v19 or v34) and v34.current and not v37.current and not wasLastInputGamepad()) then
			v37.current = true
			v34.current:CaptureFocus()
		end
	end, { t3.autofocus })

	return React.createElement(FlexLayout, {
		margin = v28.inputAndCancelButtonMargin,
		flexSlot = React.createElement("Frame", {
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			BackgroundColor3 = v28.inputBackgroundColor,
			Size = UDim2.new(1, 0, 0, v38)
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, v28.borderRadius)
			}),
			SearchIcon = React.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0, 0.5),
				Image = t1.search,
				ImageColor3 = v28.textIconColor,
				ImageTransparency = v28.textIconTransparency,
				Position = UDim2.new(0, v28.iconOffsetX, 0.5, 0),
				Size = UDim2.fromOffset(v28.iconSize, v28.iconSize)
			}),
			SearchBox = React.createElement(Focusable.TextBox, {
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClearTextOnFocus = false,
				ClipsDescendants = true,
				Font = v28.font,
				OverlayNativeInput = true,
				PlaceholderColor3 = v28.textIconColor,
				PlaceholderText = v39,
				Position = UDim2.new(0, v40, 0.5, 0),
				ReturnKeyType = Enum.ReturnKeyType.Search,
				RichText = false,
				Size = UDim2.new(1, v41, 1, 0),
				Text = t3.text or "",
				TextColor3 = v28.textIconColor,
				TextInputType = Enum.TextInputType.NoSuggestions,
				TextSize = v28.textSize,
				TextTransparency = v28.textIconTransparency,
				TextWrapped = false,
				TextXAlignment = Enum.TextXAlignment.Left,
				[React.Change.Text] = function(p3) -- line: 146
					-- upvalues: t3 (copy), v33 (copy)
					if t3.onChange then
						t3.onChange(p3.Text or "")
					end

					v33(p3.Text ~= "")
				end,
				[React.Event.Focused] = function(p4) -- line: 154
					-- upvalues: t3 (copy)
					if t3.onFocus then
						t3.onFocus(p4)
					end
				end,
				[React.Event.FocusLost] = function(p5, p6, _) -- line: 160
					-- upvalues: t3 (copy)
					if p6 and t3.onSubmit then
						t3.onSubmit(p5.Text or "")
					end
				end,
				[React.Event.ReturnPressedFromOnScreenKeyboard] = function(p8) -- line: 168
					-- upvalues: t3 (copy)
					if t3.onSubmit then
						t3.onSubmit(p8.Text or "")
					end
				end,
				[React.Tag] = "data-testid=AvatarExperienceSearch_SearchBar_TextBox",
				ref = v34,
				SelectionImageObject = v29,
				NextSelectionDown = t3.nextSelectionDown,
				NextSelectionUp = t3.nextSelectionUp,
				NextSelectionRight = if not v32 then if not t3.showCancelButton then nil else v36 else v35
			}),
			ClearSearchButton = v32 and React.createElement(Focusable[ImageSetButton], {
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				Image = t1.clear,
				ImageColor3 = v28.textIconColor,
				ImageTransparency = v28.textIconTransparency,
				Position = UDim2.new(1, v42, 0.5, 0),
				Size = UDim2.fromOffset(v28.iconSize, v28.iconSize),
				[React.Event.Activated] = function() -- line: 135
					-- upvalues: v19 (copy), v34 (copy), t3 (copy)
					if (not v19 or v34) and v34.current then
						if t3.onClear then
							t3.onClear(v34.current.Text or "")
						end

						v34.current.Text = ""
						v34.current:CaptureFocus()
					end
				end,
				[React.Tag] = "data-testid=AvatarExperienceSearch_SearchBar_ClearButton",
				SelectionImageObject = v30,
				NextSelectionDown = t3.nextSelectionDown,
				NextSelectionUp = t3.nextSelectionUp,
				NextSelectionLeft = v34,
				NextSelectionRight = if not t3.showCancelButton then nil else v36
			})
		}),
		rigidSlot = if not t3.showCancelButton then nil else React.createElement(Focusable.TextButton, {
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Font = v28.font,
			Size = UDim2.new(0, 0, 0, v38),
			Text = v27.cancelButtonText,
			TextColor3 = v28.textIconColor,
			TextSize = v28.textSize,
			TextTransparency = v28.textIconTransparency,
			TextXAlignment = Enum.TextXAlignment.Center,
			[React.Event.Activated] = t3.onCancel,
			[React.Tag] = "data-testid=AvatarExperienceSearch_SearchBar_CancelButton",
			SelectionImageObject = v31,
			NextSelectionDown = t3.nextSelectionDown,
			NextSelectionUp = t3.nextSelectionUp,
			NextSelectionLeft = if not v32 then v34 else v35
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingRight = UDim.new(0, v28.cancelButtonPadding),
				PaddingLeft = UDim.new(0, v28.cancelButtonPadding)
			})
		})
	})
end

return React.forwardRef(SearchBar)
