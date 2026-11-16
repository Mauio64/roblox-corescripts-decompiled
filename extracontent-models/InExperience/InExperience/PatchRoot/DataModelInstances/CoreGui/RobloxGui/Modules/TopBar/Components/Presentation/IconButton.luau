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
local CursorKind = UIBlox.App.SelectionImage.CursorKind
local ReactOtter = require(CorePackages.Packages.ReactOtter)

local Foundation = require(CorePackages.Packages.Foundation)
local withCursor = Foundation.Hooks.withCursor
local SkinToneCircle = Foundation.Enums.CursorType.SkinToneCircle

local parent = script.Parent.Parent.Parent

local FlashingDot = require(script.Parent.FlashingDot)
local FlashingDotV2 = require(script.Parent.FlashingDotV2)
local GetFFlagFlashingDotUseAsyncInit = require(CoreGui.RobloxGui.Modules.Flags.GetFFlagFlashingDotUseAsyncInit)
local Chrome = require(CorePackages.Workspace.Packages.Chrome)
local enabled = Chrome.Enabled()
local isNewTiltIconEnabled = require(CoreGui.RobloxGui.Modules.isNewTiltIconEnabled)
local Constants = require(script.Parent.Parent.Parent.Constants)

local extended = Roact.PureComponent:extend("IconButton")

local component_assetscircle_17 = Images["component_assets/circle_17"]

local strictInterface = t.strictInterface
local v = {
	["icon"] = t.union(t.string, t.table),
	iconSize = t.union(t.number, t.UDim2, t.table),
	enableFlashingDot = t.optional(t.boolean),
	useIconScaleAnimation = t.optional(t.boolean),
	onActivated = t.callback,
	onHover = t.optional(t.callback),
	onHoverEnd = t.optional(t.callback),
	backgroundTransparency = t.optional(t.number),
	backgroundColor3 = t.optional(t.Color3),
	backgroundCornerRadius = t.optional(t.UDim),
	forwardRef = t.optional(t.any)
}
local onSelectionChanged

if enabled and FFlagEnableConsoleExpControls then
	onSelectionChanged = t.optional(t.callback)
end

v.onSelectionChanged = onSelectionChanged
local nextSelectionRightRef

if enabled and FFlagEnableConsoleExpControls then
	nextSelectionRightRef = t.optional(t.any)
end

v.nextSelectionRightRef = nextSelectionRightRef
local modal

if FFlagAddUILessMode and FIntAddUILessModeVariant == 2 then
	modal = t.optional(t.boolean)
end

v.modal = modal
v[Roact.Change.AbsoluteSize] = t.optional(t.callback)
v[Roact.Change.AbsolutePosition] = t.optional(t.callback)
extended.validateProps = strictInterface(v)

function AnimatedScaleIcon(props)
	local v2, v3 = ReactOtter.useAnimatedBinding(props.iconSize)

	React.useEffect(function()
		v3(ReactOtter.spring(props.iconSize, {
			dampingRatio = 1,
			frequency = 20 / 7
		}))

		return function() end
	end, { props.iconSize })

	return Roact.createElement(ImageSetLabel, {
		Size = v2:map(function(p)
			return UDim2.fromOffset(p, p)
		end),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		Image = props.icon,
		ImageColor3 = props.style.Theme.IconEmphasis.Color,
		ImageTransparency = props.style.Theme.IconEmphasis.Transparency,
		ZIndex = 1
	})
end

function extended:init()
	self:setState({ controlState = ControlState.Default })

	function self.controlStateUpdated(p, controlState)
		if self.props.onHover and controlState == ControlState.Hover then
			self.props.onHover()
		elseif self.props.onHoverEnd and p == ControlState.Hover and controlState ~= ControlState.Hover then
			self.props.onHoverEnd()
		end

		self:setState({ controlState = controlState })
	end
	self.disposeUiScaleEffect = Signals.createEffect(function(p)
		self:setState({
			UiScale = Display.GetDisplayStore(p).getUIScale(p)
		})
	end)
end

function extended:render()
	if enabled then
		return withCursor(function(p)
			return self:renderWithCursor(p)
		end)
	end

	return withSelectionCursorProvider(function(p)
		return self:renderWithCursor(p)
	end)
end

