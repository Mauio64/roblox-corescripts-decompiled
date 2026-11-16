local UserInputService = game:GetService("UserInputService")
local AuthCommon = script:FindFirstAncestor("AuthCommon")
local parent = AuthCommon.Parent

local RoactRodux = require(parent.RoactRodux)
local RoactAppExperiment = require(parent.RoactAppExperiment)

local Roact = require(parent.Roact)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local withStyle = UIBlox.Style.withStyle

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local RobloxAppAssets = require(parent.RobloxAppAssets)
local GetImageData = RobloxAppAssets.GetImageData

local AreaTest = require(AuthCommon.Utils.AreaTest)

local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local OpenTypeSupport = UIBlox.Utility.OpenTypeSupport

local SharedFlags = require(parent.SharedFlags)
local GetFFlagLuaAppFixSelectionCursor = SharedFlags.GetFFlagLuaAppFixSelectionCursor

local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagEnableTextFieldContentType = SharedFlags2.GetFFlagEnableTextFieldContentType

local SharedFlags3 = require(parent.SharedFlags)
local GetFFlagLuaAppEnableOpenTypeSupport = SharedFlags3.GetFFlagLuaAppEnableOpenTypeSupport

local engineFeature = game:GetEngineFeature("GuiObjectInputSink")

local defineFastFlag = game:DefineFastFlag("EnableKeyboardVisibilityCheckOnPasswordFocus", false)

local engineFeature2 = game:GetEngineFeature("EnableAndroidPasswordSuggestion")

local SharedFlags4 = require(parent.SharedFlags)
local FFlagAndroidPasswordSuggestionExperimentEnrollmentBypass = SharedFlags4.FFlagAndroidPasswordSuggestionExperimentEnrollmentBypass

local SharedFlags5 = require(parent.SharedFlags)
local FStringLuaMultiPageSignupIxpLayer = SharedFlags5.FStringLuaMultiPageSignupIxpLayer

local extended = Roact.PureComponent:extend("PasswordBox")

function extended:init()
	self.state = { hidePassword = true, containerSize = Vector2.new(0, 0) }

	function self.getHidePassword()
		if self.props.hidePassword == nil then
			return self.state.hidePassword
		end

		return self.props.hidePassword
	end

	self.isMounted = false
	self.passwordBoxRef = Roact.createRef()

	local ref = Roact.createRef()
	function self.getPasswordTextBoxRef()
		return self.props.TextBoxRef or ref
	end

	function self.isTouchPositionInPasswordBox(p)
		if not self.passwordBoxRef.current then
			return false
		end

		local absolutePosition = self.passwordBoxRef.current.AbsolutePosition
		local absoluteSize = self.passwordBoxRef.current.AbsoluteSize

		return AreaTest.IsPointInRect(Rect.new(absolutePosition, absolutePosition + absoluteSize), p)
	end

	self.tapBeganInTextbox = false
	function self.tapEventBegan(p, _)
		if
			self.props.CentralOverlayBlocksInput
			and self.props.centralOverlay
			and self.props.centralOverlay.OverlayType ~= nil
			or defineFastFlag and not UserInputService.OnScreenKeyboardVisible
		then
			return
		end

		self.tapBeganInTextbox = self.isTouchPositionInPasswordBox(p)
		local current = self.getPasswordTextBoxRef().current
		local focusedTextBox = UserInputService:GetFocusedTextBox()

		if current and focusedTextBox ~= current and self.tapBeganInTextbox and self.props.CaptureFocusOnTapStart then
			if focusedTextBox then
				focusedTextBox:ReleaseFocus()
			end

			current:CaptureFocus()
		end
	end

	function self.tapEventEnded(p, _)
		if self.tapBeganInTextbox then
			self.tapBeganInTextbox = false
			return
		end

		local focusedTextBox = UserInputService:GetFocusedTextBox()
		local current = self.getPasswordTextBoxRef().current

		if not focusedTextBox or focusedTextBox ~= current then
			return
		end

		if not self.isTouchPositionInPasswordBox(p) then
			current:ReleaseFocus()
		end
	end

	function self.onAbsoluteSizeChanged(p)
		local containerSize = self.state.containerSize
		local absoluteSize = p.AbsoluteSize

		if absoluteSize.X > 0 and absoluteSize.Y > 0 and containerSize ~= absoluteSize then
			spawn(function()
				if self.isMounted then
					self:setState({ containerSize = absoluteSize })
				end
			end)
		end
	end

	function self.onTogglerActivated(_)
		local onToggleCallback = self.props.onToggleCallback
		local hidePassword = self.getHidePassword()

		if onToggleCallback then
			onToggleCallback(hidePassword)
		end

		if self.isMounted then
			self:setState({
				hidePassword = not hidePassword
			})
		end
	end

	function self.shouldTakeInput(p)
		if self.props.Disabled then
			return false
		end

		local v = p.UserInputType == Enum.UserInputType.MouseButton1 or p.UserInputType == Enum.UserInputType.Touch
		return not self.props.ManualFocusRelease and v
	end
