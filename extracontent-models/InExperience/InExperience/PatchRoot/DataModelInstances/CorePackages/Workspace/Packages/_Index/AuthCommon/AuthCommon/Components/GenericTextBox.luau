local Parent = script:FindFirstAncestor("AuthCommon").Parent
local Roact = require(Parent.Roact)
local UIBlox = require(Parent.UIBlox)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local GetImageData = require(Parent.RobloxAppAssets).GetImageData
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local OpenTypeSupport = UIBlox.Utility.OpenTypeSupport
local GetFFlagLuaAppFixSelectionCursor = require(Parent.SharedFlags).GetFFlagLuaAppFixSelectionCursor
local v10 = Roact.PureComponent:extend("GenericTextBox")
local GetFFlagLuaAppEnableOpenTypeSupport = require(Parent.SharedFlags).GetFFlagLuaAppEnableOpenTypeSupport
local EngineFeature = game:GetEngineFeature("EnableAndroidPasswordSuggestion")

v10.defaultProps = {
	PaddingX = 0,
	PaddingY = 0
}

function v10.render(p1) -- line: 27
	-- upvalues: GetFFlagLuaAppFixSelectionCursor (copy), withSelectionCursorProvider (copy)
	if GetFFlagLuaAppFixSelectionCursor() then
		return withSelectionCursorProvider(function(p2) -- line: 29
			-- upvalues: p1 (copy)
			return p1:renderWithSelectionCursor(p2)
		end)
	end

	return p1:renderWithSelectionCursor(nil)
end
function v10.renderWithSelectionCursor(p3, p4) -- line: 38
	-- upvalues: GetFFlagLuaAppFixSelectionCursor (copy), CursorKind (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), EngineFeature (copy), OpenTypeSupport (copy), Roact (copy), ImageSetLabel (copy), GetImageData (copy)
	local propsSize = p3.props.Size
	local propsPosition = p3.props.Position
	local propsLayoutOrder = p3.props.LayoutOrder
	local propsText = p3.props.Text
	local propsFont = p3.props.Font
	local propsTextSize = p3.props.TextSize
	local PlaceholderText = p3.props.PlaceholderText
	local TextXAlignment = p3.props.TextXAlignment
	local TextColor = p3.props.TextColor
	local PlaceholderColor = p3.props.PlaceholderColor
	local ClearTextOnFocus = p3.props.ClearTextOnFocus
	local TextInputType = p3.props.TextInputType
	local ReturnKeyType = p3.props.ReturnKeyType
	local ManualFocusRelease = p3.props.ManualFocusRelease
	local NextSelectionDown = p3.props.NextSelectionDown
	local NextSelectionLeft = p3.props.NextSelectionLeft
	local NextSelectionRight = p3.props.NextSelectionRight
	local NextSelectionUp = p3.props.NextSelectionUp
	local propsColor = p3.props.Color
	local propsTransparency = p3.props.Transparency
	local propsTextTransparency = p3.props.TextTransparency
	local maxLength = p3.props.maxLength
	local onChangeText = p3.props.onChangeText
	local onAncestryChanged = p3.props.onAncestryChanged
	local onReturnPressedFromOnScreenKeyboard = p3.props.onReturnPressedFromOnScreenKeyboard
	local onFocused = p3.props.onFocused
	local onFocusLost = p3.props.onFocusLost
	local onMouseEnter = p3.props.onMouseEnter
	local onMouseLeave = p3.props.onMouseLeave
	local PaddingX = p3.props.PaddingX
	local PaddingY = p3.props.PaddingY
	local TextBoxRef = p3.props.TextBoxRef
	local v48 = nil

	if GetFFlagLuaAppFixSelectionCursor() then
		v48 = p4(CursorKind.InputButton)
	end

	local v49 = nil

	if GetFFlagLuaAppEnableOpenTypeSupport() then
		if p3.props.openTypeFeatures == nil then
			if TextInputType == Enum.TextInputType.Password or TextInputType == Enum.TextInputType.PasswordShown or TextInputType == Enum.TextInputType.OneTimePassword or EngineFeature and TextInputType == Enum.TextInputType.NewPassword or EngineFeature and TextInputType == Enum.TextInputType.NewPasswordShown then
				v49 = OpenTypeSupport:getPasswordStylisticAlternative()
			elseif TextInputType == Enum.TextInputType.Username then
				v49 = OpenTypeSupport:getUserNameStylisticAlternative()
			end
		else
			v49 = p3.props.openTypeFeatures
		end
	else
		v49 = nil
	end

	local function handleTextChanged(p5) -- line: 102
		-- upvalues: maxLength (copy), onChangeText (copy)
		if maxLength then
			local v53 = string.sub(p5.Text, 1, maxLength)

			if v53 ~= p5.Text then
				p5.Text = v53

				return
			end
		end

		if onChangeText then
			onChangeText(p5)
		end
	end

	return Roact.createElement(ImageSetLabel, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = propsSize,
		Position = propsPosition,
		LayoutOrder = propsLayoutOrder,
		Image = GetImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
		ImageColor3 = propsColor,
		ImageTransparency = propsTransparency,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(8, 8, 9, 9)
	}, {
		UIPadding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, PaddingY),
			PaddingBottom = UDim.new(0, PaddingY),
			PaddingLeft = UDim.new(0, PaddingX),
			PaddingRight = UDim.new(0, PaddingX)
		}),
		TextBox = Roact.createElement("TextBox", {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Text = propsText,
			PlaceholderText = PlaceholderText,
			PlaceholderColor3 = PlaceholderColor,
			Font = propsFont,
			TextSize = propsTextSize,
			TextColor3 = TextColor,
			TextTransparency = propsTextTransparency,
			TextXAlignment = TextXAlignment,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundTransparency = 1,
			ClearTextOnFocus = ClearTextOnFocus,
			OverlayNativeInput = true,
			ClipsDescendants = true,
			TextInputType = TextInputType,
			ReturnKeyType = ReturnKeyType,
			ManualFocusRelease = ManualFocusRelease,
			NextSelectionDown = NextSelectionDown,
			NextSelectionLeft = NextSelectionLeft,
			NextSelectionRight = NextSelectionRight,
			NextSelectionUp = NextSelectionUp,
			SelectionImageObject = v48,
			OpenTypeFeatures = v49 or nil,
			RichText = not not v49 or nil,
			[Roact.Ref] = TextBoxRef,
			[Roact.Change.Text] = handleTextChanged,
			[Roact.Event.AncestryChanged] = onAncestryChanged,
			[Roact.Event.ReturnPressedFromOnScreenKeyboard] = onReturnPressedFromOnScreenKeyboard,
			[Roact.Event.Focused] = onFocused,
			[Roact.Event.FocusLost] = onFocusLost,
			[Roact.Event.MouseEnter] = onMouseEnter,
			[Roact.Event.MouseLeave] = onMouseLeave
		})
	})
end

return v10
