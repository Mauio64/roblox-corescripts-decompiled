local parent = script:FindFirstAncestor("BuildExperience").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local Skeleton = Foundation.Skeleton
local View = Foundation.View

local Radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function ChatHistoryLoadingState()
	local v = useTokens()

	return React.createElement(
		View,
		{ Size = UDim2.fromScale(1, 1), tag = "col gap-xlarge", testId = "ChatHistoryLoadingState" },
		{
			UserMessage = React.createElement(View, {
				LayoutOrder = 1,
				tag = "row size-full-0 auto-y"
			}, {
				Spacer = React.createElement(View, { LayoutOrder = 1, tag = "fill" }),
				Bubble = React.createElement(Skeleton, {
					LayoutOrder = 2,
					Size = UDim2.new(0.68, 0, 0, v.Size.Size_1200),
					radius = Radius.Large,
					testId = "ChatHistoryLoadingState.UserMessage"
				})
			}),
			AgentResponse = React.createElement(View, {
				LayoutOrder = 2,
				tag = "col gap-small size-full-0 auto-y"
			}, {
				Line1 = React.createElement(Skeleton, {
					LayoutOrder = 1,
					Size = UDim2.new(0.92, 0, 0, v.Size.Size_300),
					radius = Radius.Small,
					testId = "ChatHistoryLoadingState.AgentLine1"
				}),
				Line2 = React.createElement(Skeleton, {
					LayoutOrder = 2,
					Size = UDim2.new(0.78, 0, 0, v.Size.Size_300),
					radius = Radius.Small,
					testId = "ChatHistoryLoadingState.AgentLine2"
				}),
				Line3 = React.createElement(Skeleton, {
					LayoutOrder = 3,
					Size = UDim2.new(0.54, 0, 0, v.Size.Size_300),
					radius = Radius.Small,
					testId = "ChatHistoryLoadingState.AgentLine3"
				})
			}),
			PlaytestCard = React.createElement(Skeleton, {
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, v.Size.Size_2400 + v.Size.Size_800),
				radius = Radius.Medium,
				testId = "ChatHistoryLoadingState.PlaytestCard"
			})
		}
	)
end

return ChatHistoryLoadingState
