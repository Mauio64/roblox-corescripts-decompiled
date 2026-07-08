local TextService = game:GetService("TextService")
local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local UIBlox = InGameMenuDependencies.UIBlox
local t = InGameMenuDependencies.t
local Button = UIBlox.App.Button.Button
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local withStyle = UIBlox.Core.Style.withStyle
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
	-- upvalues: withStyle (copy), TextService (copy), Roact (copy), ImageSetLabel (copy), Assets (copy), ThemedTextLabel (copy), Divider (copy), Button (copy), ButtonType (copy)
	local props = p1.props

	return withStyle(function(p2) -- line: 44
		-- upvalues: props (copy), TextService (copy), Roact (copy), ImageSetLabel (copy), Assets (copy), p1 (copy), ThemedTextLabel (copy), Divider (copy), Button (copy), ButtonType (copy)
		local BodyFont = p2.Font.Body.Font
		local v27 = p2.Font.Body.RelativeSize * p2.Font.BaseSize
		local bodyText = props.bodyText
		local v29 = math.max(TextService:GetTextSize(bodyText, v27, BodyFont, Vector2.new(264, 1e999)).Y, v27 * 2) + 48

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
				BackgroundColor3 = p2.Theme.Overlay.Color,
				BackgroundTransparency = p2.Theme.Overlay.Transparency,
				Size = UDim2.new(1, 0, 1, 0)
			}),
			DialogMainFrame = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = Assets.Images.RoundedRect.Image,
				ImageColor3 = p2.Theme.BackgroundUIDefault.Color,
				ImageTransparency = p2.Theme.BackgroundUIDefault.Transparency,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				ScaleType = Assets.Images.RoundedRect.ScaleType,
				Size = UDim2.new(0, 312, 0, v29 + 49 + 36 + 36 + 24 + 10),
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
					Size = UDim2.new(1, 0, 0, v29)
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
function v16.bindActions(p3) -- line: 139
	-- upvalues: ContextActionService (copy)
	local function dismissFunc(_, p5, _) -- line: 140
		-- upvalues: p3 (copy)
		if p5 == Enum.UserInputState.Begin then
			p3.props.onDismiss()
		end
	end

	ContextActionService:BindCoreAction("InGameMenuModalDismiss", dismissFunc, false, Enum.KeyCode.Escape)
end
function v16.unbindActions(_) -- line: 149
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindCoreAction("InGameMenuModalDismiss")
end
function v16.didMount(p8) -- line: 153
	if p8.props.visible then
		p8:bindActions()
	end
end
function v16.didUpdate(p9) -- line: 159
	if p9.props.visible then
		p9:bindActions()

		return
	end

	p9:unbindActions()
end
function v16.willUnmount(p10) -- line: 167
	p10:unbindActions()
end

return v16
