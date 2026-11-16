local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local CoreGuiCommon = require(parent.CoreGuiCommon)
local Display = require(parent.Display)
local Foundation = require(parent.Foundation)
local Motion = require(parent.Motion)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local BuildPillMenuPageHost = require(BuildExperience.Components.BuildPillMenu.BuildPillMenuPageHost)
local PublishSheetController = require(BuildExperience.Components.PublishSheet.PublishSheetController)
local getCurrentExperienceProject = require(BuildExperience.utils.getCurrentExperienceProject)
local useHardwareInsets = require(script.Parent.useHardwareInsets)
local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)
local useGamePermissions = require(BuildExperience.useGamePermissions)

local Image = Foundation.Image
local IconButton = Foundation.IconButton
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useOverlay = Foundation.Hooks.useOverlay
local usePreferences = Foundation.Hooks.usePreferences
local useTokens = Foundation.Hooks.useTokens

local function noop() end

local function createToolbarButtons(props, onActivated, p: string, p2)
	local isDisabled = FFlagBuildCheckGamePermissions and not p2.canEditOnBuild

	if props.isSelecting then
		local v = {
			Cancel = React.createElement(IconButton, {
				LayoutOrder = 1,
				icon = IconName.X,
				onActivated = props.onSelectionCancelled or noop,
				size = InputSize.Medium,
				testId = `{p}-cancel-selection`,
				variant = ButtonVariant.Utility
			}),
			Confirm = 0
		}
		local confirm

		if props.onSelectionConfirmed ~= nil then
			confirm = React.createElement(IconButton, {
				LayoutOrder = 2,
				icon = IconName.CheckLarge,
				isDisabled = isDisabled,
				onActivated = props.onSelectionConfirmed,
				size = InputSize.Medium,
				testId = `{p}-confirm-selection`,
				variant = ButtonVariant.Utility
			})
		end

		v.Confirm = confirm
		return v
	else
		local v = {
			Chat = React.createElement(IconButton, {
				LayoutOrder = 1,
				icon = IconName.Nebula,
				onActivated = props.onActivated,
				size = InputSize.Medium,
				testId = `{p}-chat`,
				variant = ButtonVariant.Utility
			}),
			Select = React.createElement(IconButton, {
				LayoutOrder = 2,
				icon = IconName.CursorStars,
				isDisabled = isDisabled,
				onActivated = props.onSelectionActivated or noop,
				size = InputSize.Medium,
				testId = `{p}-select`,
				variant = ButtonVariant.Utility
			}),
			Capture = React.createElement(IconButton, {
				LayoutOrder = 3,
				icon = IconName.FrameCameraCenter,
				isDisabled = isDisabled,
				onActivated = props.onCaptureActivated or noop,
				size = InputSize.Medium,
				testId = `{p}-capture`,
				variant = ButtonVariant.Utility
			}),
			Publish = React.createElement(IconButton, {
				LayoutOrder = 4,
				icon = IconName.ArrowUpRightFromSquare,
				isDisabled = FFlagBuildCheckGamePermissions and not p2.canPublish,
				onActivated = onActivated,
				size = InputSize.Medium,
				testId = `{p}-publish`,
				variant = ButtonVariant.Utility
			})
		}

		if props.isLibraryMode then
			v.Select = nil
			v.Capture = nil
		end

		return v
	end
end

