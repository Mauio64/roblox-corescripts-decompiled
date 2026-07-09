local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local UIBlox = require(CorePackages.Packages.UIBlox)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local t = require(CorePackages.Packages.t)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Dash = require(CorePackages.Packages.Dash)
local Focusable = RoactGamepad.Focusable
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local ActionBar = UIBlox.App.Button.ActionBar
local ButtonStack = UIBlox.App.Button.ButtonStack
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local v14 = Roact.PureComponent:extend("ProfilePictureEditorBottomBar")

v14.validateProps = t.strictInterface({
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

function v14.init(p1) -- line: 49
	-- upvalues: Roact (copy), FFlagRenameDeprecatedUIBloxTokens (copy)
	local designTokens = p1.props.designTokens
	local v17, v18 = Roact.createBinding(UDim2.new(1, 0, 0, 100 + if not FFlagRenameDeprecatedUIBloxTokens then designTokens.Global.Space_50 else designTokens.Size.Size_100))

	p1.bottomBarSize = v17
	p1.updateBottomBarSize = v18

	function p1.onAbsoluteSizeChanged(t1: {[any]: any}) -- line: 64
		-- upvalues: p1 (copy), FFlagRenameDeprecatedUIBloxTokens (copy), designTokens (copy)
		p1.updateBottomBarSize(UDim2.new(1, 0, 0, t1.Y + if not FFlagRenameDeprecatedUIBloxTokens then designTokens.Global.Space_50 else designTokens.Size.Size_100))

		if p1.props.onAbsoluteSizeChanged then
			p1.props.onAbsoluteSizeChanged(t1)
		end
	end
end
function v14.render(p2) -- line: 85
	-- upvalues: Roact (copy), Focusable (copy), FFlagRenameDeprecatedUIBloxTokens (copy), ActionBar (copy), ButtonStack (copy), ButtonType (copy)
	local button1 = p2.props.button1
	local button2 = p2.props.button2
	local designTokens = p2.props.designTokens
	local localized = p2.props.localized

	return Roact.createElement(Focusable.Frame, {
		Size = p2.bottomBarSize,
		Position = UDim2.fromScale(0, 1),
		AnchorPoint = Vector2.new(0, 1),
		ZIndex = 2,
		BorderSizePixel = 0,
		BackgroundColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then designTokens.Semantic.Color.Background.Default else designTokens.Color.Surface.Surface_0)).Color3,
		NextSelectionUp = p2.props.NextSelectionUp,
		[Roact.Ref] = p2.props.baseRef
	}, {
		GradientFrame = Roact.createElement("Frame", {
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 20),
			Position = UDim2.new(0, 0, 0, -20),
			BackgroundColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then designTokens.Semantic.Color.Background.Default else designTokens.Color.Surface.Surface_0)).Color3
		}, {
			Gradient = Roact.createElement("UIGradient", {
				Rotation = -90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0),
					NumberSequenceKeypoint.new(1, 1)
				})
			})
		}),
		Padding = Roact.createElement("UIPadding", {
			PaddingBottom = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then designTokens.Global.Space_50 else designTokens.Size.Size_100)
		}),
		ActionBar = Roact.createElement(ActionBar, {
			onAbsoluteSizeChanged = p2.onAbsoluteSizeChanged
		}, {
			ButtonStack = Roact.createElement(ButtonStack, {
				buttons = {
					{
						props = {
							onActivated = button1.onActivated,
							text = localized.button1Text,
							isDisabled = button1.isDisabled
						}
					},
					{
						isDefaultChild = true,
						buttonType = ButtonType.PrimarySystem,
						props = {
							onActivated = button2.onActivated,
							text = localized.button2Text,
							isDisabled = button2.isDisabled
						}
					}
				}
			})
		})
	})
end
function ProfilePictureEditorBottomBarHOC(p3) -- line: 155
	-- upvalues: useDesignTokens (copy), useLocalization (copy), Roact (copy), v14 (copy), Dash (copy)
	local v25 = useDesignTokens()
	local v26 = useLocalization({
		button1Text = p3.button1.textKey,
		button2Text = p3.button2.textKey
	})

	return Roact.createElement(v14, Dash.assign(p3, {
		designTokens = v25,
		localized = v26
	}))
end

return ProfilePictureEditorBottomBarHOC
