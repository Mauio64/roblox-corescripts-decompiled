local AvatarExperienceSearch = script:FindFirstAncestor("AvatarExperienceSearch")
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local AvatarExperienceSearchParent = AvatarExperienceSearch.Parent
local React = require(AvatarExperienceSearchParent.React)
local UIBlox = require(AvatarExperienceSearchParent.UIBlox)
local Otter = require(AvatarExperienceSearchParent.Otter)
local tutils = require(AvatarExperienceSearchParent.tutils)
local useTokens = require(AvatarExperienceSearchParent.Foundation).Hooks.useTokens
local Foundation = require(AvatarExperienceSearchParent.Foundation)
local Responsive = require(AvatarExperienceSearchParent.Responsive)
local getIconSize = UIBlox.App.ImageSet.getIconSize
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local Interactable = UIBlox.Core.Control.Interactable
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local Images = UIBlox.App.ImageSet.Images
local v16 = Images["icons/actions/cycleLeft"]
local v17 = Images["icons/actions/cycleRight"]
local t1 = {
	frequency = 2,
	dampingRatio = 0.9,
	restingPositionLimit = 0.5,
	restingVelocityLimit = 0.1
}

function getMaxNumOfItemsVisible(t2: {[any]: any}) -- line: 49
	local v20 = t2.itemWidth + t2.itemPadding

	return (math.floor((t2.absoluteWidth + t2.itemPadding) / v20))
end
function CarouselScrollButton(t3: {[any]: any}) -- line: 60
	-- upvalues: useTokens (copy), React (copy), Interactable (copy), ImageSetLabel (copy), getIconSize (copy), IconSize (copy)
	local v22 = useTokens()

	return React.createElement(Interactable, {
		AutoButtonColor = false,
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = v22.Color.OverMedia.OverMedia_0.Color3,
		BackgroundTransparency = v22.Color.OverMedia.OverMedia_0.Transparency,
		BorderSizePixel = 0,
		[React.Event.Activated] = t3.onActivate
	}, {
		CarouselScrollButtonIcon = React.createElement(ImageSetLabel, {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(getIconSize(IconSize.Medium), getIconSize(IconSize.Medium)),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Image = t3.icon,
			ImageColor3 = v22.Color.ActionStandard.Foreground.Color3,
			ImageTransparency = v22.Color.ActionStandard.Foreground.Transparency
		})
	})
