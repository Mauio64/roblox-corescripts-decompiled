local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/React")
local module2 = require("@luauforge/bundled/fpV")
local module3 = require("@luauforge/bundled/fpW")
local normalizeFontFace = module3.Utility.normalizeFontFace
local foundationFontFaceMigration = module3.Utility.Flags.FoundationFontFaceMigration

local module4 = require("@luauforge/bundled/fpX")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/Style").useDesignTokens
local useLocalization = require("@luauforge/bundled/fpQ").Hooks.useLocalization
local wasLastInputGamepad = require("@luauforge/bundled/fpZ").wasLastInputGamepad
local module5 = require("@luauforge/bundled/fqa")

local module6 = require("@luauforge/bundled/fqb")

local images = module2.App.ImageSet.Images
local imageSetLabel = module2.Core.ImageSet.ImageSetLabel
local imageSetButton = module2.Core.ImageSet.ImageSetButton
local useSelectionCursor = module2.App.SelectionImage.useSelectionCursor
local cursorKind = module2.App.SelectionImage.CursorKind

local focusable = module4.Focusable

local axRecentlyViewedSearchItemsIXPTest = module5.Experiments.AXRecentlyViewedSearchItemsIXPTest

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

	local function fn2(p3)
		if props.onChange then
			props.onChange(p3.Text or "")
		end

		setState(p3.Text ~= "")
	end

	local function fn3(p3)
		if props.onFocus then
			props.onFocus(p3)
		end
	end

	local function fn4(p3, p4, p5)
		if p4 and props.onSubmit then
			props.onSubmit(p3.Text or "")
		end
	end

	local function fn5(p3)
		if props.onSubmit then
			props.onSubmit(p3.Text or "")
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
	local v21 = {}
	v21.AnchorPoint = Vector2.new(0, 0.5)
	v21.BackgroundTransparency = 1
	v21.BorderSizePixel = 0
	v21.ClearTextOnFocus = false
	v21.ClipsDescendants = true
	local v22 = if not foundationFontFaceMigration then v8.font else nil
	v21.Font = v22
	local v23 = if foundationFontFaceMigration then normalizeFontFace(v8.font) else nil
	v21.FontFace = v23
	v21.OverlayNativeInput = true
	v21.PlaceholderColor3 = v8.textIconColor
	v21.PlaceholderText = placeholder
	v21.Position = UDim2.new(0, v13, 0.5, 0)
	v21.ReturnKeyType = Enum.ReturnKeyType.Search
	v21.RichText = false
	v21.Size = UDim2.new(1, v14, 1, 0)
	v21.Text = props.text or ""
	v21.TextColor3 = v8.textIconColor
	v21.TextInputType = Enum.TextInputType.NoSuggestions
	v21.TextSize = v8.textSize
	v21.TextTransparency = v8.textIconTransparency
	v21.TextWrapped = false
	v21.TextXAlignment = Enum.TextXAlignment.Left
	v21[React.Change.Text] = fn2
	v21[React.Event.Focused] = fn3
	v21[React.Event.FocusLost] = fn4
	v21[React.Event.ReturnPressedFromOnScreenKeyboard] = fn5
	v21[React.Tag] = "data-testid=AvatarExperienceSearch_SearchBar_TextBox"
	v21.ref = p2
	v21.SelectionImageObject = v9
	v21.NextSelectionDown = props.nextSelectionDown
	v21.NextSelectionUp = props.nextSelectionUp

	local v24 = if state then v12 elseif props.showCancelButton then ref else nil
	v21.NextSelectionRight = v24
	v20.SearchBox = createElement3(textBox, v21)
	local v25

	if state then
		local createElement4 = React.createElement
		local v26 = focusable[imageSetButton]
		local v27 = {
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

		v27.NextSelectionRight = ref
		v25 = createElement4(v26, v27)
	else
		v25 = state
	end

	v20.ClearSearchButton = v25
	v17.flexSlot = createElement2("Frame", v19, v20)
	local v26

	if props.showCancelButton then
		local createElement4 = React.createElement
		local textButton = focusable.TextButton
		local v27 = {
			["AutomaticSize"] = nil,
			["AutomaticSize"] = nil,
			["AutomaticSize"] = nil,
			["AutomaticSize"] = nil,
			["AutomaticSize"] = nil,
			["AutomaticSize"] = nil,
			["AutomaticSize"] = nil,
			["AutomaticSize"] = nil,
			["AutomaticSize"] = nil,
			["AutomaticSize"] = nil,
			["AutomaticSize"] = nil,
			["AutomaticSize"] = nil,
			["AutomaticSize"] = nil,
			["AutomaticSize"] = nil,
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		}

		local v28 = if not foundationFontFaceMigration then v8.font else nil
		v27.Font = v28
		local v29 = if foundationFontFaceMigration then normalizeFontFace(v8.font) else nil
		v27.FontFace = v29
		v27.Size = UDim2.new(0, 0, 0, height)
		v27.Text = v7.cancelButtonText
		v27.TextColor3 = v8.textIconColor
		v27.TextSize = v8.textSize
		v27.TextTransparency = v8.textIconTransparency
		v27.TextXAlignment = Enum.TextXAlignment.Center
		v27[React.Event.Activated] = props.onCancel
		v27[React.Tag] = "data-testid=AvatarExperienceSearch_SearchBar_CancelButton"
		v27.SelectionImageObject = v11
		v27.NextSelectionDown = props.nextSelectionDown
		v27.NextSelectionUp = props.nextSelectionUp

		if not state then
			v12 = p2
		end

		v27.NextSelectionLeft = v12
		v26 = createElement4(textButton, v27, {
			Padding = React.createElement("UIPadding", {
				PaddingRight = UDim.new(0, v8.cancelButtonPadding),
				PaddingLeft = UDim.new(0, v8.cancelButtonPadding)
			})
		})
	end

	v17.rigidSlot = v26
	return createElement(module6, v17)
end

return React.forwardRef(SearchBar)
