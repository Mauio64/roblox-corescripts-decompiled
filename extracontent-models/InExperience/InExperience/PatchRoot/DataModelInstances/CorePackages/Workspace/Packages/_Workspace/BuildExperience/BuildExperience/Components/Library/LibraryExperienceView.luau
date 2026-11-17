local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local Motion = require(parent.Motion)

local Button = Foundation.Button
local IconButton = Foundation.IconButton
local SegmentedControl = Foundation.SegmentedControl
local Text = Foundation.Text
local View = Foundation.View

local ButtonVariant = Foundation.Enums.ButtonVariant
local IconName = Foundation.Enums.IconName
local InputSize = Foundation.Enums.InputSize
local SearchBarContainer = require(BuildExperience.Components.SearchBar.SearchBarContainer)
local LibraryWorldBackdropView = require(script.Parent.LibraryWorldCutout.LibraryWorldBackdropView)
require(script.Parent.LibraryWorldCutout.useLibraryWorldCutoutViewModel)
local releaseFocusWithin = require(BuildExperience.utils.releaseFocusWithin)
local useTypedQueryBinding = require(script.Parent.useTypedQueryBinding)
local useHardwareInsets = require(BuildExperience.Components.ChatSheet.useHardwareInsets)
local SharedFlags = require(parent.SharedFlags)
local FFlagBuildExperienceLibrary = SharedFlags.FFlagBuildExperienceLibrary

local v = {
	Top = { UDim2.fromOffset(-10000, -10000), UDim2.new(1, 20000, 0, 10000) },
	Bottom = { UDim2.new(0, -10000, 1, 0), UDim2.new(1, 20000, 0, 10000) },
	Left = { UDim2.fromOffset(-10000, 0), UDim2.new(0, 10000, 1, 0) },
	Right = { UDim2.fromScale(1, 0), UDim2.new(0, 10000, 1, 0) }
}

