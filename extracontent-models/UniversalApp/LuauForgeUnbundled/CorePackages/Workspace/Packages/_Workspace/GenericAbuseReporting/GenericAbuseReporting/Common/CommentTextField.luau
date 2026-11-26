local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/UIBlox")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation").Utility.normalizeFontFace
local useCursor = UIBlox.App.SelectionCursor.useCursor
local useStyle = UIBlox.Core.Style.useStyle

local function CommentTextField(props)
	local state, setState = React.useState("")
	local v5 = useCursor()
	local v6 = useStyle()
	local baseSize = v6.Font.BaseSize
	local theme = v6.Theme

	local v7 = React.useCallback(function(state2)
		local text = state2.Text

		if not state2.TextFits then
			state2.Text = state

			return
		end

		setState(text)
		props.onUpdate(text)
	end)

	local createElement = React.createElement
	local v9 = {
		Size = UDim2.new(1, 0, 0, 60),
		BackgroundTransparency = 0,
		BackgroundColor3 = 0,
		LayoutOrder = 0,
		AutomaticSize = 0
	}
	local v10 = if props.backgroundTransparency == nil then v6.Theme.BackgroundDefault.Transparency else props.backgroundTransparency
	v9.BackgroundTransparency = v10

	v9.BackgroundColor3 = props.backgroundColor3 or v6.Theme.BackgroundDefault.Color
	v9.LayoutOrder = props.layoutOrder
	v9.AutomaticSize = Enum.AutomaticSize.Y
	return createElement("Frame", v9, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10)
		}),
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		CommentField = React.createElement("TextBox", {
			Size = UDim2.new(1, 0, 0, 40),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UDim2.new(0, 0, 0, 0),
			AnchorPoint = Vector2.new(0, 0),
			BackgroundColor3 = props.backgroundColor3 or theme.BackgroundDefault.Color,
			PlaceholderText = props.placeholderText,
			FontFace = normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font),
			SelectionImageObject = v5,
			Text = props.text,
			TextSize = baseSize,
			TextColor3 = theme.TextDefault.Color,
			TextTransparency = theme.TextDefault.Transparency,
			TextXAlignment = props.textXAlignment or Enum.TextXAlignment.Left,
			TextYAlignment = props.textYAlignment or Enum.TextYAlignment.Top,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			RichText = false,
			MultiLine = true,
			TextWrapped = true,
			TextTruncate = Enum.TextTruncate.SplitWord,
			ClearTextOnFocus = false,
			OverlayNativeInput = true,
			ClipsDescendants = true,
			Interactable = props.interactable,
			[React.Change.Text] = v7
		})
	})
end

return CommentTextField
