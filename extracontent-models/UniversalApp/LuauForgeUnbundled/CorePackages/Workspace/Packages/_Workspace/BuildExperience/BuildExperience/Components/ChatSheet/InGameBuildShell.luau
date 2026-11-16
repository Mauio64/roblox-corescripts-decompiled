local CoreGuiCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/CoreGuiCommon")
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Display")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local Motion = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Motion")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local BuildPillMenuPageHost = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/BuildPillMenu/BuildPillMenuPageHost")
local PublishSheetController = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/PublishSheet/PublishSheetController")
local getCurrentExperienceProject = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/getCurrentExperienceProject")
local useHardwareInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ChatSheet/useHardwareInsets")
local FFlagBuildCheckGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildCheckGamePermissions")
local useGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/useGamePermissions")

local image = Foundation.Image
local iconButton = Foundation.IconButton
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize
local stateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useOverlay = Foundation.Hooks.useOverlay
local usePreferences = Foundation.Hooks.usePreferences
local useTokens = Foundation.Hooks.useTokens

local function noop() end

local function createToolbarButtons(props, onActivated, p2, p3)
	local v5 = FFlagBuildCheckGamePermissions and not p3.canEditOnBuild

	if props.isSelecting then
		local v6 = {
			Cancel = React.createElement(iconButton, {
				LayoutOrder = 1,
				icon = iconName.X,
				onActivated = props.onSelectionCancelled or noop,
				size = inputSize.Medium,
				testId = `{p2}-cancel-selection`,
				variant = buttonVariant.Utility
			}),
			Confirm = 0
		}

		local v7 = if props.onSelectionConfirmed ~= nil then React.createElement(iconButton, {
			LayoutOrder = 2,
			icon = iconName.CheckLarge,
			isDisabled = v5,
			onActivated = props.onSelectionConfirmed,
			size = inputSize.Medium,
			testId = `{p2}-confirm-selection`,
			variant = buttonVariant.Utility
		}) else nil
		v6.Confirm = v7
		return v6
	else
		local v6 = {
			Chat = React.createElement(iconButton, {
				LayoutOrder = 1,
				icon = iconName.Nebula,
				onActivated = props.onActivated,
				size = inputSize.Medium,
				testId = `{p2}-chat`,
				variant = buttonVariant.Utility
			}),
			Select = React.createElement(iconButton, {
				LayoutOrder = 2,
				icon = iconName.CursorStars,
				isDisabled = v5,
				onActivated = props.onSelectionActivated or noop,
				size = inputSize.Medium,
				testId = `{p2}-select`,
				variant = buttonVariant.Utility
			}),
			Capture = React.createElement(iconButton, {
				LayoutOrder = 3,
				icon = iconName.FrameCameraCenter,
				isDisabled = v5,
				onActivated = props.onCaptureActivated or noop,
				size = inputSize.Medium,
				testId = `{p2}-capture`,
				variant = buttonVariant.Utility
			}),
			Publish = React.createElement(iconButton, {
				LayoutOrder = 4,
				icon = iconName.ArrowUpRightFromSquare,
				isDisabled = FFlagBuildCheckGamePermissions and not p3.canPublish,
				onActivated = onActivated,
				size = inputSize.Medium,
				testId = `{p2}-publish`,
				variant = buttonVariant.Utility
			})
		}

		if props.isLibraryMode then
			v6.Select = nil
			v6.Capture = nil
		end

		return v6
	end
end

