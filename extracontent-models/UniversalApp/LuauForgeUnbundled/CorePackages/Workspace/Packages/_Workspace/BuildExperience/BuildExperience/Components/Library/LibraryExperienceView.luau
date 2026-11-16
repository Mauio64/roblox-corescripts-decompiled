local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Motion = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Motion")

local iconButton = Foundation.IconButton
local segmentedControl = Foundation.SegmentedControl
local text = Foundation.Text
local view = Foundation.View

local buttonVariant = Foundation.Enums.ButtonVariant
local iconName = Foundation.Enums.IconName
local inputSize = Foundation.Enums.InputSize
local SearchBarContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/SearchBar/SearchBarContainer")
local LibraryWorldBackdropView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryWorldCutout/LibraryWorldBackdropView")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryWorldCutout/useLibraryWorldCutoutViewModel")
local releaseFocusWithin = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/releaseFocusWithin")
local useTypedQueryBinding = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/useTypedQueryBinding")
local useHardwareInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ChatSheet/useHardwareInsets")

local v5 = {
	Top = { UDim2.fromOffset(-10000, -10000), UDim2.new(1, 20000, 0, 10000) },
	Bottom = { UDim2.new(0, -10000, 1, 0), UDim2.new(1, 20000, 0, 10000) },
	Left = { UDim2.fromOffset(-10000, 0), UDim2.new(0, 10000, 1, 0) },
	Right = { UDim2.fromScale(1, 0), UDim2.new(0, 10000, 1, 0) }
}

