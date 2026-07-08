local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local t1 = {
	searchPlaceholder = "Feature.Catalog.Label.Search",
	clear = "Feature.Avatar.Action.Clear"
}

local function SearchInputView(t2: {[any]: any}) -- line: 31
	-- upvalues: useTokens (copy), useLocalization (copy), t1 (copy), React (copy), Foundation (copy)
	local v9 = useTokens()
	local v10 = useLocalization(t1)
	local v11 = Font.fromEnum(v9.Typography.BodyMedium.Font)
	local FontSize = v9.Typography.BodyMedium.FontSize

	return React.createElement(Foundation.View, {
		tag = "row align-y-center gap-small size-full-0 auto-y padding-x-xlarge radius-medium",
		testId = "SearchInputView"
	}, {
		BackButton = React.createElement(Foundation.IconButton, {
			LayoutOrder = 0,
			icon = Foundation.Enums.IconName.ChevronLargeLeft,
			variant = Foundation.Enums.ButtonVariant.Utility,
			size = Foundation.Enums.ButtonSize.Small,
			onActivated = t2.onBack
		}),
		SearchField = React.createElement(Foundation.View, {
			tag = "fill radius-medium bg-surface-200",
			LayoutOrder = 1,
			Size = UDim2.fromOffset(0, 36)
		}, {
			SearchIcon = React.createElement(Foundation.Icon, {
				name = Foundation.Enums.IconName.MagnifyingGlass,
				size = Foundation.Enums.IconSize.Small,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.new(0, 12, 0.5, 0)
			}),
			TextBox = React.createElement("TextBox", {
				ref = t2.textBoxRef,
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClearTextOnFocus = false,
				ClipsDescendants = true,
				FontFace = v11,
				PlaceholderText = v10.searchPlaceholder,
				PlaceholderColor3 = v9.Color.Content.Default.Color3,
				Position = UDim2.new(0, 40, 0.5, 0),
				Size = UDim2.new(1, -40, 1, 0),
				Text = t2.text,
				TextColor3 = v9.Color.Content.Emphasis.Color3,
				TextSize = FontSize,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = false,
				[React.Change.Text] = t2.onTextChanged,
				[React.Event.FocusLost] = t2.onFocusLost
			})
		}),
		ClearButton = React.createElement(Foundation.Button, {
			LayoutOrder = 2,
			text = v10.clear,
			variant = Foundation.Enums.ButtonVariant.Utility,
			size = Foundation.Enums.InputSize.XSmall,
			onActivated = t2.onClear
		})
	})
end

return SearchInputView
