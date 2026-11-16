local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Foundation")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/Responsive")

local view = Foundation.View
local iconButton = Foundation.IconButton
local useTokens = Foundation.Hooks.useTokens
local useDeviceInsets = Responsive.useDeviceInsets

local DetailsPageLayoutContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppBlox/AppBlox/DetailsPageLayout/DetailsPageLayoutContext")

local function DetailsPageLayoutHeader(props, ref)
	local v5 = useTokens()
	local v6 = useDeviceInsets()
	local v7 = React.useContext(DetailsPageLayoutContext)
	local setHasHeader = v7.setHasHeader

	React.useEffect(function()
		setHasHeader(true)
		return function()
			setHasHeader(false)
		end
	end, { setHasHeader })

	local hasFullBleed = v7.hasFullBleed
	local headerBarHeight = v7.headerBarHeight
	local stickyHeaderActive = v7.stickyHeaderActive
	local headerOpacity = v7.headerOpacity
	local top = v6.top
	local v8 = v7.onClose
	local isFullscreenOverlay = v7.isFullscreenOverlay
	local onExitFullscreenOverlay = v7.onExitFullscreenOverlay
	local v9 = props.closeIconName or Foundation.Enums.IconName.ChevronLargeLeft
	local backgroundColor = props.backgroundColor or v5.Color.Surface.Surface_0
	local v10 = Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small)
	local testId = v7.testId

	assert(testId, "DetailsPageLayout.Header must be used within DetailsPageLayout.Root")
	v8 = isFullscreenOverlay and onExitFullscreenOverlay or v8

	if isFullscreenOverlay then
		v9 = Foundation.Enums.IconName.ChevronLargeLeft
	end

	if isFullscreenOverlay then
		headerOpacity = nil
	end

	local v11

	if hasFullBleed and headerOpacity then
		v11 = headerOpacity:map(function(p2): boolean
			return p2 >= 0.5
		end)
	end

	local v12 = props.children
		and (hasFullBleed and headerOpacity or not hasFullBleed or stickyHeaderActive)
	local v13

	if v8 then
		local createElement = React.createElement
		local v15 = {
			variant = Foundation.Enums.ButtonVariant.Utility,
			size = 0,
			icon = 0,
			onActivated = 0,
			testId = 0
		}
		local v16 = if v10 then Foundation.Enums.InputSize.Medium else Foundation.Enums.InputSize.Large
		v15.size = v16
		v15.icon = v9
		v15.onActivated = v8
		local v17 = if testId then `{testId}--close-button` else nil
		v15.testId = v17
		v13 = createElement(iconButton, v15)
	end

	local v14

	if props.fullWidthContent then
		local createElement = React.createElement
		local v18

		if v13 then
			local createElement2 = React.createElement
			local v20 = {
				ZIndex = 2,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = 0,
				tag = 0,
				backgroundStyle = 0
			}
			local newUDim2 = UDim2.new

			local v22 = if v10 then v5.Padding.Medium else v5.Padding.XLarge
			v20.Position = newUDim2(0, v22, 0.5, (math.floor(top / 2)))

			v20.tag = {
				["auto-xy radius-medium"] = props.backgroundColor ~= nil,
				["auto-xy radius-medium bg-over-media-0"] = props.backgroundColor == nil
			}

			v20.backgroundStyle = props.backgroundColor
				and {
					Color3 = backgroundColor.Color3,
					Transparency = backgroundColor.Transparency
				}
				or nil
			v18 = createElement2(view, v20, { CloseButton = v13 })
		end

		local v19 = if v12 then React.createElement(view, {
			Size = UDim2.new(1, 0, 1, -top),
			Position = UDim2.new(0, 0, 0, top),
			Visible = v11
		}, {
			Content = React.createElement(React.Fragment, nil, props.children)
		}) else nil
		v14 = createElement(view, { LayoutOrder = 1, tag = "fill size-full-0" }, {
			CloseButtonOverlay = v18,
			Children = v19
		})
	else
		local createElement = React.createElement
		local v16 = {
			LayoutOrder = 1,
			tag = {
				["row align-y-center fill size-full-0 auto-y padding-x-medium"] = v10,
				["row align-y-center fill size-full-0 auto-y padding-x-xlarge"] = not v10
			},
			padding = top > 0 and { top = UDim.new(0, top) } or nil
		}

		local v18 = if v13 then React.createElement(view, {
			tag = {
				["auto-xy radius-medium"] = props.backgroundColor ~= nil,
				["auto-xy radius-medium bg-over-media-0"] = props.backgroundColor == nil
			},
			backgroundStyle = props.backgroundColor and {
				Color3 = backgroundColor.Color3,
				Transparency = backgroundColor.Transparency
			} or nil
		}, { CloseButton = v13 }) else nil

		local v19 = if v12 then React.createElement(
			view,
			{ tag = "fill auto-y", LayoutOrder = 1, Visible = v11 },
			{
				Content = React.createElement(React.Fragment, nil, props.children)
			}
		) else nil
		v14 = createElement(view, v16, { Container = v18, Children = v19 })
	end

	local createElement = React.createElement
	local v16 = {
		ZIndex = 2,
		Size = UDim2.new(1, 0, 0, headerBarHeight),
		tag = "col",
		backgroundStyle = 0,
		ref = 0
	}
	local v17

	if hasFullBleed and headerOpacity then
		v17 = headerOpacity:map(function(p2)
			return {
				Color3 = backgroundColor.Color3,
				Transparency = math.lerp(1, backgroundColor.Transparency, p2)
			}
		end)
	else
		v17 = {
			Color3 = backgroundColor.Color3,
			Transparency = backgroundColor.Transparency
		}
	end

	v16.backgroundStyle = v17

	v16.ref = ref

	local createElement2 = React.createElement
	local v21

	if headerOpacity then
		v21 = headerOpacity:map(function(p2)
			return {
				Color3 = v5.Color.Stroke.Muted.Color3,
				Transparency = math.lerp(1, v5.Color.Stroke.Muted.Transparency, p2)
			}
		end)
	else
		v21 = {
			Color3 = v5.Color.Stroke.Muted.Color3,
			Transparency = v5.Color.Stroke.Muted.Transparency
		}
	end

	local v22 = if testId then `{testId}--header--bottom-border` else nil
	return createElement(view, v16, {
		HeaderContent = v14,
		BottomBorder = createElement2(view, {
			LayoutOrder = 2,
			backgroundStyle = v21,
			testId = v22,
			Size = UDim2.new(1, 0, 0, v5.Stroke.Standard)
		})
	})
end

return React.memo(React.forwardRef(DetailsPageLayoutHeader))
