local VirtualEvents = script:FindFirstAncestor("VirtualEvents")
local React = require(VirtualEvents.Parent.React)
local Foundation = require(VirtualEvents.Parent.Foundation)

require(VirtualEvents.Parent.GraphQLServer)

local useScreenSize = require(VirtualEvents.Parent.RobloxAppHooks).useScreenSize
local EventDetailsBody = require(VirtualEvents.Components.EventDetailsBody)
local EventActionBar = require(VirtualEvents.Components.EventActionBar)

require(VirtualEvents.Parent.VirtualEventsState)

local constants = require(VirtualEvents.constants)
local useTokens = Foundation.Hooks.useTokens

local function EventDetailsContainer(t1: {[any]: any}) -- line: 31
	-- upvalues: useTokens (copy), useScreenSize (copy), React (copy), EventDetailsBody (copy), constants (copy), EventActionBar (copy)
	local v11 = useTokens()
	local v12 = useScreenSize()
	local experienceDetails = t1.virtualEvent.experienceDetails
	local v14, v15 = React.useState(false)
	local v16, v17 = React.useState(0.99)
	local v18 = React.useRef(0)
	local v19 = React.useCallback(function() -- line: 40
		-- upvalues: v18 (copy), t1 (copy), v17 (copy)
		if not v18.current or not t1.bottomHeight then
			return
		end

		if t1.bottomHeight > 0 and t1.bottomHeight < v18.current then
			v17(1 - t1.bottomHeight / v18.current)
		end
	end, { t1.bottomHeight })
	local v20 = React.useCallback(function(p1) -- line: 49
		-- upvalues: v18 (copy), v19 (copy)
		if v18.current and v18.current ~= p1.AbsoluteSize.Y then
			v18.current = p1.AbsoluteSize.Y
			v19()
		end
	end, { v19 })

	React.useEffect(function() -- line: 56
		-- upvalues: v19 (copy)
		v19()
	end, {
		t1.bottomHeight,
		v19
	})

	return React.createElement("TextButton", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		[React.Event.TouchTap] = function() -- line: 66
			-- upvalues: v15 (copy)
			v15(false)
		end,
		[React.Event.Activated] = function() -- line: 69
			-- upvalues: v15 (copy)
			v15(false)
		end
	}, {
		Scrim = React.createElement("Frame", {
			ZIndex = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = not v14 and 1 or v11.Color.Extended.Black.Black_50.Transparency,
			BackgroundColor3 = v11.Color.Extended.Black.Black_50.Color3
		}),
		EventsWithGradientContainer = React.createElement("Frame", {
			ZIndex = 2,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			BackgroundTransparency = v11.Color.Extended.White.White_100.Transparency,
			BackgroundColor3 = v11.Color.Extended.White.White_100.Color3,
			BorderSizePixel = 0,
			[React.Change.AbsoluteSize] = v20
		}, {
			Gradient = React.createElement("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, v11.Color.Surface.Surface_100.Color3),
					ColorSequenceKeypoint.new(1, v11.Color.Surface.Surface_100.Color3)
				}),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(v16, 0),
					NumberSequenceKeypoint.new(1, 0)
				})
			}),
			ContentContainer = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				[React.Change.AbsoluteSize] = v20
			}, {
				Padding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 80),
					PaddingLeft = UDim.new(0, 20),
					PaddingRight = UDim.new(0, 20),
					PaddingBottom = UDim.new(0, 20)
				}),
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Vertical,
					VerticalAlignment = Enum.VerticalAlignment.Bottom,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 16)
				}),
				EventDetailsBody = React.createElement(EventDetailsBody, {
					virtualEvent = t1.virtualEvent,
					eventStatus = t1.eventStatus,
					containerSize = Vector2.new((t1.isWideMode and constants.CONTAINER_WIDTH or v12.X) - 40, v12.Y),
					isExpanded = v14,
					setIsExpanded = v15
				}),
				Divider = React.createElement("Frame", {
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 1),
					BackgroundColor3 = v11.Color.Common.Shimmer.Color3,
					BackgroundTransparency = v11.Color.Common.Shimmer.Transparency
				}),
				EventActionBar = React.createElement(EventActionBar, {
					universeId = t1.virtualEvent.universeId,
					experienceName = not experienceDetails and "" or experienceDetails.name,
					onExperienceTileActivated = t1.onExperienceTileActivated,
					ctaProps = t1.ctaProps
				})
			})
		})
	})
end

return EventDetailsContainer
