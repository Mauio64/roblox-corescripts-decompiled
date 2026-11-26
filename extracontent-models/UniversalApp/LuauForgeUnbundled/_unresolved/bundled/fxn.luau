local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/React")
local module2 = require("@luauforge/bundled/fxp")
local normalizeFontFace = require("@luauforge/bundled/fxq").Utility.normalizeFontFace

local module3 = require("@luauforge/bundled/fxr")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/Style").useDesignTokens
local useLocalization = require("@luauforge/bundled/fxk").Hooks.useLocalization
local wasLastInputGamepad = require("@luauforge/bundled/fxt").wasLastInputGamepad
local module4 = require("@luauforge/bundled/fxu")

local module5 = require("@luauforge/bundled/fxv")

local images = module2.App.ImageSet.Images
local imageSetLabel = module2.Core.ImageSet.ImageSetLabel
local imageSetButton = module2.Core.ImageSet.ImageSetButton
local useSelectionCursor = module2.App.SelectionImage.useSelectionCursor
local cursorKind = module2.App.SelectionImage.CursorKind

local focusable = module3.Focusable

local axRecentlyViewedSearchItemsIXPTest = module4.Experiments.AXRecentlyViewedSearchItemsIXPTest

local defineFastFlag = game:DefineFastFlag("AXFixConditionalUseRefSearchBar", false)

local v5 = {
	clear = images["icons/actions/edit/clear_small"],
	search = images["icons/common/search_small"]
}

local v6 = {
	cancelButtonText = "Feature.Catalog.Action.Cancel",
	placeholder = "Feature.Catalog.Search.Placeholder"
}

local function mapTokens(data)
	return {
		borderRadius = data.Radius.Medium,
		cancelButtonPadding = data.Size.Size_200,
		defaultHeight = data.Size.Size_1000,
		font = data.Typography.BodyLarge.Font,
		iconAndTextInputMargin = data.Size.Size_400,
		iconOffsetX = data.Size.Size_300,
		iconSize = data.Size.Size_400,
		inputAndCancelButtonMargin = data.Size.Size_200,
		inputBackgroundColor = data.Color.Surface.Surface_100.Color3,
		textIconColor = data.Color.Content.Emphasis.Color3,
		textIconTransparency = data.Color.Content.Emphasis.Transparency,
		textSize = data.Typography.BodyLarge.FontSize
	}
end

