local CorePackages = game:GetService("CorePackages")
local ContextActionService = game:GetService("ContextActionService")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local t = require(CorePackages.Packages.t)
local ParentParent = script.Parent.Parent
local VirtualKeyboardMonitor = require(ParentParent.Components.VirtualKeyboardMonitor)
local Assets = require(ParentParent.Resources.Assets)
local Dependencies = require(ParentParent.Dependencies)
local Divider = require(Dependencies.Divider)
local ImageSetButton = UIBlox.Core.ImageSet.ImageSetButton
local withStyle = UIBlox.Core.Style.withStyle
local IconButton = UIBlox.App.Button.IconButton
local HeaderBar = UIBlox.App.Bar.HeaderBar
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Images = UIBlox.App.ImageSet.Images
local makeBackButton = require(CorePackages.Workspace.Packages.AppHeaderBar).makeBackButton
local v18 = Roact.Component:extend("ModalDialog")

v18.validateProps = t.strictInterface({
	visible = t.boolean,
	screenSize = t.Vector2,
	titleText = t.optional(t.string),
	showCloseButton = t.optional(t.boolean),
	headerBar = t.optional(t.table),
	contents = t.optional(t.table),
	actionButtons = t.optional(t.table),
	onDismiss = t.optional(t.callback),
	onBackButtonActivated = t.optional(t.callback)
})

function v18.init(p1) -- line: 44
	-- upvalues: VirtualKeyboardMonitor (copy)
	p1.virtualKeyboardMonitor = VirtualKeyboardMonitor.getInstance()

	function p1.onOverlayActivated() -- line: 46
		-- upvalues: p1 (copy)
		if p1.virtualKeyboardMonitor:isKeyboardJustOff() then
			return
		end

		p1.props.onDismiss()
	end
end
function v18.renderHeaderBarLeft(p2) -- line: 55
	-- upvalues: Roact (copy), IconButton (copy), IconSize (copy), Images (copy), makeBackButton (copy)
	local props = p2.props

	if props.showCloseButton then
		return function() -- line: 59
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

	return function() -- line: 71
		return nil
	end
end
function v18.renderHeaderBarRight(_) -- line: 77
	return function() -- line: 79
		return nil
	end
end
function v18.render(p4) -- line: 84
	-- upvalues: withStyle (copy), Roact (copy), ImageSetButton (copy), Assets (copy), HeaderBar (copy), Divider (copy)
	local props = p4.props
	local vector2 = Vector2.new(math.min(props.screenSize.X, 540), (math.min(props.screenSize.Y, 375)))
	local vector2_2, uDim2

	if props.screenSize.X < 540 then
		vector2_2 = Vector2.new(0.5, 1)
		uDim2 = UDim2.fromScale(0.5, 1)
	else
		vector2_2 = Vector2.new(0.5, 0.5)
		uDim2 = UDim2.fromScale(0.5, 0.5)
	end

	local u28 = math.min(230, vector2.Y - 49 - 96)

	if not props.actionButtons then
		u28 += 96
	end

	return withStyle(function(p5) -- line: 106
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
				ZIndex = -10,
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
					Size = UDim2.new(1, 0, 0, 96)
				}, {
					Padding = Roact.createElement("UIPadding", {
						PaddingTop = UDim.new(0, 24),
						PaddingBottom = UDim.new(0, 24),
						PaddingLeft = UDim.new(0, 24),
						PaddingRight = UDim.new(0, 24)
					}),
					ActionButtons = props.actionButtons
				}) or nil
			})
		})
	end)
end
function v18.bindActions(p6) -- line: 181
	-- upvalues: ContextActionService (copy)
	local function dismissFunc(_, p8, _) -- line: 182
		-- upvalues: p6 (copy)
		if p8 == Enum.UserInputState.Begin then
			p6.props.onDismiss()
		end
	end

	ContextActionService:BindCoreAction("ModalDialogDismiss", dismissFunc, false, Enum.KeyCode.Escape)
end
function v18.unbindActions(_) -- line: 190
	-- upvalues: ContextActionService (copy)
	ContextActionService:UnbindCoreAction("ModalDialogDismiss")
end
function v18.didMount(p11) -- line: 194
	if p11.props.visible then
		p11:bindActions()
	end
end
function v18.didUpdate(p12) -- line: 200
	if p12.props.visible then
		p12:bindActions()

		return
	end

	p12:unbindActions()
end
function v18.willUnmount(p13) -- line: 208
	p13:unbindActions()
end

return v18
