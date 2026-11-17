local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t

local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Style = require(CorePackages.Workspace.Packages.Style)
local GetTextSize = Style.GetTextSize
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle

local parent = script.Parent.Parent
local Assets = require(parent.Resources.Assets)

local ThemedTextLabel = require(script.Parent.ThemedTextLabel)
local Divider = require(script.Parent.Divider)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local extended = Roact.PureComponent:extend("InfoDialog")

extended.validateProps = t.strictInterface({
	bodyText = t.string,
	dismissText = t.string,
	titleText = t.string,
	iconImage = t.union(t.string, t.table),
	onDismiss = t.callback,
	visible = t.boolean,
	buttonRef = t.optional(t.table)
})

function extended.render(p)
	local props = p.props

	return withFoundationOrUIBloxStyle(function(tokens)
		return {
			Tokens = tokens,
			Theme = {
				Overlay = {
					Color = tokens.Color.Common.Scrim.Color3,
					Transparency = tokens.Color.Common.Scrim.Transparency
				},
				BackgroundUIDefault = {
					Color = tokens.Color.Surface.Surface_300.Color3,
					Transparency = tokens.Color.Surface.Surface_300.Transparency
				}
			},
			Font = {
				BaseSize = 1,
				Body = {
					Font = tokens.Typography.BodyLarge.Font,
					RelativeSize = tokens.Typography.BodyLarge.FontSize
				}
			}
		}
	end, function(props2)
		local v = props2.Font.Body.RelativeSize * props2.Font.BaseSize
		local bodyText = props.bodyText
		local v2 = math.max(
			GetTextSize(bodyText, v, props2.Tokens.Typography.BodyLarge.Font, Vector2.new(264, 1e999), {
				addTemporaryPadding = false
			}).Y,
			v * 2
		) + 48

		return Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				ZIndex = 8,
				Visible = props.visible
			},
			{
				Overlay = Roact.createElement("TextButton", {
					AutoButtonColor = false,
					BackgroundColor3 = props2.Theme.Overlay.Color,
					BackgroundTransparency = props2.Theme.Overlay.Transparency,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 1, 0),
					Text = ""
				}),
				DialogMainFrame = Roact.createElement(ImageSetLabel, {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Image = Assets.Images.RoundedRect.Image,
					ImageColor3 = props2.Theme.BackgroundUIDefault.Color,
					ImageTransparency = props2.Theme.BackgroundUIDefault.Transparency,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					ScaleType = Assets.Images.RoundedRect.ScaleType,
					Size = UDim2.new(0, 312, 0, v2 + 49 + 36 + 36 + 24 + 10),
					SliceCenter = Assets.Images.RoundedRect.SliceCenter
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 10),
						PaddingBottom = UDim.new(0, 24),
						PaddingLeft = UDim.new(0, 24),
						PaddingRight = UDim.new(0, 24)
					}),
					Layout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					Icon = Roact.createElement(ImageSetLabel, {
						Size = UDim2.new(0, 36, 0, 36),
						BackgroundTransparency = 1,
						Image = p.props.iconImage,
						LayoutOrder = 1
					}),
					Title = Roact.createElement(ThemedTextLabel, {
						fontKey = "Header1",
						themeKey = "TextEmphasis",
						LayoutOrder = 2,
						Size = UDim2.new(1, 0, 0, 48),
						Text = props.titleText
					}),
					Divider = Roact.createElement(Divider, { LayoutOrder = 3 }),
					BodyTextContainer = Roact.createElement(
						"Frame",
						{
							BackgroundTransparency = 1,
							LayoutOrder = 4,
							Size = UDim2.new(1, 0, 0, v2)
						},
						{
							BodyText = Roact.createElement(ThemedTextLabel, {
								Size = UDim2.new(1, 0, 1, 0),
								Text = props.bodyText,
								TextWrapped = true
							})
						}
					),
					ConfirmButton = Roact.createElement(Button, {
						buttonType = ButtonType.PrimarySystem,
						layoutOrder = 5,
						size = UDim2.new(1, 0, 0, 36),
						onActivated = props.onDismiss,
						text = props.dismissText,
						[Roact.Ref] = p.props.buttonRef
					})
				})
			}
		)
	end)
end

function extended:bindActions()
	local function dismissFunc(_, p, _)
		if p == Enum.UserInputState.Begin then
			self.props.onDismiss()
		end
	end

	ContextActionService:BindCoreAction("InGameMenuModalDismiss", dismissFunc, false, Enum.KeyCode.Escape)
end

function extended:unbindActions()
	ContextActionService:UnbindCoreAction("InGameMenuModalDismiss")
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
