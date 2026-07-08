local UserInputService = game:GetService("UserInputService")
local AuthCommon = script:FindFirstAncestor("AuthCommon")
local AuthCommonParent = AuthCommon.Parent
local RoactRodux = require(AuthCommonParent.RoactRodux)
local RoactAppExperiment = require(AuthCommonParent.RoactAppExperiment)
local Roact = require(AuthCommonParent.Roact)
local UIBlox = require(AuthCommonParent.UIBlox)
local withStyle = UIBlox.Style.withStyle
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local GetImageData = require(AuthCommonParent.RobloxAppAssets).GetImageData
local AreaTest = require(AuthCommon.Utils.AreaTest)
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local OpenTypeSupport = UIBlox.Utility.OpenTypeSupport
local GetFFlagLuaAppFixSelectionCursor = require(AuthCommonParent.SharedFlags).GetFFlagLuaAppFixSelectionCursor
local GetFFlagEnableTextFieldContentType = require(AuthCommonParent.SharedFlags).GetFFlagEnableTextFieldContentType
local GetFFlagLuaAppEnableOpenTypeSupport = require(AuthCommonParent.SharedFlags).GetFFlagLuaAppEnableOpenTypeSupport
local v18 = game:DefineFastFlag("EnableKeyboardVisibilityCheckOnPasswordFocus", false)
local EngineFeature = game:GetEngineFeature("EnableAndroidPasswordSuggestion")
local FFlagAndroidPasswordSuggestionExperimentEnrollmentBypass = require(AuthCommonParent.SharedFlags).FFlagAndroidPasswordSuggestionExperimentEnrollmentBypass
local FStringLuaMultiPageSignupIxpLayer = require(AuthCommonParent.SharedFlags).FStringLuaMultiPageSignupIxpLayer
local v22 = Roact.PureComponent:extend("PasswordBox")

function v22.init(p1) -- line: 47
	-- upvalues: Roact (copy), AreaTest (copy), v18 (copy), UserInputService (copy)
	p1.state = {
		hidePassword = true,
		containerSize = Vector2.new(0, 0)
	}

	function p1.getHidePassword() -- line: 54
		-- upvalues: p1 (copy)
		if p1.props.hidePassword ~= nil then
			return p1.props.hidePassword
		end

		return p1.state.hidePassword
	end

	p1.isMounted = false
	p1.passwordBoxRef = Roact.createRef()

	local v25 = Roact.createRef()

	function p1.getPasswordTextBoxRef() -- line: 66
		-- upvalues: p1 (copy), v25 (copy)
		return p1.props.TextBoxRef or v25
	end
	function p1.isTouchPositionInPasswordBox(p2) -- line: 70
		-- upvalues: p1 (copy), AreaTest (copy)
		if not p1.passwordBoxRef.current then
			return false
		end

		local AbsolutePosition = p1.passwordBoxRef.current.AbsolutePosition
		local AbsoluteSize = p1.passwordBoxRef.current.AbsoluteSize

		return AreaTest.IsPointInRect(Rect.new(AbsolutePosition, AbsolutePosition + AbsoluteSize), p2)
	end

	p1.tapBeganInTextbox = false

	function p1.tapEventBegan(p3, _) -- line: 84
		-- upvalues: p1 (copy), v18 (copy), UserInputService (copy)
		if p1.props.CentralOverlayBlocksInput and (p1.props.centralOverlay and p1.props.centralOverlay.OverlayType ~= nil) then
			return
		end

		if v18 and not UserInputService.OnScreenKeyboardVisible then
			return
		end

		p1.tapBeganInTextbox = p1.isTouchPositionInPasswordBox(p3)

		local current = p1.getPasswordTextBoxRef().current
		local FocusedTextBox = UserInputService:GetFocusedTextBox()

		if current and FocusedTextBox ~= current and p1.tapBeganInTextbox and p1.props.CaptureFocusOnTapStart then
			if FocusedTextBox then
				FocusedTextBox:ReleaseFocus()
			end

			current:CaptureFocus()
		end
	end
	function p1.tapEventEnded(p5, _) -- line: 118
		-- upvalues: p1 (copy), UserInputService (copy)
		if p1.tapBeganInTextbox then
			p1.tapBeganInTextbox = false

			return
		end

		local FocusedTextBox = UserInputService:GetFocusedTextBox()
		local current = p1.getPasswordTextBoxRef().current

		if not FocusedTextBox or FocusedTextBox ~= current then
			return
		end

		if not p1.isTouchPositionInPasswordBox(p5) then
			current:ReleaseFocus()
		end
	end
	function p1.onAbsoluteSizeChanged(p7) -- line: 136
		-- upvalues: p1 (copy)
		local containerSize = p1.state.containerSize
		local AbsoluteSize = p7.AbsoluteSize

		if AbsoluteSize.X > 0 and (AbsoluteSize.Y > 0 and containerSize ~= AbsoluteSize) then
			spawn(function() -- line: 142
				-- upvalues: p1 (copy), AbsoluteSize (copy)
				if p1.isMounted then
					p1:setState({
						containerSize = AbsoluteSize
					})
				end
			end)
		end
	end
	function p1.onTogglerActivated(_) -- line: 152
		-- upvalues: p1 (copy)
		local onToggleCallback = p1.props.onToggleCallback
		local v80 = p1.getHidePassword()

		if onToggleCallback then
			onToggleCallback(v80)
		end

		if p1.isMounted then
			p1:setState({
				hidePassword = not v80
			})
		end
	end
	function p1.shouldTakeInput(p9) -- line: 167
		-- upvalues: p1 (copy)
		if p1.props.Disabled then
			return false
		end

		local v82 = p9.UserInputType == Enum.UserInputType.MouseButton1 or p9.UserInputType == Enum.UserInputType.Touch

		return not p1.props.ManualFocusRelease and v82
	end
