local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Roact")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UIBlox")

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getImageData = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppAssets").GetImageData

local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local openTypeSupport = UIBlox.Utility.OpenTypeSupport

local getFFlagLuaAppFixSelectionCursor = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").GetFFlagLuaAppFixSelectionCursor

local extended = Roact.PureComponent:extend("GenericTextBox")
local getFFlagLuaAppEnableOpenTypeSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").GetFFlagLuaAppEnableOpenTypeSupport

local engineFeature = game:GetEngineFeature("EnableAndroidPasswordSuggestion")

extended.defaultProps = { PaddingX = 0, PaddingY = 0 }

function extended:render()
	if getFFlagLuaAppFixSelectionCursor() then
		return withSelectionCursorProvider(function(p2)
			return self:renderWithSelectionCursor(p2)
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

	local v5 = if getFFlagLuaAppFixSelectionCursor() then callback(cursorKind.InputButton) else nil

	local v6 = nil

	if getFFlagLuaAppEnableOpenTypeSupport() then
		if self.props.openTypeFeatures == nil then
			if
				textInputType == Enum.TextInputType.Password
				or textInputType == Enum.TextInputType.PasswordShown
				or textInputType == Enum.TextInputType.OneTimePassword
				or engineFeature and textInputType == Enum.TextInputType.NewPassword
				or engineFeature and textInputType == Enum.TextInputType.NewPasswordShown
			then
				v6 = openTypeSupport:getPasswordStylisticAlternative()
			elseif textInputType == Enum.TextInputType.Username then
				v6 = openTypeSupport:getUserNameStylisticAlternative()
			end
		else
			v6 = self.props.openTypeFeatures
		end
	end

	local function handleTextChanged(p3)
		if maxLength then
			local v7 = string.sub(p3.Text, 1, maxLength)

			if v7 ~= p3.Text then
				p3.Text = v7
				return
			end
		end

		if onChangeText then
			onChangeText(p3)
		end
	end

	return Roact.createElement(imageSetLabel, {
		Size = size,
		Position = position,
		LayoutOrder = layoutOrder,
		BackgroundTransparency = 1,
		Image = getImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
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
			SelectionImageObject = v5,
			OpenTypeFeatures = v6 or nil,
			RichText = v6 and true or nil,
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
