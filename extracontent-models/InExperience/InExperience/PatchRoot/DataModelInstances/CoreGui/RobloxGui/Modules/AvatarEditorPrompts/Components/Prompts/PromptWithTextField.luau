local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)

local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Style.withStyle

local Images = UIBlox.App.ImageSet.Images

CoreGui:WaitForChild("RobloxGui")
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local ExternalEventConnection = RoactUtils.ExternalEventConnection

local component_assetscircle_17_stroke_1 = Images["component_assets/circle_17_stroke_1"]
local rect = Rect.new(8, 8, 8, 8)

local extended = Roact.PureComponent:extend("PromptWithTextField")

extended.validateProps = t.strictInterface({
	fieldText = t.string,
	onFieldTextUpdated = t.callback,
	title = t.string,
	bodyText = t.optional(t.string),
	buttonStackInfo = t.table,
	screenSize = t.Vector2
})

function extended:init()
	self:setState({ alertPosition = UDim2.fromScale(0.5, 0.5) })

	self.textBoxRef = Roact.createRef()

	function self.textUpdated(p)
		self.props.onFieldTextUpdated(p.Text)
	end

	self.lastAlertHeight = 100

	function self.calculateAlertPosition()
		local udim = UDim2.fromScale(0.5, 0.5)

		if UserInputService.OnScreenKeyboardVisible then
			local v = (self.props.screenSize.Y - UserInputService.OnScreenKeyboardSize.Y) / 2
			local v2 = v - self.lastAlertHeight / 2

			if v2 < 20 then
				v += 20 - v2
			end

			udim = UDim2.new(0.5, 0, 0, v)
		end

		if self.state.alertPosition ~= udim then
			self:setState({ alertPosition = udim })
		end
	end

	function self.alertSizeChanged(p)
		self.lastAlertHeight = p.AbsoluteSize.Y

		self.calculateAlertPosition()
	end

	function self.alertMounted()
		local value = self.textBoxRef:getValue()

		if value then
			value:CaptureFocus()
		end
	end
end

function extended:renderAlertMiddleContent()
	return withStyle(function(p)
		local font = p.Font
		local theme = p.Theme

		return Roact.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 35),
				Position = UDim2.fromScale(0, 1),
				AnchorPoint = Vector2.new(0, 1)
			},
			{
				TextboxBorder = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					Image = component_assetscircle_17_stroke_1,
					ImageColor3 = theme.UIDefault.Color,
					ImageTransparency = theme.UIDefault.Transparency,
					LayoutOrder = 3,
					ScaleType = Enum.ScaleType.Slice,
					Size = UDim2.new(1, 0, 1, -5),
					Position = UDim2.fromScale(0, 1),
					AnchorPoint = Vector2.new(0, 1),
					SliceCenter = rect
				}, {
					Textbox = Roact.createElement(RoactGamepad.Focusable.TextBox, {
						BackgroundTransparency = 1,
						ClearTextOnFocus = false,
						Font = font.Header2.Font,
						TextSize = font.BaseSize * font.CaptionBody.RelativeSize,
						PlaceholderColor3 = theme.TextDefault.Color,
						PlaceholderText = RobloxTranslator:FormatByKey("CoreScripts.AvatarEditorPrompts.OutfitNamePlaceholder"),
						Position = UDim2.new(0, 6, 0, 0),
						Size = UDim2.new(1, -12, 1, 0),
						TextColor3 = theme.TextEmphasis.Color,
						TextTruncate = Enum.TextTruncate.AtEnd,
						Text = self.props.fieldText,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Left,
						OverlayNativeInput = true,
						[Roact.Change.Text] = self.textUpdated,
						[Roact.Ref] = self.textBoxRef
					})
				})
			}
		)
	end)
end

function extended:render()
	return Roact.createFragment({
		InteractiveAlert = Roact.createElement(InteractiveAlert, {
			title = self.props.title,
			bodyText = self.props.bodyText,
			buttonStackInfo = self.props.buttonStackInfo,
			position = self.state.alertPosition,
			screenSize = self.props.screenSize,
			middleContent = function()
				return self:renderAlertMiddleContent()
			end,
			isMiddleContentFocusable = true,
			onAbsoluteSizeChanged = self.alertSizeChanged,
			onMounted = self.alertMounted
		}),
		OnScreenKeyboardVisibleConnection = Roact.createElement(ExternalEventConnection, {
			event = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardVisible"),
			callback = self.calculateAlertPosition
		}),
		OnScreenKeyboardSizeConnection = Roact.createElement(ExternalEventConnection, {
			event = UserInputService:GetPropertyChangedSignal("OnScreenKeyboardSize"),
			callback = self.calculateAlertPosition
		})
	})
end

function extended.didMount(p)
	p.calculateAlertPosition()
end

local function mapStateToProps(p)
	return { screenSize = p.screenSize }
end

return RoactRodux.connect(mapStateToProps, nil)(extended)
