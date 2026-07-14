local TextService = game:GetService("TextService")
local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local withFoundationOrUIBloxStyle = require(CorePackages.Workspace.Packages.CoreGuiCommon).withFoundationOrUIBloxStyle
local ParentParent = script.Parent.Parent
local Assets = require(ParentParent.Resources.Assets)
local ThemedTextLabel = require(script.Parent.ThemedTextLabel)
local Divider = require(script.Parent.Divider)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local v16 = Roact.PureComponent:extend("InfoDialog")

v16.validateProps = t.strictInterface({
	bodyText = t.string,
	dismissText = t.string,
	titleText = t.string,
	iconImage = t.union(t.string, t.table),
	onDismiss = t.callback,
	visible = t.boolean,
	buttonRef = t.optional(t.table)
})

function v16.render(p1) -- line: 41
	-- upvalues: withFoundationOrUIBloxStyle (copy), TextService (copy), Roact (copy), ImageSetLabel (copy), Assets (copy), ThemedTextLabel (copy), Divider (copy), Button (copy), ButtonType (copy)
	local props = p1.props

	return withFoundationOrUIBloxStyle(function(p2) -- line: 44
		return {
			Theme = {
				Overlay = {
					Color = p2.Color.Common.Scrim.Color3,
					Transparency = p2.Color.Common.Scrim.Transparency
				},
				BackgroundUIDefault = {
					Color = p2.Color.Surface.Surface_300.Color3,
					Transparency = p2.Color.Surface.Surface_300.Transparency
				}
			},
			Font = {
				BaseSize = 1,
				Body = {
					Font = p2.Typography.BodyLarge.Font,
					RelativeSize = p2.Typography.BodyLarge.FontSize
				}
			}
		}
	end, function(p3) -- line: 55
		-- upvalues: props (copy), TextService (copy), Roact (copy), ImageSetLabel (copy), Assets (copy), p1 (copy), ThemedTextLabel (copy), Divider (copy), Button (copy), ButtonType (copy)
		local BodyFont = p3.Font.Body.Font
		local v28 = p3.Font.Body.RelativeSize * p3.Font.BaseSize
		local bodyText = props.bodyText
		local v30 = math.max(TextService:GetTextSize(bodyText, v28, BodyFont, Vector2.new(264, 1e999)).Y, v28 * 2) + 48

		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 8,
			Size = UDim2.new(1, 0, 1, 0),
			Visible = props.visible
		}, {
			Overlay = Roact.createElement("TextButton", {
				AutoButtonColor = false,
				BorderSizePixel = 0,
				Text = "",
				BackgroundColor3 = p3.Theme.Overlay.Color,
				BackgroundTransparency = p3.Theme.Overlay.Transparency,
				Size = UDim2.new(1, 0, 1, 0)
			}),
			DialogMainFrame = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = Assets.Images.RoundedRect.Image,
				ImageColor3 = p3.Theme.BackgroundUIDefault.Color,
				ImageTransparency = p3.Theme.BackgroundUIDefault.Transparency,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				ScaleType = Assets.Images.RoundedRect.ScaleType,
				Size = UDim2.new(0, 312, 0, v30 + 49 + 36 + 36 + 24 + 10),
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
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(0, 36, 0, 36),
					Image = p1.props.iconImage
				}),
				Title = Roact.createElement(ThemedTextLabel, {
					fontKey = "Header1",
					themeKey = "TextEmphasis",
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, 48),
					Text = props.titleText
				}),
				Divider = Roact.createElement(Divider, {
					LayoutOrder = 3
				}),
				BodyTextContainer = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 4,
					Size = UDim2.new(1, 0, 0, v30)
				}, {
					BodyText = Roact.createElement(ThemedTextLabel, {
						TextWrapped = true,
						Size = UDim2.new(1, 0, 1, 0),
						Text = props.bodyText
					})
				}),
				ConfirmButton = Roact.createElement(Button, {
					buttonType = ButtonType.PrimarySystem,
					layoutOrder = 5,
					size = UDim2.new(1, 0, 0, 36),
					onActivated = props.onDismiss,
					text = props.dismissText,
					[Roact.Ref] = p1.props.buttonRef
				})
			})
		})
	end)
end
function v16.bindActions(p4) -- line: 150
	-- upvalues: ContextActionService (copy)
	local function dismissFunc(_, p6, _) -- line: 151
		-- upvalues: p4 (copy)
		if p6 == Enum.UserInputState.Begin then
			p4.props.onDismiss()
		end
	end

	ContextActionService:BindCoreAction("InGameMenuModalDismiss", dismissFunc, false, Enum.KeyCode.Escape)
end
function v16.unbindActions(_) -- line: 160
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindCoreAction("InGameMenuModalDismiss")
end
function v16.didMount(p9) -- line: 164
	if p9.props.visible then
		p9:bindActions()
	end
end
function v16.didUpdate(p10) -- line: 170
	if p10.props.visible then
		p10:bindActions()

		return
	end

	p10:unbindActions()
end
function v16.willUnmount(p11) -- line: 178
	p11:unbindActions()
end

return v16
