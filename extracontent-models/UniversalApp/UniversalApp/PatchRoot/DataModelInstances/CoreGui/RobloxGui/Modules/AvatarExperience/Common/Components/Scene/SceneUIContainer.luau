local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local Focusable = require(CorePackages.Packages.RoactGamepad).Focusable
local FullViewIndicator = require(Modules.AvatarExperience.Common.Components.Scene.FullViewIndicator)
local RobuxBalance = require(Modules.AvatarExperience.Catalog.Components.RobuxBalance)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local useShouldRenderQuickMenuButton = require(Modules.AvatarExperience.Common.Hooks.useShouldRenderQuickMenuButton)
local GetFFlagAXFixRobuxBalanceButtonPositionSecond = require(Modules.AvatarExperience.Flags.GetFFlagAXFixRobuxBalanceButtonPositionSecond)
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useDeviceOrientation = require(CorePackages.Workspace.Packages.RobloxAppHooks).useDeviceOrientation
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local FFlagAXMoveRobuxBalanceButtonLower = require(Modules.AvatarExperience.Flags.FFlagAXMoveRobuxBalanceButtonLower)
local QuickMenuButton = require(script.Parent.QuickMenuButton)
local v17 = Roact.PureComponent:extend("SceneUIContainer")

v17.defaultProps = {
	isVisible = true
}

function v17.init(p1) -- line: 44
	-- upvalues: Roact (copy)
	p1.robuxBalanceRef = Roact.createRef()
	p1.quickMenuRef = Roact.createRef()
end
function v17.renderRobloxBalanceContainer(p2) -- line: 49
	-- upvalues: Roact (copy), RobuxBalance (copy)
	return Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.XY,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(0, 0, 0, 0)
	}, {
		RobuxBalance = Roact.createElement(RobuxBalance, {
			[Roact.Ref] = p2.robuxBalanceRef,
			NextSelectionLeft = p2.quickMenuRef
		})
	})
end
function v17.getRow1Children(p3) -- line: 64
	-- upvalues: Roact (copy), QuickMenuButton (copy), FFlagAXMoveRobuxBalanceButtonLower (copy)
	local showRobuxBalance = p3.props.showRobuxBalance

	return {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			HorizontalAlignment = Enum.HorizontalAlignment.Right,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 5)
		}),
		QuickMenuButton = if not p3.props.showQuickMenuButton then nil else Roact.createElement(QuickMenuButton, {
			[Roact.Ref] = p3.quickMenuRef,
			NextSelectionRight = p3.robuxBalanceRef
		}),
		RobuxBalanceContainer = if not FFlagAXMoveRobuxBalanceButtonLower then showRobuxBalance and p3:renderRobloxBalanceContainer() else nil
	}
end
function v17.render(p4) -- line: 87
	-- upvalues: DeviceOrientationMode (copy), GetFFlagAXFixRobuxBalanceButtonPositionSecond (copy), FFlagRenameDeprecatedUIBloxTokens (copy), Roact (copy), Focusable (copy), FullViewIndicator (copy)
	local isVisible = p4.props.isVisible
	local forwardRef = p4.props.forwardRef
	local n1 = 4

	if p4.props.deviceOrientation == DeviceOrientationMode.Landscape then
		local designTokens = p4.props.designTokens

		n1 = if not GetFFlagAXFixRobuxBalanceButtonPositionSecond() then ((p4.props.globalGuiInset or {}).top or 0) + if not FFlagRenameDeprecatedUIBloxTokens then designTokens.Global.Size_150 else designTokens.Size.Size_300 else p4.props.statusBarHeight + if not FFlagRenameDeprecatedUIBloxTokens then designTokens.Global.Size_150 else designTokens.Size.Size_300
	end

	return Roact.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 72),
		Position = UDim2.new(0, -12, 0, n1),
		Visible = isVisible,
		[Roact.Ref] = forwardRef,
		restorePreviousChildFocus = true,
		defaultChild = p4.quickMenuRef
	}, {
		Row1 = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 36),
			Visible = p4.props.row1ChildrenVisible
		}, p4:getRow1Children()),
		FullViewIndicator = Roact.createElement(FullViewIndicator, {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, 0, 0, 40)
		})
	})
end

return Roact.forwardRef(function(p5, p6) -- line: 138
	-- upvalues: useShouldRenderQuickMenuButton (copy), useDesignTokens (copy), useDeviceOrientation (copy), Roact (copy), v17 (copy), Cryo (copy)
	local v29 = useShouldRenderQuickMenuButton()
	local v30 = useDesignTokens()
	local v31 = useDeviceOrientation()

	return Roact.createElement(v17, Cryo.Dictionary.join(p5, {
		forwardRef = p6,
		showQuickMenuButton = v29,
		designTokens = v30,
		deviceOrientation = v31
	}))
end)
