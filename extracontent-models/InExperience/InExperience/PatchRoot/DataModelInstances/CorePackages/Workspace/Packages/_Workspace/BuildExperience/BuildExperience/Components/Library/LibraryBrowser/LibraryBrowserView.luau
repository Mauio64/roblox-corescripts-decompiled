local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local AppComposition = require(parent.AppComposition)
local Display = require(parent.Display)
local SignalsReact = require(parent.SignalsReact)

local LibraryTile = require(script.Parent.Parent.LibraryTile)
require(script.Parent.Parent.LibraryTypes)
local LibraryWorldCutoutView = require(script.Parent.Parent.LibraryWorldCutout.LibraryWorldCutoutView)
local useHardwareInsets = require(BuildExperience.Components.ChatSheet.useHardwareInsets)

local Icon = Foundation.Icon
local ScrollView = Foundation.ScrollView
local Skeleton = Foundation.Skeleton
local Text = Foundation.Text
local View = Foundation.View

local IconName = Foundation.Enums.IconName
local IconSize = Foundation.Enums.IconSize
local Radius = Foundation.Enums.Radius
local ScrollBarVisibility = Foundation.Enums.ScrollBarVisibility

local function renderLoadingTiles(p: string, p2: number, p3: number, p4)
	local children = {}

	for i = 1, 4 do
		children[tostring(i)] = React.createElement(View, {
			LayoutOrder = i,
			Size = UDim2.fromOffset(p3, p3 + p4.Size.Size_1000),
			tag = "col gap-small",
			testId = `Library.Category.{p}.Skeleton.{i}`
		}, {
			Thumbnail = React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.fromOffset(p3, p3),
				radius = Radius.Medium
			}),
			Title = React.createElement(Skeleton, {
				LayoutOrder = 2,
				Size = UDim2.fromOffset(p4.Size.Size_1800, p4.Size.Size_400),
				radius = Radius.Small
			})
		})
	end

	return React.createElement(ScrollView, {
		Size = UDim2.new(1, 0, 0, p3 + p4.Size.Size_1000),
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.X,
			CanvasSize = UDim2.fromOffset(0, 0),
			ScrollingDirection = Enum.ScrollingDirection.X,
			scrollBarVisibility = ScrollBarVisibility.None
		},
		testId = `Library.Category.{p}.Skeleton`
	}, {
		Content = React.createElement(View, {
			padding = { left = UDim.new(0, p2), right = UDim.new(0, p2) },
			tag = "row gap-small size-0-full auto-x"
		}, children)
	})
end

local function renderCategory(props, k: number, margin: number, p: number, p2)
	local v = p + p2.Size.Size_1000

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
			Size = UDim2.fromOffset(p, v),
			mediaSize = UDim2.fromOffset(p, p)
		})
	end

	local onOpenCategory

	if props.status == "Ready" then
		onOpenCategory = props.onOpenCategory
	end

	local content

	if props.status == "Loading" or props.status == "NotReady" then
		content = renderLoadingTiles(categoryKey, margin, p, p2)
	else
		content = React.createElement(ScrollView, {
			onCanvasPositionChanged = props.onScrollChanged,
			onAbsoluteCanvasSizeChanged = props.onScrollChanged,
			onAbsoluteWindowSizeChanged = props.onScrollChanged,
			Size = UDim2.new(1, 0, 0, v),
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.X,
				CanvasSize = UDim2.fromOffset(0, 0),
				ScrollingDirection = Enum.ScrollingDirection.X,
				scrollBarVisibility = ScrollBarVisibility.None
			},
			testId = `Library.Section.{categoryKey}.Carousel`
		}, {
			Content = React.createElement(View, {
				padding = { left = UDim.new(0, margin), right = UDim.new(0, margin) },
				tag = "row gap-small size-0-full auto-x"
			}, children)
		})
	end

	local createElement = React.createElement
	local v2 = {
		LayoutOrder = k,
		tag = "col gap-large size-full-0 auto-y",
		testId = `Library.Category.{categoryKey}`
	}

	local createElement2 = React.createElement
	local v3 = {
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
	local v4 = {
		Title = React.createElement(Text, {
			LayoutOrder = 1,
			Text = props.title,
			tag = "auto-xy text-heading-small text-align-x-left content-emphasis",
			testId = `Library.Section.{categoryKey}.Title`
		}),
		Chevron = 0
	}
	local chevron

	if onOpenCategory ~= nil then
		chevron = React.createElement(Icon, {
			LayoutOrder = 2,
			name = IconName.ChevronLargeRight,
			size = IconSize.Small,
			style = p2.Color.Content.Default,
			testId = `Library.Category.{categoryKey}.Header.Chevron`
		})
	end

	v4.Chevron = chevron
	return createElement(View, v2, {
		Header = createElement2(View, v3, v4),
		Cells = React.createElement(
			View,
			{
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, v),
				testId = `Library.Category.{categoryKey}.Cells`
			},
			{ Content = content }
		)
	})
end

local function LibraryBrowserView(props)
	local margin = AppComposition.useCompositionLayout().margin
	local bottom = useHardwareInsets().bottom
	local v = Foundation.Hooks.useTokens()
	local v2 = Foundation.Hooks.useScaledValue(160)

	if SignalsReact.useSignalState(Display.GetDisplayStore(false).getDisplaySize) == Enum.DisplaySize.Small then
		v2 = v.Size.Size_2400
	end

	local children = {}

	for k, category in props.categories do
		children[category.categoryKey or category.itemKind] = renderCategory(category, k, margin, v2, v)
	end

	if props.status == "Loading" or props.status == "NotReady" then
		children = {}

		for k, v3 in { "Model", "Image", "Sound" } do
			children[v3] = React.createElement(
				View,
				{
					LayoutOrder = k,
					tag = "col gap-large size-full-0 auto-y",
					testId = `Library.Section.{v3}.Skeleton`
				},
				{
					Heading = React.createElement(View, {
						LayoutOrder = 1,
						padding = { left = UDim.new(0, margin), right = UDim.new(0, margin) },
						tag = "size-full-0 auto-y"
					}, {
						Skeleton = React.createElement(Skeleton, {
							Size = UDim2.fromOffset(v.Size.Size_2800, v.Size.Size_600),
							radius = Radius.Small,
							testId = `Library.Section.{v3}.HeadingSkeleton`
						})
					}),
					Cards = React.createElement(View, {
						LayoutOrder = 2,
						tag = "size-full-0 auto-y"
					}, {
						Content = renderLoadingTiles(v3, margin, v2, v)
					})
				}
			)
		end
	elseif #props.categories == 0 then
		children.Empty = React.createElement(Text, {
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

	local element = React.createElement(View, {
		padding = {
			bottom = UDim.new(0, v.Padding.Small + bottom)
		},
		tag = "col size-full-0 auto-y padding-top-medium",
		testId = "Library.Browser.Content"
	}, {
		Categories = React.createElement(View, {
			LayoutOrder = 1,
			tag = "col gap-large size-full-0 auto-y"
		}, children)
	})

	return React.createElement(View, { tag = "col size-full", testId = "Library.Browser" }, {
		Body = React.createElement(ScrollView, {
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
