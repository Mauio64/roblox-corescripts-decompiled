local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)

local t = require(CorePackages.Packages.t)

local parent = script.Parent.Parent
local Assets = require(parent.Resources.Assets)
local Divider = require(parent.Components.PortedComponents.Divider)

local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local withStyle = UIBlox.Core.Style.withStyle
local IconButton = UIBlox.App.Button.IconButton
local HeaderBar = UIBlox.App.Bar.HeaderBar
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Images = UIBlox.App.ImageSet.Images
local AppHeaderBar = require(CorePackages.Workspace.Packages.AppHeaderBar)
local makeBackButton = AppHeaderBar.makeBackButton

local extended = Roact.Component:extend("ModalDialog")

extended.validateProps = t.strictInterface({
	visible = t.boolean,
	screenSize = t.Vector2,
	titleText = t.optional(t.string),
	showCloseButton = t.optional(t.boolean),
	headerBar = t.optional(t.table),
	contents = t.optional(t.table),
	actionButtons = t.optional(t.table),
	onDismiss = t.optional(t.callback),
	onBackButtonActivated = t.optional(t.callback),
	maxHeight = t.optional(t.number),
	maxWidth = t.optional(t.number)
})

function extended:init()
	function self.onOverlayActivated()
		self.props.onDismiss()
	end
end

function extended:renderHeaderBarLeft()
	local props = self.props

	if props.showCloseButton then
		return function()
			return Roact.createElement(IconButton, {
				iconSize = IconSize.Medium,
				icon = Images["icons/navigation/close"],
				onActivated = props.onDismiss
			})
		end
	end

	if props.onBackButtonActivated == nil then
		return function(): nil
			return nil
		end
	end

	return makeBackButton(props.onBackButtonActivated)
end

function extended:renderHeaderBarRight()
	return function(): nil
		return nil
	end
end

function extended:render()
	local props = self.props

	local v = math.min(props.screenSize.Y, 645)

	if props.maxHeight then
		v = math.min(v, props.maxHeight)
	end

	local v2 = math.min(props.screenSize.X, 540)

	if props.maxWidth then
		v2 = math.min(v2, props.maxWidth)
	end

	local vector2 = Vector2.new(v2, v)
	local vector2_2, udim

	if props.screenSize.X < 540 then
		vector2_2 = Vector2.new(0.5, 1)
		udim = UDim2.fromScale(0.5, 1)
	else
		vector2_2 = Vector2.new(0.5, 0.5)
		udim = UDim2.fromScale(0.5, 0.5)
	end

	local v3 = math.min(600, vector2.Y - 49 - 60)

	if not props.actionButtons then
		v3 += 60
	end

	return withStyle(function(p)
		return Roact.createElement(
			"Frame",
			{ BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Visible = props.visible },
			{
				Overlay = Roact.createElement("TextButton", {
					AutoButtonColor = false,
					BackgroundColor3 = p.Theme.Overlay.Color,
					BackgroundTransparency = p.Theme.Overlay.Transparency,
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1),
					Text = "",
					[Roact.Event.Activated] = self.onOverlayActivated
				}),
				Dialog = Roact.createElement(ImageSetButton, {
					Active = true,
					AnchorPoint = vector2_2,
					BackgroundTransparency = 1,
					Image = Assets.Images.RoundedRect.Image,
					ImageColor3 = p.Theme.BackgroundUIDefault.Color,
					ImageTransparency = p.Theme.BackgroundUIDefault.Transparency,
					Position = udim,
					ScaleType = Assets.Images.RoundedRect.ScaleType,
					Size = UDim2.fromOffset(vector2.X, vector2.Y),
					SliceCenter = Assets.Images.RoundedRect.SliceCenter
				}, {
					Layout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					HeaderBar = Roact.createElement(
						"Frame",
						{
							BackgroundTransparency = 1,
							LayoutOrder = 1,
							Size = UDim2.new(1, 0, 0, 48)
						},
						{
							Bar = props.headerBar or Roact.createElement(HeaderBar, {
								backgroundTransparency = 1,
								barHeight = 48,
								renderLeft = self:renderHeaderBarLeft(),
								renderRight = self:renderHeaderBarRight(),
								title = props.titleText
							}) or nil
						}
					),
					Divider = Roact.createElement(Divider, { LayoutOrder = 2 }),
					Content = Roact.createElement(
						"Frame",
						{
							BackgroundTransparency = 1,
							LayoutOrder = 3,
							Size = UDim2.new(1, 0, 0, v3),
							ZIndex = 10
						},
						{ Contents = props.contents }
					),
					ActionBar = props.actionButtons and Roact.createElement(
						"Frame",
						{
							BackgroundTransparency = 1,
							LayoutOrder = 4,
							Size = UDim2.new(1, 0, 0, 60)
						},
						{
							Padding = Roact.createElement("UIPadding", {
								PaddingTop = UDim.new(0, 8),
								PaddingBottom = UDim.new(0, 2),
								PaddingLeft = UDim.new(0, 24),
								PaddingRight = UDim.new(0, 24)
							}),
							ActionButtons = props.actionButtons
						}
					) or nil
				})
			}
		)
	end)
end

function extended:bindActions()
	local function dismissFunc(p)
		if p == Enum.UserInputState.Begin then
			self.props.onDismiss()
		end
	end
	ContextActionService:BindCoreAction("ModalDialogDismiss", dismissFunc, false, Enum.KeyCode.Escape)
end

function extended:unbindActions()
	ContextActionService:UnbindCoreAction("ModalDialogDismiss")
end

function extended:didMount()
	if self.props.visible then
		self:bindActions()
	end
end

function extended:didUpdate()
	if self.props.visible then
		self:bindActions()
	else
		self:unbindActions()
	end
end

function extended:willUnmount()
	self:unbindActions()
end

return extended