local function LibraryExperienceView(props)
	local v6 = Foundation.Hooks.useTokens()
	local reducedMotion = Foundation.Hooks.usePreferences().reducedMotion
	local bottom = useHardwareInsets().bottom
	local state, setState = React.useState(props.isOpen)
	local v7, v8 = Motion.useMotion({
		transparency = props.isOpen and 0 or 1
	})
	React.useEffect(function()
		local v9 = false

		if props.isOpen then
			setState(true)
		end

		v8(Motion.createState({
			transparency = props.isOpen and 0 or 1
		}, {
			default = Motion.transition({
				duration = (reducedMotion or not props.showModeControl) and 0 or 0.15,
				easingStyle = Enum.EasingStyle.Quad
			})
		}), {
			onAnimationComplete = function(p2)
				if p2 and not (v9 or props.isOpen) then
					setState(false)
				end
			end
		})

		return function()
			v9 = true
		end
	end, { props.isOpen, props.showModeControl, reducedMotion, v8 })
	local ref = React.useRef(nil)
	React.useEffect(function()
		local current = ref.current

		if current == nil or props.isWorldAvailable ~= false then
			return nil
		end

		local selectablesByGuiObject = { [current] = current.Selectable }
		local textTransparenciesByGuiObject = {}

		for i, guiObject in current:GetDescendants() do
			if guiObject:IsA("GuiButton") then
				selectablesByGuiObject[guiObject] = guiObject.Selectable
			elseif guiObject:IsA("TextLabel") then
				textTransparenciesByGuiObject[guiObject] = guiObject.TextTransparency
			end
		end

		for k in selectablesByGuiObject do
			k.Selectable = false
		end

		for k, v9 in textTransparenciesByGuiObject do
			k.TextTransparency = 1 - (1 - v9) * 0.5
		end

		return function()
			for k, v9 in selectablesByGuiObject do
				k.Selectable = v9
			end

			for k, v9 in textTransparenciesByGuiObject do
				k.TextTransparency = v9
			end
		end
	end, { props.isWorldAvailable, props.showModeControl })
	local worldCutout = props.worldCutout
	local v9 = not (worldCutout == nil) and worldCutout.isTransitioning

	local v10 = if worldCutout == nil or not v9 then v7.transparency else worldCutout.progress
	local isOpen = props.isOpen or state or v9
	local mapped = v10:map(function(p2)
		return { Color3 = v6.Color.Surface.Surface_0.Color3, Transparency = p2 }
	end)

	local state2, setState2 = React.useState(nil)
	local v11 = props.isOpen

	if v11 then
		v11 = not (props.onQueryChanged == nil) and props.query ~= nil
	end

	local onBack = props.onBack
	local title = props.title or props.assetLabel
	local v12 = state2 == title
	local v13 = v11 and (v12 or props.query ~= "")

	React.useEffect(function()
		setState2(nil)
	end, { props.title, props.isOpen })
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)

	local v14, v15 = useTypedQueryBinding(props.query)

	local children = {}

	local function fn(p2): boolean
		local current = ref3.current

		if p2 == nil or current == nil then
			return false
		end

		local v16 = Vector2.new(p2.Position.X, p2.Position.Y) - current.AbsolutePosition
		return v16.X >= 0
			and v16.Y >= 0
			and v16.X <= current.AbsoluteSize.X
			and v16.Y <= current.AbsoluteSize.Y
	end

	for k, v16 in v5 do
		children[k] = React.createElement(view, {
			Position = v16[1],
			Size = v16[2],
			backgroundStyle = mapped,
			testId = `Library.Experience.SafeAreaFill.{k}`
		})
	end

	local createElement = React.createElement
	local v17 = {
		Size = UDim2.new(1, 0, 1, bottom),
		tag = "col",
		backgroundStyle = { Transparency = 1 },
		testId = "Library.Experience"
	}

	local children2 = {
		SafeAreaFill = React.createElement("Folder", nil, children),
		Header = 0,
		ModeRow = 0,
		Content = 0
	}
	local createElement2 = React.createElement
	local v19 = {
		LayoutOrder = 1,
		backgroundStyle = mapped,
		onActivated = function() end,
		selection = { Selectable = false },
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		tag = {
			["row align-y-center gap-small size-full-0 auto-y padding-x-medium padding-top-xxlarge"] = true,
			["padding-bottom-small"] = props.showModeControl == true,
			["padding-bottom-medium"] = props.showModeControl ~= true
		},
		ref = ref2,
		testId = "Library.Experience.Header"
	}

	local createElement3 = React.createElement

	local v23 = if not props.isOpen then v6.Color.OverMedia.OverMedia_0 else nil

	local createElement4 = React.createElement
	local v27 = if onBack == nil then iconName.X else iconName.ChevronLargeLeft
	local v20 = {
		Leading = createElement3(
			view,
			{
				LayoutOrder = 1,
				backgroundStyle = v23,
				tag = "auto-xy radius-circle",
				testId = "Library.Experience.LeadingChip"
			},
			{
				Button = createElement4(iconButton, {
					icon = v27,
					isCircular = true,
					ref = ref3,
					onActivated = function()
						local v28 = onBack or props.onLeave
						releaseFocusWithin(ref2.current)

						setState2(nil)

						if not v13 or onBack ~= nil then
							v28()

							return
						end

						v15("")

						if props.onSearchReset == nil then
							props.onQueryChanged("")
						else
							props.onSearchReset()
						end
					end,
					size = inputSize.Large,
					variant = buttonVariant.Utility,
					testId = onBack == nil and "Library.Experience.Leave" or "Library.Experience.Back"
				})
			}
		),
		Title = 0,
		Search = 0
	}
	local v28

	if v13 then
		v28 = React.createElement(
			view,
			{
				LayoutOrder = 2,
				tag = "grow auto-y",
				testId = "Library.Experience.Search"
			},
			{
				Input = React.createElement(SearchBarContainer, {
					key = title,
					query = v14,
					placeholder = props.searchPlaceholder,
					setQuery = function(p2)
						v15(p2)
						props.onQueryChanged(p2)
					end,
					clear = function()
						releaseFocusWithin(ref2.current)

						v15("")

						if props.onSearchReset == nil then
							props.onQueryChanged("")
						else
							props.onSearchReset()
						end
					end,
					onDismiss = function()
						releaseFocusWithin(ref2.current)

						setState2(nil)
					end,
					onFocusLost = function(p2)
						if v14:getValue() == "" and not fn(p2) then
							setState2(nil)
						end
					end,
					shouldFocus = v12
				})
			}
		)
	else
		v28 = React.createElement(text, {
			LayoutOrder = 2,
			Text = title,
			tag = "fill text-heading-small text-align-x-left text-truncate-end content-emphasis",
			testId = "Library.Experience.Title"
		})
	end

	v20.Title = v28
	local v29

	if v11 and not v13 then
		v29 = React.createElement(iconButton, {
			LayoutOrder = 3,
			icon = iconName.MagnifyingGlass,
			onActivated = function()
				setState2(title)
			end,
			size = inputSize.Large,
			variant = buttonVariant.Utility,
			testId = "Library.Experience.Search.Action"
		})
	end

	v20.Search = v29
	children2.Header = createElement2(view, v19, v20)
	local v30

	if props.showModeControl then
		v30 = React.createElement(
			view,
			{
				LayoutOrder = 2,
				backgroundStyle = mapped,
				tag = "row align-x-center size-full-0 auto-y padding-x-medium padding-bottom-medium",
				testId = "Library.Experience.ModeRow"
			},
			{
				Control = React.createElement(segmentedControl, {
					isCircular = true,
					segments = {
						{ id = "Library", text = props.assetLabel },
						{ id = "World", text = props.worldLabel, ref = ref }
					},
					value = props.isOpen and "Library" or "World",
					onActivated = function(p2)
						if p2 == "Library" then
							props.onShowLibrary()
						elseif p2 == "World" then
							props.onShowWorld()
						end
					end,
					size = inputSize.Medium,
					testId = "Library.Experience.Mode"
				})
			}
		)
	end

	children2.ModeRow = v30

	local createElement5 = React.createElement

	local v33 = if worldCutout ~= nil then worldCutout.onContentRectChanged else nil
	local v34 = if worldCutout ~= nil then worldCutout.onContentRectChanged else nil
	local v35 = if worldCutout ~= nil then worldCutout.onContentRectChanged else nil
	local v37

	if worldCutout ~= nil then
		local createElement6 = React.createElement
		local v40 = if worldCutout.showHole then worldCutout.hole else nil
		local v39 = {
			hole = v40,
			progress = worldCutout.progress,
			cornerRadius = v6.Radius.Medium,
			color = v6.Color.Surface.Surface_0.Color3,
			transparency = 0,
			Visible = 0,
			ZIndex = 1
		}
		local v41

		if v9 then
			v41 = worldCutout.progress:map(function(): number
				return 0
			end)
		else
			v41 = v7.transparency
		end

		v39.transparency = v41

		v39.Visible = isOpen
		v37 = createElement6(LibraryWorldBackdropView, v39)
	end

	local v36 = {
		Backdrop = v37,
		Body = React.createElement(view, {
			Visible = isOpen,
			GroupTransparency = v10,
			ZIndex = 2,
			backgroundStyle = worldCutout ~= nil and { Transparency = 1 } or nil,
			tag = {
				["size-full clip"] = true,
				["bg-surface-0"] = worldCutout == nil
			},
			testId = "Library.Experience.Body"
		}, props.children),
		WorldViewport = 0
	}
	local v38 = if not (props.isOpen or v9) and props.onWorldViewportChanged ~= nil then React.createElement(view, {
		ZIndex = 3,
		tag = "size-full",
		ref = props.onWorldViewportChanged,
		onAbsolutePositionChanged = props.onWorldViewportChanged,
		onAbsoluteSizeChanged = props.onWorldViewportChanged,
		backgroundStyle = { Transparency = 1 },
		testId = "Library.Experience.WorldViewport"
	}) else nil
	v36.WorldViewport = v38
	children2.Content = createElement5(view, {
		LayoutOrder = 3,
		ref = v33,
		onAbsolutePositionChanged = v34,
		onAbsoluteSizeChanged = v35,
		tag = "fill size-full-0 clip",
		testId = "Library.Experience.Content"
	}, v36)
	return createElement(view, v17, children2)
end

return LibraryExperienceView
