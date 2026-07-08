local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local ParentParentParentParent = ParentParentParent.Parent
local Roact = require(ParentParentParentParent.Roact)
local t = require(ParentParentParentParent.t)
local FitFrame = require(ParentParentParentParent.FitFrame)
local Foundation = require(ParentParentParentParent.Foundation)
local FitFrameVertical = FitFrame.FitFrameVertical
local Label = require(ParentParentParent.Core.ImageSet.ImageSetComponent).Label
local GenericTextLabel = require(ParentParentParent.Core.Text.GenericTextLabel.GenericTextLabel)
local withStyle = require(ParentParentParent.Core.Style.withStyle)
local ButtonType = require(ParentParentParent.App.Button.Enum.ButtonType)
local getIconSize = require(ParentParent.ImageSet.getIconSize)
local IconSize = require(ParentParent.ImageSet.Enum.IconSize)
local Checkbox = Foundation.Checkbox
local PartialPageModal = require(scriptParent.PartialPageModal)
local v18 = Roact.PureComponent:extend("EducationalModal")

v18.validateProps = t.strictInterface({
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

local function ContentItem(p1) -- line: 69
	-- upvalues: Roact (copy), Label (copy), getIconSize (copy), IconSize (copy), GenericTextLabel (copy)
	local vector2 = Vector2.new(16, 16)
	local v22 = p1.isSystemMenuIcon or false
	local v23 = v22 or p1.icon
	local stylePalette = p1.stylePalette
	local Theme = stylePalette.Theme
	local stylePaletteFont = stylePalette.Font
	local v27 = stylePaletteFont.Body.RelativeSize * stylePaletteFont.BaseSize

	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = v23 and UDim2.new(0, 253, 0, vector2.Y) or UDim2.new(1, 0, 0, vector2.Y),
		AutomaticSize = v23 and Enum.AutomaticSize.None or Enum.AutomaticSize.Y,
		LayoutOrder = p1.layoutOrder
	}, {
		HorizontalLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = v22 and UDim.new(0, 10) or UDim.new(0, 8),
			VerticalAlignment = Enum.VerticalAlignment.Center
		}),
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = v22 and UDim.new(0, 2) or UDim.new(0, 0)
		}),
		Icon = v22 and Roact.createElement(Label, {
			BackgroundTransparency = 1,
			Image = "rbxasset://textures/ui/TopBar/iconBase.png",
			LayoutOrder = 1,
			Size = UDim2.fromOffset(32, 32)
		}, {
			Icon = Roact.createElement(Label, {
				ZIndex = 1,
				BackgroundTransparency = 1,
				Image = "rbxasset://textures/ui/TopBar/coloredlogo.png",
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.fromOffset(24, 24)
			})
		}) or (v23 and Roact.createElement(Label, {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Image = p1.icon,
			Size = UDim2.fromOffset(getIconSize(IconSize.Medium), getIconSize(IconSize.Medium)),
			ImageColor3 = Theme.IconDefault.Color,
			ImageTransparency = Theme.IconDefault.Transparency
		}) or nil),
		Text = p1.text and Roact.createElement(GenericTextLabel, {
			BackgroundTransparency = 1,
			TextWrapped = true,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, vector2.Y),
			AutomaticSize = v23 and Enum.AutomaticSize.None or Enum.AutomaticSize.Y,
			Text = p1.text,
			TextSize = v27,
			colorStyle = Theme.TextDefault,
			TextTransparency = Theme.TextDefault.Transparency,
			fontStyle = stylePaletteFont.Body,
			TextXAlignment = v23 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center
		})
	})
end

function v18.init(p2) -- line: 134
	-- upvalues: Roact (copy)
	p2.state = {
		shouldNotShowAgain = false
	}

	local v29, v30 = Roact.createBinding(Vector2.new(0, 0))

	p2.contentSize = v29
	p2.changeContentSize = v30

	function p2.toggleDoNotShow() -- line: 140
		-- upvalues: p2 (copy)
		p2:setState(function(p3) -- line: 141
			return {
				shouldNotShowAgain = not p3.shouldNotShowAgain
			}
		end)
	end
	function p2.onDismiss() -- line: 148
		-- upvalues: p2 (copy)
		p2.props.onDismiss(p2.state.shouldNotShowAgain)
	end
	function p2.onCancel() -- line: 151
		-- upvalues: p2 (copy)
		p2.props.onCancel(p2.state.shouldNotShowAgain)
	end
	function p2.onConfirm() -- line: 154
		-- upvalues: p2 (copy)
		p2.props.onConfirm(p2.state.shouldNotShowAgain)
	end
end
function v18.render(p4) -- line: 159
	-- upvalues: withStyle (copy), Roact (copy), ContentItem (copy), Checkbox (copy), PartialPageModal (copy), ButtonType (copy), FitFrameVertical (copy)
	local props = p4.props
	local hasDoNotShow = props.hasDoNotShow

	return withStyle(function(p5) -- line: 163
		-- upvalues: props (copy), Roact (copy), ContentItem (copy), hasDoNotShow (copy), Checkbox (copy), p4 (copy), PartialPageModal (copy), ButtonType (copy), FitFrameVertical (copy)
		local n1 = 0
		local t1 = {}

		for i, v in ipairs(props.bodyContents) do
			table.insert(t1, (Roact.createElement(ContentItem, {
				key = tostring(i),
				icon = v.icon,
				text = v.text,
				layoutOrder = i,
				isSystemMenuIcon = v.isSystemMenuIcon,
				stylePalette = p5
			})))
			n1 += 1
		end

		local Theme = p5.Theme

		if hasDoNotShow then
			table.insert(t1, (Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 50),
				LayoutOrder = n1 + 1
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
					BorderSizePixel = 0,
					BackgroundColor3 = Theme.Divider.Color,
					BackgroundTransparency = Theme.Divider.Transparency,
					Size = UDim2.new(1, 0, 0, 1)
				}),
				DoNotShowCheckbox = Roact.createElement(Checkbox, {
					LayoutOrder = 2,
					label = props.doNotShowText,
					onActivated = p4.toggleDoNotShow,
					isChecked = p4.state.shouldNotShowAgain
				})
			})))
		end

		return Roact.createElement(PartialPageModal, {
			bottomPadding = 50,
			title = props.titleText,
			titleBackgroundImageProps = props.titleBackgroundImageProps,
			screenSize = props.screenSize,
			buttonStackProps = {
				buttons = {
					{
						props = {
							isDisabled = false,
							onActivated = if not hasDoNotShow then props.onCancel else p4.onCancel,
							text = props.cancelText
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
						props = {
							isDisabled = false,
							onActivated = if not hasDoNotShow then props.onConfirm else p4.onConfirm,
							text = props.confirmText
						}
					}
				}
			},
			onCloseClicked = if not hasDoNotShow then props.onDismiss else p4.onDismiss
		}, {
			BodyContents = Roact.createElement(FitFrameVertical, {
				BackgroundTransparency = 1,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				width = UDim.new(1, 0),
				contentPadding = UDim.new(0, 28),
				margin = {
					top = 36,
					bottom = 36
				},
				[Roact.Change.AbsoluteSize] = function(p6) -- line: 245
					-- upvalues: p4 (copy)
					p4.changeContentSize(p6.AbsoluteSize)
				end
			}, t1)
		})
	end)
end

return v18