local function InGameBuildShell(props)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState(nil)
	local v

	if FFlagBuildCheckGamePermissions then
		v = useGamePermissions({ universeId = getCurrentExperienceProject().universeId })
	end

	local onActivated = React.useCallback(function()
		local currentExperienceProject = getCurrentExperienceProject()

		if currentExperienceProject.universeId == nil then
			return
		end

		setState3({
			universeId = currentExperienceProject.universeId,
			placeId = currentExperienceProject.placeId,
			sessionId = nil,
			isNewGameTarget = false
		})

		setState(true)
	end, {})
	local onClose = React.useCallback(function()
		setState(false)
	end, {})
	local onClose2 = React.useCallback(function()
		setState2(nil)
	end, {})
	local navigateToSubPage = React.useCallback(function(screen: string, data)
		setState2({
			type = "screen",
			screen = screen,
			target = {
				universeId = data.universeId,
				placeId = data.placeId,
				sessionId = data.sessionId,
				isNewGameTarget = data.isNewGameTarget or false
			}
		})
	end, {})
	local v2 = useTokens()
	local reducedMotion = usePreferences().reducedMotion
	local v3 = useHardwareInsets((useOverlay()))
	local displayStore = Display.GetDisplayStore(false)
	local keepOutAreasStore = CoreGuiCommon.Stores.GetKeepOutAreasStore(false)
	local v4 = SignalsReact.useSignalState(displayStore.getGuiInset)
	local state4, setState4 = React.useState(nil)
	local v5 = SignalsReact.useSignalState(displayStore.getViewportSize)
	local v6 = SignalsReact.useSignalState(displayStore.getDisplaySize)
	local v7 = v5.X > v5.Y
	local v8

	if v6 == nil then
		v8 = false
	else
		v8 = v6 ~= Enum.DisplaySize.Small
	end

	local visible = v8 or props.isVisible ~= false
	local state5, setState5 = React.useState(nil)
	local ref = React.useCallback(function(p)
		setState5(p)
	end, {})
	local size_1200 = v2.Size.Size_1200
	local v9 = React.useMemo(function()
		return {
			visible = Motion.createState({ progress = 1 }, {
				default = Motion.transition({
					duration = reducedMotion and 0 or v2.Time.Time_300,
					easingStyle = v2.Ease.StandardOut
				})
			}),
			hidden = Motion.createState({ progress = 0 }, {
				default = Motion.transition({
					duration = reducedMotion and 0 or v2.Time.Time_100,
					easingStyle = v2.Ease.StandardIn
				})
			})
		}
	end, { reducedMotion, v2 })

	local useMotion = Motion.useMotion
	local v10 = if visible then v9.visible else v9.hidden
	local v11, v12 = useMotion(v10)
	local state6, setState6 = React.useState(visible)

	React.useEffect(function()
		local v13 = false

		if visible then
			setState6(true)
			v12(v9.visible)
		else
			v12(v9.hidden, {
				onAnimationComplete = function(p)
					if not v13 and p == true then
						if props.onInsetsChanged ~= nil then
							props.onInsetsChanged(0, 0, 0)
						end

						setState6(false)
					end
				end
			})
		end

		return function()
			v13 = true
		end
	end, { v12, v9, visible, props.onInsetsChanged })

	local state7, setState7 = React.useState(0)
	local state8, setState8 = React.useState(0)
	local onAbsoluteSizeChanged = React.useCallback(function(p)
		setState7(p.AbsoluteSize.Y)
	end, {})
	local v13 = React.useCallback(function(p)
		setState8(p.AbsoluteSize.X)
		keepOutAreasStore.setKeepOutArea("build-shell-right-inset", p.AbsolutePosition, p.AbsoluteSize)
	end, { keepOutAreasStore })
	local onAbsoluteSizeChanged2 = React.useCallback(function(p)
		if props.onInsetsChanged ~= nil then
			props.onInsetsChanged(0, (not v7 or v8) and 0 or p.AbsoluteSize.X, (v7 or v8) and 0 or p.AbsoluteSize.Y)
		end
	end, { v7, props.onInsetsChanged, v8 })
	React.useEffect(function()
		if v8 and props.onInsetsChanged ~= nil then
			props.onInsetsChanged(0, 0, 0)
		end
	end, { props.onInsetsChanged, v8 })
	React.useEffect(function()
		if not state6 or not v7 or v8 then
			keepOutAreasStore.removeKeepOutArea("build-shell-right-inset")
		end
	end, { v7, state6, keepOutAreasStore, v8 })
	React.useEffect(function()
		return function()
			keepOutAreasStore.removeKeepOutArea("build-shell-right-inset")
		end
	end, { keepOutAreasStore })
	local progress = v11.progress
	local mapped = progress:map(function(p: number)
		return UDim2.new(1, state8 * (1 - p), 0, 0)
	end)

	local mapped2 = progress:map(function(p: number)
		return UDim2.new(1, -state8 * p + 1, 0, 0)
	end)

	local mapped3 = progress:map(function(p: number)
		return UDim2.new(0, 0, 1, state7 * (1 - p))
	end)

	local mapped4 = progress:map(function(p: number)
		return UDim2.new(0, -1, 1, -state7 * p + 1)
	end)

	local mapped5 = progress:map(function(p: number)
		return UDim2.new(1, -(not v7 and 0 or state8) * p + 1, 1, -(v7 and 0 or state7) * p + 1)
	end)

	local mapped6 = progress:map(function(p: number)
		if v8 then
			return UDim2.fromOffset(0, 0)
		end

		return UDim2.fromOffset((not v7 and 0 or state8) * p, (v7 and 0 or state7) * p)
	end)

	local surface_100 = v2.Color.Surface.Surface_100
	local mapped7 = progress:map(function(p: number)
		return {
			Color3 = surface_100.Color3,
			Transparency = 1 - (1 - surface_100.Transparency) * p
		}
	end)

	local createElement = React.createElement
	local v14 = {
		Visible = state6,
		tag = "size-full",
		testId = props.testId or "in-game-build-shell"
	}
	local floatingToolbarBounds

	if v8 then
		floatingToolbarBounds = React.createElement(View, {
			Position = UDim2.fromOffset(v3.left + v2.Padding.Large, v3.top + v2.Padding.Large),
			Size = UDim2.new(
				1,
				-(v3.left + v3.right + v2.Padding.Large * 2),
				1,
				-(v3.top + v3.bottom + v2.Padding.Large * 2)
			),
			ref = ref,
			testId = "in-game-build-shell-floating-toolbar-bounds"
		}, {
			Toolbar = React.createElement(View, {
				Visible = visible,
				ZIndex = 1000,
				onActivated = noop,
				stateLayer = { affordance = StateLayerAffordance.None },
				tag = "col align-x-center gap-xsmall position-center-right anchor-center-right auto-xy padding-xsmall radius-medium bg-surface-100",
				testId = "in-game-build-shell-floating-toolbar"
			}, {
				DragDetector = React.createElement("UIDragDetector", {
					BoundingBehavior = Enum.UIDragDetectorBoundingBehavior.EntireObject,
					BoundingUI = state5,
					DragStyle = Enum.UIDragDetectorDragStyle.TranslatePlane,
					ReferenceUIInstance = state5,
					ResponseStyle = Enum.UIDragDetectorResponseStyle.Scale
				}),
				Buttons = React.createElement(
					React.Fragment,
					nil,
					createToolbarButtons(props, onActivated, "in-game-build-shell-floating", v)
				),
				DragAffordance = React.createElement(
					View,
					{
						LayoutOrder = 6,
						tag = "position-center-center anchor-center-center auto-xy padding-xxsmall"
					},
					{
						Icon = React.createElement(Image, {
							Image = "component_assets/dragger_small",
							tag = "position-center-center anchor-center-center size-600-400 content-muted"
						})
					}
				)
			})
		})
	end

	local children = {
		FloatingToolbarBounds = floatingToolbarBounds,
		InsetReporter = React.createElement(View, {
			Size = mapped6,
			onAbsoluteSizeChanged = onAbsoluteSizeChanged2,
			testId = "in-game-build-shell-inset-reporter"
		}),
		RightInset = 0,
		TopRightInnerCorner = 0,
		BottomLeftInnerCorner = 0,
		BottomRightInnerCorner = 0,
		BottomBar = 0
	}
	local rightInset

	if v7 and not v8 then
		rightInset = React.createElement(View, {
			Position = mapped,
			ZIndex = 1000,
			tag = "col align-x-center align-y-center gap-xsmall anchor-top-right size-0-full auto-x bg-surface-100",
			padding = {
				left = UDim.new(0, v2.Padding.Small),
				right = UDim.new(0, (math.max(v3.right, v2.Padding.Small)))
			},
			onAbsolutePositionChanged = v13,
			onAbsoluteSizeChanged = v13,
			testId = "in-game-build-shell-right-toolbar"
		}, createToolbarButtons(props, onActivated, "in-game-build-shell-landscape", v))
	end

	children.RightInset = rightInset
	local topRightInnerCorner

	if v7 and not v8 then
		topRightInnerCorner = React.createElement(View, {
			Position = mapped2,
			Size = UDim2.fromOffset(size_1200, size_1200),
			ZIndex = 1000,
			tag = "anchor-top-right clip",
			testId = "in-game-build-shell-top-right-inner-corner"
		}, {
			Image = React.createElement(Image, {
				Image = "rbxasset://textures/ui/AvatarExperience/CircleCutoutLargeNoBorder.png",
				Position = UDim2.fromOffset(-size_1200, 0),
				Size = UDim2.fromOffset(size_1200 * 2, size_1200 * 2),
				ZIndex = 1000,
				imageStyle = mapped7,
				testId = "in-game-build-shell-top-right-inner-corner-image"
			})
		})
	end

	children.TopRightInnerCorner = topRightInnerCorner
	local bottomLeftInnerCorner

	if not (v8 or v7 or state7 == 0) then
		bottomLeftInnerCorner = React.createElement(View, {
			Position = mapped4,
			Size = UDim2.fromOffset(size_1200, size_1200),
			ZIndex = 1000,
			tag = "anchor-bottom-left clip",
			testId = "in-game-build-shell-bottom-left-inner-corner"
		}, {
			Image = React.createElement(Image, {
				Image = "rbxasset://textures/ui/AvatarExperience/CircleCutoutLargeNoBorder.png",
				Position = UDim2.fromOffset(0, -size_1200),
				Size = UDim2.fromOffset(size_1200 * 2, size_1200 * 2),
				ZIndex = 1000,
				imageStyle = mapped7,
				testId = "in-game-build-shell-bottom-left-inner-corner-image"
			})
		})
	end

	children.BottomLeftInnerCorner = bottomLeftInnerCorner
	local bottomRightInnerCorner

	if not (v8 or not v7 and state7 == 0) then
		bottomRightInnerCorner = React.createElement(View, {
			Position = mapped5,
			Size = UDim2.fromOffset(size_1200, size_1200),
			ZIndex = 1000,
			tag = "anchor-bottom-right clip",
			testId = "in-game-build-shell-bottom-right-inner-corner"
		}, {
			Image = React.createElement(Image, {
				Image = "rbxasset://textures/ui/AvatarExperience/CircleCutoutLargeNoBorder.png",
				Position = UDim2.fromOffset(-size_1200, -size_1200),
				Size = UDim2.fromOffset(size_1200 * 2, size_1200 * 2),
				ZIndex = 1000,
				imageStyle = mapped7,
				testId = "in-game-build-shell-bottom-right-inner-corner-image"
			})
		})
	end

	children.BottomRightInnerCorner = bottomRightInnerCorner

	children.BottomBar = React.createElement(View, {
		Position = mapped3,
		Visible = not (v7 or v8),
		tag = "row align-x-center align-y-center gap-xsmall anchor-bottom-left size-full-0 auto-y bg-surface-100",
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		padding = {
			top = UDim.new(0, v2.Padding.Small),
			left = UDim.new(0, v2.Padding.Large),
			right = UDim.new(0, v2.Padding.Large),
			bottom = UDim.new(0, v2.Margin.Small + v3.bottom)
		},
		testId = "in-game-build-shell-bottom-inset"
	}, createToolbarButtons(props, onActivated, "in-game-build-shell", v))
	local element = createElement(View, v14, children)

	local v15 = v3.top + v4.top
	local createElement2 = React.createElement
	local fragment = React.Fragment
	local publishOverlay

	if not (state3 == nil or props.isLibraryMode) then
		publishOverlay = React.createElement(View, {
			Position = UDim2.fromOffset(0, v15),
			Size = UDim2.new(1, 0, 1, -v15),
			ZIndex = 2,
			ref = setState4,
			testId = "in-game-build-shell-publish-overlay"
		})
	end

	local publishSheet

	if not (state3 == nil or not props.isLibraryMode and state4 == nil) then
		local createElement3 = React.createElement
		local overlayProvider = Foundation.OverlayProvider

		if props.isLibraryMode then
			state4 = nil
		end

		publishSheet = createElement3(overlayProvider, { gui = state4 }, {
			Controller = React.createElement(PublishSheetController, {
				isOpen = state,
				target = state3,
				onClose = onClose,
				navigateToSubPage = navigateToSubPage,
				showPreviewButton = false
			})
		})
	end

	local publishPage

	if state3 ~= nil then
		publishPage = React.createElement(BuildPillMenuPageHost, {
			activePage = state2,
			target = state3,
			onClose = onClose2
		})
	end

	return createElement2(fragment, nil, {
		Shell = element,
		PublishOverlay = publishOverlay,
		PublishSheet = publishSheet,
		PublishPage = publishPage
	})
end

return InGameBuildShell
