local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local Dash = require(parent.Dash)
local Otter = require(parent.Otter)
local React = require(parent.React)
local ReactOtter = require(parent.ReactOtter)
local ReactRoblox = require(parent.ReactRoblox)
local useAnimatedBinding = ReactOtter.useAnimatedBinding

local Backdrop = require(Foundation.Components.Backdrop)
local CloseAffordance = require(Foundation.Components.CloseAffordance)
local Constants = require(Foundation.Constants)
local Image = require(Foundation.Components.Image)
local View = require(Foundation.Components.View)

local useOverlay = require(Foundation.Providers.Overlay.useOverlay)

local DialogSize = require(Foundation.Enums.DialogSize)
local OnCloseCallbackReason = require(Foundation.Enums.OnCloseCallbackReason)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)

local Flags = require(Foundation.Utility.Flags)
local useScaledValue = require(Foundation.Utility.useScaledValue)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)

local usePreferences = require(Foundation.Providers.Preferences.usePreferences)

local Types = require(script.Parent.Types)
require(Foundation.Components.Types)
local useDialogVariants = require(script.Parent.useDialogVariants)
local useDialogVariants2 = useDialogVariants.useDialogVariants
local DialogProvider = require(script.Parent.DialogProvider)
local useDialog = require(script.Parent.useDialog)
local useDialogResponsiveSize = require(script.Parent.useDialogResponsiveSize)

local useElevation = require(Foundation.Providers.Elevation.useElevation)
local ElevationProvider = require(Foundation.Providers.Elevation.ElevationProvider)
local ElevationOwnerScope = ElevationProvider.ElevationOwnerScope
local ElevationLayer = require(Foundation.Enums.ElevationLayer)

local v = {
	size = DialogSize.Medium,
	disablePortal = true,
	hasBackdrop = false,
	testId = "--foundation-dialog"
}

local SHADOW_IMAGE = Constants.SHADOW_IMAGE
local SHADOW_SIZE = Constants.SHADOW_SIZE

