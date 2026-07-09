local Parent = script:FindFirstAncestor("SocialCommon").Parent
local CallbackInputBox = require(Parent.LuaSocialLibrariesDeps).SocialLibraries.config({}).Components.CallbackInputBox
local React = require(Parent.React)
local RoactAppExperiment = require(Parent.RoactAppExperiment)
local Text = require(Parent.AppCommonLib).Text
local Dash = require(Parent.Dash)
local UIBlox = require(Parent.UIBlox)
local IconSize = UIBlox.App.Constant.IconSize
local TextButton = UIBlox.App.Button.TextButton
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local useStyle = UIBlox.Core.Style.useStyle
local Foundation = require(Parent.Foundation)
local Icon = Foundation.Icon
local Enums = Foundation.Enums
local v16 = Images["icons/actions/edit/clear_small"]
local FFlagDisableAutocorrectSocialUserSearch = require(Parent.SharedFlags).FFlagDisableAutocorrectSocialUserSearch
local FFlagEnableLeftNavOnConsole = require(Parent.SharedFlags).FFlagEnableLeftNavOnConsole
local v19 = game:DefineFastString("DisableAutocorrectExperimentLayer", "Social.UserSearchUX")
local t1 = {
	cancelText = "Cancel",
	searchPlaceholderText = "Text",
	initialInputText = nil,
	LayoutOrder = 1,
	isDisabled = false,
	captureFocusOnMount = false,
	cancelCallback = nil,
	textChangedCallback = nil,
	focusChangedCallback = function() -- line: 72
	end
}

return function(p1) -- line: 75
	-- upvalues: FFlagDisableAutocorrectSocialUserSearch (copy), RoactAppExperiment (copy), v19 (copy), Dash (copy), t1 (copy), useStyle (copy), React (copy), Text (copy), TextButton (copy), ImageSetLabel (copy), Icon (copy), Enums (copy), CallbackInputBox (copy), v16 (copy), IconSize (copy), FFlagEnableLeftNavOnConsole (copy)
	local v22 = if not FFlagDisableAutocorrectSocialUserSearch then nil else RoactAppExperiment.useUserExperiment({ v19 }, function(p2) -- line: 77
		-- upvalues: v19 (copy)
		return (p2[v19] or {}).disableAutocorrectSocialUserSearch
	end)
	local v23 = Dash.join(t1, p1 or {})
	local v24 = useStyle()
	local v25 = React.useRef(nil)
	local v26, v27 = React.useState(nil)
	local v28, v29 = React.useState(nil)

	React.useEffect(function() -- line: 90
		-- upvalues: v23 (copy)
		if v23.onSelectCallback then
			v23.onSelectCallback()
		end

		if v23.resetOnMount then
			v23.resetOnMount()
		end
	end, {})

	local Header2 = v24.Font.Header2
	local v31 = v24.Font.BaseSize * Header2.RelativeSize
	local v32 = Text.GetTextWidth(v23.cancelText, Header2.Font, v31)
	local uDim = UDim.new(0, 4)
	local v34 = if not v23.isDisabled then UDim2.new(1, -v32 - 12, 1, 0) else UDim2.new(1, 0, 1, 0)
	local Body = v24.Font.Body
	local v36 = v24.Font.BaseSize * Body.RelativeSize

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		BackgroundTransparency = v24.Theme.BackgroundDefault.Transparency,
		BackgroundColor3 = v24.Theme.BackgroundDefault.Color,
		Size = UDim2.new(1, 0, 1, 0),
		LayoutOrder = v23.LayoutOrder
	}, {
		Layout = React.createElement("UIListLayout", {
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = uDim
		}),
		Padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 6),
			PaddingBottom = UDim.new(0, 6)
		}),
		CancelTextButton = if not v23.isDisabled then v23.cancelCallback and React.createElement(TextButton, {
			layoutOrder = 2,
			text = v23.cancelText,
			onActivated = v23.cancelCallback
		}) else nil,
		FilterBoxBackground = React.createElement(ImageSetLabel, {
			BorderSizePixel = 0,
			LayoutOrder = 1,
			Size = v34,
			BackgroundColor3 = v24.Theme.UIMuted.Color,
			BackgroundTransparency = v24.Theme.UIMuted.Transparency
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 4)
			}),
			UIStroke = React.createElement("UIStroke", {
				Thickness = 1,
				Color = v26 or v24.Theme.Divider.Color,
				Transparency = v28 or v24.Theme.Divider.Transparency
			}),
			UIListLayout = React.createElement("UIListLayout", {
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4)
			}),
			UIPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10)
			}),
			SearchIcon = React.createElement(Icon, {
				name = Enums.IconName.MagnifyingGlass,
				size = Enums.IconSize.Medium
			}),
			FilterBoxContainer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.new(1, -28, 1, 0)
			}, {
				filterBox = if not v23.isDisabled then React.createElement(CallbackInputBox, {
					clearButtonDisabled = false,
					initialInputText = v23.initialInputText,
					inputTextColor3 = v24.Theme.TextEmphasis.Color,
					inputTextFont = Body.Font,
					inputTextSize = v36,
					inputTextTransparency = v24.Theme.TextEmphasis.Transparency,
					inputTextXAlignment = Enum.TextXAlignment.Left,
					textInputType = if not FFlagDisableAutocorrectSocialUserSearch or not v22 then nil else Enum.TextInputType.NoSuggestions,
					returnKeyType = if not FFlagDisableAutocorrectSocialUserSearch or not v22 then nil else Enum.ReturnKeyType.Search,
					placeholderText = v23.searchPlaceholderText,
					placeholderTextColor3 = v24.Theme.TextDefault.Color,
					placeholderTextTransparency = v24.Theme.TextMuted.Transparency,
					captureFocusOnMount = v23.captureFocusOnMount,
					clearIcon = v16,
					clearIconColor3 = v24.Theme.IconEmphasis.Color,
					clearIconTransparency = v24.Theme.IconEmphasis.Transparency,
					clearButtonSize = IconSize.Small,
					textChangedCallback = v23.textChangedCallback,
					onSelectCallback = v23.onSelectCallback,
					focusChangedCallback = function(p3, p4) -- line: 114
						-- upvalues: v23 (copy), v27 (copy), v24 (copy), v29 (copy)
						if v23.focusChangedCallback then
							v23.focusChangedCallback(p3, p4)
						end

						if p3 then
							v27(v24.Theme.SecondaryOnHover.Color)
							v29(v24.Theme.SecondaryOnHover.Transparency)

							return
						end

						v27(v24.Theme.Divider.Color)
						v29(v24.Theme.Divider.Transparency)
					end,
					returnPressedFromOnScreenKeyboardCallback = if not FFlagEnableLeftNavOnConsole then if not FFlagDisableAutocorrectSocialUserSearch or not v22 then nil else v23.returnPressedFromOnScreenKeyboardCallback else v23.returnPressedFromOnScreenKeyboardCallback,
					inputBoxRef = v25
				}) else React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					Text = v23.searchPlaceholderText,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Center,
					Size = UDim2.fromScale(1, 1),
					TextSize = v36,
					Font = Body.Font,
					TextColor3 = v24.Theme.TextDefault.Color,
					TextTransparency = v24.Theme.TextMuted.Transparency
				})
			})
		})
	})
end