function extended:renderWithCursor(p)
	local backgroundColor3 = not isNewTiltIconEnabled() and self.props.backgroundColor3
	local v2 = Constants.TopBarButtonHeight * self.state.UiScale
	return withStyle(function(style)
		local v3 = { Color = Color3.new(1, 1, 1), Transparency = 1 }

		if self.state.controlState == ControlState.Pressed then
			v3 = style.Theme.BackgroundOnPress
		elseif self.state.controlState == ControlState.Hover then
			v3 = style.Theme.BackgroundOnHover
		end

		local createElement = Roact.createElement
		local v4 = {}
		v4.onStateChanged = self.controlStateUpdated
		v4.ZIndex = 1
		local modal2

		if FFlagAddUILessMode and FIntAddUILessModeVariant == 2 then
			modal2 = self.props.modal
		end

		v4.Modal = modal2
		v4.BackgroundTransparency = not isNewTiltIconEnabled() and 1
			or style.Theme.BackgroundUIContrast.Transparency * style.Settings.PreferredTransparency

		v4.Position = UDim2.fromScale(0, isNewTiltIconEnabled() and 0.5 or 1)
		v4.AnchorPoint = Vector2.new(0, isNewTiltIconEnabled() and 0.5 or 1)
		v4.Size = UDim2.fromOffset(v2, v2)
		v4.Image = not isNewTiltIconEnabled() and "rbxasset://textures/ui/TopBar/iconBase.png" or nil
		v4.BackgroundColor3 = style.Theme.BackgroundUIContrast.Color
		local selectionImageObject

		if isNewTiltIconEnabled() then
			selectionImageObject = p.getCursor(SkinToneCircle)
		end

		v4.SelectionImageObject = selectionImageObject
		local nextSelectionRight

		if enabled and FFlagEnableConsoleExpControls then
			nextSelectionRight = self.props.nextSelectionRightRef
		end

		v4.NextSelectionRight = nextSelectionRight
		v4[Roact.Event.Activated] = self.props.onActivated
		local selectionChanged = Roact.Event.SelectionChanged
		local v5

		if enabled and FFlagEnableConsoleExpControls then
			v5 = self.props.onSelectionChanged
		end

		v4[selectionChanged] = v5
		v4[Roact.Ref] = self.props.forwardRef
		local v6 = {
			UICorner = isNewTiltIconEnabled() and Roact.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			}) or nil,
			BackgroundFrame = 0,
			Icon = 0,
			ScalingIcon = 0,
			FlashingDot = 0,
			StateOverlayRound = 0,
			StateOverlay = 0
		}
		local backgroundFrame

		if backgroundColor3 then
			local createElement2 = Roact.createElement
			local v7 = {
				Size = self.props.iconSize,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BorderSizePixel = 0,
				BackgroundTransparency = self.props.backgroundTransparency,
				BackgroundColor3 = self.props.backgroundColor3,
				ZIndex = 0
			}
			local uiCorner

			if self.props.backgroundCornerRadius then
				uiCorner = Roact.createElement("UICorner", {
					CornerRadius = self.props.backgroundCornerRadius
				})
			end

			backgroundFrame = createElement2("Frame", v7, { UICorner = uiCorner })
		end

		v6.BackgroundFrame = backgroundFrame

		local icon = not self.props.useIconScaleAnimation

		if icon then
			local createElement2 = Roact.createElement
			local size

			if typeof(self.props.iconSize) == "number" then
				size = UDim2.fromOffset(self.props.iconSize, self.props.iconSize)
			else
				size = self.props.iconSize
			end

			icon = createElement2(ImageSetLabel, {
				Size = size,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Image = self.props.icon,
				ImageColor3 = style.Theme.IconEmphasis.Color,
				ImageTransparency = style.Theme.IconEmphasis.Transparency,
				ZIndex = 1
			})
		end

		v6.Icon = icon

		v6.ScalingIcon = self.props.useIconScaleAnimation
			and Roact.createElement(AnimatedScaleIcon, {
				icon = self.props.icon,
				iconSize = self.props.iconSize,
				style = style
			})
		local flashingDot

		if self.props.enableFlashingDot then
			local createElement2 = Roact.createElement
			local v7

			if GetFFlagFlashingDotUseAsyncInit() then
				v7 = FlashingDotV2
			else
				v7 = FlashingDot
			end

			flashingDot = createElement2(v7)
		end

		v6.FlashingDot = flashingDot
		local stateOverlayRound

		if isNewTiltIconEnabled() then
			stateOverlayRound = Roact.createElement(
					"Frame",
					{
						BackgroundTransparency = v3.Transparency,
						BackgroundColor3 = v3.Color,
						Size = UDim2.fromScale(1, 1),
						ZIndex = 2
					},
					{
						UICorner = isNewTiltIconEnabled() and Roact.createElement("UICorner", {
							CornerRadius = UDim.new(1, 0)
						}) or nil
					}
				)
				or nil
		end

		v6.StateOverlayRound = stateOverlayRound
		local stateOverlay

		if not isNewTiltIconEnabled() then
			stateOverlay = Roact.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				Image = component_assetscircle_17,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(8, 8, 8, 8),
				ImageColor3 = v3.Color,
				ImageTransparency = v3.Transparency,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 2
			}) or nil
		end

		v6.StateOverlay = stateOverlay
		return createElement(Interactable, v4, v6)
	end)
end

function extended.willUnmount(p)
	if p.disposeUiScaleEffect then
		p.disposeUiScaleEffect()
	end
end
return Roact.forwardRef(function(p, forwardRef)
	return Roact.createElement(extended, Cryo.Dictionary.join(p, { forwardRef = forwardRef }))
end)
