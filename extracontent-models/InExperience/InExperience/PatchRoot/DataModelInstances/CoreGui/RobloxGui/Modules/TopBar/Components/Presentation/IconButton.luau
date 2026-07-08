local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")

game:GetService("GuiService")

local Signals = require(CorePackages.Packages.Signals)
local Display = require(CorePackages.Workspace.Packages.Display)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableConsoleExpControls = SharedFlags.FFlagEnableConsoleExpControls
local FFlagAddUILessMode = SharedFlags.FFlagAddUILessMode
local FIntAddUILessModeVariant = SharedFlags.FIntAddUILessModeVariant
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local t = require(CorePackages.Packages.t)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Cryo = require(CorePackages.Packages.Cryo)
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local withStyle = UIBlox.Core.Style.withStyle
local Interactable = UIBlox.Core.Control.Interactable
local ControlState = UIBlox.Core.Control.Enum.ControlState
local Images = UIBlox.App.ImageSet.Images
local withSelectionCursorProvider = UIBlox.App.SelectionImage.withSelectionCursorProvider
local _ = UIBlox.App.SelectionImage.CursorKind
local ReactOtter = require(CorePackages.Packages.ReactOtter)
local Foundation = require(CorePackages.Packages.Foundation)
local withCursor = Foundation.Hooks.withCursor
local SkinToneCircle = Foundation.Enums.CursorType.SkinToneCircle
local _ = script.Parent.Parent.Parent
local FlashingDot = require(script.Parent.FlashingDot)
local FlashingDotV2 = require(script.Parent.FlashingDotV2)
local GetFFlagFlashingDotUseAsyncInit = require(CoreGui.RobloxGui.Modules.Flags.GetFFlagFlashingDotUseAsyncInit)
local v29 = require(CorePackages.Workspace.Packages.Chrome).Enabled()
local isNewTiltIconEnabled = require(CoreGui.RobloxGui.Modules.isNewTiltIconEnabled)
local Constants = require(script.Parent.Parent.Parent.Constants)
local v32 = Roact.PureComponent:extend("IconButton")
local v33 = Images["component_assets/circle_17"]

v32.validateProps = t.strictInterface({
	icon = t.union(t.string, t.table),
	iconSize = t.union(t.number, t.UDim2, t.table),
	enableFlashingDot = t.optional(t.boolean),
	useIconScaleAnimation = t.optional(t.boolean),
	onActivated = t.callback,
	onHover = t.optional(t.callback),
	onHoverEnd = t.optional(t.callback),
	backgroundTransparency = t.optional(t.number),
	backgroundColor3 = t.optional(t.Color3),
	backgroundCornerRadius = t.optional(t.UDim),
	forwardRef = t.optional(t.any),
	onSelectionChanged = if not v29 or not FFlagEnableConsoleExpControls then nil else t.optional(t.callback),
	nextSelectionRightRef = if not v29 or not FFlagEnableConsoleExpControls then nil else t.optional(t.any),
	modal = if not FFlagAddUILessMode or FIntAddUILessModeVariant ~= 2 then nil else t.optional(t.boolean),
	[Roact.Change.AbsoluteSize] = t.optional(t.callback),
	[Roact.Change.AbsolutePosition] = t.optional(t.callback)
})

function AnimatedScaleIcon(p1) -- line: 65
	-- upvalues: ReactOtter (copy), React (copy), Roact (copy), ImageSetLabel (copy)
	local v35, v36 = ReactOtter.useAnimatedBinding(p1.iconSize)

	React.useEffect(function() -- line: 68
		-- upvalues: v36 (copy), ReactOtter (copy), p1 (copy)
		v36(ReactOtter.spring(p1.iconSize, {
			dampingRatio = 1,
			frequency = 2.857142857142857
		}))

		return function() -- line: 73
		end
	end, { p1.iconSize })

	return Roact.createElement(ImageSetLabel, {
		BackgroundTransparency = 1,
		ZIndex = 1,
		Size = v35:map(function(p2) -- line: 77
			return UDim2.fromOffset(p2, p2)
		end),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Image = p1.icon,
		ImageColor3 = p1.style.Theme.IconEmphasis.Color,
		ImageTransparency = p1.style.Theme.IconEmphasis.Transparency
	})
end
function v32.init(p3) -- line: 90
	-- upvalues: ControlState (copy), Signals (copy), Display (copy)
	p3:setState({
		controlState = ControlState.Default
	})

	function p3.controlStateUpdated(p4, p5) -- line: 95
		-- upvalues: p3 (copy), ControlState (copy)
		if p3.props.onHover and p5 == ControlState.Hover then
			p3.props.onHover()
		elseif p3.props.onHoverEnd and p4 == ControlState.Hover and p5 ~= ControlState.Hover then
			p3.props.onHoverEnd()
		end

		p3:setState({
			controlState = p5
		})
	end

	p3.disposeUiScaleEffect = Signals.createEffect(function(p6) -- line: 109
		-- upvalues: Display (copy), p3 (copy)
		local v50 = Display.GetDisplayStore(p6)

		p3:setState({
			UiScale = v50.getUIScale(p6)
		})
	end)
end
function v32.render(p7) -- line: 117
	-- upvalues: v29 (copy), withCursor (copy), withSelectionCursorProvider (copy)
	if v29 then
		return withCursor(function(p8) -- line: 119
			-- upvalues: p7 (copy)
			return p7:renderWithCursor(p8)
		end)
	end

	return withSelectionCursorProvider(function(p9) -- line: 123
		-- upvalues: p7 (copy)
		return p7:renderWithCursor(p9)
	end)
