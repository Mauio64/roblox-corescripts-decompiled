local VirtualEvents = script:FindFirstAncestor("VirtualEvents")

local React = require(VirtualEvents.Parent.React)
local Foundation = require(VirtualEvents.Parent.Foundation)
require(VirtualEvents.Parent.GraphQLServer)
local RobloxAppHooks = require(VirtualEvents.Parent.RobloxAppHooks)
local useScreenSize = RobloxAppHooks.useScreenSize

local EventDetailsBody = require(VirtualEvents.Components.EventDetailsBody)
local EventActionBar = require(VirtualEvents.Components.EventActionBar)

require(VirtualEvents.Parent.VirtualEventsState)
local constants = require(VirtualEvents.constants)

local useTokens = Foundation.Hooks.useTokens

local function EventDetailsContainer(props)
	local v = useTokens()
	local v2 = useScreenSize()
	local experienceDetails = props.virtualEvent.experienceDetails
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(0.99)

	local ref = React.useRef(0)

	local v3 = React.useCallback(function()
		if ref.current and props.bottomHeight and props.bottomHeight > 0 and props.bottomHeight < ref.current then
			setState2(1 - props.bottomHeight / ref.current)
		end
	end, { props.bottomHeight })

	local v4 = React.useCallback(function(p)
		if ref.current and ref.current ~= p.AbsoluteSize.Y then
			ref.current = p.AbsoluteSize.Y
			v3()
		end
	end, { v3 })

	React.useEffect(function()
		v3()
	end, { props.bottomHeight, v3 })

	return React.createElement("TextButton", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
		[React.Event.TouchTap] = function()
			setState(false)
		end,
		[React.Event.Activated] = function()
			setState(false)
		end
	}, {
		Scrim = React.createElement("Frame", {
			ZIndex = 1,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = not state and 1 or v.Color.Extended.Black.Black_50.Transparency,
			BackgroundColor3 = v.Color.Extended.Black.Black_50.Color3,
			BorderSizePixel = 0
		}),
		EventsWithGradientContainer = React.createElement("Frame", {
			ZIndex = 2,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			BackgroundTransparency = v.Color.Extended.White.White_100.Transparency,
			BackgroundColor3 = v.Color.Extended.White.White_100.Color3,
			BorderSizePixel = 0,
			[React.Change.AbsoluteSize] = v4
		}, {
			Gradient = React.createElement("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, v.Color.Surface.Surface_100.Color3),
					ColorSequenceKeypoint.new(1, v.Color.Surface.Surface_100.Color3)
				}),
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(state2, 0),
					NumberSequenceKeypoint.new(1, 0)
				})
			}),
			ContentContainer = React.createElement("Frame", {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				[React.Change.AbsoluteSize] = v4
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
					virtualEvent = props.virtualEvent,
					eventStatus = props.eventStatus,
					containerSize = Vector2.new((props.isWideMode and constants.CONTAINER_WIDTH or v2.X) - 40, v2.Y),
					isExpanded = state,
					setIsExpanded = setState
				}),
				Divider = React.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					BackgroundColor3 = v.Color.Common.Shimmer.Color3,
					BackgroundTransparency = v.Color.Common.Shimmer.Transparency,
					BorderSizePixel = 0
				}),
				EventActionBar = React.createElement(EventActionBar, {
					universeId = props.virtualEvent.universeId,
					experienceName = not experienceDetails and "" or experienceDetails.name,
					onExperienceTileActivated = props.onExperienceTileActivated,
					ctaProps = props.ctaProps
				})
			})
		})
	})
end

return EventDetailsContainer
