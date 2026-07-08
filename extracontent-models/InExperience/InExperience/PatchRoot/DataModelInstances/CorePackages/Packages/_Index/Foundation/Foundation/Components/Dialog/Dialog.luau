local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local Dash = require(FoundationParent.Dash)
local Otter = require(FoundationParent.Otter)
local React = require(FoundationParent.React)
local ReactOtter = require(FoundationParent.ReactOtter)
local ReactRoblox = require(FoundationParent.ReactRoblox)
local useAnimatedBinding = ReactOtter.useAnimatedBinding
local CloseAffordance = require(Foundation.Components.CloseAffordance)
local Constants = require(Foundation.Constants)
local Image = require(Foundation.Components.Image)
local View = require(Foundation.Components.View)
local useOverlay = require(Foundation.Providers.Overlay.useOverlay)
local DialogSize = require(Foundation.Enums.DialogSize)
local OnCloseCallbackReason = require(Foundation.Enums.OnCloseCallbackReason)
local StateLayerAffordance = require(Foundation.Enums.StateLayerAffordance)
local useScaledValue = require(Foundation.Utility.useScaledValue)
local useTokens = require(Foundation.Providers.Style.useTokens)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local withDefaults = require(Foundation.Utility.withDefaults)
local Flags = require(Foundation.Utility.Flags)
local usePreferences = require(Foundation.Providers.Preferences.usePreferences)
local Types = require(script.Parent.Types)

require(Foundation.Components.Types)

local useDialogVariants = require(script.Parent.useDialogVariants).useDialogVariants
local DialogProvider = require(script.Parent.DialogProvider)
local useDialog = require(script.Parent.useDialog)
local useDialogResponsiveSize = require(script.Parent.useDialogResponsiveSize)
local useDialogSize = require(script.Parent.useDialogSize)
local useElevation = require(Foundation.Providers.Elevation.useElevation)
local ElevationOwnerScope = require(Foundation.Providers.Elevation.ElevationProvider).ElevationOwnerScope
local ElevationLayer = require(Foundation.Enums.ElevationLayer)
local t1 = {
	disablePortal = true,
	hasBackdrop = false,
	testId = "--foundation-dialog",
	size = DialogSize.Medium
}
local SHADOW_IMAGE = Constants.SHADOW_IMAGE
local SHADOW_SIZE = Constants.SHADOW_SIZE

