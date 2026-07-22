local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local useCursor = UIBlox.App.SelectionCursor.useCursor
local useStyle = UIBlox.Core.Style.useStyle
local FFlagChatLineReportingFocusFixesEnabled = require(Parent.SharedFlags).FFlagChatLineReportingFocusFixesEnabled

local function CommentTextField(t1: {[any]: any}) -- line: 25
	-- upvalues: React (copy), FFlagChatLineReportingFocusFixesEnabled (copy), useCursor (copy), useStyle (copy)
	local v9, v10 = React.useState("")
	local v11 = if not FFlagChatLineReportingFocusFixesEnabled then nil else useCursor()
	local v12 = useStyle()
	local BodyFont = v12.Font.Body.Font
	local BaseSize = v12.Font.BaseSize
	local Theme = v12.Theme
	local v16 = React.useCallback(function(p1) -- line: 33
		-- upvalues: v10 (copy), t1 (copy), v9 (copy)
		local p1Text = p1.Text

		if p1.TextFits then
			v10(p1Text)
			t1.onUpdate(p1Text)

			return
		end

		p1.Text = v9
	end)

	return React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 60),
		BackgroundTransparency = if t1.backgroundTransparency == nil then v12.Theme.BackgroundDefault.Transparency else t1.backgroundTransparency,
		BackgroundColor3 = t1.backgroundColor3 or v12.Theme.BackgroundDefault.Color,
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
			SelectionImageObject = v11,
			Text = t1.text,
			TextSize = BaseSize,
			TextColor3 = Theme.TextDefault.Color,
			TextTransparency = Theme.TextDefault.Transparency,
			TextXAlignment = t1.textXAlignment or Enum.TextXAlignment.Left,
			TextYAlignment = t1.textYAlignment or Enum.TextYAlignment.Top,
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
			Interactable = t1.interactable,
			[React.Change.Text] = v16
		})
	})
end

return CommentTextField