local function SearchBar(props, p2)
	local v7 = useLocalization(v6)
	local v8 = useDesignTokens(mapTokens)
	local v9 = useSelectionCursor(cursorKind.InputFields)
	local v10 = useSelectionCursor(cursorKind.RoundedRect)
	local v11 = useSelectionCursor(cursorKind.RoundedRectNoInset)

	local state, setState = React.useState(props.text and props.text ~= "")

	if not (axRecentlyViewedSearchItemsIXPTest.isEnabled() or defineFastFlag) then
		p2 = p2 or React.useRef(nil)
	end

	local v12 = React.useRef(nil)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(false)

	local height = props.height or v8.defaultHeight
	local placeholder = props.placeholder or v7.placeholder

	local v13 = v8.iconSize + 2 * v8.iconOffsetX
	local v14 = -v13 + (not state and 0 or -v13)
	local v15 = -(v8.iconSize + v8.iconOffsetX)

	React.useEffect(function()
		if
			props.autofocus
			and (not defineFastFlag or p2)
			and p2.current
			and not (ref2.current or wasLastInputGamepad())
		then
			ref2.current = true
			p2.current:CaptureFocus()
		end
	end, { props.autofocus })

	local function fn()
		if (not defineFastFlag or p2) and p2.current then
			if props.onClear then
				props.onClear(p2.current.Text or "")
			end

			p2.current.Text = ""

			p2.current:CaptureFocus()
		end
	end

	local createElement = React.createElement
	local v17 = { margin = v8.inputAndCancelButtonMargin, flexSlot = 0, rigidSlot = 0 }
	local createElement2 = React.createElement
	local v19 = {
		BackgroundColor3 = v8.inputBackgroundColor,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, height)
	}
	local v20 = {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, v8.borderRadius)
		}),
		SearchIcon = React.createElement(imageSetLabel, {
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Image = v5.search,
			ImageColor3 = v8.textIconColor,
			ImageTransparency = v8.textIconTransparency,
			Position = UDim2.new(0, v8.iconOffsetX, 0.5, 0),
			Size = UDim2.fromOffset(v8.iconSize, v8.iconSize)
		}),
		SearchBox = 0,
		ClearSearchButton = 0
	}

	local createElement3 = React.createElement
	local textBox = focusable.TextBox
	local v21 = {
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClearTextOnFocus = false,
		ClipsDescendants = true,
		FontFace = normalizeFontFace(v8.font),
		OverlayNativeInput = true,
		PlaceholderColor3 = v8.textIconColor,
		PlaceholderText = placeholder,
		Position = UDim2.new(0, v13, 0.5, 0),
		ReturnKeyType = Enum.ReturnKeyType.Search,
		RichText = false,
		Size = UDim2.new(1, v14, 1, 0),
		Text = props.text or "",
		TextColor3 = v8.textIconColor,
		TextInputType = Enum.TextInputType.NoSuggestions,
		TextSize = v8.textSize,
		TextTransparency = v8.textIconTransparency,
		TextWrapped = false,
		TextXAlignment = Enum.TextXAlignment.Left,
		[React.Change.Text] = function(p3)
			if props.onChange then
				props.onChange(p3.Text or "")
			end

			setState(p3.Text ~= "")
		end,
		[React.Event.Focused] = function(p3)
			if props.onFocus then
				props.onFocus(p3)
			end
		end,
		[React.Event.FocusLost] = function(p3, p4, p5)
			if p4 and props.onSubmit then
				props.onSubmit(p3.Text or "")
			end
		end,
		[React.Event.ReturnPressedFromOnScreenKeyboard] = function(p3)
			if props.onSubmit then
				props.onSubmit(p3.Text or "")
			end
		end,
		[React.Tag] = "data-testid=AvatarExperienceSearch_SearchBar_TextBox",
		ref = p2,
		SelectionImageObject = v9,
		NextSelectionDown = props.nextSelectionDown,
		NextSelectionUp = props.nextSelectionUp
	}

	local v22 = if state then v12 elseif props.showCancelButton then ref else nil
	v21.NextSelectionRight = v22
	v20.SearchBox = createElement3(textBox, v21)
	local v23

	if state then
		local createElement4 = React.createElement
		local v24 = focusable[imageSetButton]
		local v25 = {
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundTransparency = 1,
			Image = v5.clear,
			ImageColor3 = v8.textIconColor,
			ImageTransparency = v8.textIconTransparency,
			Position = UDim2.new(1, v15, 0.5, 0),
			Size = UDim2.fromOffset(v8.iconSize, v8.iconSize),
			[React.Event.Activated] = fn,
			[React.Tag] = "data-testid=AvatarExperienceSearch_SearchBar_ClearButton",
			SelectionImageObject = v10,
			NextSelectionDown = props.nextSelectionDown,
			NextSelectionUp = props.nextSelectionUp,
			NextSelectionLeft = p2
		}

		if not props.showCancelButton then
			ref = nil
		end

		v25.NextSelectionRight = ref
		v23 = createElement4(v24, v25)
	else
		v23 = state
	end

	v20.ClearSearchButton = v23
	v17.flexSlot = createElement2("Frame", v19, v20)
	local v24

	if props.showCancelButton then
		local createElement4 = React.createElement
		local textButton = focusable.TextButton
		local v25 = {
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			FontFace = normalizeFontFace(v8.font),
			Size = UDim2.new(0, 0, 0, height),
			Text = v7.cancelButtonText,
			TextColor3 = v8.textIconColor,
			TextSize = v8.textSize,
			TextTransparency = v8.textIconTransparency,
			TextXAlignment = Enum.TextXAlignment.Center,
			[React.Event.Activated] = props.onCancel,
			[React.Tag] = "data-testid=AvatarExperienceSearch_SearchBar_CancelButton",
			SelectionImageObject = v11,
			NextSelectionDown = props.nextSelectionDown,
			NextSelectionUp = props.nextSelectionUp
		}

		if not state then
			v12 = p2
		end

		v25.NextSelectionLeft = v12
		v24 = createElement4(textButton, v25, {
			Padding = React.createElement("UIPadding", {
				PaddingRight = UDim.new(0, v8.cancelButtonPadding),
				PaddingLeft = UDim.new(0, v8.cancelButtonPadding)
			})
		})
	end

	v17.rigidSlot = v24
	return createElement(module5, v17)
end

return React.forwardRef(SearchBar)
