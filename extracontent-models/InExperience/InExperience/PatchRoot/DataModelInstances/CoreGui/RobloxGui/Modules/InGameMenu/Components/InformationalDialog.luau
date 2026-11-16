local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t

local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local withStyle = UIBlox.Core.Style.withStyle

local parent = script.Parent.Parent
local flags = parent.Flags
local GetFFlagIGMGamepadSelectionHistory = require(flags.GetFFlagIGMGamepadSelectionHistory)
local Constants = require(parent.Resources.Constants)
local Assets = require(parent.Resources.Assets)

local ThemedTextLabel = require(script.Parent.ThemedTextLabel)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local FocusHandler = require(script.Parent.Connection.FocusHandler)
local Foundation = require(CorePackages.Packages.Foundation)
local Style = require(CorePackages.Workspace.Packages.Style)
local GetTextSize = Style.GetTextSize
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local extended = Roact.PureComponent:extend("InformationalDialog")

extended.validateProps = t.strictInterface({
	bodyText = t.string,
	confirmText = t.string,
	titleText = t.string,
	subBodyText = t.optional(t.string),
	iconImage = t.optional(t.union(t.table, t.string)),
	iconSize = t.number,
	onContinueFunc = t.optional(t.callback),
	bindReturnToConfirm = t.boolean,
	blurBackground = t.boolean,
	visible = t.boolean,
	inputType = t.optional(t.string)
})

extended.defaultProps = {
	subBodyText = nil,
	blurBackground = false,
	iconImage = nil,
	iconSize = 64
}

function extended:init()
	self.state = { isRooted = false, show = true }

	function self.onAncestryChanged(instance)
		if instance:IsDescendantOf(game) then
			self:setState({ isRooted = true })
		end
	end
	self.confirmButtonRef = Roact.createRef()
	self.buttonContainerRef = Roact.createRef()
end

