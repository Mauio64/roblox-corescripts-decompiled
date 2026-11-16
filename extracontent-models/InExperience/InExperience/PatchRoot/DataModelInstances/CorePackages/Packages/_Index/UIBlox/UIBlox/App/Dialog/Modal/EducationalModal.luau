local parent = script.Parent
local parent2 = parent.Parent.Parent
local parent3 = parent2.Parent

local parent4 = parent3.Parent
local Roact = require(parent4.Roact)
local t = require(parent4.t)
local FitFrame = require(parent4.FitFrame)
local Foundation = require(parent4.Foundation)
local FitFrameVertical = FitFrame.FitFrameVertical

local ImageSetComponent = require(parent3.Core.ImageSet.ImageSetComponent)
local Label = ImageSetComponent.Label
local GenericTextLabel = require(parent3.Core.Text.GenericTextLabel.GenericTextLabel)
local withStyle = require(parent3.Core.Style.withStyle)
local ButtonType = require(parent3.App.Button.Enum.ButtonType)
local getIconSize = require(parent2.ImageSet.getIconSize)
local IconSize = require(parent2.ImageSet.Enum.IconSize)

local Checkbox = Foundation.Checkbox

local PartialPageModal = require(parent.PartialPageModal)

local extended = Roact.PureComponent:extend("EducationalModal")

extended.validateProps = t.strictInterface({
	bodyContents = t.array(t.strictInterface({
		icon = t.optional(t.union(t.string, t.table)),
		text = t.string,
		layoutOrder = t.optional(t.integer),
		isSystemMenuIcon = t.optional(t.boolean)
	})),
	hasDoNotShow = t.optional(t.boolean),
	cancelText = t.string,
	confirmText = t.string,
	doNotShowText = t.optional(t.string),
	titleText = t.optional(t.string),
	titleBackgroundImageProps = t.strictInterface({
		image = t.string,
		imageHeight = t.number,
		text = t.optional(t.string)
	}),
	screenSize = t.Vector2,
	onDismiss = t.callback,
	onCancel = t.callback,
	onConfirm = t.callback
})

local function ContentItem(props)
	local vector2 = Vector2.new(16, 16)

	local isSystemMenuIcon = props.isSystemMenuIcon or false
	local v = isSystemMenuIcon or props.icon

	local stylePalette = props.stylePalette
	local theme = stylePalette.Theme
	local font = stylePalette.Font
	local textSize = font.Body.RelativeSize * font.BaseSize

	local createElement = Roact.createElement
	local v2 = {
		Size = v and UDim2.new(0, 253, 0, vector2.Y) or UDim2.new(1, 0, 0, vector2.Y),
		AutomaticSize = v and Enum.AutomaticSize.None or Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = props.layoutOrder
	}
	local v3 = {
		HorizontalLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = isSystemMenuIcon and UDim.new(0, 10) or UDim.new(0, 8),
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = isSystemMenuIcon and UDim.new(0, 2) or UDim.new(0, 0)
		}),
		Icon = 0,
		Text = 0
	}

	local icon = isSystemMenuIcon
		and Roact.createElement(
			Label,
			{
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(32, 32),
				Image = "rbxasset://textures/ui/TopBar/iconBase.png",
				LayoutOrder = 1
			},
			{
				Icon = Roact.createElement(Label, {
					ZIndex = 1,
					BackgroundTransparency = 1,
					Position = UDim2.fromScale(0.5, 0.5),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Size = UDim2.fromOffset(24, 24),
					Image = "rbxasset://textures/ui/TopBar/coloredlogo.png"
				})
			}
		)

	if not icon then
		if v then
			icon = Roact.createElement(Label, {
				Image = props.icon,
				Size = UDim2.fromOffset(getIconSize(IconSize.Medium), getIconSize(IconSize.Medium)),
				ImageColor3 = theme.IconDefault.Color,
				ImageTransparency = theme.IconDefault.Transparency,
				BackgroundTransparency = 1,
				LayoutOrder = 1
			}) or nil
		else
			icon = nil
		end
	end

	v3.Icon = icon

	v3.Text = props.text and Roact.createElement(GenericTextLabel, {
		Size = UDim2.new(1, 0, 0, vector2.Y),
		AutomaticSize = v and Enum.AutomaticSize.None or Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Text = props.text,
		TextSize = textSize,
		colorStyle = theme.TextDefault,
		TextTransparency = theme.TextDefault.Transparency,
		fontStyle = font.Body,
		TextXAlignment = v and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center,
		TextWrapped = true,
		LayoutOrder = 2
	})
	return createElement("Frame", v2, v3)
