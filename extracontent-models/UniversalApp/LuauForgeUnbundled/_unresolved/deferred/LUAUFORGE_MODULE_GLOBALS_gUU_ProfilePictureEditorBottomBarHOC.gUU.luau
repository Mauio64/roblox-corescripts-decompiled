local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)

local t = require(CorePackages.Packages.t)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Dash = require(CorePackages.Packages.Dash)

local focusable = RoactGamepad.Focusable

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization

local actionBar = UIBlox.App.Button.ActionBar
local buttonStack = UIBlox.App.Button.ButtonStack
local buttonType = UIBlox.App.Button.Enum.ButtonType

local extended = Roact.PureComponent:extend("ProfilePictureEditorBottomBar")

extended.validateProps = t.strictInterface({
	button1 = t.strictInterface({
		textKey = t.string,
		onActivated = t.callback,
		isDisabled = t.optional(t.boolean)
	}),
	button2 = t.strictInterface({
		textKey = t.string,
		onActivated = t.callback,
		isDisabled = t.optional(t.boolean)
	}),
	designTokens = t.table,
	localized = t.table,
	onAbsoluteSizeChanged = t.optional(t.callback),
	NextSelectionUp = t.table,
	baseRef = t.table
})

function extended:init()
	local designTokens = self.props.designTokens

	local binding, v5 = Roact.createBinding(UDim2.new(1, 0, 0, 100 + designTokens.Size.Size_100))
	self.bottomBarSize = binding
	self.updateBottomBarSize = v5

	function self.onAbsoluteSizeChanged(p2)
		self.updateBottomBarSize(UDim2.new(1, 0, 0, p2.Y + designTokens.Size.Size_100))

		if self.props.onAbsoluteSizeChanged then
			self.props.onAbsoluteSizeChanged(p2)
		end
	end
end

function extended.render(props)
	local button1 = props.props.button1
	local button2 = props.props.button2
	local designTokens = props.props.designTokens
	local localized = props.props.localized

	return Roact.createElement(focusable.Frame, {
		Size = props.bottomBarSize,
		Position = UDim2.fromScale(0, 1),
		AnchorPoint = Vector2.new(0, 1),
		ZIndex = 2,
		BorderSizePixel = 0,
		BackgroundColor3 = designTokens.Color.Surface.Surface_0.Color3,
		NextSelectionUp = props.props.NextSelectionUp,
		[Roact.Ref] = props.props.baseRef
	}, {
		GradientFrame = Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 0, 20),
				Position = UDim2.new(0, 0, 0, -20),
				BackgroundColor3 = designTokens.Color.Surface.Surface_0.Color3,
				BorderSizePixel = 0
			},
			{
				Gradient = Roact.createElement("UIGradient", {
					Rotation = -90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(1, 1)
					})
				})
			}
		),
		Padding = Roact.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, designTokens.Size.Size_100)
		}),
		ActionBar = Roact.createElement(
			actionBar,
			{ onAbsoluteSizeChanged = props.onAbsoluteSizeChanged },
			{
				ButtonStack = Roact.createElement(buttonStack, {
					buttons = {
						{
							props = {
								onActivated = button1.onActivated,
								text = localized.button1Text,
								isDisabled = button1.isDisabled
							}
						},
						{
							buttonType = buttonType.PrimarySystem,
							isDefaultChild = true,
							props = {
								onActivated = button2.onActivated,
								text = localized.button2Text,
								isDisabled = button2.isDisabled
							}
						}
					}
				})
			}
		)
	})
end

function LUAUFORGE_MODULE_GLOBALS_gUU_ProfilePictureEditorBottomBarHOC(p2)
	local v5 = useDesignTokens()
	local v6 = useLocalization({
		button1Text = p2.button1.textKey,
		button2Text = p2.button2.textKey
	})

	return Roact.createElement(extended, Dash.assign(p2, {
		designTokens = v5,
		localized = v6
	}))
end

return LUAUFORGE_MODULE_GLOBALS_gUU_ProfilePictureEditorBottomBarHOC
