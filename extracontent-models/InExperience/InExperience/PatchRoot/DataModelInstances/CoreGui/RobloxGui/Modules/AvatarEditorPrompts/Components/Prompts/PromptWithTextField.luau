local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local _ = UIBlox.App.Button.Enum.ButtonType
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Style.withStyle
local Images = UIBlox.App.ImageSet.Images

CoreGui:WaitForChild("RobloxGui")

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local ExternalEventConnection = require(CorePackages.Workspace.Packages.RoactUtils).ExternalEventConnection
local v16 = Images["component_assets/circle_17_stroke_1"]
local rect = Rect.new(8, 8, 8, 8)
local v18 = Roact.PureComponent:extend("PromptWithTextField")

v18.validateProps = t.strictInterface({
	fieldText = t.string,
	onFieldTextUpdated = t.callback,
	title = t.string,
	bodyText = t.optional(t.string),
	buttonStackInfo = t.table,
	screenSize = t.Vector2
})

function v18.init(p1) -- line: 50
	-- upvalues: Roact (copy), UserInputService (copy)
	p1:setState({
		alertPosition = UDim2.fromScale(0.5, 0.5)
	})
	p1.textBoxRef = Roact.createRef()

	function p1.textUpdated(p2) -- line: 57
		-- upvalues: p1 (copy)
		p1.props.onFieldTextUpdated(p2.Text)
	end

	p1.lastAlertHeight = 100

	function p1.calculateAlertPosition() -- line: 63
		-- upvalues: UserInputService (copy), p1 (copy)
		local uDim2 = UDim2.fromScale(0.5, 0.5)

		if UserInputService.OnScreenKeyboardVisible then
			local v27 = (p1.props.screenSize.Y - UserInputService.OnScreenKeyboardSize.Y) / 2
			local v28 = v27 - p1.lastAlertHeight / 2

			if v28 < 20 then
				v27 += 20 - v28
			end

			uDim2 = UDim2.new(0.5, 0, 0, v27)
		end

		if uDim2 ~= p1.state.alertPosition then
			p1:setState({
				alertPosition = uDim2
			})
		end
	end
	function p1.alertSizeChanged(p3) -- line: 86
		-- upvalues: p1 (copy)
		p1.lastAlertHeight = p3.AbsoluteSize.Y
		p1.calculateAlertPosition()
	end
	function p1.alertMounted() -- line: 92
		-- upvalues: p1 (copy)
		local v30 = p1.textBoxRef:getValue()

		if v30 then
			v30:CaptureFocus()
		end
	end
end
function v18.renderAlertMiddleContent(p4) -- line: 100
	-- upvalues: withStyle (copy), Roact (copy), ImageSetLabel (copy), v16 (copy), rect (copy), RoactGamepad (copy), RobloxTranslator (copy)
	return withStyle(function(p5) -- line: 101
		-- upvalues: Roact (copy), ImageSetLabel (copy), v16 (copy), rect (copy), RoactGamepad (copy), RobloxTranslator (copy), p4 (copy)
		local p5Font = p5.Font
		local Theme = p5.Theme

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 35),
			Position = UDim2.fromScale(0, 1),
			AnchorPoint = Vector2.new(0, 1)
		}, {
			TextboxBorder = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				LayoutOrder = 3,
				Image = v16,
				ImageColor3 = Theme.UIDefault.Color,
				ImageTransparency = Theme.UIDefault.Transparency,
				ScaleType = Enum.ScaleType.Slice,
				Size = UDim2.new(1, 0, 1, -5),
				Position = UDim2.fromScale(0, 1),
				AnchorPoint = Vector2.new(0, 1),
				SliceCenter = rect
			}, {
				Textbox = Roact.createElement(RoactGamepad.Focusable.TextBox, {
					BackgroundTransparency = 1,
					ClearTextOnFocus = false,
					Font = p5Font.Header2.Font,
					TextSize = p5Font.BaseSize * p5Font.CaptionBody.RelativeSize,
					PlaceholderColor3 = Theme.TextDefault.Color,
					PlaceholderText = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.OutfitNamePlaceholder"),
					Position = UDim2.new(0, 6, 0, 0),
					Size = UDim2.new(1, -12, 1, 0),
					TextColor3 = Theme.TextEmphasis.Color,
					TextTruncate = Enum.TextTruncate.AtEnd,
					Text = p4.props.fieldText,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					OverlayNativeInput = true,
					[Roact.Change.Text] = p4.textUpdated,
					[Roact.Ref] = p4.textBoxRef
				})
			})
		})
	end)
end
function v18.render(p6) -- line: 149
	-- upvalues: Roact (copy), InteractiveAlert (copy), ExternalEventConnection (copy), UserInputService (copy)
	return Roact.createFragment({
		InteractiveAlert = Roact.createElement(InteractiveAlert, {
			isMiddleContentFocusable = true,
			title = p6.props.title,
			bodyText = p6.props.bodyText,
			buttonStackInfo = p6.props.buttonStackInfo,
			position = p6.state.alertPosition,
			screenSize = p6.props.screenSize,
			middleContent = function() -- line: 159
				-- upvalues: p6 (copy)
				return p6:renderAlertMiddleContent()
			end,
			onAbsoluteSizeChanged = p6.alertSizeChanged,
			onMounted = p6.alertMounted
		}),
		OnScreenKeyboardVisibleConnection = Roact.createElement(ExternalEventConnection, {
			event = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"),
			callback = p6.calculateAlertPosition
		}),
		OnScreenKeyboardSizeConnection = Roact.createElement(ExternalEventConnection, {
			event = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardSize"),
			callback = p6.calculateAlertPosition
		})
	})
end
function v18.didMount(p7) -- line: 179
	p7.calculateAlertPosition()
end

local function mapStateToProps(p8) -- line: 183
	return {
		screenSize = p8.screenSize
	}
end

return RoactRodux.connect(mapStateToProps, nil)(v18)