local function Dialog(p1) -- line: 70
	-- upvalues: Dash (copy), useDialogVariants (copy), useScaledValue (copy), Flags (copy), React (copy), useDialogSize (copy), useOverlay (copy), useElevation (copy), ElevationLayer (copy), useDialog (copy), useDialogResponsiveSize (copy), useTokens (copy), usePreferences (copy), useAnimatedBinding (copy), Otter (copy), View (copy), Image (copy), SHADOW_IMAGE (copy), SHADOW_SIZE (copy), withCommonProps (copy), StateLayerAffordance (copy), Types (copy), CloseAffordance (copy), ElevationOwnerScope (copy), OnCloseCallbackReason (copy), ReactRoblox (copy)
	local v38 = Dash.assign({}, p1, {
		LayoutOrder = 1
	})
	local v39 = useDialogVariants()
	local v40 = useScaledValue(v39.inner.maxWidth)
	local v41 = if Flags.FoundationDialogAnimation then nil else React.useRef(nil)
	local u42 = nil
	local v43

	if Flags.FoundationDialogAnimation then
		local v44

		v43, v44 = React.useBinding(Vector2.new(0, 0))
		u42 = v44
	else
		v43 = useDialogSize(v41)
	end

	local v45 = useOverlay()
	local v46 = useElevation(ElevationLayer.Dialog, {
		stackAboveOwner = false
	})
	local v47 = useDialog()

	useDialogResponsiveSize(v38.size)

	local v48 = if not Flags.FoundationDialogAnimation then nil else useTokens()
	local u49 = false

	if Flags.FoundationDialogAnimation then
		u49 = usePreferences().reducedMotion
	end

	local v50 = not Flags.FoundationDialogAnimation and 0 or v48.Size.Size_800
	local v51 = nil
	local u52 = nil

	if Flags.FoundationDialogAnimation then
		local v53

		v51, v53 = React.useState(true)
		u52 = v53
	end

	local v54 = if not Flags.FoundationDialogAnimation then nil else React.useRef(false)
	local v55 = if not Flags.FoundationDialogAnimation then nil else React.useRef(nil)
	local v56 = nil
	local u57 = nil

	if Flags.FoundationDialogAnimation then
		local v58

		v56, v58 = useAnimatedBinding(1)
		u57 = v58
	end

	local v59 = nil
	local u60 = nil

	if Flags.FoundationDialogAnimation then
		local v61

		v59, v61 = useAnimatedBinding(v50, function() -- line: 116
			-- upvalues: v54 (copy), v38 (copy), v55 (copy), u52 (ref)
			if v54.current then
				if v38.onClose then
					v38.onClose(v55.current)

					return
				end
			else
				u52(false)
			end
		end)
		u60 = v61
	end

	if Flags.FoundationDialogAnimation then
		React.useEffect(function() -- line: 131
			-- upvalues: u49 (ref), u60 (ref), Otter (copy), u57 (ref), v48 (copy)
			if u49 then
				u60((Otter.instant(0)))
				u57((Otter.instant(0)))

				return
			end

			u60(Otter.ease(0, {
				easingStyle = v48.Ease.StandardOut,
				duration = v48.Time.Time_300
			}))
			u57(Otter.ease(0, {
				duration = v48.Time.Time_100
			}))
		end, {})
	end

	local u62 = nil

	if Flags.FoundationDialogAnimation then
		u62 = React.useCallback(function(p2) -- line: 150
			-- upvalues: v54 (copy), v55 (copy), u49 (ref), u60 (ref), Otter (copy), v50 (copy), u57 (ref), v48 (copy), u52 (ref)
			if v54.current then
				return
			end

			v55.current = p2

			if u49 then
				v54.current = true
				u60(Otter.instant(v50))
				u57(Otter.instant(1))

				return
			end

			u60(Otter.ease(v50, {
				easingStyle = v48.Ease.StandardIn,
				duration = v48.Time.Time_200
			}))
			u57(Otter.ease(1, {
				duration = v48.Time.Time_100
			}))
			u52(true)
			v54.current = true
		end, {
			v50,
			u49
		})
	end

	local v63 = if not Flags.FoundationDialogAnimation then nil else React.useMemo(function() -- line: 174
		return Instance.new("Folder")
	end, {})

	if Flags.FoundationDialogAnimation then
		React.useEffect(function() -- line: 180
			-- upvalues: v63 (copy)
			return function() -- line: 181
				-- upvalues: v63 (copy)
				v63:Destroy()
			end
		end, { v63 })
	end

	local v64 = nil
	local u65 = nil

	if Flags.FoundationDialogAnimation then
		local v66

		v64, v66 = React.useState(false)
		u65 = v66
	end

	local v67 = if not Flags.FoundationDialogAnimation then nil else React.useCallback(function(p3) -- line: 194
		-- upvalues: v63 (copy), u65 (ref)
		if p3 then
			v63.Parent = p3
			u65(true)

			return
		end

		v63.Parent = nil
		u65(false)
	end, { v63 })
	local v68 = React.createElement(View, {
		ZIndex = 2,
		tag = v39.container.tag
	}, {
		Shadow = React.createElement(Image, {
			Image = SHADOW_IMAGE,
			Size = v43:map(function(vector2: Vector2) -- line: 211
				-- upvalues: SHADOW_SIZE (copy)
				return UDim2.fromOffset(vector2.X + SHADOW_SIZE * 2, vector2.Y + SHADOW_SIZE * 2)
			end),
			slice = {
				scale = 2,
				center = Rect.new(SHADOW_SIZE, SHADOW_SIZE, SHADOW_SIZE, SHADOW_SIZE)
			},
			imageStyle = v39.shadow.imageStyle,
			testId = `{ v38.testId }--shadow`
		})
	})
	local v69 = React.createElement(View, {
		ZIndex = 3,
		tag = v39.container.tag
	}, {
		DialogFlexStart = if not Flags.FoundationDialogAnimation then React.createElement(View, {
			tag = "fill",
			LayoutOrder = 0
		}) else nil,
		DialogInner = React.createElement(View, withCommonProps(v38, {
			tag = v39.inner.tag,
			ref = v38.forwardRef,
			sizeConstraint = {
				MaxSize = Vector2.new(v40, 1e999)
			},
			stateLayer = {
				affordance = StateLayerAffordance.None
			},
			selection = Types.nonSelectable,
			selectionGroup = Types.isolatedSelectionGroup,
			onActivated = Dash.noop
		}), {
			CloseAffordance = if not v38.onClose then nil else React.createElement(CloseAffordance, {
				ZIndex = 2,
				onActivated = if not Flags.FoundationDialogAnimation or (not u62 or u49) then v38.onClose else u62,
				ref = v47.closeAffordanceRef,
				NextSelectionDown = v47.contentStartRef,
				Position = UDim2.new(1, -v39.closeAffordance.offset, 0, v39.closeAffordance.offset),
				AnchorPoint = Vector2.new(1, 0),
				testId = `{ v38.testId }--close-affordance`
			}),
			DialogBody = React.createElement(View, {
				tag = v39.body.tag,
				ref = if Flags.FoundationDialogAnimation then nil else v41,
				onAbsoluteSizeChanged = if not Flags.FoundationDialogAnimation then nil else function(p4) -- line: 269
					-- upvalues: u42 (ref)
					local AbsoluteSize = p4.AbsoluteSize

					if AbsoluteSize.X > 0 and AbsoluteSize.Y > 0 then
						u42(AbsoluteSize)
					end
				end,
				testId = `{ v38.testId }--body`
			}, React.createElement(ElevationOwnerScope, {
				owner = v46
			}, v38.children))
		}),
		DialogFlexEnd = if not Flags.FoundationDialogAnimation then React.createElement(View, {
			tag = "fill",
			LayoutOrder = 2
		}) else nil
	})
	local v70 = React.createElement(View, {
		tag = "size-full",
		ZIndex = v46.zIndex,
		testId = `{ v38.testId }--container`
	}, {
		Backdrop = if not v38.hasBackdrop then nil else React.createElement(View, {
			tag = "position-center-center anchor-center-center",
			ZIndex = 2,
			Size = UDim2.fromScale(2, 2),
			stateLayer = {
				affordance = StateLayerAffordance.None
			},
			onActivated = function() -- line: 300
				-- upvalues: v38 (copy), Flags (copy), u62 (ref), u49 (ref), OnCloseCallbackReason (copy)
				if v38.onClose then
					if Flags.FoundationDialogAnimation and u62 and not u49 then
						u62(OnCloseCallbackReason.BackdropClick)

						return
					end

					v38.onClose(OnCloseCallbackReason.BackdropClick)
				end
			end,
			backgroundStyle = if not Flags.FoundationDialogAnimation or (u49 or not v56) then v39.backdrop.backgroundStyle else v56:map(function(n1: number) -- line: 312
				-- upvalues: v39 (copy)
				return {
					Color3 = v39.backdrop.backgroundStyle.Color3,
					Transparency = math.lerp(v39.backdrop.backgroundStyle.Transparency, 1, n1)
				}
			end),
			testId = `{ v38.testId }--backdrop`
		}),
		DialogContentWrapper = React.createElement(View, {
			ZIndex = 2,
			ref = if not Flags.FoundationDialogAnimation or u49 then nil else v67,
			Position = if not Flags.FoundationDialogAnimation or (u49 or not v59) then nil else v59:map(function(n2: number) -- line: 334
				return UDim2.new(0.5, 0, 0.5, n2)
			end),
			sizeConstraint = if not Flags.FoundationDialogAnimation or u49 then nil else {
				MaxSize = Vector2.new(v40 + SHADOW_SIZE * 2, 1e999)
			},
			tag = {
				["anchor-center-center size-full"] = Flags.FoundationDialogAnimation and not u49,
				["size-full"] = not Flags.FoundationDialogAnimation or u49
			},
			GroupTransparency = if not Flags.FoundationDialogAnimation or (u49 or (not v51 or not v59)) then nil else v59:map(function(n3: number) -- line: 350
				-- upvalues: v50 (copy)
				return n3 / v50
			end)
		}, if not not Flags.FoundationDialogAnimation and not u49 then nil else {
			DialogShadowWrapper = v68,
			Dialog = v69
		})
	})

	if Flags.FoundationDialogAnimation and not u49 then
		local v71 = if not v38.disablePortal and v45 ~= nil then ReactRoblox.createPortal(v70, v45) else v70

		return React.createElement(React.Fragment, nil, {
			Main = v71,
			StableContent = if not v64 then nil else ReactRoblox.createPortal(React.createElement(React.Fragment, nil, {
				DialogShadowWrapper = v68,
				Dialog = v69
			}), v63)
		})
	end

	if v38.disablePortal or v45 == nil then
		return v70
	end

	return ReactRoblox.createPortal(v70, v45)
end
local function DialogContainer(p5, p6) -- line: 390
	-- upvalues: withDefaults (copy), t1 (copy), React (copy), DialogProvider (copy), Dialog (copy), Dash (copy)
	local v74 = withDefaults(p5, t1)

	return React.createElement(DialogProvider, {
		size = v74.size,
		responsiveSize = v74.size,
		testId = v74.testId
	}, {
		Dialog = React.createElement(Dialog, Dash.assign({}, v74, {
			forwardRef = p6
		}))
	})
end

return React.memo(React.forwardRef(DialogContainer))
