local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local useCursor = UIBlox.App.SelectionCursor.useCursor
local useStyle = UIBlox.Core.Style.useStyle

local function CommentTextField(props)
	local state, setState = React.useState("")
	local v5 = useCursor()
	local v6 = useStyle()
	local font = v6.Font.Body.Font
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
	local v11 = {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10)
		}),
		UICorner = React.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
		CommentField = 0
	}

	local createElement2 = React.createElement
	local v13 = {}
	v13.Size = UDim2.new(1, 0, 0, 40)
	v13.AutomaticSize = Enum.AutomaticSize.Y
	v13.Position = UDim2.new(0, 0, 0, 0)
	v13.AnchorPoint = Vector2.new(0, 0)
	v13.BackgroundColor3 = props.backgroundColor3 or theme.BackgroundDefault.Color
	v13.PlaceholderText = props.placeholderText

	if foundationFontFaceMigration then
		font = nil
	end

	v13.Font = font

	local v14 = if foundationFontFaceMigration then normalizeFontFace(v6.Tokens.Typography.BodyLarge.Font) else nil
	v13.FontFace = v14

	v13.SelectionImageObject = v5
	v13.Text = props.text
	v13.TextSize = baseSize
	v13.TextColor3 = theme.TextDefault.Color
	v13.TextTransparency = theme.TextDefault.Transparency
	v13.TextXAlignment = props.textXAlignment or Enum.TextXAlignment.Left
	v13.TextYAlignment = props.textYAlignment or Enum.TextYAlignment.Top
	v13.BackgroundTransparency = 1
	v13.BorderSizePixel = 0
	v13.LayoutOrder = 1
	v13.RichText = false
	v13.MultiLine = true
	v13.TextWrapped = true
	v13.TextTruncate = Enum.TextTruncate.SplitWord
	v13.ClearTextOnFocus = false
	v13.OverlayNativeInput = true
	v13.ClipsDescendants = true
	v13.Interactable = props.interactable
	v13[React.Change.Text] = v7
	v11.CommentField = createElement2("TextBox", v13)
	return createElement("Frame", v9, v11)
end

return CommentTextField
