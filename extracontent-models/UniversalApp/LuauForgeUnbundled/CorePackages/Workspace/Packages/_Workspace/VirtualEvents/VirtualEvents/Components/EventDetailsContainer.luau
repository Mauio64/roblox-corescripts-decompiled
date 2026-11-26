local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/Foundation")
require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/GraphQLServer")
local useScreenSize = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/RobloxAppHooks").useScreenSize

local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/EventDetailsBody")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/Components/EventActionBar")

require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEventsState")
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/VirtualEvents/constants")

local useTokens = Foundation.Hooks.useTokens

local function EventDetailsContainer(props)
	local v5 = useTokens()
	local v6 = useScreenSize()
	local experienceDetails = props.virtualEvent.experienceDetails
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(0.99)

	local ref = React.useRef(0)

	local v7 = React.useCallback(function()
		if
			ref.current
			and props.bottomHeight
			and props.bottomHeight > 0
			and props.bottomHeight < ref.current
		then
			setState2(1 - props.bottomHeight / ref.current)
		end
	end, { props.bottomHeight })

	local v8 = React.useCallback(function(p2)
		if ref.current and ref.current ~= p2.AbsoluteSize.Y then
			ref.current = p2.AbsoluteSize.Y
			v7()
		end
	end, { v7 })

	React.useEffect(function()
		v7()
	end, { props.bottomHeight, v7 })

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
			BackgroundTransparency = not state and 1 or v5.Color.Extended.Black.Black_50.Transparency,
			BackgroundColor3 = v5.Color.Extended.Black.Black_50.Color3,
			BorderSizePixel = 0
		}),
		EventsWithGradientContainer = React.createElement("Frame", {
			ZIndex = 2,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			BackgroundTransparency = v5.Color.Extended.White.White_100.Transparency,
			BackgroundColor3 = v5.Color.Extended.White.White_100.Color3,
			BorderSizePixel = 0,
			[React.Change.AbsoluteSize] = v8
		}, {
			Gradient = React.createElement("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, v5.Color.Surface.Surface_100.Color3),
					ColorSequenceKeypoint.new(1, v5.Color.Surface.Surface_100.Color3)
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
				[React.Change.AbsoluteSize] = v8
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
				EventDetailsBody = React.createElement(module3, {
					virtualEvent = props.virtualEvent,
					eventStatus = props.eventStatus,
					containerSize = Vector2.new(
						(props.isWideMode and constants.CONTAINER_WIDTH or v6.X) - 40,
						v6.Y
					),
					isExpanded = state,
					setIsExpanded = setState
				}),
				Divider = React.createElement("Frame", {
					Size = UDim2.new(1, 0, 0, 1),
					BackgroundColor3 = v5.Color.Common.Shimmer.Color3,
					BackgroundTransparency = v5.Color.Common.Shimmer.Transparency,
					BorderSizePixel = 0
				}),
				EventActionBar = React.createElement(module4, {
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
