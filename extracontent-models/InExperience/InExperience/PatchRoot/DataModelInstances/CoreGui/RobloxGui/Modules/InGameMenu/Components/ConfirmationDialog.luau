local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local GuiService = game:GetService("GuiService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local UIBlox = InGameMenuDependencies.UIBlox
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local withStyle = UIBlox.Core.Style.withStyle
local ParentParent = script.Parent.Parent
local Constants = require(ParentParent.Resources.Constants)
local Assets = require(ParentParent.Resources.Assets)
local ThemedTextLabel = require(script.Parent.ThemedTextLabel)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local FocusHandler = require(script.Parent.Connection.FocusHandler)
local v20 = Roact.PureComponent:extend("ConfirmationDialog")

v20.validateProps = t.strictInterface({
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
v20.defaultProps = {
	bodyText = "This is some body text. It will wrap when needed.",
	cancelText = "Cancel",
	confirmText = "Confirm",
	titleText = "Dialog Title",
	blurBackground = false
}

function v20.init(p1) -- line: 59
	-- upvalues: Roact (copy)
	p1.state = {
		isRooted = false
	}

	function p1.onAncestryChanged(p2) -- line: 64
		-- upvalues: p1 (copy)
		if p2:IsDescendantOf(game) then
			p1:setState({
				isRooted = true
			})
		end
	end

	p1.confirmButtonRef = Roact.createRef()
	p1.buttonContainerRef = Roact.createRef()
end
function v20.render(p3) -- line: 75
	-- upvalues: withStyle (copy), TextService (copy), Roact (copy), CoreGui (copy), Constants (copy), ImageSetLabel (copy), Assets (copy), ThemedTextLabel (copy), Button (copy), ButtonType (copy), FocusHandler (copy), GuiService (copy)
	local props = p3.props

	return withStyle(function(p4) -- line: 78
		-- upvalues: props (copy), TextService (copy), Roact (copy), CoreGui (copy), Constants (copy), ImageSetLabel (copy), Assets (copy), ThemedTextLabel (copy), p3 (copy), Button (copy), ButtonType (copy), FocusHandler (copy), GuiService (copy)
		local BodyFont = p4.Font.Body.Font
		local v36 = p4.Font.Body.RelativeSize * p4.Font.BaseSize
		local bodyText = props.bodyText
		local v38 = math.max(TextService:GetTextSize(bodyText, v36, BodyFont, Vector2.new(295, 1e999)).Y, v36 * 2) + 20 + 20

		return Roact.createElement(Roact.Portal, {
			target = CoreGui
		}, {
			InGameMenuConfirmationDialog = Roact.createElement("ScreenGui", {
				IgnoreGuiInset = true,
				DisplayOrder = Constants.DisplayOrder.ConfirmationDialog,
				OnTopOfCoreBlur = props.blurBackground,
				Enabled = props.visible,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			}, {
				Overlay = Roact.createElement("TextButton", {
					AutoButtonColor = false,
					BorderSizePixel = 0,
					Text = "",
					BackgroundColor3 = p4.Theme.Overlay.Color,
					BackgroundTransparency = p4.Theme.Overlay.Transparency,
					Size = UDim2.new(1, 0, 1, 0)
				}),
				DialogMainFrame = Roact.createElement(ImageSetLabel, {
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Image = Assets.Images.RoundedRect.Image,
					ImageColor3 = p4.Theme.BackgroundUIDefault.Color,
					ImageTransparency = p4.Theme.BackgroundUIDefault.Transparency,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					ScaleType = Assets.Images.RoundedRect.ScaleType,
					Size = UDim2.new(0, 335, 0, v38 + 49 + 36 + 20),
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
						BorderSizePixel = 0,
						LayoutOrder = 3,
						BackgroundColor3 = p4.Theme.Divider.Color,
						BackgroundTransparency = p4.Theme.Divider.Transparency,
						Size = UDim2.new(0.8, 0, 0, 1)
					}),
					BodyTextContainer = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 4,
						Size = UDim2.new(1, 0, 0, v38)
					}, {
						BodyText = Roact.createElement(ThemedTextLabel, {
							TextWrapped = true,
							Size = UDim2.new(1, 0, 1, 0),
							Text = props.bodyText
						})
					}),
					ButtonContainer = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 5,
						Size = UDim2.new(1, 0, 0, 36),
						[Roact.Ref] = p3.buttonContainerRef,
						[Roact.Event.AncestryChanged] = p3.onAncestryChanged
					}, {
						Layout = Roact.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							Padding = UDim.new(0, 10),
							SortOrder = Enum.SortOrder.LayoutOrder,
							VerticalAlignment = Enum.VerticalAlignment.Center
						}),
						CancelButton = Roact.createElement(Button, {
							layoutOrder = 1,
							buttonType = ButtonType.Secondary,
							size = UDim2.new(0.5, -5, 1, 0),
							text = props.cancelText,
							onActivated = props.onCancel
						}),
						ConfirmButton = Roact.createElement(Button, {
							buttonType = ButtonType.PrimarySystem,
							layoutOrder = 2,
							size = UDim2.new(0.5, -5, 1, 0),
							text = props.confirmText,
							onActivated = props.onConfirm,
							[Roact.Ref] = p3.confirmButtonRef
						})
					})
				})
			}),
			FocusHandler = Roact.createElement(FocusHandler, {
				isFocused = p3.state.isRooted and (p3.props.visible and p3.props.inputType == Constants.InputType.Gamepad),
				didFocus = function() -- line: 198
					-- upvalues: GuiService (copy), p3 (copy)
					GuiService:RemoveSelectionGroup("InGameMenuModalButtonsSelectionParent")
					GuiService:AddSelectionParent("InGameMenuModalButtonsSelectionParent", p3.buttonContainerRef:getValue())
					GuiService.SelectedCoreObject = p3.confirmButtonRef:getValue()
				end
			})
		})
	end)
end
function v20.updateBlur(p5) -- line: 209
	-- upvalues: RunService (copy)
	local v25 = p5.props.blurBackground and p5.props.visible

	RunService:SetRobloxGuiFocused(v25)
end
function v20.bindActions(p6) -- line: 215
	-- upvalues: ContextActionService (copy)
	local function confirmFunc(_, p8, _) -- line: 216
		-- upvalues: p6 (copy)
		if p8 == Enum.UserInputState.Begin then
			p6.props.onConfirm()
		end
	end

	if p6.props.bindReturnToConfirm then
		ContextActionService:BindCoreAction("InGameMenuModalConfirm", confirmFunc, false, Enum.KeyCode.Return)
	end

	local function cancelFunc(_, p11, _) -- line: 226
		-- upvalues: p6 (copy)
		if p11 == Enum.UserInputState.Begin then
			p6.props.onCancel()
		end
	end

	ContextActionService:BindCoreAction("InGameMenuModalCancel", cancelFunc, false, Enum.KeyCode.Escape)
end
function v20.unbindActions(_) -- line: 235
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindCoreAction("InGameMenuModalConfirm")
	ContextActionService:UnbindCoreAction("InGameMenuModalCancel")
end
function v20.didMount(p14) -- line: 240
	p14:updateBlur()

	if p14.props.visible then
		p14:bindActions()
	end
end
function v20.didUpdate(p15) -- line: 248
	p15:updateBlur()

	if p15.props.visible then
		p15:bindActions()

		return
	end

	p15:unbindActions()
end
function v20.willUnmount(p16) -- line: 258
	-- upvalues: RunService (copy)
	if p16.props.blurBackground then
		RunService:SetRobloxGuiFocused(false)
	end

	p16:unbindActions()
end

return v20
