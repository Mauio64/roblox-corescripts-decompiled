local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local ParentParent = script.Parent.Parent
local Assets = require(ParentParent.Resources.Assets)
local Divider = require(ParentParent.Components.PortedComponents.Divider)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local withStyle = UIBlox.Core.Style.withStyle
local IconButton = UIBlox.App.Button.IconButton
local HeaderBar = UIBlox.App.Bar.HeaderBar
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Images = UIBlox.App.ImageSet.Images
local makeBackButton = require(CorePackages.Workspace.Packages.AppHeaderBar).makeBackButton
local v16 = Roact.Component:extend("ModalDialog")

v16.validateProps = t.strictInterface({
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

function v16.init(p1) -- line: 44
	function p1.onOverlayActivated() -- line: 45
		-- upvalues: p1 (copy)
		p1.props.onDismiss()
	end
end
function v16.renderHeaderBarLeft(p2) -- line: 50
	-- upvalues: Roact (copy), IconButton (copy), IconSize (copy), Images (copy), makeBackButton (copy)
	local props = p2.props

	if props.showCloseButton then
		return function() -- line: 54
			-- upvalues: Roact (copy), IconButton (copy), IconSize (copy), Images (copy), props (copy)
			return Roact.createElement(IconButton, {
				iconSize = IconSize.Medium,
				icon = Images["icons/navigation/close"],
				onActivated = props.onDismiss
			})
		end
	end

	if props.onBackButtonActivated ~= nil then
		return makeBackButton(props.onBackButtonActivated)
	end

	return function() -- line: 66
		return nil
	end
end
function v16.renderHeaderBarRight(_) -- line: 72
	return function() -- line: 74
		return nil
	end
end
function v16.render(p4) -- line: 79
	-- upvalues: withStyle (copy), Roact (copy), ImageSetButton (copy), Assets (copy), HeaderBar (copy), Divider (copy)
	local props = p4.props
	local v23 = math.min(props.screenSize.Y, 645)

	if props.maxHeight then
		v23 = math.min(v23, props.maxHeight)
	end

	local v24 = math.min(props.screenSize.X, 540)

	if props.maxWidth then
		v24 = math.min(v24, props.maxWidth)
	end

	local vector2 = Vector2.new(v24, v23)
	local vector2_2, uDim2

	if props.screenSize.X < 540 then
		vector2_2 = Vector2.new(0.5, 1)
		uDim2 = UDim2.fromScale(0.5, 1)
	else
		vector2_2 = Vector2.new(0.5, 0.5)
		uDim2 = UDim2.fromScale(0.5, 0.5)
	end

	local u28 = math.min(600, vector2.Y - 49 - 60)

	if not props.actionButtons then
		u28 += 60
	end

	return withStyle(function(p5) -- line: 115
		-- upvalues: Roact (copy), props (copy), p4 (copy), ImageSetButton (copy), vector2_2 (ref), Assets (copy), uDim2 (ref), vector2 (copy), HeaderBar (copy), Divider (copy), u28 (ref)
		return Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Visible = props.visible
		}, {
			Overlay = Roact.createElement("TextButton", {
				AutoButtonColor = false,
				BackgroundColor3 = p5.Theme.Overlay.Color,
				BackgroundTransparency = p5.Theme.Overlay.Transparency,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
				Text = "",
				[Roact.Event.Activated] = p4.onOverlayActivated
			}),
			Dialog = Roact.createElement(ImageSetButton, {
				Active = true,
				BackgroundTransparency = 1,
				AnchorPoint = vector2_2,
				Image = Assets.Images.RoundedRect.Image,
				ImageColor3 = p5.Theme.BackgroundUIDefault.Color,
				ImageTransparency = p5.Theme.BackgroundUIDefault.Transparency,
				Position = uDim2,
				ScaleType = Assets.Images.RoundedRect.ScaleType,
				Size = UDim2.fromOffset(vector2.X, vector2.Y),
				SliceCenter = Assets.Images.RoundedRect.SliceCenter
			}, {
				Layout = Roact.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				HeaderBar = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, 48)
				}, {
					Bar = props.headerBar or (Roact.createElement(HeaderBar, {
						backgroundTransparency = 1,
						barHeight = 48,
						renderLeft = p4:renderHeaderBarLeft(),
						renderRight = p4:renderHeaderBarRight(),
						title = props.titleText
					}) or nil)
				}),
				Divider = Roact.createElement(Divider, {
					LayoutOrder = 2
				}),
				Content = Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 3,
					ZIndex = 10,
					Size = UDim2.new(1, 0, 0, u28)
				}, {
					Contents = props.contents
				}),
				ActionBar = props.actionButtons and Roact.createElement("Frame", {
					BackgroundTransparency = 1,
					LayoutOrder = 4,
					Size = UDim2.new(1, 0, 0, 60)
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 8),
						PaddingBottom = UDim.new(0, 2),
						PaddingLeft = UDim.new(0, 24),
						PaddingRight = UDim.new(0, 24)
					}),
					ActionButtons = props.actionButtons
				}) or nil
			})
		})
	end)
end
function v16.bindActions(p6) -- line: 189
	-- upvalues: ContextActionService (copy)
	local function dismissFunc(p7) -- line: 190
		-- upvalues: p6 (copy)
		if p7 == Enum.UserInputState.Begin then
			p6.props.onDismiss()
		end
	end

	ContextActionService:BindCoreAction("ModalDialogDismiss", dismissFunc, false, Enum.KeyCode.Escape)
end
function v16.unbindActions(_) -- line: 198
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindCoreAction("ModalDialogDismiss")
end
function v16.didMount(p9) -- line: 202
	if p9.props.visible then
		p9:bindActions()
	end
end
function v16.didUpdate(p10) -- line: 208
	if p10.props.visible then
		p10:bindActions()

		return
	end

	p10:unbindActions()
end
function v16.willUnmount(p11) -- line: 216
	p11:unbindActions()
end

return v16