local function Dialog(p)
	local v2 = Dash.assign({}, p, { LayoutOrder = 1 })
	local v3 = useDialogVariants2()
	local v4 = useScaledValue(v3.inner.maxWidth)

	local v5, v6 = React.useBinding(Vector2.new(0, 0))

	local v7 = useOverlay()
	local owner = useElevation(ElevationLayer.Dialog, { stackAboveOwner = false })
	local v8 = useDialog()

	useDialogResponsiveSize(v2.size)

	local v9 = useTokens()
	local reducedMotion = usePreferences().reducedMotion

	local size_800 = v9.Size.Size_800
	local state, setState = React.useState(true)

	local ref = React.useRef(false)
	local ref2 = React.useRef(nil)

	local transparency, v10 = useAnimatedBinding(1)

	local v11, v12 = useAnimatedBinding(size_800, function()
		if ref.current then
			if v2.onClose then
				v2.onClose(ref2.current)
			end
		else
			setState(false)
		end
	end)

	React.useEffect(function()
		if reducedMotion then
			v12((Otter.instant(0)))
			v10((Otter.instant(0)))
		else
			v12(Otter.ease(0, { easingStyle = v9.Ease.StandardOut, duration = v9.Time.Time_300 }))

			v10(Otter.ease(0, { duration = v9.Time.Time_100 }))
		end
	end, {})

	local v13 = React.useCallback(function(current)
		if ref.current then
			return
		end

		ref2.current = current

		if reducedMotion then
			ref.current = true
			v12(Otter.instant(size_800))
			v10(Otter.instant(1))
		else
			v12(Otter.ease(size_800, {
				easingStyle = v9.Ease.StandardIn,
				duration = v9.Time.Time_200
			}))

			v10(Otter.ease(1, { duration = v9.Time.Time_100 }))

			setState(true)
			ref.current = true
		end
	end, { size_800, reducedMotion })

	local v14 = React.useMemo(function()
		return Instance.new("Folder")
	end, {})

	React.useEffect(function()
		return function()
			v14:Destroy()
		end
	end, { v14 })

	local state2, setState2 = React.useState(false)

	local ref3 = React.useCallback(function(parent2)
		if parent2 then
			v14.Parent = parent2
			setState2(true)
		else
			v14.Parent = nil
			setState2(false)
		end
	end, { v14 })

	local createElement = React.createElement
	local v15 = { tag = v3.container.tag, ZIndex = 2 }
	local shadow

	if Flags.FoundationDialogOverlayShadow then
		shadow = React.createElement(View, {
			tag = "shadow-overlay-300 radius-large",
			Size = v5:map(function(vector2: Vector2)
				return UDim2.fromOffset(vector2.X, vector2.Y)
			end),
			testId = `{v2.testId}--shadow`
		})
	else
		shadow = React.createElement(Image, {
			Image = SHADOW_IMAGE,
			Size = v5:map(function(vector2: Vector2)
				return UDim2.fromOffset(vector2.X + SHADOW_SIZE * 2, vector2.Y + SHADOW_SIZE * 2)
			end),
			slice = {
				center = Rect.new(SHADOW_SIZE, SHADOW_SIZE, SHADOW_SIZE, SHADOW_SIZE),
				scale = 2
			},
			imageStyle = v3.shadow.imageStyle,
			testId = `{v2.testId}--shadow`
		})
	end

	local element = createElement(View, v15, { Shadow = shadow })

	local createElement2 = React.createElement
	local v16 = { tag = v3.container.tag, ZIndex = 3 }

	local createElement3 = React.createElement

	local v17 = withCommonProps(v2, {
		tag = v3.inner.tag,
		ref = v2.forwardRef,
		sizeConstraint = { MaxSize = Vector2.new(v4, 1e999) },
		stateLayer = { affordance = StateLayerAffordance.None },
		selection = Types.nonSelectable,
		selectionGroup = Types.isolatedSelectionGroup,
		onActivated = Dash.noop
	})
	local closeAffordance

	if v2.onClose then
		local createElement4 = React.createElement
		local onActivated

		if v13 and not reducedMotion then
			onActivated = v13
		else
			onActivated = v2.onClose
		end

		closeAffordance = createElement4(CloseAffordance, {
			onActivated = onActivated,
			ref = v8.closeAffordanceRef,
			NextSelectionDown = v8.contentStartRef,
			Position = UDim2.new(1, -v3.closeAffordance.offset, 0, v3.closeAffordance.offset),
			AnchorPoint = Vector2.new(1, 0),
			ZIndex = 2,
			testId = `{v2.testId}--close-affordance`
		})
	end

	local element2 = createElement2(View, v16, {
		DialogInner = createElement3(View, v17, {
			CloseAffordance = closeAffordance,
			DialogBody = React.createElement(View, {
				tag = v3.body.tag,
				onAbsoluteSizeChanged = function(p2)
					local absoluteSize = p2.AbsoluteSize

					if absoluteSize.X > 0 and absoluteSize.Y > 0 then
						v6(absoluteSize)
					end
				end,
				testId = `{v2.testId}--body`
			}, React.createElement(ElevationOwnerScope, { owner = owner }, v2.children))
		})
	})

	local createElement4 = React.createElement
	local v18 = {
		ZIndex = owner.zIndex,
		tag = "size-full padding-y-xlarge",
		testId = `{v2.testId}--container`
	}
	local backdrop

	if v2.hasBackdrop then
		if Flags.FoundationDialogInternalBackdrop then
			local createElement5 = React.createElement

			if reducedMotion then
				transparency = nil
			end

			backdrop = createElement5(Backdrop, {
				transparency = transparency,
				onActivated = function()
					if v2.onClose then
						if v13 and not reducedMotion then
							v13(OnCloseCallbackReason.BackdropClick)
						else
							v2.onClose(OnCloseCallbackReason.BackdropClick)
						end
					end
				end,
				ZIndex = 2,
				testId = `{v2.testId}--backdrop`
			})
		else
			local createElement5 = React.createElement
			local v19 = {
				tag = "position-center-center anchor-center-center",
				Size = UDim2.fromScale(2, 2),
				stateLayer = { affordance = StateLayerAffordance.None },
				onActivated = function()
					if v2.onClose then
						if v13 and not reducedMotion then
							v13(OnCloseCallbackReason.BackdropClick)
						else
							v2.onClose(OnCloseCallbackReason.BackdropClick)
						end
					end
				end,
				backgroundStyle = 0,
				ZIndex = 2,
				testId = 0
			}
			local backgroundStyle

			if reducedMotion or not transparency then
				backgroundStyle = v3.backdrop.backgroundStyle
			else
				backgroundStyle = transparency:map(function(p2: number)
					return {
						Color3 = v3.backdrop.backgroundStyle.Color3,
						Transparency = math.lerp(v3.backdrop.backgroundStyle.Transparency, 1, p2)
					}
				end)
			end

			v19.backgroundStyle = backgroundStyle

			v19.testId = `{v2.testId}--backdrop`
			backdrop = createElement5(View, v19)
		end
	end

	local createElement5 = React.createElement

	if reducedMotion then
		ref3 = nil
	end

	local position

	if not (reducedMotion or not v11) then
		position = v11:map(function(p2: number)
			return UDim2.new(0.5, 0, 0.5, p2)
		end)
	end

	local sizeConstraint

	if not reducedMotion then
		sizeConstraint = { MaxSize = 0 }
		local v19

		if Flags.FoundationDialogOverlayShadow then
			v19 = v9.Size.Size_1400 * 2
		else
			v19 = SHADOW_SIZE * 2
		end

		sizeConstraint.MaxSize = Vector2.new(v4 + v19, 1e999)
	end

	local v19 = {
		ref = ref3,
		Position = position,
		sizeConstraint = sizeConstraint,
		testId = `{v2.testId}--content-wrapper`,
		tag = {
			["anchor-center-center size-full"] = not reducedMotion,
			["size-full"] = reducedMotion
		},
		ZIndex = 2,
		GroupTransparency = 0
	}
	local groupTransparency

	if Flags.FoundationDialogOverlayShadow then
		if not (reducedMotion or not v11) then
			groupTransparency = v11:map(function(p2: number)
				return p2 / size_800
			end)
		end
	elseif not (reducedMotion or not (state and v11)) then
		groupTransparency = v11:map(function(p2: number)
			return p2 / size_800
		end)
	end

	v19.GroupTransparency = groupTransparency
	local element3 = createElement4(View, v18, {
		Backdrop = backdrop,
		DialogContentWrapper = createElement5(
			View,
			v19,
			reducedMotion and { DialogShadowWrapper = element, Dialog = element2 } or nil
		)
	})

	if reducedMotion then
		if v2.disablePortal or v7 == nil then
			return element3
		end

		return ReactRoblox.createPortal(element3, v7)
	else
		if not v2.disablePortal and v7 ~= nil then
			element3 = ReactRoblox.createPortal(element3, v7)
		end

		local createElement6 = React.createElement
		local fragment = React.Fragment
		local stableContent

		if state2 then
			stableContent = ReactRoblox.createPortal(
				React.createElement(React.Fragment, nil, {
					DialogShadowWrapper = element,
					Dialog = element2
				}),
				v14
			)
		end

		return createElement6(fragment, nil, { Main = element3, StableContent = stableContent })
	end
end

local function DialogContainer(p, forwardRef)
	local v2 = withDefaults(p, v)

	return React.createElement(DialogProvider, {
		size = v2.size,
		responsiveSize = v2.size,
		testId = v2.testId
	}, {
		Dialog = React.createElement(Dialog, Dash.assign({}, v2, { forwardRef = forwardRef }))
	})
end

return React.memo(React.forwardRef(DialogContainer))
