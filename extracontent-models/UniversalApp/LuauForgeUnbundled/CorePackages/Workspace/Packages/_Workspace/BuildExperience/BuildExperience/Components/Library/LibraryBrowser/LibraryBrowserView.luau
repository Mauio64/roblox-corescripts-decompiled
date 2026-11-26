local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local AppComposition = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/AppComposition")
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Display")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local LibraryTile = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryTile")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryTypes")
local LibraryWorldCutoutView = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Library/LibraryWorldCutout/LibraryWorldCutoutView")
local useHardwareInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/ChatSheet/useHardwareInsets")

local icon = Foundation.Icon
local scrollView = Foundation.ScrollView
local skeleton = Foundation.Skeleton
local text = Foundation.Text
local view = Foundation.View

local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local radius = Foundation.Enums.Radius
local scrollBarVisibility = Foundation.Enums.ScrollBarVisibility

local function renderLoadingTiles(p2, p3, p4, p5)
	local children = {}

	for i = 1, 4 do
		children[tostring(i)] = React.createElement(view, {
			LayoutOrder = i,
			Size = UDim2.fromOffset(p4, p4 + p5.Size.Size_1000),
			tag = "col gap-small",
			testId = `Library.Category.{p2}.Skeleton.{i}`
		}, {
			Thumbnail = React.createElement(skeleton, {
				LayoutOrder = 1,
				Size = UDim2.fromOffset(p4, p4),
				radius = radius.Medium
			}),
			Title = React.createElement(skeleton, {
				LayoutOrder = 2,
				Size = UDim2.fromOffset(p5.Size.Size_1800, p5.Size.Size_400),
				radius = radius.Small
			})
		})
	end

	return React.createElement(scrollView, {
		Size = UDim2.new(1, 0, 0, p4 + p5.Size.Size_1000),
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			CanvasSize = UDim2.fromOffset(0, 0),
			ScrollingDirection = Enum.ScrollingDirection.X,
			scrollBarVisibility = scrollBarVisibility.None
		},
		testId = `Library.Category.{p2}.Skeleton`
	}, {
		Content = React.createElement(view, {
			padding = { left = UDim.new(0, p3), right = UDim.new(0, p3) },
			tag = "row gap-small size-0-full auto-x"
		}, children)
	})
end

local function renderCategory(props, k, margin, p2, p3)
	local v5 = p2 + p3.Size.Size_1000

	local categoryKey = props.categoryKey or props.itemKind
	local children = {}

	for k2, item in props.items do
		children[item.tileKey or item.itemId or tostring(k2)] = React.createElement(LibraryTile, {
			compact = true,
			tileKey = item.tileKey,
			itemId = item.itemId,
			itemKind = item.itemKind,
			isFolder = item.isFolder,
			folderPreview = item.folderPreview,
			displayName = item.displayName,
			unavailableText = item.unavailableText,
			thumbnail = item.thumbnail,
			model = item.model,
			onActivated = item.onActivated,
			LayoutOrder = k2,
			Size = UDim2.fromOffset(p2, v5),
			mediaSize = UDim2.fromOffset(p2, p2)
		})
	end

	local onOpenCategory = if props.status == "Ready" then props.onOpenCategory else nil
	local v6

	if props.status == "Loading" or props.status == "NotReady" then
		v6 = renderLoadingTiles(categoryKey, margin, p2, p3)
	else
		v6 = React.createElement(scrollView, {
			onCanvasPositionChanged = props.onScrollChanged,
			onAbsoluteCanvasSizeChanged = props.onScrollChanged,
			onAbsoluteWindowSizeChanged = props.onScrollChanged,
			Size = UDim2.new(1, 0, 0, v5),
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.X,
				CanvasSize = UDim2.fromOffset(0, 0),
				ScrollingDirection = Enum.ScrollingDirection.X,
				scrollBarVisibility = scrollBarVisibility.None
			},
			testId = `Library.Section.{categoryKey}.Carousel`
		}, {
			Content = React.createElement(view, {
				padding = { left = UDim.new(0, margin), right = UDim.new(0, margin) },
				tag = "row gap-small size-0-full auto-x"
			}, children)
		})
	end

	local createElement = React.createElement
	local v8 = {
		LayoutOrder = k,
		tag = "col gap-large size-full-0 auto-y",
		testId = `Library.Category.{categoryKey}`
	}

	local createElement2 = React.createElement
	local v10 = {
		LayoutOrder = 1,
		onActivated = onOpenCategory,
		selection = {
			Selectable = onOpenCategory ~= nil
		},
		stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
		padding = { left = UDim.new(0, margin), right = UDim.new(0, margin) },
		tag = "row align-y-center gap-xsmall size-full-600",
		testId = `Library.Category.{categoryKey}.Header`
	}
	local v11 = {
		Title = React.createElement(text, {
			LayoutOrder = 1,
			Text = props.title,
			tag = "auto-xy text-heading-small text-align-x-left content-emphasis",
			testId = `Library.Section.{categoryKey}.Title`
		}),
		Chevron = 0
	}

	local v12 = if onOpenCategory ~= nil then React.createElement(icon, {
		LayoutOrder = 2,
		name = iconName.ChevronLargeRight,
		size = iconSize.Small,
		style = p3.Color.Content.Default,
		testId = `Library.Category.{categoryKey}.Header.Chevron`
	}) else nil
	v11.Chevron = v12
	return createElement(view, v8, {
		Header = createElement2(view, v10, v11),
		Cells = React.createElement(
			view,
			{
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, v5),
				testId = `Library.Category.{categoryKey}.Cells`
			},
			{ Content = v6 }
		)
	})