end

v22.defaultProps = {
	PaddingX = 10,
	PaddingY = 7,
	ClearTextOnFocus = false,
	IsKeyboardOverlayUsed = true,
	TextXAlignment = Enum.TextXAlignment.Left
}

function v22.didMount(p10) -- line: 187
	-- upvalues: UserInputService (copy)
	p10.isMounted = true

	if p10.props.IsKeyboardOverlayUsed then
		p10.inputBeganConnection = UserInputService.InputBegan:connect(function(p11, p12) -- line: 191
			-- upvalues: p10 (copy)
			if p10.shouldTakeInput(p11) then
				p10.tapEventBegan(p11.Position, p12)
			end
		end)
		p10.inputEndedConnection = UserInputService.InputEnded:connect(function(p13, p14) -- line: 197
			-- upvalues: p10 (copy)
			if p10.shouldTakeInput(p13) then
				p10.tapEventEnded(p13.Position, p14)
			end
		end)
	end
end
function v22.willUnmount(p15) -- line: 205
	p15.isMounted = false

	if p15.props.IsKeyboardOverlayUsed then
		if p15.inputBeganConnection then
			p15.inputBeganConnection:disconnect()
		end

		if p15.inputEndedConnection then
			p15.inputEndedConnection:disconnect()
		end
	end
end
function v22.render(p16) -- line: 217
	-- upvalues: GetFFlagLuaAppFixSelectionCursor (copy), withSelectionCursorProvider (copy)
	if GetFFlagLuaAppFixSelectionCursor() then
		return withSelectionCursorProvider(function(p17) -- line: 219
			-- upvalues: p16 (copy)
			return p16:renderWithSelectionCursor(p17)
		end)
	end

	return p16:renderWithSelectionCursor(nil)