end

function extended:init()
	self.state = { shouldNotShowAgain = false }

	local binding, changeContentSize = Roact.createBinding(Vector2.new(0, 0))
	self.contentSize = binding
	self.changeContentSize = changeContentSize

	function self.toggleDoNotShow()
		self:setState(function(p)
			return {
				shouldNotShowAgain = not p.shouldNotShowAgain
			}
		end)
	end

	function self.onDismiss()
		self.props.onDismiss(self.state.shouldNotShowAgain)
	end
	function self.onCancel()
		self.props.onCancel(self.state.shouldNotShowAgain)
	end
	function self.onConfirm()
		self.props.onConfirm(self.state.shouldNotShowAgain)
	end
end

function extended.render(data)
	local props = data.props
	local hasDoNotShow = props.hasDoNotShow

	return withStyle(function(stylePalette)
		local children = {}
		local count = 0

		for i, bodyContent in ipairs(props.bodyContents) do
			table.insert(children, (Roact.createElement(ContentItem, {
				key = tostring(i),
				icon = bodyContent.icon,
				text = bodyContent.text,
				layoutOrder = i,
				isSystemMenuIcon = bodyContent.isSystemMenuIcon,
				stylePalette = stylePalette
			})))
			count += 1
		end

		local theme = stylePalette.Theme

		if hasDoNotShow then
			table.insert(children, (Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 50),
				LayoutOrder = count + 1,
				BackgroundTransparency = 1
			}, {
				UIListLayout = Roact.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, 21),
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center
				}),
				Divider = Roact.createElement("Frame", {
					LayoutOrder = 1,
					BackgroundColor3 = theme.Divider.Color,
					BackgroundTransparency = theme.Divider.Transparency,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 1)
				}),
				DoNotShowCheckbox = Roact.createElement(Checkbox, {
					label = props.doNotShowText,
					onActivated = data.toggleDoNotShow,
					isChecked = data.state.shouldNotShowAgain,
					LayoutOrder = 2
				})
			})))
		end

		local createElement = Roact.createElement
		local v = {
			title = props.titleText,
			titleBackgroundImageProps = props.titleBackgroundImageProps,
			screenSize = props.screenSize,
			bottomPadding = 50,
			buttonStackProps = 0,
			onCloseClicked = 0
		}
		local onActivated

		if hasDoNotShow then
			onActivated = data.onCancel
		else
			onActivated = props.onCancel
		end

		local props2 = { isDisabled = false, onActivated = onActivated, text = props.cancelText }

		local v2 = { buttonType = ButtonType.PrimarySystem, props = 0 }
		local onActivated2

		if hasDoNotShow then
			onActivated2 = data.onConfirm
		else
			onActivated2 = props.onConfirm
		end

		v2.props = { isDisabled = false, onActivated = onActivated2, text = props.confirmText }
		v.buttonStackProps = {
			buttons = {
				{ props = props2 },
				v2
			}
		}
		local onCloseClicked

		if hasDoNotShow then
			onCloseClicked = data.onDismiss
		else
			onCloseClicked = props.onDismiss
		end

		v.onCloseClicked = onCloseClicked
		return createElement(PartialPageModal, v, {
			BodyContents = Roact.createElement(FitFrameVertical, {
				BackgroundTransparency = 1,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				width = UDim.new(1, 0),
				contentPadding = UDim.new(0, 28),
				margin = { top = 36, bottom = 36 },
				[Roact.Change.AbsoluteSize] = function(p)
					data.changeContentSize(p.AbsoluteSize)
				end
			}, children)
		})
	end)
end

return extended
