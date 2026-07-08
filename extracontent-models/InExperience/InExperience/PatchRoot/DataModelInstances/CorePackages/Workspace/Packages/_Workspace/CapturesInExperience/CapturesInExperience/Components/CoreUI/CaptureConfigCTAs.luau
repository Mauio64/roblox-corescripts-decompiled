local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local GuiService = game:GetService("GuiService")
local UserInputService = game:GetService("UserInputService")
local AppCommonLib = require(ParentParentParent.AppCommonLib)
local Localization = require(ParentParentParent.Localization)
local React = require(ParentParentParent.React)
local UIBlox = require(ParentParentParent.UIBlox)
local useLocalization = Localization.Hooks.useLocalization
local useStyle = UIBlox.Core.Style.useStyle
local AppCommonLibText = AppCommonLib.Text
local CapturesContext = require(ParentParent.Context.CapturesContext)
local CapturesPolicy = require(ParentParent.App.CapturesPolicy)
local OnOffButton = require(ParentParent.Components.CoreUI.OnOffButton)
local VideoCaptureCTA = require(ParentParent.Components.CoreUI.VideoCaptureCTA)
local useKeyboardEnabled = require(ParentParent.Hooks.useKeyboardEnabled)
local uDim = UDim.new(0, 8)
local v18 = UserInputService:GetPlatform() ~= Enum.Platform.OSX and "Alt" or "Opt"

return (CapturesPolicy.connect(function(p1) -- line: 222
	return {
		eligibleForVideoCapture = p1.eligibleForVideoCapture()
	}
end)(function(t1: {[any]: any}) -- line: 44
	-- upvalues: useStyle (copy), React (copy), CapturesContext (copy), GuiService (copy), useLocalization (copy), v18 (copy), UserInputService (copy), useKeyboardEnabled (copy), AppCommonLibText (copy), uDim (copy), OnOffButton (copy), VideoCaptureCTA (copy)
	local v20 = useStyle()
	local chromeEnabled = React.useContext(CapturesContext).chromeEnabled
	local v22, v23 = React.useState(Vector2.new(0, 0))
	local v24, v25 = React.useState(GuiService.PreferredTextSize)

	React.useEffect(function() -- line: 51
		-- upvalues: v25 (copy), GuiService (copy)
		local function onPreferredTextSizeChangedSignal() -- line: 52
			-- upvalues: v25 (copy), GuiService (copy)
			v25(GuiService.PreferredTextSize)
		end

		local connection = GuiService:GetPropertyChangedSignal("PreferredTextSize"):Connect(onPreferredTextSizeChangedSignal)

		return function() -- line: 58
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, {})

	local v26 = useLocalization({
		capturesTitle = "Feature.Captures.Title.Captures",
		educationalText = "Feature.Captures.Label.EducationalText",
		hotkeyEducationalText = {
			"Feature.Captures.Label.HotkeyEducationalText",
			keyOne = v18,
			keyTwo = UserInputService:GetStringForKeyCode(Enum.KeyCode.One)
		}
	})
	local v27 = if not useKeyboardEnabled() then v26.educationalText else v26.hotkeyEducationalText
	local BackgroundDefaultColor = v20.Theme.BackgroundDefault.Color
	local BackgroundDefaultTransparency = v20.Theme.BackgroundDefault.Transparency
	local TextDefaultColor = v20.Theme.TextDefault.Color
	local CaptionBodyFont = v20.Font.CaptionBody.Font
	local v32 = v20.Font.BaseSize * v20.Font.CaptionBody.RelativeSize
	local TextEmphasisColor = v20.Theme.TextEmphasis.Color
	local Header2Font = v20.Font.Header2.Font
	local v35 = v20.Font.BaseSize * v20.Font.Header2.RelativeSize
	local v36 = React.useCallback(function(p2) -- line: 89
		-- upvalues: v23 (copy), t1 (copy)
		v23(p2.AbsoluteSize)

		if t1.onAbsoluteSizeChanged then
			t1.onAbsoluteSizeChanged(p2.AbsoluteSize)
		end
	end, {})
	local v37 = React.useMemo(function() -- line: 96
		-- upvalues: AppCommonLibText (copy), v27 (copy), CaptionBodyFont (copy), v32 (copy)
		return AppCommonLibText.GetTextWidth(v27, CaptionBodyFont, v32)
	end, {
		CaptionBodyFont,
		v32,
		v24,
		v27
	})
	local X = v22.X
	local v39 = v37 < X - 224 - 24
	local n1 = 20

	if not v39 and not (v37 < X - 24) then
		n1 = AppCommonLibText.GetTextHeight(v27, CaptionBodyFont, v32, X - 24) + 10
	end

	return React.createElement("Frame", {
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = BackgroundDefaultColor,
		BackgroundTransparency = BackgroundDefaultTransparency,
		BorderSizePixel = 0,
		LayoutOrder = t1.LayoutOrder,
		Size = UDim2.fromScale(1, 0),
		[React.Change.AbsoluteSize] = v36
	}, {
		UICorner = React.createElement("UICorner", {
			CornerRadius = uDim
		}),
		UIPadding = React.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, 12),
			PaddingLeft = UDim.new(0, 12),
			PaddingRight = UDim.new(0, 12),
			PaddingTop = UDim.new(0, 12)
		}),
		Layout = if chromeEnabled then nil else React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Top
		}),
		CapturesToggleCTA = if chromeEnabled then nil else React.createElement("Frame", {
			BorderSizePixel = 0,
			LayoutOrder = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundColor3 = BackgroundDefaultColor,
			BackgroundTransparency = BackgroundDefaultTransparency,
			Size = UDim2.fromScale(1, 0)
		}, {
			TextFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 0)
			}, {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalAlignment = Enum.VerticalAlignment.Top
				}),
				Title = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Font = Header2Font,
					Size = UDim2.new(1, 0, 0, 30),
					Text = v26.capturesTitle,
					TextColor3 = TextEmphasisColor,
					TextSize = v35,
					TextXAlignment = Enum.TextXAlignment.Left
				}),
				EducationalLabel = React.createElement("TextLabel", {
					BackgroundTransparency = 1,
					LayoutOrder = 2,
					TextWrapped = true,
					Font = CaptionBodyFont,
					Size = UDim2.new(1, 0, 0, n1),
					Text = v27,
					TextColor3 = TextDefaultColor,
					TextSize = v32,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			}),
			CapturesToggleFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				AnchorPoint = if not v39 then Vector2.new(1, 0) else Vector2.new(1, 0.5),
				Position = if not v39 then UDim2.new(1, 0, 0, -10) else UDim2.fromScale(1, 0.5),
				Size = UDim2.fromOffset(224, 44)
			}, {
				OnOffButton = React.createElement(OnOffButton, {
					height = 44,
					width = 224
				})
			})
		}),
		Space = if not t1.eligibleForVideoCapture or chromeEnabled then nil else React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(0, 0, 0, 20)
		}),
		VideoCaptureCTA = if not t1.eligibleForVideoCapture then nil else React.createElement(VideoCaptureCTA, {
			LayoutOrder = 3,
			closeSettingsMenu = t1.closeSettingsMenu
		})
	})
end))