local function InGameBuildShell(props)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState(nil)
	local v5

	if FFlagBuildCheckGamePermissions then
		v5 = useGamePermissions({ universeId = getCurrentExperienceProject().universeId })
	end

	local v6 = React.useCallback(function()
		local v7 = getCurrentExperienceProject()

		if v7.universeId == nil then
			return
		end

		setState3({
			universeId = v7.universeId,
			placeId = v7.placeId,
			sessionId = nil,
			isNewGameTarget = false
		})

		setState(true)
	end, {})
	local v7 = React.useCallback(function()
		setState(false)
	end, {})
	local v8 = React.useCallback(function()
		setState2(nil)
	end, {})
	local v9 = React.useCallback(function(p2, data)
		setState2({
			type = "screen",
			screen = p2,
			target = {
				universeId = data.universeId,
				placeId = data.placeId,
				sessionId = data.sessionId,
				isNewGameTarget = data.isNewGameTarget or false
			}
		})
	end, {})
	local v10 = useTokens()
	local reducedMotion = usePreferences().reducedMotion
	local v12 = useHardwareInsets((useOverlay()))
	local displayStore = Display.GetDisplayStore(false)
	local keepOutAreasStore = CoreGuiCommon.Stores.GetKeepOutAreasStore(false)
	local v13 = SignalsReact.useSignalState(displayStore.getGuiInset)
	local state4, setState4 = React.useState(nil)
	local v14 = SignalsReact.useSignalState(displayStore.getViewportSize)
	local v15 = SignalsReact.useSignalState(displayStore.getDisplaySize)
	local v16 = v14.X > v14.Y
	local v17 = not (v15 == nil) and v15 ~= Enum.DisplaySize.Small
	local v18 = v17 or props.isVisible ~= false
	local state5, setState5 = React.useState(nil)
	local v19 = React.useCallback(function(p2)
		setState5(p2)
	end, {})
	local size_1200 = v10.Size.Size_1200
	local v20 = React.useMemo(function()
		return {
			visible = Motion.createState({ progress = 1 }, {
				default = Motion.transition({
					duration = reducedMotion and 0 or v10.Time.Time_300,
					easingStyle = v10.Ease.StandardOut
				})
			}),
			hidden = Motion.createState({ progress = 0 }, {
				default = Motion.transition({
					duration = reducedMotion and 0 or v10.Time.Time_100,
					easingStyle = v10.Ease.StandardIn
				})
			})
		}
	end, { reducedMotion, v10 })

	local useMotion = Motion.useMotion
	local v21 = if v18 then v20.visible else v20.hidden
	local v22, v23 = useMotion(v21)
	local state6, setState6 = React.useState(v18)

	React.useEffect(function()
		local v24 = false

		if v18 then
			setState6(true)
			v23(v20.visible)
		else
			v23(v20.hidden, {
				onAnimationComplete = function(p2)
					if not v24 and p2 == true then
						if props.onInsetsChanged ~= nil then
							props.onInsetsChanged(0, 0, 0)
						end

						setState6(false)
					end
				end
			})
		end

		return function()
			v24 = true
		end
	end, { v23, v20, v18, props.onInsetsChanged })

	local state7, setState7 = React.useState(0)
	local state8, setState8 = React.useState(0)
	local v24 = React.useCallback(function(p2)
		setState7(p2.AbsoluteSize.Y)
	end, {})
	local v25 = React.useCallback(function(p2)
		setState8(p2.AbsoluteSize.X)
		keepOutAreasStore.setKeepOutArea("build-shell-right-inset", p2.AbsolutePosition, p2.AbsoluteSize)
	end, { keepOutAreasStore })
	local v26 = React.useCallback(function(p2)
		if props.onInsetsChanged ~= nil then
			props.onInsetsChanged(
				0,
				(not v16 or v17) and 0 or p2.AbsoluteSize.X,
				(v16 or v17) and 0 or p2.AbsoluteSize.Y
			)
		end
	end, { v16, props.onInsetsChanged, v17 })
	React.useEffect(function()
		if v17 and props.onInsetsChanged ~= nil then
			props.onInsetsChanged(0, 0, 0)
		end
	end, { props.onInsetsChanged, v17 })
	React.useEffect(function()
		if not state6 or not v16 or v17 then
			keepOutAreasStore.removeKeepOutArea("build-shell-right-inset")
		end
	end, { v16, state6, keepOutAreasStore, v17 })
	React.useEffect(function()
		return function()
			keepOutAreasStore.removeKeepOutArea("build-shell-right-inset")
		end
	end, { keepOutAreasStore })
	local progress = v22.progress
	local mapped = progress:map(function(p2)
		return UDim2.new(1, state8 * (1 - p2), 0, 0)
	end)

	local mapped2 = progress:map(function(p2)
		return UDim2.new(1, -state8 * p2 + 1, 0, 0)
	end)

	local mapped3 = progress:map(function(p2)
		return UDim2.new(0, 0, 1, state7 * (1 - p2))
	end)

	local mapped4 = progress:map(function(p2)
		return UDim2.new(0, -1, 1, -state7 * p2 + 1)
	end)

	local mapped5 = progress:map(function(p2)
		return UDim2.new(1, -(not v16 and 0 or state8) * p2 + 1, 1, -(v16 and 0 or state7) * p2 + 1)
	end)

	local mapped6 = progress:map(function(p2)
		if v17 then
			return UDim2.fromOffset(0, 0)
		end

		return UDim2.fromOffset((not v16 and 0 or state8) * p2, (v16 and 0 or state7) * p2)
	end)

	local surface_100 = v10.Color.Surface.Surface_100
	local mapped7 = progress:map(function(p2)
		return {
			Color3 = surface_100.Color3,
			Transparency = 1 - (1 - surface_100.Transparency) * p2
		}
	end)

	local createElement = React.createElement
	local v28 = {
		Visible = state6,
		tag = "size-full",
		testId = props.testId or "in-game-build-shell"
	}

	local v29 = if v17 then React.createElement(view, {
		Position = UDim2.fromOffset(v12.left + v10.Padding.Large, v12.top + v10.Padding.Large),
		Size = UDim2.new(
			1,
			-(v12.left + v12.right + v10.Padding.Large * 2),
			1,
			-(v12.top + v12.bottom + v10.Padding.Large * 2)
		),
		ref = v19,
		testId = "in-game-build-shell-floating-toolbar-bounds"
	}, {
		Toolbar = React.createElement(view, {
			Visible = v18,
			ZIndex = 1000,
			onActivated = noop,
			stateLayer = { affordance = stateLayerAffordance.None },
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
				createToolbarButtons(props, v6, "in-game-build-shell-floating", v5)
			),
			DragAffordance = React.createElement(
				view,
				{
					LayoutOrder = 6,
					tag = "position-center-center anchor-center-center auto-xy padding-xxsmall"
				},
				{
					Icon = React.createElement(image, {
						Image = "component_assets/dragger_small",
						tag = "position-center-center anchor-center-center size-600-400 content-muted"
					})
				}
			)
		})
	}) else nil
	local children = {
		FloatingToolbarBounds = v29,
		InsetReporter = React.createElement(view, {
			Size = mapped6,
			onAbsoluteSizeChanged = v26,
			testId = "in-game-build-shell-inset-reporter"
		}),
		RightInset = 0,
		TopRightInnerCorner = 0,
		BottomLeftInnerCorner = 0,
		BottomRightInnerCorner = 0,
		BottomBar = 0
	}

	local v30 = if v16 and not v17 then React.createElement(view, {
		Position = mapped,
		ZIndex = 1000,
		tag = "col align-x-center align-y-center gap-xsmall anchor-top-right size-0-full auto-x bg-surface-100",
		padding = {
			left = UDim.new(0, v10.Padding.Small),
			right = UDim.new(0, (math.max(v12.right, v10.Padding.Small)))
		},
		onAbsolutePositionChanged = v25,
		onAbsoluteSizeChanged = v25,
		testId = "in-game-build-shell-right-toolbar"
	}, createToolbarButtons(props, v6, "in-game-build-shell-landscape", v5)) else nil
	children.RightInset = v30

	local v31 = if v16 and not v17 then React.createElement(view, {
		Position = mapped2,
		Size = UDim2.fromOffset(size_1200, size_1200),
		ZIndex = 1000,
		tag = "anchor-top-right clip",
		testId = "in-game-build-shell-top-right-inner-corner"
	}, {
		Image = React.createElement(image, {
			Image = "rbxasset://textures/ui/AvatarExperience/CircleCutoutLargeNoBorder.png",
			Position = UDim2.fromOffset(-size_1200, 0),
			Size = UDim2.fromOffset(size_1200 * 2, size_1200 * 2),
			ZIndex = 1000,
			imageStyle = mapped7,
			testId = "in-game-build-shell-top-right-inner-corner-image"
		})
	}) else nil
	children.TopRightInnerCorner = v31

	local v32 = if not (v17 or v16) and state7 ~= 0 then React.createElement(view, {
		Position = mapped4,
		Size = UDim2.fromOffset(size_1200, size_1200),
		ZIndex = 1000,
		tag = "anchor-bottom-left clip",
		testId = "in-game-build-shell-bottom-left-inner-corner"
	}, {
		Image = React.createElement(image, {
			Image = "rbxasset://textures/ui/AvatarExperience/CircleCutoutLargeNoBorder.png",
			Position = UDim2.fromOffset(0, -size_1200),
			Size = UDim2.fromOffset(size_1200 * 2, size_1200 * 2),
			ZIndex = 1000,
			imageStyle = mapped7,
			testId = "in-game-build-shell-bottom-left-inner-corner-image"
		})
	}) else nil
	children.BottomLeftInnerCorner = v32

	local v33 = if not v17 and (not not v16 or state7 ~= 0) then React.createElement(view, {
		Position = mapped5,
		Size = UDim2.fromOffset(size_1200, size_1200),
		ZIndex = 1000,
		tag = "anchor-bottom-right clip",
		testId = "in-game-build-shell-bottom-right-inner-corner"
	}, {
		Image = React.createElement(image, {
			Image = "rbxasset://textures/ui/AvatarExperience/CircleCutoutLargeNoBorder.png",
			Position = UDim2.fromOffset(-size_1200, -size_1200),
			Size = UDim2.fromOffset(size_1200 * 2, size_1200 * 2),
			ZIndex = 1000,
			imageStyle = mapped7,
			testId = "in-game-build-shell-bottom-right-inner-corner-image"
		})
	}) else nil
	children.BottomRightInnerCorner = v33

	children.BottomBar = React.createElement(view, {
		Position = mapped3,
		Visible = not (v16 or v17),
		tag = "row align-x-center align-y-center gap-xsmall anchor-bottom-left size-full-0 auto-y bg-surface-100",
		onAbsoluteSizeChanged = v24,
		padding = {
			top = UDim.new(0, v10.Padding.Small),
			left = UDim.new(0, v10.Padding.Large),
			right = UDim.new(0, v10.Padding.Large),
			bottom = UDim.new(0, v10.Margin.Small + v12.bottom)
		},
		testId = "in-game-build-shell-bottom-inset"
	}, createToolbarButtons(props, v6, "in-game-build-shell", v5))
	local element = createElement(view, v28, children)

	local v34 = v12.top + v13.top
	local createElement2 = React.createElement
	local fragment = React.Fragment

	local v37 = if state3 ~= nil and not props.isLibraryMode then React.createElement(view, {
		Position = UDim2.fromOffset(0, v34),
		Size = UDim2.new(1, 0, 1, -v34),
		ZIndex = 2,
		ref = setState4,
		testId = "in-game-build-shell-publish-overlay"
	}) else nil
	local v38

	if not (state3 == nil or not props.isLibraryMode and state4 == nil) then
		local createElement3 = React.createElement
		local overlayProvider = Foundation.OverlayProvider

		if props.isLibraryMode then
			state4 = nil
		end

		v38 = createElement3(overlayProvider, { gui = state4 }, {
			Controller = React.createElement(PublishSheetController, {
				isOpen = state,
				target = state3,
				onClose = v7,
				navigateToSubPage = v9,
				showPreviewButton = false
			})
		})
	end

	local v39 = if state3 ~= nil then React.createElement(BuildPillMenuPageHost, {
		activePage = state2,
		target = state3,
		onClose = v8
	}) else nil
	return createElement2(fragment, nil, {
		Shell = element,
		PublishOverlay = v37,
		PublishSheet = v38,
		PublishPage = v39
	})
end

return InGameBuildShell