function extended.render(object)
	local props = object.props

	return withStyle(function(props2)
		local font = props2.Font.Body.Font
		local v = props2.Font.Body.RelativeSize * props2.Font.BaseSize
		local bodyText = props.bodyText
		local y

		if FoundationFontFaceMigration then
			y = GetTextSize(bodyText, v, props2.Tokens.Typography.BodyLarge.Font, Vector2.new(295, 1e999), {
				addTemporaryPadding = false
			}).Y
		else
			y = TextService:GetTextSize(bodyText, v, font, Vector2.new(295, 1e999)).Y
		end

		local y2

		if FoundationFontFaceMigration then
			y2 = GetTextSize(props.subBodyText, v, props2.Tokens.Typography.BodyLarge.Font, Vector2.new(295, 1e999), {
				addTemporaryPadding = false
			}).Y
		else
			y2 = TextService:GetTextSize(props.subBodyText, v, font, Vector2.new(295, 1e999)).Y
		end

		local v2 = math.max(y, v * 2) + 20
		local v3 = math.max(y2, v * 2) + 20
		local shouldForgetPreviousSelection

		if GetFFlagIGMGamepadSelectionHistory() then
			shouldForgetPreviousSelection = not object.props.visible
		end

		return Roact.createElement(Roact.Portal, { target = CoreGui }, {
			InGameMenuInformationalDialog = Roact.createElement("ScreenGui", {
				DisplayOrder = 8,
				IgnoreGuiInset = true,
				OnTopOfCoreBlur = props.blurBackground,
				Enabled = props.visible and object.state.show,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			}, {
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
					Size = UDim2.new(0, 335, 0, v2 + 49 + v3 + 36 + 70 + props.iconSize),
					SliceCenter = Assets.Images.RoundedRect.SliceCenter
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 20),
						PaddingBottom = UDim.new(0, 20),
						PaddingLeft = UDim.new(0, 20),
						PaddingRight = UDim.new(0, 20)
					}),
					Layout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					Icon = Roact.createElement(ImageSetLabel, {
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Image = props.iconImage,
						Size = UDim2.new(0, props.iconSize, 0, props.iconSize),
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						BorderSizePixel = 0
					}),
					Title = Roact.createElement(ThemedTextLabel, {
						fontKey = "Header1",
						themeKey = "TextEmphasis",
						LayoutOrder = 2,
						Size = UDim2.new(1, 0, 0, 48),
						Text = props.titleText
					}),
					Divider = Roact.createElement("Frame", {
						BackgroundColor3 = props2.Theme.Divider.Color,
						BackgroundTransparency = props2.Theme.Divider.Transparency,
						BorderSizePixel = 0,
						LayoutOrder = 3,
						Size = UDim2.new(0.8, 0, 0, 1)
					}),
					SpaceContainer = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 4,
						Size = UDim2.new(1, 0, 0, 10)
					}),
					BodyTextContainer = Roact.createElement(
						"Frame",
						{
							BackgroundTransparency = 1,
							LayoutOrder = 5,
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
					SubBodyTextContainer = Roact.createElement(
						"Frame",
						{
							BackgroundTransparency = 1,
							LayoutOrder = 6,
							Size = UDim2.new(1, 0, 0, v3)
						},
						{
							BodyText = Roact.createElement(ThemedTextLabel, {
								Size = UDim2.new(1, 0, 1, 0),
								Text = props.subBodyText,
								TextWrapped = true
							})
						}
					),
					SpaceContainer2 = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 7,
						Size = UDim2.new(1, 0, 0, 10)
					}),
					ButtonContainer = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 8,
						Size = UDim2.new(1, 0, 0, 36),
						[Roact.Ref] = object.buttonContainerRef,
						[Roact.Event.AncestryChanged] = object.onAncestryChanged
					}, {
						Layout = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							Padding = UDim.new(0, 20),
							SortOrder = Enum.SortOrder.LayoutOrder,
							VerticalAlignment = Enum.VerticalAlignment.Center
						}),
						ConfirmButton = Roact.createElement(Button, {
							buttonType = ButtonType.PrimarySystem,
							layoutOrder = 1,
							size = UDim2.new(1, -5, 1, 0),
							text = props.confirmText,
							onActivated = function()
								object:setState({ show = false })

								if object.props.onContinueFunc then
									object.props.onContinueFunc()
								end

								RunService:SetRobloxGuiFocused(false)
							end,
							[Roact.Ref] = object.confirmButtonRef
						})
					})
				})
			}),
			FocusHandler = Roact.createElement(FocusHandler, {
				isFocused = object.state.isRooted and object.props.visible and object.props.inputType == Constants.InputType.Gamepad,
				shouldForgetPreviousSelection = shouldForgetPreviousSelection,
				didFocus = function()
					GuiService:RemoveSelectionGroup("InGameMenuModalButtonsSelectionParent")
					GuiService:AddSelectionParent(
						"InGameMenuModalButtonsSelectionParent",
						object.buttonContainerRef:getValue()
					)

					GuiService.SelectedCoreObject = object.confirmButtonRef:getValue()
				end
			})
		})
	end)
end

function extended:updateBlur()
	RunService:SetRobloxGuiFocused(self.props.blurBackground and self.props.visible)
end

function extended:bindActions()
	local function confirmFunc(_, p, _)
		if p == Enum.UserInputState.Begin then
			self.props.onConfirm()
		end
	end

	if self.props.bindReturnToConfirm then
		ContextActionService:BindCoreAction("InGameMenuModalConfirm", confirmFunc, false, Enum.KeyCode.Return)
	end
end

function extended:unbindActions()
	ContextActionService:UnbindCoreAction("InGameMenuModalConfirm")
end

function extended:didMount()
	self:updateBlur()

	if self.props.visible then
		self:bindActions()
	end
end

function extended:didUpdate()
	self:updateBlur()

	if self.props.visible then
		self:bindActions()
	else
		self:unbindActions()
	end
end

function extended:willUnmount()
	if self.props.blurBackground then
		RunService:SetRobloxGuiFocused(false)
	end

	self:unbindActions()
end

return extended
