local UserInputService = game:GetService("UserInputService")

local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactRodux")
local RoactAppExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RoactAppExperiment")

local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Roact")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/UIBlox")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/Foundation").Utility.normalizeFontFace
local withStyle = UIBlox.Style.withStyle

local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local getImageData = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/RobloxAppAssets").GetImageData

local AreaTest = require("@game/CorePackages/Workspace/Packages/_Index/AuthCommon/AuthCommon/Utils/AreaTest")

local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local cursorKind = UIBlox.App.SelectionImage.CursorKind
local openTypeSupport = UIBlox.Utility.OpenTypeSupport

local getFFlagLuaAppFixSelectionCursor = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").GetFFlagLuaAppFixSelectionCursor

local getFFlagEnableTextFieldContentType = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").GetFFlagEnableTextFieldContentType

local getFFlagLuaAppEnableOpenTypeSupport = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").GetFFlagLuaAppEnableOpenTypeSupport

local engineFeature = game:GetEngineFeature("GuiObjectInputSink")

local defineFastFlag = game:DefineFastFlag("EnableKeyboardVisibilityCheckOnPasswordFocus", false)

local engineFeature2 = game:GetEngineFeature("EnableAndroidPasswordSuggestion")

local fFlagAndroidPasswordSuggestionExperimentEnrollmentBypass = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FFlagAndroidPasswordSuggestionExperimentEnrollmentBypass

local fStringLuaMultiPageSignupIxpLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AuthCommon/SharedFlags").FStringLuaMultiPageSignupIxpLayer

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

	function self.isTouchPositionInPasswordBox(p2)
		if not self.passwordBoxRef.current then
			return false
		end

		local absolutePosition = self.passwordBoxRef.current.AbsolutePosition
		local absoluteSize = self.passwordBoxRef.current.AbsoluteSize

		return AreaTest.IsPointInRect(Rect.new(absolutePosition, absolutePosition + absoluteSize), p2)
	end

	self.tapBeganInTextbox = false
	function self.tapEventBegan(p2, p3)
		if
			self.props.CentralOverlayBlocksInput
			and self.props.centralOverlay
			and self.props.centralOverlay.OverlayType ~= nil
			or defineFastFlag and not UserInputService.OnScreenKeyboardVisible
		then
			return
		end

		self.tapBeganInTextbox = self.isTouchPositionInPasswordBox(p2)
		local current = self.getPasswordTextBoxRef().current
		local focusedTextBox = UserInputService:GetFocusedTextBox()

		if
			current
			and focusedTextBox ~= current
			and self.tapBeganInTextbox
			and self.props.CaptureFocusOnTapStart
		then
			if focusedTextBox then
				focusedTextBox:ReleaseFocus()
			end

			current:CaptureFocus()
		end
	end

	function self.tapEventEnded(p2, p3)
		if self.tapBeganInTextbox then
			self.tapBeganInTextbox = false
			return
		end

		local focusedTextBox = UserInputService:GetFocusedTextBox()
		local current = self.getPasswordTextBoxRef().current

		if not focusedTextBox or focusedTextBox ~= current then
			return
		end

		if not self.isTouchPositionInPasswordBox(p2) then
			current:ReleaseFocus()
		end
	end

	function self.onAbsoluteSizeChanged(p2)
		local containerSize = self.state.containerSize
		local absoluteSize = p2.AbsoluteSize

		if absoluteSize.X > 0 and absoluteSize.Y > 0 and containerSize ~= absoluteSize then
			spawn(function()
				if self.isMounted then
					self:setState({ containerSize = absoluteSize })
				end
			end)
		end
	end

	function self.onTogglerActivated(p2)
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

	function self.shouldTakeInput(p2)
		if self.props.Disabled then
			return false
		end

		local v5 = p2.UserInputType == Enum.UserInputType.MouseButton1
			or p2.UserInputType == Enum.UserInputType.Touch
		return not self.props.ManualFocusRelease and v5
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
		self.inputBeganConnection = UserInputService.InputBegan:connect(function(p2, p3)
			if self.shouldTakeInput(p2) then
				self.tapEventBegan(p2.Position, p3)
			end
		end)

		self.inputEndedConnection = UserInputService.InputEnded:connect(function(p2, p3)
			if self.shouldTakeInput(p2) then
				self.tapEventEnded(p2.Position, p3)
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

	local newPasswordShown = enablePasswordSuggestion
		and engineFeature2
		and Enum.TextInputType.NewPasswordShown
		or getFFlagEnableTextFieldContentType() and Enum.TextInputType.PasswordShown
		or Enum.TextInputType.NoSuggestions

	return withStyle(function(p2)
		local v5 = if getFFlagLuaAppFixSelectionCursor() then callback(cursorKind.InputButton) else nil

		local createElement = Roact.createElement
		local v7 = {
			Size = size,
			Position = position,
			LayoutOrder = layoutOrder,
			BackgroundTransparency = 1,
			Image = getImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
			ImageColor3 = color,
			ImageTransparency = transparency,
			BorderSizePixel = 0,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(8, 8, 9, 9),
			[Roact.Ref] = self.passwordBoxRef,
			[Roact.Change.AbsoluteSize] = self.onAbsoluteSizeChanged
		}

		local createElement2 = Roact.createElement
		local v9 = {
			Size = UDim2.new(1, -y, 1, 0),
			BackgroundTransparency = 1
		}

		local createElement3 = Roact.createElement
		local v11 = {
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
			PlaceholderColor3 = placeholderColor,
			FontFace = normalizeFontFace(p2.Tokens.Typography.BodyLarge.Font)
		}
		local v12 = if engineFeature then Enum.InputSink.None else nil
		v11.InputSink = v12
		local v13 = if getFFlagLuaAppEnableOpenTypeSupport() then openTypeSupport:getPasswordStylisticAlternative() else nil
		v11.OpenTypeFeatures = v13

		v11.TextSize = textSize
		v11.TextColor3 = textColor
		v11.TextTransparency = textTransparency
		v11.TextXAlignment = textXAlignment
		v11.TextYAlignment = Enum.TextYAlignment.Center
		v11.BackgroundTransparency = 1
		v11.ClearTextOnFocus = clearTextOnFocus
		v11.OverlayNativeInput = true
		v11.ManualFocusRelease = self.props.IsKeyboardOverlayUsed
		v11.ClipsDescendants = true
		v11.TextInputType = hidePassword and newPassword or newPasswordShown
		v11.ReturnKeyType = returnKeyType
		v11.NextSelectionDown = nextSelectionDown
		v11.NextSelectionLeft = nextSelectionLeft
		v11.NextSelectionRight = nextSelectionRight
		v11.NextSelectionUp = nextSelectionUp
		v11.SelectionImageObject = v5
		v11[Roact.Ref] = self.getPasswordTextBoxRef()
		v11[Roact.Change.Text] = self.props.onChangeText
		v11[Roact.Event.ReturnPressedFromOnScreenKeyboard] = self.props.onReturnPressedFromOnScreenKeyboard
		v11[Roact.Event.Focused] = onFocused
		v11[Roact.Event.FocusLost] = onFocusLost
		v11[Roact.Event.MouseEnter] = onMouseEnter
		v11[Roact.Event.MouseLeave] = onMouseLeave
		local children = {
			TextBoxContainer = createElement2("Frame", v9, {
				TextBox = createElement3("TextBox", v11),
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
			SelectionImageObject = v5,
			[Roact.Event.Activated] = self.onTogglerActivated
		}

		local createElement5 = Roact.createElement
		local v17 = {
			Size = UDim2.new(0, 16, 0, 16),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Image = 0,
			ImageColor3 = 0,
			ImageTransparency = 0
		}

		local v18 = if hidePassword then getImageData("LuaApp/icons/actions_privacy_show") or "LuaApp/icons/actions_privacy_show" else getImageData("LuaApp/icons/actions_edit_hide") or "LuaApp/icons/actions_edit_hide"
		v17.Image = v18

		v17.ImageColor3 = p2.Theme.IconDefault.Color
		v17.ImageTransparency = p2.Theme.IconDefault.Transparency
		children.Toggler = createElement4("TextButton", onTogglerActivatedsByActivated, {
			ImageLabel = createElement5(imageSetLabel, v17)
		})
		return createElement(imageSetLabel, v7, children)
	end)
end

local v5 = RoactRodux.connect(function(p2, p3)
	return { centralOverlay = p2.CentralOverlay }
end)(extended)

if engineFeature2 then
	v5 = RoactAppExperiment.connectBrowserTrackerLayer({ fStringLuaMultiPageSignupIxpLayer }, function(p2, p3)
		return {
			enablePasswordSuggestion = (p2[fStringLuaMultiPageSignupIxpLayer] or {}).enablePasswordSuggestion or fFlagAndroidPasswordSuggestionExperimentEnrollmentBypass or false
		}
	end)(v5)
end

return v5
