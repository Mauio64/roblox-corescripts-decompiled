local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t

local UIBlox = InGameMenuDependencies.UIBlox
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Style = require(CorePackages.Workspace.Packages.Style)
local GetTextSize = Style.GetTextSize
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local withFoundationOrUIBloxStyle = CoreGuiCommon.withFoundationOrUIBloxStyle

local parent = script.Parent.Parent
local Constants = require(parent.Resources.Constants)
local Assets = require(parent.Resources.Assets)
local FFlagIGMDialogButtonsUseUIBloxButton = require(parent.Flags.FFlagIGMDialogButtonsUseUIBloxButton)

local ThemedTextLabel = require(script.Parent.ThemedTextLabel)

local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

local FocusHandler = require(script.Parent.Connection.FocusHandler)

local extended = Roact.PureComponent:extend("ConfirmationDialog")

extended.validateProps = t.strictInterface({
	bodyText = t.string,
	cancelText = t.string,
	confirmText = t.string,
	titleText = t.string,
	bindReturnToConfirm = t.boolean,
	onCancel = t.callback,
	onConfirm = t.callback,
	blurBackground = t.boolean,
	visible = t.boolean,
	inputType = t.optional(t.string)
})

extended.defaultProps = {
	bodyText = "This is some body text. It will wrap when needed.",
	cancelText = "Cancel",
	confirmText = "Confirm",
	titleText = "Dialog Title",
	blurBackground = false
}

function extended:init()
	self.state = { isRooted = false }

	function self.onAncestryChanged(instance)
		if instance:IsDescendantOf(game) then
			self:setState({ isRooted = true })
		end
	end
	self.confirmButtonRef = Roact.createRef()
	self.buttonContainerRef = Roact.createRef()
end

function extended.render(data)
	local props = data.props

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
				},
				Divider = {
					Color = tokens.Color.Stroke.Emphasis.Color3,
					Transparency = tokens.Color.Stroke.Emphasis.Transparency
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
			GetTextSize(bodyText, v, props2.Tokens.Typography.BodyLarge.Font, Vector2.new(295, 1e999), {
				addTemporaryPadding = false
			}).Y,
			v * 2
		) + 20 + 20

		return Roact.createElement(Roact.Portal, { target = CoreGui }, {
			InGameMenuConfirmationDialog = Roact.createElement("ScreenGui", {
				DisplayOrder = Constants.DisplayOrder.ConfirmationDialog,
				IgnoreGuiInset = true,
				OnTopOfCoreBlur = props.blurBackground,
				Enabled = props.visible,
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
					Size = UDim2.new(0, 335, 0, v2 + 49 + 36 + 20),
					SliceCenter = Assets.Images.RoundedRect.SliceCenter
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingBottom = UDim.new(0, 20),
						PaddingLeft = UDim.new(0, 20),
						PaddingRight = UDim.new(0, 20)
					}),
					Layout = Roact.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					Title = Roact.createElement(ThemedTextLabel, {
						fontKey = "Header1",
						themeKey = "TextEmphasis",
						LayoutOrder = 1,
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
					ButtonContainer = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 5,
						Size = UDim2.new(1, 0, 0, 36),
						[Roact.Ref] = data.buttonContainerRef,
						[Roact.Event.AncestryChanged] = data.onAncestryChanged
					}, {
						Layout = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							Padding = UDim.new(0, 10),
							SortOrder = Enum.SortOrder.LayoutOrder,
							VerticalAlignment = Enum.VerticalAlignment.Center
						}),
						CancelButton = Roact.createElement(Button, {
							buttonType = ButtonType.Secondary,
							layoutOrder = 1,
							size = UDim2.new(0.5, -5, 1, 0),
							text = props.cancelText,
							onActivated = props.onCancel,
							DO_NOT_USE_useUIBloxButton = FFlagIGMDialogButtonsUseUIBloxButton and true or nil
						}),
						ConfirmButton = Roact.createElement(Button, {
							buttonType = ButtonType.PrimarySystem,
							layoutOrder = 2,
							size = UDim2.new(0.5, -5, 1, 0),
							text = props.confirmText,
							onActivated = props.onConfirm,
							[Roact.Ref] = data.confirmButtonRef,
							DO_NOT_USE_useUIBloxButton = FFlagIGMDialogButtonsUseUIBloxButton and true or nil
						})
					})
				})
			}),
			FocusHandler = Roact.createElement(FocusHandler, {
				isFocused = data.state.isRooted and data.props.visible and data.props.inputType == Constants.InputType.Gamepad,
				didFocus = function()
					GuiService:RemoveSelectionGroup("InGameMenuModalButtonsSelectionParent")
					GuiService:AddSelectionParent(
						"InGameMenuModalButtonsSelectionParent",
						data.buttonContainerRef:getValue()
					)

					GuiService.SelectedCoreObject = data.confirmButtonRef:getValue()
				end
			})
		})
	end)
end

function extended:updateBlur()
	local visible = self.props.blurBackground and self.props.visible
	RunService:SetRobloxGuiFocused(visible)
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

	local function cancelFunc(_, p, _)
		if p == Enum.UserInputState.Begin then
			self.props.onCancel()
		end
	end

	ContextActionService:BindCoreAction("InGameMenuModalCancel", cancelFunc, false, Enum.KeyCode.Escape)
end

function extended:unbindActions()
	ContextActionService:UnbindCoreAction("InGameMenuModalConfirm")
	ContextActionService:UnbindCoreAction("InGameMenuModalCancel")
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
