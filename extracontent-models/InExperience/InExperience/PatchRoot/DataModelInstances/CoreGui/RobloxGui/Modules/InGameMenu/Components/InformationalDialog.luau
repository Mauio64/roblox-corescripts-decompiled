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
local ParentParent = script.Parent.Parent
local Flags = ParentParent.Flags
local GetFFlagIGMGamepadSelectionHistory = require(Flags.GetFFlagIGMGamepadSelectionHistory)
local Constants = require(ParentParent.Resources.Constants)
local Assets = require(ParentParent.Resources.Assets)
local ThemedTextLabel = require(script.Parent.ThemedTextLabel)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local FocusHandler = require(script.Parent.Connection.FocusHandler)
local v22 = Roact.PureComponent:extend("InformationalDialog")

v22.validateProps = t.strictInterface({
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
v22.defaultProps = {
	subBodyText = nil,
	blurBackground = false,
	iconImage = nil,
	iconSize = 64
}

function v22.init(p1) -- line: 66
	-- upvalues: Roact (copy)
	p1.state = {
		isRooted = false,
		show = true
	}

	function p1.onAncestryChanged(p2) -- line: 72
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
function v22.render(p3) -- line: 83
	-- upvalues: withStyle (copy), TextService (copy), GetFFlagIGMGamepadSelectionHistory (copy), Roact (copy), CoreGui (copy), ImageSetLabel (copy), Assets (copy), ThemedTextLabel (copy), Button (copy), ButtonType (copy), RunService (copy), FocusHandler (copy), Constants (copy), GuiService (copy)
	local props = p3.props

	return withStyle(function(p4) -- line: 86
		-- upvalues: props (copy), TextService (copy), GetFFlagIGMGamepadSelectionHistory (copy), p3 (copy), Roact (copy), CoreGui (copy), ImageSetLabel (copy), Assets (copy), ThemedTextLabel (copy), Button (copy), ButtonType (copy), RunService (copy), FocusHandler (copy), Constants (copy), GuiService (copy)
		local BodyFont = p4.Font.Body.Font
		local v37 = p4.Font.Body.RelativeSize * p4.Font.BaseSize
		local bodyText = props.bodyText
		local Y = TextService:GetTextSize(bodyText, v37, BodyFont, Vector2.new(295, 1e999)).Y
		local Y2 = TextService:GetTextSize(props.subBodyText, v37, BodyFont, Vector2.new(295, 1e999)).Y
		local v41 = math.max(Y, v37 * 2) + 20
		local v42 = math.max(Y2, v37 * 2) + 20
		local v43 = nil

		if GetFFlagIGMGamepadSelectionHistory() then
			v43 = not p3.props.visible
		end

		return Roact.createElement(Roact.Portal, {
			target = CoreGui
		}, {
			InGameMenuInformationalDialog = Roact.createElement("ScreenGui", {
				DisplayOrder = 8,
				IgnoreGuiInset = true,
				OnTopOfCoreBlur = props.blurBackground,
				Enabled = props.visible and p3.state.show,
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
					Size = UDim2.new(0, 335, 0, v41 + 49 + v42 + 36 + 70 + props.iconSize),
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
						LayoutOrder = 1,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Position = UDim2.fromScale(0.5, 0.5),
						AnchorPoint = Vector2.new(0.5, 0.5),
						Image = props.iconImage,
						Size = UDim2.new(0, props.iconSize, 0, props.iconSize)
					}),
					Title = Roact.createElement(ThemedTextLabel, {
						fontKey = "Header1",
						themeKey = "TextEmphasis",
						LayoutOrder = 2,
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
					SpaceContainer = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 4,
						Size = UDim2.new(1, 0, 0, 10)
					}),
					BodyTextContainer = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 5,
						Size = UDim2.new(1, 0, 0, v41)
					}, {
						BodyText = Roact.createElement(ThemedTextLabel, {
							TextWrapped = true,
							Size = UDim2.new(1, 0, 1, 0),
							Text = props.bodyText
						})
					}),
					SubBodyTextContainer = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 6,
						Size = UDim2.new(1, 0, 0, v42)
					}, {
						BodyText = Roact.createElement(ThemedTextLabel, {
							TextWrapped = true,
							Size = UDim2.new(1, 0, 1, 0),
							Text = props.subBodyText
						})
					}),
					SpaceContainer2 = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 7,
						Size = UDim2.new(1, 0, 0, 10)
					}),
					ButtonContainer = Roact.createElement("Frame", {
						BackgroundTransparency = 1,
						LayoutOrder = 8,
						Size = UDim2.new(1, 0, 0, 36),
						[Roact.Ref] = p3.buttonContainerRef,
						[Roact.Event.AncestryChanged] = p3.onAncestryChanged
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
							onActivated = function() -- line: 237
								-- upvalues: p3 (copy), RunService (copy)
								p3:setState({
									show = false
								})

								if p3.props.onContinueFunc then
									p3.props.onContinueFunc()
								end

								RunService:SetRobloxGuiFocused(false)
							end,
							[Roact.Ref] = p3.confirmButtonRef
						})
					})
				})
			}),
			FocusHandler = Roact.createElement(FocusHandler, {
				isFocused = p3.state.isRooted and (p3.props.visible and p3.props.inputType == Constants.InputType.Gamepad),
				shouldForgetPreviousSelection = v43,
				didFocus = function() -- line: 256
					-- upvalues: GuiService (copy), p3 (copy)
					GuiService:RemoveSelectionGroup("InGameMenuModalButtonsSelectionParent")
					GuiService:AddSelectionParent("InGameMenuModalButtonsSelectionParent", p3.buttonContainerRef:getValue())
					GuiService.SelectedCoreObject = p3.confirmButtonRef:getValue()
				end
			})
		})
	end)
end
function v22.updateBlur(p5) -- line: 267
	-- upvalues: RunService (copy)
	local v27 = p5.props.blurBackground and p5.props.visible

	RunService:SetRobloxGuiFocused(v27)
end
function v22.bindActions(p6) -- line: 272
	-- upvalues: ContextActionService (copy)
	local function confirmFunc(_, p8, _) -- line: 273
		-- upvalues: p6 (copy)
		if p8 == Enum.UserInputState.Begin then
			p6.props.onConfirm()
		end
	end

	if p6.props.bindReturnToConfirm then
		ContextActionService:BindCoreAction("InGameMenuModalConfirm", confirmFunc, false, Enum.KeyCode.Return)
	end
end
function v22.unbindActions(_) -- line: 284
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindCoreAction("InGameMenuModalConfirm")
end
function v22.didMount(p11) -- line: 288
	p11:updateBlur()

	if p11.props.visible then
		p11:bindActions()
	end
end
function v22.didUpdate(p12) -- line: 296
	p12:updateBlur()

	if p12.props.visible then
		p12:bindActions()

		return
	end

	p12:unbindActions()
end
function v22.willUnmount(p13) -- line: 306
	-- upvalues: RunService (copy)
	if p13.props.blurBackground then
		RunService:SetRobloxGuiFocused(false)
	end

	p13:unbindActions()
end

return v22