end
function v32.renderWithCursor(p10, p11) -- line: 129
	-- upvalues: isNewTiltIconEnabled (copy), Constants (copy), withStyle (copy), ControlState (copy), Roact (copy), Interactable (copy), FFlagAddUILessMode (copy), FIntAddUILessModeVariant (copy), SkinToneCircle (copy), v29 (copy), FFlagEnableConsoleExpControls (copy), ImageSetLabel (copy), GetFFlagFlashingDotUseAsyncInit (copy), FlashingDotV2 (copy), FlashingDot (copy), v33 (copy)
	local v41 = not isNewTiltIconEnabled() and p10.props.backgroundColor3
	local v42 = Constants.TopBarButtonHeight * p10.state.UiScale

	return withStyle(function(p12) -- line: 132
		-- upvalues: p10 (copy), ControlState (copy), Roact (copy), Interactable (copy), FFlagAddUILessMode (copy), FIntAddUILessModeVariant (copy), isNewTiltIconEnabled (copy), v42 (copy), p11 (copy), SkinToneCircle (copy), v29 (copy), FFlagEnableConsoleExpControls (copy), v41 (copy), ImageSetLabel (copy), GetFFlagFlashingDotUseAsyncInit (copy), FlashingDotV2 (copy), FlashingDot (copy), v33 (copy)
		local t1 = {
			Transparency = 1,
			Color = Color3.new(1, 1, 1)
		}

		if p10.state.controlState == ControlState.Pressed then
			t1 = p12.Theme.BackgroundOnPress
		elseif p10.state.controlState == ControlState.Hover then
			t1 = p12.Theme.BackgroundOnHover
		end

		return Roact.createElement(Interactable, {
			onStateChanged = p10.controlStateUpdated,
			ZIndex = 1,
			Modal = if not FFlagAddUILessMode or FIntAddUILessModeVariant ~= 2 then nil else p10.props.modal,
			BackgroundTransparency = not isNewTiltIconEnabled() and 1 or p12.Theme.BackgroundUIContrast.Transparency * p12.Settings.PreferredTransparency,
			Position = UDim2.fromScale(0, not isNewTiltIconEnabled() and 1 or 0.5),
			AnchorPoint = Vector2.new(0, not isNewTiltIconEnabled() and 1 or 0.5),
			Size = UDim2.fromOffset(v42, v42),
			Image = if isNewTiltIconEnabled() then nil else "rbxasset://textures/ui/TopBar/iconBase.png",
			BackgroundColor3 = p12.Theme.BackgroundUIContrast.Color,
			SelectionImageObject = if not isNewTiltIconEnabled() then nil else p11.getCursor(SkinToneCircle),
			NextSelectionRight = if not v29 or not FFlagEnableConsoleExpControls then nil else p10.props.nextSelectionRightRef,
			[Roact.Event.Activated] = p10.props.onActivated,
			[Roact.Event.SelectionChanged] = if not v29 or not FFlagEnableConsoleExpControls then nil else p10.props.onSelectionChanged,
			[Roact.Ref] = p10.props.forwardRef
		}, {
			UICorner = isNewTiltIconEnabled() and Roact.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			}) or nil,
			BackgroundFrame = if not v41 then nil else Roact.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 0,
				Size = p10.props.iconSize,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = p10.props.backgroundTransparency,
				BackgroundColor3 = p10.props.backgroundColor3
			}, {
				UICorner = if not p10.props.backgroundCornerRadius then nil else Roact.createElement("UICorner", {
					CornerRadius = p10.props.backgroundCornerRadius
				})
			}),
			Icon = not p10.props.useIconScaleAnimation and Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				ZIndex = 1,
				Size = if typeof(p10.props.iconSize) == "number" then UDim2.fromOffset(p10.props.iconSize, p10.props.iconSize) else p10.props.iconSize,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Image = p10.props.icon,
				ImageColor3 = p12.Theme.IconEmphasis.Color,
				ImageTransparency = p12.Theme.IconEmphasis.Transparency
			}),
			ScalingIcon = p10.props.useIconScaleAnimation and Roact.createElement(AnimatedScaleIcon, {
				icon = p10.props.icon,
				iconSize = p10.props.iconSize,
				style = p12
			}),
			FlashingDot = if not p10.props.enableFlashingDot then nil else Roact.createElement(if not GetFFlagFlashingDotUseAsyncInit() then FlashingDot else FlashingDotV2),
			StateOverlayRound = isNewTiltIconEnabled() and Roact.createElement("Frame", {
				ZIndex = 2,
				BackgroundTransparency = t1.Transparency,
				BackgroundColor3 = t1.Color,
				Size = UDim2.fromScale(1, 1)
			}, {
				UICorner = isNewTiltIconEnabled() and Roact.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0)
				}) or nil
			}) or nil,
			StateOverlay = not isNewTiltIconEnabled() and Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Image = v33,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 8, 8),
				ImageColor3 = t1.Color,
				ImageTransparency = t1.Transparency,
				Size = UDim2.fromScale(1, 1)
			}) or nil
		})
	end)
end
function v32.willUnmount(p13) -- line: 236
	if p13.disposeUiScaleEffect then
		p13.disposeUiScaleEffect()
	end
end

return Roact.forwardRef(function(p14, p15) -- line: 241
	-- upvalues: Roact (copy), v32 (copy), Cryo (copy)
	return Roact.createElement(v32, Cryo.Dictionary.join(p14, {
		forwardRef = p15
	}))
end)
