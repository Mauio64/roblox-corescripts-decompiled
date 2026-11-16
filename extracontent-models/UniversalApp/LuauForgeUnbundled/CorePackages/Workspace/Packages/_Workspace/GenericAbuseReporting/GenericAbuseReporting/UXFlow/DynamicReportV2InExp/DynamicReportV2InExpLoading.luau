local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local LayoutSlots = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Components/LayoutSlots")

local layout = LayoutSlots.inlineSlots.Layout
local overlaidControlsProvider = LayoutSlots.OverlaidControlsProvider
local radius = Foundation.Enums.Radius
local skeleton = Foundation.Skeleton
local view = Foundation.View

local function DynamicReportV2InExpLoading(p2)
	return React.createElement(overlaidControlsProvider, {
		value = p2.shouldUseOverlaidControls
	}, {
		Layout = React.createElement(layout, {
			body = React.createElement(React.Fragment, nil, {
				Title = React.createElement(skeleton, {
					Size = UDim2.new(0.8, 0, 0, 40),
					radius = radius.Medium,
					LayoutOrder = 1
				}),
				Items = React.createElement(
					view,
					{ tag = "col gap-medium size-full-0 auto-y", LayoutOrder = 2 },
					{
						Item1 = React.createElement(skeleton, {
							Size = UDim2.new(1, 0, 0, 50),
							radius = radius.Medium
						}),
						Item2 = React.createElement(skeleton, {
							Size = UDim2.new(1, 0, 0, 50),
							radius = radius.Medium
						}),
						Item3 = React.createElement(skeleton, {
							Size = UDim2.new(1, 0, 0, 50),
							radius = radius.Medium
						}),
						Item4 = React.createElement(skeleton, {
							Size = UDim2.new(1, 0, 0, 50),
							radius = radius.Medium
						}),
						Item5 = React.createElement(skeleton, {
							Size = UDim2.new(1, 0, 0, 50),
							radius = radius.Medium
						})
					}
				)
			})
		})
	})
end

return React.memo(DynamicReportV2InExpLoading)