end

extended.defaultProps = {
	TextXAlignment = Enum.TextXAlignment.Left,
	PaddingX = 10,
	PaddingY = 7,
	ClearTextOnFocus = false,
	IsKeyboardOverlayUsed = true
}

function extended:didMount()
	self.isMounted = true

	if self.props.IsKeyboardOverlayUsed then
		self.inputBeganConnection = UserInputService.InputBegan:connect(function(p, p2)
			if self.shouldTakeInput(p) then
				self.tapEventBegan(p.Position, p2)
			end
		end)

		self.inputEndedConnection = UserInputService.InputEnded:connect(function(p, p2)
			if self.shouldTakeInput(p) then
				self.tapEventEnded(p.Position, p2)
			end
		end)
	end
end

function extended:willUnmount()
	self.isMounted = false

	if self.props.IsKeyboardOverlayUsed then
		if self.inputBeganConnection then
			self.inputBeganConnection:disconnect()
		end

		if self.inputEndedConnection then
			self.inputEndedConnection:disconnect()
		end
	end
end

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
	local textSize = self.props.TextSize
	local placeholderText = self.props.PlaceholderText
	local textXAlignment = self.props.TextXAlignment
	local textColor = self.props.TextColor
	local placeholderColor = self.props.PlaceholderColor
	local clearTextOnFocus = self.props.ClearTextOnFocus

	local color = self.props.Color
	local transparency = self.props.Transparency
	local textTransparency = self.props.TextTransparency

	local returnKeyType = self.props.ReturnKeyType

	local nextSelectionDown = self.props.NextSelectionDown
	local nextSelectionLeft = self.props.NextSelectionLeft
	local nextSelectionRight = self.props.NextSelectionRight
	local nextSelectionUp = self.props.NextSelectionUp

	local paddingX = self.props.PaddingX
	local paddingY = self.props.PaddingY

	local hidePassword = self.getHidePassword()
	local y = self.state.containerSize.Y
	local onFocused = self.props.onFocused
	local onFocusLost = self.props.onFocusLost
	local onMouseEnter = self.props.onMouseEnter
	local onMouseLeave = self.props.onMouseLeave

	local enablePasswordSuggestion = self.props.IsNewPassword and self.props.enablePasswordSuggestion

	local newPassword = enablePasswordSuggestion and engineFeature2 and Enum.TextInputType.NewPassword
		or Enum.TextInputType.Password

	local newPasswordShown = enablePasswordSuggestion and engineFeature2 and Enum.TextInputType.NewPasswordShown
		or GetFFlagEnableTextFieldContentType() and Enum.TextInputType.PasswordShown
		or Enum.TextInputType.NoSuggestions

	return withStyle(function(props)
		local selectionImageObject

		if GetFFlagLuaAppFixSelectionCursor() then
			selectionImageObject = callback(CursorKind.InputButton)
		end

		local createElement = Roact.createElement
		local v = {
			Size = size,
			Position = position,
			LayoutOrder = layoutOrder,
			BackgroundTransparency = 1,
			Image = GetImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
			ImageColor3 = color,
			ImageTransparency = transparency,
			BorderSizePixel = 0,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(8, 8, 9, 9),
			[Roact.Ref] = self.passwordBoxRef,
			[Roact.Change.AbsoluteSize] = self.onAbsoluteSizeChanged
		}

		local createElement2 = Roact.createElement
		local v2 = {
			Size = UDim2.new(1, -y, 1, 0),
			BackgroundTransparency = 1
		}

		local createElement3 = Roact.createElement
		local v3 = {
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			["Size"] = nil,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Text = text,
			PlaceholderText = placeholderText,
			PlaceholderColor3 = placeholderColor
		}
		local font

		if not FoundationFontFaceMigration then
			font = props.Font.Body.Font
		end

		v3.Font = font
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(props.Tokens.Typography.BodyLarge.Font)
		end

		v3.FontFace = fontFace
		local inputSink

		if engineFeature then
			inputSink = Enum.InputSink.None
		end

		v3.InputSink = inputSink
		local openTypeFeatures

		if GetFFlagLuaAppEnableOpenTypeSupport() then
			openTypeFeatures = OpenTypeSupport:getPasswordStylisticAlternative()
		end

		v3.OpenTypeFeatures = openTypeFeatures

		v3.TextSize = textSize
		v3.TextColor3 = textColor
		v3.TextTransparency = textTransparency
		v3.TextXAlignment = textXAlignment
		v3.TextYAlignment = Enum.TextYAlignment.Center
		v3.BackgroundTransparency = 1
		v3.ClearTextOnFocus = clearTextOnFocus
		v3.OverlayNativeInput = true
		v3.ManualFocusRelease = self.props.IsKeyboardOverlayUsed
		v3.ClipsDescendants = true
		v3.TextInputType = hidePassword and newPassword or newPasswordShown
		v3.ReturnKeyType = returnKeyType
		v3.NextSelectionDown = nextSelectionDown
		v3.NextSelectionLeft = nextSelectionLeft
		v3.NextSelectionRight = nextSelectionRight
		v3.NextSelectionUp = nextSelectionUp
		v3.SelectionImageObject = selectionImageObject
		v3[Roact.Ref] = self.getPasswordTextBoxRef()
		v3[Roact.Change.Text] = self.props.onChangeText
		v3[Roact.Event.ReturnPressedFromOnScreenKeyboard] = self.props.onReturnPressedFromOnScreenKeyboard
		v3[Roact.Event.Focused] = onFocused
		v3[Roact.Event.FocusLost] = onFocusLost
		v3[Roact.Event.MouseEnter] = onMouseEnter
		v3[Roact.Event.MouseLeave] = onMouseLeave
		local children = {
			TextBoxContainer = createElement2("Frame", v2, {
				TextBox = createElement3("TextBox", v3),
				UIPadding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, paddingY),
					PaddingBottom = UDim.new(0, paddingY),
					PaddingLeft = UDim.new(0, paddingX),
					PaddingRight = UDim.new(0, paddingX)
				})
			}),
			Toggler = 0
		}

		local createElement4 = Roact.createElement
		local onTogglerActivatedsByActivated = {
			Position = UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.new(0, y, 1, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			Text = "",
			BackgroundTransparency = 1,
			SelectionImageObject = selectionImageObject,
			[Roact.Event.Activated] = self.onTogglerActivated
		}

		local createElement5 = Roact.createElement
		local v4 = {
			Size = UDim2.new(0, 16, 0, 16),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = 0,
			ImageColor3 = 0,
			ImageTransparency = 0
		}
		local image

		if hidePassword then
			image = GetImageData("LuaApp/icons/actions_privacy_show") or "LuaApp/icons/actions_privacy_show"
		else
			image = GetImageData("LuaApp/icons/actions_edit_hide") or "LuaApp/icons/actions_edit_hide"
		end

		v4.Image = image

		v4.ImageColor3 = props.Theme.IconDefault.Color
		v4.ImageTransparency = props.Theme.IconDefault.Transparency
		children.Toggler = createElement4("TextButton", onTogglerActivatedsByActivated, {
			ImageLabel = createElement5(ImageSetLabel, v4)
		})
		return createElement(ImageSetLabel, v, children)
	end)
end

local v = RoactRodux.connect(function(p, _)
	return { centralOverlay = p.CentralOverlay }
end)(extended)

if engineFeature2 then
	return (RoactAppExperiment.connectBrowserTrackerLayer({ FStringLuaMultiPageSignupIxpLayer }, function(p, _)
		return {
			enablePasswordSuggestion = (p[FStringLuaMultiPageSignupIxpLayer] or {}).enablePasswordSuggestion or FFlagAndroidPasswordSuggestionExperimentEnrollmentBypass or false
		}
	end)(v))
end

return v