end
function Carousel(t4: {[any]: any}) -- line: 83
	-- upvalues: useTokens (copy), Responsive (copy), React (copy), Otter (copy), UserGameSettings (copy), t1 (copy), tutils (copy), Foundation (copy), v16 (copy), v17 (copy)
	local v24 = useTokens()
	local v25 = Responsive.useLastInput()
	local v26, v27 = React.useState(false)
	local v28, v29 = React.useState(false)
	local v30, v31 = React.useState(0)
	local v32, v33 = React.useState(0)
	local v34, v35 = React.useState(0)
	local v36 = React.useRef(nil)
	local v37 = React.useRef(nil)
	local v38 = React.useRef(Otter.createSingleMotor(0))
	local v39 = React.useCallback(function(p1) -- line: 98
		-- upvalues: v35 (copy)
		v35(p1.AbsoluteSize.X)
	end, {})
	local v40 = React.useMemo(function() -- line: 106
		-- upvalues: t4 (copy), React (copy), v39 (copy)
		local t5 = {}
		local v53 = false

		for v54, v55 in t4.children or {} do
			if not v53 then
				t5[v54] = React.createElement("Frame", {
					Size = UDim2.fromOffset(0, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					[React.Change.AbsoluteSize] = v39,
					LayoutOrder = (not v55.props or not v55.props.LayoutOrder) and 1 or v55.props.LayoutOrder
				}, v55)
				v53 = true
			else
				t5[v54] = v55
			end
		end

		return t5
	end, {
		t4.children,
		v39
	})
	local v41 = React.useCallback(function() -- line: 128
		-- upvalues: v37 (copy), v34 (copy), t4 (copy)
		local current = v37.current
		local n1 = 1

		if current and current.CanvasPosition.X > 0 then
			n1 = math.floor(current.CanvasPosition.X / (v34 + t4.itemPadding)) + 1
		end

		return n1
	end, {
		v34,
		t4.itemPadding
	})
	local v42 = React.useCallback(function(n2: number) -- line: 137
		-- upvalues: v34 (copy), t4 (copy)
		return (n2 - 1) * v34 + (n2 - 1) * t4.itemPadding
	end, {
		v34,
		t4.itemPadding
	})
	local v43 = React.useCallback(function(n3: number) -- line: 144
		-- upvalues: t4 (copy), v28 (copy), v37 (copy), v42 (copy), UserGameSettings (copy), v29 (copy), v38 (copy), Otter (copy), t1 (copy)
		if t4.isScrollingDisabled or (v28 or not v37.current) then
			return
		end

		local current = v37.current
		local CanvasPositionX = current.CanvasPosition.X
		local v62 = v42(n3)

		if UserGameSettings.ReducedMotion then
			current.CanvasPosition = Vector2.new(v62, 0)
			v29(false)

			return
		end

		if v38.current then
			v38.current:destroy()
		end

		v38.current = Otter.createSingleMotor(CanvasPositionX)
		v38.current:onStep(function(p2) -- line: 163
			-- upvalues: v29 (copy), current (copy)
			v29(true)
			current.CanvasPosition = Vector2.new(p2, 0)
		end)
		v38.current:onComplete(function() -- line: 167
			-- upvalues: v29 (copy)
			v29(false)
		end)
		v38.current:setGoal(Otter.spring(v62, t1))
	end, {
		t4.isScrollingDisabled,
		v28,
		v42
	})
	local v44 = React.useCallback(function(n4: number) -- line: 174
		-- upvalues: v28 (copy), tutils (copy), v40 (copy), v43 (copy)
		if v28 then
			return
		end

		local v64 = math.max(1, (math.min(n4, (tutils.fieldCount(v40)))))

		v43(v64)
	end, {
		v28,
		v43,
		v40
	})
	local v45 = React.useCallback(function(p3) -- line: 183
		-- upvalues: v31 (copy), v33 (copy), v34 (copy), t4 (copy)
		v31(p3.AbsoluteSize.X)
		v33(getMaxNumOfItemsVisible({
			itemWidth = v34,
			itemPadding = t4.itemPadding,
			absoluteWidth = p3.AbsoluteSize.X
		}))
	end, {
		v34,
		t4.itemPadding
	})
	local v46 = React.useCallback(function() -- line: 192
		-- upvalues: v41 (copy), v44 (copy), v32 (copy)
		local v66 = v41()

		v44(v66 - v32)
	end, {
		v44,
		v41,
		v32
	})
	local v47 = React.useCallback(function() -- line: 197
		-- upvalues: v41 (copy), v44 (copy), v32 (copy)
		local v67 = v41()

		v44(v67 + v32)
	end, {
		v44,
		v41,
		v32
	})
	local v48 = React.useCallback(function(p4) -- line: 202
		-- upvalues: v25 (copy), Responsive (copy), Foundation (copy), v27 (copy)
		if v25 == Responsive.Input.Pointer then
			if p4 == Foundation.Enums.ControlState.Default then
				v27(false)

				return
			end

			if p4 == Foundation.Enums.ControlState.Hover then
				v27(true)
			end
		end
	end, { v25 })

	React.useEffect(function() -- line: 212
		-- upvalues: v38 (copy)
		return function() -- line: 213
			-- upvalues: v38 (copy)
			if v38.current then
				v38.current:destroy()
			end
		end
	end, {})
	React.useEffect(function() -- line: 220
		-- upvalues: v33 (copy), v34 (copy), t4 (copy), v30 (copy)
		v33(getMaxNumOfItemsVisible({
			itemWidth = v34,
			itemPadding = t4.itemPadding,
			absoluteWidth = v30
		}))
	end, {
		v30,
		v34,
		t4.itemPadding
	})

	local v49 = React.useMemo(function() -- line: 228
		-- upvalues: v37 (copy), v26 (copy)
		local current = v37.current

		if current then
			return v26 and current.CanvasPosition.X > 0
		end

		return false
	end, {
		v26,
		v28
	})
	local v50 = React.useMemo(function() -- line: 236
		-- upvalues: v37 (copy), v30 (copy), v26 (copy)
		local current = v37.current

		if current then
			local v71 = current.CanvasPosition.X + v30 >= current.AbsoluteCanvasSize.X

			return v26 and not v71
		end

		return false
	end, {
		v26,
		v30,
		v28
	})

	return React.createElement(Foundation.View, {
		tag = "size-full-0 auto-y clip position-top-left",
		stateLayer = {
			affordance = Foundation.Enums.StateLayerAffordance.None
		},
		backgroundStyle = v24.Color.None,
		ref = v36,
		onStateChanged = v48,
		onAbsoluteSizeChanged = v45
	}, {
		CarouselLeftMargin = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 2,
			Position = UDim2.fromScale(0, 0),
			AnchorPoint = Vector2.new(0, 0),
			Size = UDim2.new(0, v24.Size.Size_1000, 1, 0)
		}, {
			ScrollLeftButton = if not v49 then nil else React.createElement(CarouselScrollButton, {
				icon = v16,
				onActivate = v46
			})
		}),
		CarouselScrollingFrame = React.createElement("ScrollingFrame", {
			Size = UDim2.new(1, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 0,
			BackgroundTransparency = 1,
			ClipsDescendants = false,
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			ScrollingEnabled = not t4.isScrollingDisabled and not v28,
			ScrollingDirection = Enum.ScrollingDirection.X,
			ElasticBehavior = Enum.ElasticBehavior.Always,
			Selectable = false,
			[React.Change.CanvasPosition] = t4.onChangeCanvasPosition,
			ref = function(p5) -- line: 282
				-- upvalues: v37 (copy), t4 (copy)
				if p5 then
					v37.current = p5
					t4.scrollingFrameRef = p5
				end
			end
		}, { React.createElement(React.Fragment, nil, {
			CarouselListLayout = React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, t4.itemPadding),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			CarouselPadding = React.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, t4.carouselMargin),
				PaddingRight = UDim.new(0, t4.carouselMargin)
			}),
			CarouselContent = React.createElement(React.Fragment, nil, v40)
		}) }),
		CarouselRightMargin = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 2,
			Position = UDim2.fromScale(1, 0),
			AnchorPoint = Vector2.new(1, 0),
			Size = UDim2.new(0, v24.Size.Size_1000, 1, 0)
		}, {
			ScrollRightButton = if not v50 then nil else React.createElement(CarouselScrollButton, {
				icon = v17,
				onActivate = v47
			})
		})
	})
end

return Carousel
