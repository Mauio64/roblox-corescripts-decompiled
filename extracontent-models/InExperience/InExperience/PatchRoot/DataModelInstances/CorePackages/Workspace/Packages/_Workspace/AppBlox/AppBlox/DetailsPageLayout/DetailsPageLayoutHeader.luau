local parent = script:FindFirstAncestor("AppBlox").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local Responsive = require(parent.Responsive)

local View = Foundation.View
local IconButton = Foundation.IconButton
local useTokens = Foundation.Hooks.useTokens
local useDeviceInsets = Responsive.useDeviceInsets

local DetailsPageLayoutContext = require(script.Parent.DetailsPageLayoutContext)

local function DetailsPageLayoutHeader(props, ref)
	local v = useTokens()
	local v2 = useDeviceInsets()
	local v3 = React.useContext(DetailsPageLayoutContext)
	local setHasHeader = v3.setHasHeader

	React.useEffect(function()
		setHasHeader(true)
		return function()
			setHasHeader(false)
		end
	end, { setHasHeader })

	local hasFullBleed = v3.hasFullBleed
	local headerBarHeight = v3.headerBarHeight
	local stickyHeaderActive = v3.stickyHeaderActive
	local headerOpacity = v3.headerOpacity
	local top = v2.top
	local onActivated = v3.onClose
	local isFullscreenOverlay = v3.isFullscreenOverlay
	local onExitFullscreenOverlay = v3.onExitFullscreenOverlay
	local icon = props.closeIconName or Foundation.Enums.IconName.ChevronLargeLeft
	local backgroundColor = props.backgroundColor or v.Color.Surface.Surface_0
	local rowalignycenterfillsizefull0autoypaddingxmedium = Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small)
	local testId = v3.testId

	assert(testId, "DetailsPageLayout.Header must be used within DetailsPageLayout.Root")
	onActivated = isFullscreenOverlay and onExitFullscreenOverlay or onActivated

	if isFullscreenOverlay then
		icon = Foundation.Enums.IconName.ChevronLargeLeft
	end

	if isFullscreenOverlay then
		headerOpacity = nil
	end

	local visible

	if hasFullBleed and headerOpacity then
		visible = headerOpacity:map(function(p: number): boolean
			return p >= 0.5
		end)
	end

	local v4 = props.children and (hasFullBleed and headerOpacity or not hasFullBleed or stickyHeaderActive)
	local closeButton

	if onActivated then
		local createElement = React.createElement
		local v5 = {
			variant = Foundation.Enums.ButtonVariant.Utility,
			size = 0,
			icon = 0,
			onActivated = 0,
			testId = 0
		}
		local size

		if rowalignycenterfillsizefull0autoypaddingxmedium then
			size = Foundation.Enums.InputSize.Medium
		else
			size = Foundation.Enums.InputSize.Large
		end

		v5.size = size
		v5.icon = icon
		v5.onActivated = onActivated
		local testId2

		if testId then
			testId2 = `{testId}--close-button`
		end

		v5.testId = testId2
		closeButton = createElement(IconButton, v5)
	end

	local headerContent

	if props.fullWidthContent then
		local createElement = React.createElement
		local closeButtonOverlay

		if closeButton then
			local createElement2 = React.createElement
			local v5 = {
				ZIndex = 2,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = 0,
				tag = 0,
				backgroundStyle = 0
			}
			local v6

			if rowalignycenterfillsizefull0autoypaddingxmedium then
				v6 = v.Padding.Medium
			else
				v6 = v.Padding.XLarge
			end

			v5.Position = UDim2.new(0, v6, 0.5, (math.floor(top / 2)))

			v5.tag = {
				["auto-xy radius-medium"] = props.backgroundColor ~= nil,
				["auto-xy radius-medium bg-over-media-0"] = props.backgroundColor == nil
			}

			v5.backgroundStyle = props.backgroundColor
				and { Color3 = backgroundColor.Color3, Transparency = backgroundColor.Transparency }
				or nil
			closeButtonOverlay = createElement2(View, v5, { CloseButton = closeButton })
		end

		local children

		if v4 then
			children = React.createElement(View, {
				Size = UDim2.new(1, 0, 1, -top),
				Position = UDim2.new(0, 0, 0, top),
				Visible = visible
			}, {
				Content = React.createElement(React.Fragment, nil, props.children)
			})
		end

		headerContent = createElement(View, { LayoutOrder = 1, tag = "fill size-full-0" }, {
			CloseButtonOverlay = closeButtonOverlay,
			Children = children
		})
	else
		local createElement = React.createElement
		local v5 = {
			LayoutOrder = 1,
			tag = {
				["row align-y-center fill size-full-0 auto-y padding-x-medium"] = rowalignycenterfillsizefull0autoypaddingxmedium,
				["row align-y-center fill size-full-0 auto-y padding-x-xlarge"] = not rowalignycenterfillsizefull0autoypaddingxmedium
			},
			padding = top > 0 and { top = UDim.new(0, top) } or nil
		}
		local container

		if closeButton then
			container = React.createElement(View, {
				tag = {
					["auto-xy radius-medium"] = props.backgroundColor ~= nil,
					["auto-xy radius-medium bg-over-media-0"] = props.backgroundColor == nil
				},
				backgroundStyle = props.backgroundColor and {
					Color3 = backgroundColor.Color3,
					Transparency = backgroundColor.Transparency
				} or nil
			}, { CloseButton = closeButton })
		end

		local children

		if v4 then
			children = React.createElement(View, {
				tag = "fill auto-y",
				LayoutOrder = 1,
				Visible = visible
			}, {
				Content = React.createElement(React.Fragment, nil, props.children)
			})
		end

		headerContent = createElement(View, v5, { Container = container, Children = children })
	end

	local createElement = React.createElement
	local v5 = {
		ZIndex = 2,
		Size = UDim2.new(1, 0, 0, headerBarHeight),
		tag = "col",
		backgroundStyle = 0,
		ref = 0
	}
	local backgroundStyle

	if hasFullBleed and headerOpacity then
		backgroundStyle = headerOpacity:map(function(p: number)
			return {
				Color3 = backgroundColor.Color3,
				Transparency = math.lerp(1, backgroundColor.Transparency, p)
			}
		end)
	else
		backgroundStyle = {
			Color3 = backgroundColor.Color3,
			Transparency = backgroundColor.Transparency
		}
	end

	v5.backgroundStyle = backgroundStyle

	v5.ref = ref

	local createElement2 = React.createElement
	local backgroundStyle2

	if headerOpacity then
		backgroundStyle2 = headerOpacity:map(function(p: number)
			return {
				Color3 = v.Color.Stroke.Muted.Color3,
				Transparency = math.lerp(1, v.Color.Stroke.Muted.Transparency, p)
			}
		end)
	else
		backgroundStyle2 = {
			Color3 = v.Color.Stroke.Muted.Color3,
			Transparency = v.Color.Stroke.Muted.Transparency
		}
	end

	local testId2

	if testId then
		testId2 = `{testId}--header--bottom-border`
	end

	return createElement(View, v5, {
		HeaderContent = headerContent,
		BottomBorder = createElement2(View, {
			LayoutOrder = 2,
			backgroundStyle = backgroundStyle2,
			testId = testId2,
			Size = UDim2.new(1, 0, 0, v.Stroke.Standard)
		})
	})
end

return React.memo(React.forwardRef(DetailsPageLayoutHeader))
