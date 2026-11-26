local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local skeleton = Foundation.Skeleton
local view = Foundation.View

local radius = Foundation.Enums.Radius
local useTokens = Foundation.Hooks.useTokens

local function ChatHistoryLoadingState()
	local v5 = useTokens()

	return React.createElement(
		view,
		{
			Size = UDim2.fromScale(1, 1),
			tag = "col gap-xlarge",
			testId = "ChatHistoryLoadingState"
		},
		{
			UserMessage = React.createElement(view, {
				LayoutOrder = 1,
				tag = "row size-full-0 auto-y"
			}, {
				Spacer = React.createElement(view, { LayoutOrder = 1, tag = "fill" }),
				Bubble = React.createElement(skeleton, {
					LayoutOrder = 2,
					Size = UDim2.new(0.68, 0, 0, v5.Size.Size_1200),
					radius = radius.Large,
					testId = "ChatHistoryLoadingState.UserMessage"
				})
			}),
			AgentResponse = React.createElement(
				view,
				{ LayoutOrder = 2, tag = "col gap-small size-full-0 auto-y" },
				{
					Line1 = React.createElement(skeleton, {
						LayoutOrder = 1,
						Size = UDim2.new(0.92, 0, 0, v5.Size.Size_300),
						radius = radius.Small,
						testId = "ChatHistoryLoadingState.AgentLine1"
					}),
					Line2 = React.createElement(skeleton, {
						LayoutOrder = 2,
						Size = UDim2.new(0.78, 0, 0, v5.Size.Size_300),
						radius = radius.Small,
						testId = "ChatHistoryLoadingState.AgentLine2"
					}),
					Line3 = React.createElement(skeleton, {
						LayoutOrder = 3,
						Size = UDim2.new(0.54, 0, 0, v5.Size.Size_300),
						radius = radius.Small,
						testId = "ChatHistoryLoadingState.AgentLine3"
					})
				}
			),
			PlaytestCard = React.createElement(skeleton, {
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, v5.Size.Size_2400 + v5.Size.Size_800),
				radius = radius.Medium,
				testId = "ChatHistoryLoadingState.PlaytestCard"
			})
		}
	)
end

return ChatHistoryLoadingState
