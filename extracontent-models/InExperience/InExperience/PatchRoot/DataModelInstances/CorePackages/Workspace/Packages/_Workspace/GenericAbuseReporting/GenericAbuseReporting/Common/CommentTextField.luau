local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local useCursor = UIBlox.App.SelectionCursor.useCursor
local useStyle = UIBlox.Core.Style.useStyle
local FFlagChatLineReportingFocusFixesEnabled = require(Parent.SharedFlags).FFlagChatLineReportingFocusFixesEnabled
local v7 = game:DefineFastFlag("AddBackgroundTransparencyToAbuseReportCommentTextField", false)

local function CommentTextField(t1: {[any]: any}) -- line: 27
	-- upvalues: React (copy), FFlagChatLineReportingFocusFixesEnabled (copy), useCursor (copy), useStyle (copy), v7 (copy)
	local v10, v11 = React.useState("")
	local v12 = if not FFlagChatLineReportingFocusFixesEnabled then nil else useCursor()
	local v13 = useStyle()
	local BodyFont = v13.Font.Body.Font
	local BaseSize = v13.Font.BaseSize
	local Theme = v13.Theme
	local v17 = React.useCallback(function(p1) -- line: 35
		-- upvalues: v11 (copy), t1 (copy), v10 (copy)
		local p1Text = p1.Text

		if p1.TextFits then
			v11(p1Text)
			t1.onUpdate(p1Text)

			return
		end

		p1.Text = v10
	end)

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 60),
		BackgroundTransparency = if not v7 then v13.Theme.BackgroundDefault.Transparency else if t1.backgroundTransparency == nil then v13.Theme.BackgroundDefault.Transparency else t1.backgroundTransparency,
		BackgroundColor3 = t1.backgroundColor3 or v13.Theme.BackgroundDefault.Color,
		LayoutOrder = t1.layoutOrder,
		AutomaticSize = Enum.AutomaticSize.Y
	}, {
		UIPadding = React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
			PaddingTop = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10)
		}),
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, 8)
		}),
		CommentField = React.createElement("TextBox", {
			Size = UDim2.new(1, 0, 0, 40),
			AutomaticSize = Enum.AutomaticSize.Y,
			Position = UDim2.new(0, 0, 0, 0),
			AnchorPoint = Vector2.new(0, 0),
			BackgroundColor3 = t1.backgroundColor3 or Theme.BackgroundDefault.Color,
			PlaceholderText = t1.placeholderText,
			Font = BodyFont,
			SelectionImageObject = v12,
			Text = t1.text,
			TextSize = BaseSize,
			TextColor3 = Theme.TextDefault.Color,
			TextTransparency = Theme.TextDefault.Transparency,
			TextXAlignment = t1.textXAlignment or Enum.TextXAlignment.Left,
			TextYAlignment = t1.textYAlignment or Enum.TextYAlignment.Top,
			BackgroundTransparency = if not v7 then Theme.BackgroundDefault.Transparency else 1,
			BorderSizePixel = 0,
			LayoutOrder = 1,
			RichText = false,
			MultiLine = true,
			TextWrapped = true,
			TextTruncate = Enum.TextTruncate.SplitWord,
			ClearTextOnFocus = false,
			OverlayNativeInput = true,
			ClipsDescendants = true,
			Interactable = t1.interactable,
			[React.Change.Text] = v17
		})
	})
end

return CommentTextField