local function LibraryExperienceView(props)
	local v2 = Foundation.Hooks.useTokens()
	local reducedMotion = Foundation.Hooks.usePreferences().reducedMotion
	local bottom = useHardwareInsets().bottom
	local state, setState = React.useState(props.isOpen)
	local v3, v4 = Motion.useMotion({
		transparency = props.isOpen and 0 or 1
	})
	React.useEffect(function()
		local v5 = false

		if props.isOpen then
			setState(true)
		end

		v4(Motion.createState({
			transparency = props.isOpen and 0 or 1
		}, {
			default = Motion.transition({
				duration = (reducedMotion or not props.showModeControl) and 0 or 0.15,
				easingStyle = Enum.EasingStyle.Quad
			})
		}), {
			onAnimationComplete = function(p)
				if p and not (v5 or props.isOpen) then
					setState(false)
				end
			end
		})

		return function()
			v5 = true
		end
	end, { props.isOpen, props.showModeControl, reducedMotion, v4 })
	local ref = React.useRef(nil)
	React.useEffect(function()
		local current = ref.current

		if current == nil or props.isWorldAvailable ~= false then
			return nil
		end

		local selectablesByGuiObject = { [current] = current.Selectable }
		local textTransparenciesByGuiObject = {}

		for _, guiObject in current:GetDescendants() do
			if guiObject:IsA("GuiButton") then
				selectablesByGuiObject[guiObject] = guiObject.Selectable
			elseif guiObject:IsA("TextLabel") then
				textTransparenciesByGuiObject[guiObject] = guiObject.TextTransparency
			end
		end

		for k in selectablesByGuiObject do
			k.Selectable = false
		end

		for k, v5 in textTransparenciesByGuiObject do
			k.TextTransparency = 1 - (1 - v5) * 0.5
		end

		return function()
			for k, selectable in selectablesByGuiObject do
				k.Selectable = selectable
			end

			for k, textTransparency in textTransparenciesByGuiObject do
				k.TextTransparency = textTransparency
			end
		end
	end, { props.isWorldAvailable, props.showModeControl })
	local worldCutout = props.worldCutout
	local v5 = not (worldCutout == nil) and worldCutout.isTransitioning
	local groupTransparency

	if worldCutout == nil or not v5 then
		groupTransparency = v3.transparency
	else
		groupTransparency = worldCutout.progress
	end

	local isOpen = props.isOpen or state or v5
	local mapped = groupTransparency:map(function(transparency: number)
		return { Color3 = v2.Color.Surface.Surface_0.Color3, Transparency = transparency }
	end)

	local state2, setState2 = React.useState(nil)
	local v6 = props.isOpen

	if v6 then
		if props.onQueryChanged == nil then
			v6 = false
		else
			v6 = props.query ~= nil
		end
	end

	local onBack = props.onBack
	local title = props.title or props.assetLabel
	local shouldFocus = state2 == title
	local v7 = v6 and (shouldFocus or props.query ~= "")

	React.useEffect(function()
		setState2(nil)
	end, { props.title, props.isOpen })
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)

	local query, v8 = useTypedQueryBinding(props.query)

	local children = {}

	local function fn(p): boolean
		local current = ref3.current

		if p == nil or current == nil then
			return false
		end

		local v9 = Vector2.new(p.Position.X, p.Position.Y) - current.AbsolutePosition
		return v9.X >= 0 and v9.Y >= 0 and v9.X <= current.AbsoluteSize.X and v9.Y <= current.AbsoluteSize.Y
	end

	for k, v9 in v do
		children[k] = React.createElement(View, {
			Position = v9[1],
			Size = v9[2],
			backgroundStyle = mapped,
			testId = `Library.Experience.SafeAreaFill.{k}`
		})
	end

	local createElement = React.createElement
	local v9 = {
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
	local v10 = {
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
	local backgroundStyle

	if not props.isOpen then
		backgroundStyle = v2.Color.OverMedia.OverMedia_0
	end

	local createElement4 = React.createElement
	local icon

	if onBack == nil and not FFlagBuildExperienceLibrary then
		icon = IconName.X
	else
		icon = IconName.ChevronLargeLeft
	end

	local v11 = {
		icon = icon,
		isCircular = true,
		ref = ref3,
		onActivated = 0,
		size = 0,
		variant = 0,
		testId = 0
	}

	local function fn2() -- 4 equivalent calls inferred from this helper
		releaseFocusWithin(ref2.current)
	end

	local function fn3() -- 2 equivalent calls inferred from this helper
		v8("")

		if props.onSearchReset == nil then
			props.onQueryChanged("")
		else
			props.onSearchReset()
		end
	end

	function v11.onActivated()
		local v12 = onBack or props.onLeave
		fn2() -- inferred equivalent call
		setState2(nil)

		if not v7 or onBack ~= nil then
			v12()

			return
		end

		fn3() -- inferred equivalent call
	end
	v11.size = InputSize.Large
	v11.variant = ButtonVariant.Utility
	v11.testId = onBack == nil and "Library.Experience.Leave" or "Library.Experience.Back"
	local v12 = {
		Leading = createElement3(
			View,
			{
				LayoutOrder = 1,
				backgroundStyle = backgroundStyle,
				tag = "auto-xy radius-circle",
				testId = "Library.Experience.LeadingChip"
			},
			{
				Button = createElement4(IconButton, v11)
			}
		),
		Title = 0,
		Search = 0,
		SelectAll = 0
	}
	local title2

	if v7 then
		title2 = React.createElement(
			View,
			{ LayoutOrder = 2, tag = "grow auto-y", testId = "Library.Experience.Search" },
			{
				Input = React.createElement(SearchBarContainer, {
					key = title,
					query = query,
					placeholder = props.searchPlaceholder,
					setQuery = function(p: string)
						v8(p)
						props.onQueryChanged(p)
					end,
					clear = function()
						fn2() -- inferred equivalent call
						fn3() -- inferred equivalent call
					end,
					onDismiss = function()
						fn2() -- inferred equivalent call
						setState2(nil)
					end,
					onFocusLost = function(p)
						if query:getValue() == "" and not fn(p) then
							setState2(nil)
						end
					end,
					shouldFocus = shouldFocus
				})
			}
		)
	else
		title2 = React.createElement(Text, {
			LayoutOrder = 2,
			Text = title,
			tag = "fill text-heading-small text-align-x-left text-truncate-end content-emphasis",
			testId = "Library.Experience.Title"
		})
	end

	v12.Title = title2
	local search

	if v6 and not v7 then
		search = React.createElement(IconButton, {
			LayoutOrder = 3,
			icon = IconName.MagnifyingGlass,
			onActivated = function()
				setState2(title)
			end,
			size = InputSize.Large,
			variant = ButtonVariant.Utility,
			testId = "Library.Experience.Search.Action"
		})
	end

	v12.Search = search
	local selectAll

	if props.isOpen and props.onSelectAll ~= nil and props.selectAllLabel ~= nil then
		selectAll = React.createElement(Button, {
			LayoutOrder = 4,
			text = props.selectAllLabel,
			onActivated = function()
				fn2() -- inferred equivalent call
				props.onSelectAll()
			end,
			size = InputSize.Medium,
			variant = ButtonVariant.Utility,
			testId = "Library.Experience.SelectAll"
		})
	end

	v12.SelectAll = selectAll
	children2.Header = createElement2(View, v10, v12)
	local modeRow

	if props.showModeControl then
		modeRow = React.createElement(
			View,
			{
				LayoutOrder = 2,
				backgroundStyle = mapped,
				tag = "row align-x-center size-full-0 auto-y padding-x-medium padding-bottom-medium",
				testId = "Library.Experience.ModeRow"
			},
			{
				Control = React.createElement(SegmentedControl, {
					isCircular = true,
					segments = {
						{ id = "Library", text = props.assetLabel },
						{ id = "World", text = props.worldLabel, ref = ref }
					},
					value = props.isOpen and "Library" or "World",
					onActivated = function(p)
						if p == "Library" then
							props.onShowLibrary()
						elseif p == "World" then
							props.onShowWorld()
						end
					end,
					size = InputSize.Medium,
					testId = "Library.Experience.Mode"
				})
			}
		)
	end

	children2.ModeRow = modeRow

	local createElement5 = React.createElement
	local ref4

	if worldCutout ~= nil then
		ref4 = worldCutout.onContentRectChanged
	end

	local onAbsolutePositionChanged

	if worldCutout ~= nil then
		onAbsolutePositionChanged = worldCutout.onContentRectChanged
	end

	local onAbsoluteSizeChanged

	if worldCutout ~= nil then
		onAbsoluteSizeChanged = worldCutout.onContentRectChanged
	end

	local backdrop

	if worldCutout ~= nil then
		local createElement6 = React.createElement
		local hole

		if worldCutout.showHole then
			hole = worldCutout.hole
		end

		local v13 = {
			hole = hole,
			progress = worldCutout.progress,
			cornerRadius = v2.Radius.Medium,
			color = v2.Color.Surface.Surface_0.Color3,
			transparency = 0,
			Visible = 0,
			ZIndex = 1
		}
		local transparency

		if v5 then
			transparency = worldCutout.progress:map(function(): number
				return 0
			end)
		else
			transparency = v3.transparency
		end

		v13.transparency = transparency

		v13.Visible = isOpen
		backdrop = createElement6(LibraryWorldBackdropView, v13)
	end

	local v13 = {
		Backdrop = backdrop,
		Body = React.createElement(View, {
			Visible = isOpen,
			GroupTransparency = groupTransparency,
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
	local worldViewport

	if not (props.isOpen or v5 or props.onWorldViewportChanged == nil) then
		worldViewport = React.createElement(View, {
			ZIndex = 3,
			tag = "size-full",
			ref = props.onWorldViewportChanged,
			onAbsolutePositionChanged = props.onWorldViewportChanged,
			onAbsoluteSizeChanged = props.onWorldViewportChanged,
			backgroundStyle = { Transparency = 1 },
			testId = "Library.Experience.WorldViewport"
		})
	end

	v13.WorldViewport = worldViewport
	children2.Content = createElement5(View, {
		LayoutOrder = 3,
		ref = ref4,
		onAbsolutePositionChanged = onAbsolutePositionChanged,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		tag = "fill size-full-0 clip",
		testId = "Library.Experience.Content"
	}, v13)
	return createElement(View, v9, children2)
end

return LibraryExperienceView