end

local function LibraryBrowserView(props)
	local margin = AppComposition.useCompositionLayout().margin
	local bottom = useHardwareInsets().bottom
	local v5 = Foundation.Hooks.useTokens()
	local v6 = Foundation.Hooks.useScaledValue(160)

	if SignalsReact.useSignalState(Display.GetDisplayStore(false).getDisplaySize) == Enum.DisplaySize.Small then
		v6 = v5.Size.Size_2400
	end

	local children = {}

	for k, category in props.categories do
		children[category.categoryKey or category.itemKind] = renderCategory(category, k, margin, v6, v5)
	end

	if props.status == "Loading" or props.status == "NotReady" then
		children = {}

		for k, v7 in { "Model", "Image", "Sound" } do
			children[v7] = React.createElement(
				view,
				{
					LayoutOrder = k,
					tag = "col gap-large size-full-0 auto-y",
					testId = `Library.Section.{v7}.Skeleton`
				},
				{
					Heading = React.createElement(view, {
						LayoutOrder = 1,
						padding = {
							left = UDim.new(0, margin),
							right = UDim.new(0, margin)
						},
						tag = "size-full-0 auto-y"
					}, {
						Skeleton = React.createElement(skeleton, {
							Size = UDim2.fromOffset(v5.Size.Size_2800, v5.Size.Size_600),
							radius = radius.Small,
							testId = `Library.Section.{v7}.HeadingSkeleton`
						})
					}),
					Cards = React.createElement(view, {
						LayoutOrder = 2,
						tag = "size-full-0 auto-y"
					}, {
						Content = renderLoadingTiles(v7, margin, v6, v5)
					})
				}
			)
		end
	elseif #props.categories == 0 then
		children.Empty = React.createElement(text, {
			Text = props.strings.empty,
			tag = "size-full-0 auto-y padding-large text-body-medium text-align-x-center content-muted"
		})
	end

	local worldCutout = props.worldCutout

	if worldCutout ~= nil then
		children.WorldCutout = React.createElement(LibraryWorldCutoutView, {
			LayoutOrder = 0,
			inset = margin,
			isLoading = props.status == "Loading" or props.status == "NotReady",
			title = worldCutout.title,
			onActivated = worldCutout.onActivated,
			onRectChanged = worldCutout.onRectChanged
		})
	end

	local element = React.createElement(view, {
		padding = {
			bottom = UDim.new(0, v5.Padding.Small + bottom)
		},
		tag = "col size-full-0 auto-y padding-top-medium",
		testId = "Library.Browser.Content"
	}, {
		Categories = React.createElement(
			view,
			{ LayoutOrder = 1, tag = "col gap-large size-full-0 auto-y" },
			children
		)
	})

	return React.createElement(view, {
		tag = "col size-full",
		testId = "Library.Browser"
	}, {
		Body = React.createElement(scrollView, {
			LayoutOrder = 1,
			tag = "fill size-full-0",
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.fromOffset(0, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y
			}
		}, { Content = element })
	})
end

return LibraryBrowserView