end
function v22.renderWithSelectionCursor(p18, p19) -- line: 228
	-- upvalues: EngineFeature (copy), GetFFlagEnableTextFieldContentType (copy), withStyle (copy), GetFFlagLuaAppFixSelectionCursor (copy), CursorKind (copy), Roact (copy), ImageSetLabel (copy), GetImageData (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), OpenTypeSupport (copy)
	local propsSize = p18.props.Size
	local propsPosition = p18.props.Position
	local propsLayoutOrder = p18.props.LayoutOrder
	local propsText = p18.props.Text
	local propsTextSize = p18.props.TextSize
	local PlaceholderText = p18.props.PlaceholderText
	local TextXAlignment = p18.props.TextXAlignment
	local TextColor = p18.props.TextColor
	local PlaceholderColor = p18.props.PlaceholderColor
	local ClearTextOnFocus = p18.props.ClearTextOnFocus
	local propsColor = p18.props.Color
	local propsTransparency = p18.props.Transparency
	local propsTextTransparency = p18.props.TextTransparency
	local ReturnKeyType = p18.props.ReturnKeyType
	local NextSelectionDown = p18.props.NextSelectionDown
	local NextSelectionLeft = p18.props.NextSelectionLeft
	local NextSelectionRight = p18.props.NextSelectionRight
	local NextSelectionUp = p18.props.NextSelectionUp
	local PaddingX = p18.props.PaddingX
	local PaddingY = p18.props.PaddingY
	local v51 = p18.getHidePassword()
	local containerSizeY = p18.state.containerSize.Y
	local onFocused = p18.props.onFocused
	local onFocusLost = p18.props.onFocusLost
	local onMouseEnter = p18.props.onMouseEnter
	local onMouseLeave = p18.props.onMouseLeave
	local v57 = p18.props.IsNewPassword and p18.props.enablePasswordSuggestion
	local v58 = v57 and (not not EngineFeature and Enum.TextInputType.NewPassword) or Enum.TextInputType.Password
	local v59 = v57 and (not not EngineFeature and Enum.TextInputType.NewPasswordShown) or (GetFFlagEnableTextFieldContentType() and Enum.TextInputType.PasswordShown or Enum.TextInputType.NoSuggestions)

	return withStyle(function(p20) -- line: 275
		-- upvalues: GetFFlagLuaAppFixSelectionCursor (copy), p19 (copy), CursorKind (copy), Roact (copy), ImageSetLabel (copy), propsSize (copy), propsPosition (copy), propsLayoutOrder (copy), GetImageData (copy), propsColor (copy), propsTransparency (copy), p18 (copy), containerSizeY (copy), propsText (copy), PlaceholderText (copy), PlaceholderColor (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), OpenTypeSupport (copy), propsTextSize (copy), TextColor (copy), propsTextTransparency (copy), TextXAlignment (copy), ClearTextOnFocus (copy), v51 (copy), v58 (copy), v59 (copy), ReturnKeyType (copy), NextSelectionDown (copy), NextSelectionLeft (copy), NextSelectionRight (copy), NextSelectionUp (copy), onFocused (copy), onFocusLost (copy), onMouseEnter (copy), onMouseLeave (copy), PaddingY (copy), PaddingX (copy)
		local v89 = nil

		if GetFFlagLuaAppFixSelectionCursor() then
			v89 = p19(CursorKind.InputButton)
		end

		return Roact.createElement(ImageSetLabel, {
			Size = propsSize,
			Position = propsPosition,
			LayoutOrder = propsLayoutOrder,
			BackgroundTransparency = 1,
			Image = GetImageData("LuaApp/buttons/buttonFill") or "LuaApp/buttons/buttonFill",
			ImageColor3 = propsColor,
			ImageTransparency = propsTransparency,
			BorderSizePixel = 0,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(8, 8, 9, 9),
			[Roact.Ref] = p18.passwordBoxRef,
			[Roact.Change.AbsoluteSize] = p18.onAbsoluteSizeChanged
		}, {
			TextBoxContainer = Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -containerSizeY, 1, 0)
			}, {
				TextBox = Roact.createElement("TextBox", {
					Size = UDim2.new(1, 0, 1, 0),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Text = propsText,
					PlaceholderText = PlaceholderText,
					PlaceholderColor3 = PlaceholderColor,
					Font = p20.Font.Body.Font,
					OpenTypeFeatures = if not GetFFlagLuaAppEnableOpenTypeSupport() then nil else OpenTypeSupport:getPasswordStylisticAlternative(),
					TextSize = propsTextSize,
					TextColor3 = TextColor,
					TextTransparency = propsTextTransparency,
					TextXAlignment = TextXAlignment,
					TextYAlignment = Enum.TextYAlignment.Center,
					BackgroundTransparency = 1,
					ClearTextOnFocus = ClearTextOnFocus,
					OverlayNativeInput = true,
					ManualFocusRelease = p18.props.IsKeyboardOverlayUsed,
					ClipsDescendants = true,
					TextInputType = v51 and v58 or v59,
					ReturnKeyType = ReturnKeyType,
					NextSelectionDown = NextSelectionDown,
					NextSelectionLeft = NextSelectionLeft,
					NextSelectionRight = NextSelectionRight,
					NextSelectionUp = NextSelectionUp,
					SelectionImageObject = v89,
					[Roact.Ref] = p18.getPasswordTextBoxRef(),
					[Roact.Change.Text] = p18.props.onChangeText,
					[Roact.Event.ReturnPressedFromOnScreenKeyboard] = p18.props.onReturnPressedFromOnScreenKeyboard,
					[Roact.Event.Focused] = onFocused,
					[Roact.Event.FocusLost] = onFocusLost,
					[Roact.Event.MouseEnter] = onMouseEnter,
					[Roact.Event.MouseLeave] = onMouseLeave
				}),
				UIPadding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, PaddingY),
					PaddingBottom = UDim.new(0, PaddingY),
					PaddingLeft = UDim.new(0, PaddingX),
					PaddingRight = UDim.new(0, PaddingX)
				})
			}),
			Toggler = Roact.createElement("TextButton", {
				Position = UDim2.new(1, 0, 0.5, 0),
				Size = UDim2.new(0, containerSizeY, 1, 0),
				AnchorPoint = Vector2.new(1, 0.5),
				Text = "",
				BackgroundTransparency = 1,
				SelectionImageObject = v89,
				[Roact.Event.Activated] = p18.onTogglerActivated
			}, {
				ImageLabel = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 16, 0, 16),
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = if not v51 then GetImageData("LuaApp/icons/actions_edit_hide") or "LuaApp/icons/actions_edit_hide" else GetImageData("LuaApp/icons/actions_privacy_show") or "LuaApp/icons/actions_privacy_show",
					ImageColor3 = p20.Theme.IconDefault.Color,
					ImageTransparency = p20.Theme.IconDefault.Transparency
				})
			})
		})
	end)
end

local v23 = RoactRodux.connect(function(p21, _) -- line: 366
	return {
		centralOverlay = p21.CentralOverlay
	}
end)(v22)

if EngineFeature then
	v23 = RoactAppExperiment.connectBrowserTrackerLayer({ FStringLuaMultiPageSignupIxpLayer }, function(p23, _) -- line: 375
		-- upvalues: FStringLuaMultiPageSignupIxpLayer (copy), FFlagAndroidPasswordSuggestionExperimentEnrollmentBypass (copy)
		return {
			enablePasswordSuggestion = (p23[FStringLuaMultiPageSignupIxpLayer] or {}).enablePasswordSuggestion or (FFlagAndroidPasswordSuggestionExperimentEnrollmentBypass or false)
		}
	end)(v23)
end

return v23
