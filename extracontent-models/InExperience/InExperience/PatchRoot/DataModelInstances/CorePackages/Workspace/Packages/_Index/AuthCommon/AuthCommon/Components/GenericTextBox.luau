local parent = script:FindFirstAncestor("AuthCommon").Parent

local Roact = require(parent.Roact)
local UIBlox = require(parent.UIBlox)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local RobloxAppAssets = require(parent.RobloxAppAssets)
local GetImageData = RobloxAppAssets.GetImageData

local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local OpenTypeSupport = UIBlox.Utility.OpenTypeSupport

local SharedFlags = require(parent.SharedFlags)
local GetFFlagLuaAppFixSelectionCursor = SharedFlags.GetFFlagLuaAppFixSelectionCursor

local extended = Roact.PureComponent:extend("GenericTextBox")
local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagLuaAppEnableOpenTypeSupport = SharedFlags2.GetFFlagLuaAppEnableOpenTypeSupport

local engineFeature = game:GetEngineFeature("EnableAndroidPasswordSuggestion")

extended.defaultProps = { PaddingX = 0, PaddingY = 0 }

function extended:render()
	if GetFFlagLuaAppFixSelectionCursor() then
		return withSelectionCursorProvider(function(p)
			return self:renderWithSelectionCursor(p)
		end)
	end

	return self:renderWithSelectionCursor(nil)
end

function extended:renderWithSelectionCursor(callback)
	local size = self.props.Size
	local position = self.props.Position
	local layoutOrder = self.props.LayoutOrder
	local text = self.props.Text
	local font = self.props.Font
	local textSize = self.props.TextSize
	local placeholderText = self.props.PlaceholderText
	local textXAlignment = self.props.TextXAlignment
	local textColor = self.props.TextColor
	local placeholderColor = self.props.PlaceholderColor
	local clearTextOnFocus = self.props.ClearTextOnFocus
	local textInputType = self.props.TextInputType
	local returnKeyType = self.props.ReturnKeyType
	local manualFocusRelease = self.props.ManualFocusRelease

	local nextSelectionDown = self.props.NextSelectionDown
	local nextSelectionLeft = self.props.NextSelectionLeft
	local nextSelectionRight = self.props.NextSelectionRight
	local nextSelectionUp = self.props.NextSelectionUp

	local color = self.props.Color
	local transparency = self.props.Transparency
	local textTransparency = self.props.TextTransparency
	local maxLength = self.props.maxLength
	local onChangeText = self.props.onChangeText
	local onAncestryChanged = self.props.onAncestryChanged
	local onReturnPressedFromOnScreenKeyboard = self.props.onReturnPressedFromOnScreenKeyboard
	local onFocused = self.props.onFocused
	local onFocusLost = self.props.onFocusLost
	local onMouseEnter = self.props.onMouseEnter
	local onMouseLeave = self.props.onMouseLeave

	local paddingX = self.props.PaddingX
	local paddingY = self.props.PaddingY

	local textBoxRef = self.props.TextBoxRef
	local selectionImageObject

	if GetFFlagLuaAppFixSelectionCursor() then
		selectionImageObject = callback(CursorKind.InputButton)
	end

	local v = nil

	if GetFFlagLuaAppEnableOpenTypeSupport() then
		if self.props.openTypeFeatures == nil then
			if
				textInputType == Enum.TextInputType.Password
				or textInputType == Enum.TextInputType.PasswordShown
				or textInputType == Enum.TextInputType.OneTimePassword
				or engineFeature and textInputType == Enum.TextInputType.NewPassword
				or engineFeature and textInputType == Enum.TextInputType.NewPasswordShown
			then
				v = OpenTypeSupport:getPasswordStylisticAlternative()
			elseif textInputType == Enum.TextInputType.Username then
				v = OpenTypeSupport:getUserNameStylisticAlternative()
			end
		else
			v = self.props.openTypeFeatures
		end
	end

	local function handleTextChanged(p)
		if maxLength then
			local text2 = string.sub(p.Text, 1, maxLength)

			if text2 ~= p.Text then
				p.Text = text2
				return
			end
		end

		if onChangeText then
			onChangeText(p)
		end
	end

	return Roact.createElement(ImageSetLabel, {
		Size = size,
		Position = position,
		LayoutOrder = layoutOrder,
		BackgroundTransparency = 1,
		Image = GetImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
		ImageColor3 = color,
		ImageTransparency = transparency,
		BorderSizePixel = 0,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(8, 8, 9, 9)
	}, {
		UIPadding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, paddingY),
			PaddingBottom = UDim.new(0, paddingY),
			PaddingLeft = UDim.new(0, paddingX),
			PaddingRight = UDim.new(0, paddingX)
		}),
		TextBox = Roact.createElement("TextBox", {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Text = text,
			PlaceholderText = placeholderText,
			PlaceholderColor3 = placeholderColor,
			Font = font,
			TextSize = textSize,
			TextColor3 = textColor,
			TextTransparency = textTransparency,
			TextXAlignment = textXAlignment,
			TextYAlignment = Enum.TextYAlignment.Center,
			BackgroundTransparency = 1,
			ClearTextOnFocus = clearTextOnFocus,
			OverlayNativeInput = true,
			ClipsDescendants = true,
			TextInputType = textInputType,
			ReturnKeyType = returnKeyType,
			ManualFocusRelease = manualFocusRelease,
			NextSelectionDown = nextSelectionDown,
			NextSelectionLeft = nextSelectionLeft,
			NextSelectionRight = nextSelectionRight,
			NextSelectionUp = nextSelectionUp,
			SelectionImageObject = selectionImageObject,
			OpenTypeFeatures = v or nil,
			RichText = v and true or nil,
			[Roact.Ref] = textBoxRef,
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

return extended
