local Parent = script:FindFirstAncestor("AppBlox").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local Responsive = require(Parent.Responsive)
local View = Foundation.View
local IconButton = Foundation.IconButton
local useTokens = Foundation.Hooks.useTokens
local useDeviceInsets = Responsive.useDeviceInsets
local DetailsPageLayoutContext = require(script.Parent.DetailsPageLayoutContext)

local function DetailsPageLayoutHeader(t1: {[any]: any}, p1) -- line: 45
	-- upvalues: useTokens (copy), useDeviceInsets (copy), React (copy), DetailsPageLayoutContext (copy), Foundation (copy), Responsive (copy), IconButton (copy), View (copy)
	local v13 = useTokens()
	local v14 = useDeviceInsets()
	local v15 = React.useContext(DetailsPageLayoutContext)
	local setHasHeader = v15.setHasHeader

	React.useEffect(function() -- line: 51
		-- upvalues: setHasHeader (copy)
		setHasHeader(true)

		return function() -- line: 53
			-- upvalues: setHasHeader (copy)
			setHasHeader(false)
		end
	end, { setHasHeader })

	local hasFullBleed = v15.hasFullBleed
	local headerBarHeight = v15.headerBarHeight
	local stickyHeaderActive = v15.stickyHeaderActive
	local headerOpacity = v15.headerOpacity
	local top = v14.top
	local onClose = v15.onClose
	local isFullscreenOverlay = v15.isFullscreenOverlay
	local onExitFullscreenOverlay = v15.onExitFullscreenOverlay
	local v25 = t1.closeIconName or Foundation.Enums.IconName.ChevronLargeLeft
	local v26 = t1.backgroundColor or v13.Color.Surface.Surface_0
	local v27 = Responsive.useBreakpointXOrSmaller(Responsive.Keys.Small)
	local testId = v15.testId

	assert(testId, "DetailsPageLayout.Header must be used within DetailsPageLayout.Root")

	local v29 = isFullscreenOverlay and onExitFullscreenOverlay or onClose
	local v30 = if not isFullscreenOverlay then v25 else Foundation.Enums.IconName.ChevronLargeLeft
	local v31 = if not isFullscreenOverlay then headerOpacity else nil
	local v32 = if not hasFullBleed or not v31 then nil else v31:map(function(n1: number) -- line: 85
		return n1 >= 0.5
	end)
	local v33 = t1.children and (hasFullBleed and v31 or (not hasFullBleed or stickyHeaderActive))
	local v34 = if not v29 then nil else React.createElement(IconButton, {
		variant = Foundation.Enums.ButtonVariant.Utility,
		size = if not v27 then Foundation.Enums.InputSize.Large else Foundation.Enums.InputSize.Medium,
		icon = v30,
		onActivated = v29,
		testId = if not testId then nil else `{ testId }--close-button`
	})
	local v35 = if not t1.fullWidthContent then React.createElement(View, {
		LayoutOrder = 1,
		tag = {
			["row align-y-center fill size-full-0 auto-y padding-x-medium"] = v27,
			["row align-y-center fill size-full-0 auto-y padding-x-xlarge"] = not v27
		},
		padding = if not (top > 0) then nil else {
			top = UDim.new(0, top)
		}
	}, {
		Container = if not v34 then nil else React.createElement(View, {
			tag = {
				["auto-xy radius-medium"] = t1.backgroundColor ~= nil,
				["auto-xy radius-medium bg-over-media-0"] = t1.backgroundColor == nil
			},
			backgroundStyle = if not t1.backgroundColor then nil else {
				Color3 = v26.Color3,
				Transparency = v26.Transparency
			}
		}, {
			CloseButton = v34
		}),
		Children = if not v33 then nil else React.createElement(View, {
			tag = "fill auto-y",
			LayoutOrder = 1,
			Visible = v32
		}, {
			Content = React.createElement(React.Fragment, nil, t1.children)
		})
	}) else React.createElement(View, {
		LayoutOrder = 1,
		tag = "fill size-full-0"
	}, {
		CloseButtonOverlay = if not v34 then nil else React.createElement(View, {
			ZIndex = 2,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, if not v27 then v13.Padding.XLarge else v13.Padding.Medium, 0.5, (math.floor(top / 2))),
			tag = {
				["auto-xy radius-medium"] = t1.backgroundColor ~= nil,
				["auto-xy radius-medium bg-over-media-0"] = t1.backgroundColor == nil
			},
			backgroundStyle = if not t1.backgroundColor then nil else {
				Color3 = v26.Color3,
				Transparency = v26.Transparency
			}
		}, {
			CloseButton = v34
		}),
		Children = if not v33 then nil else React.createElement(View, {
			Size = UDim2.new(1, 0, 1, -top),
			Position = UDim2.new(0, 0, 0, top),
			Visible = v32
		}, {
			Content = React.createElement(React.Fragment, nil, t1.children)
		})
	})

	return React.createElement(View, {
		ZIndex = 2,
		tag = "col",
		Size = UDim2.new(1, 0, 0, headerBarHeight),
		backgroundStyle = if not not hasFullBleed and v31 then v31:map(function(n2: number) -- line: 179
			-- upvalues: v26 (copy)
			return {
				Color3 = v26.Color3,
				Transparency = math.lerp(1, v26.Transparency, n2)
			}
		end) else {
			Color3 = v26.Color3,
			Transparency = v26.Transparency
		},
		ref = p1
	}, {
		HeaderContent = v35,
		BottomBorder = React.createElement(View, {
			LayoutOrder = 2,
			backgroundStyle = if not v31 then {
				Color3 = v13.Color.Stroke.Muted.Color3,
				Transparency = v13.Color.Stroke.Muted.Transparency
			} else v31:map(function(n3: number) -- line: 191
				-- upvalues: v13 (copy)
				return {
					Color3 = v13.Color.Stroke.Muted.Color3,
					Transparency = math.lerp(1, v13.Color.Stroke.Muted.Transparency, n3)
				}
			end),
			testId = if not testId then nil else `{ testId }--header--bottom-border`,
			Size = UDim2.new(1, 0, 0, v13.Stroke.Standard)
		})
	})
end

return React.memo(React.forwardRef(DetailsPageLayoutHeader))
