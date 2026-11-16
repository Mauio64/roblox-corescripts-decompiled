local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/React")

local radius = Foundation.Enums.Radius
local sheet = Foundation.Sheet
local skeleton = Foundation.Skeleton
local view = Foundation.View

local function DynamicReportV2Loading(p2)
	return React.createElement(React.Fragment, nil, {
		Header = React.createElement(
			sheet.Header,
			{ hasCloseAffordance = true },
			React.createElement(skeleton, {
				Size = UDim2.new(1, 0, 0, 24),
				radius = radius.Medium
			})
		),
		Content = React.createElement(
			sheet.Content,
			nil,
			React.createElement(view, { tag = "col gap-medium size-full-0 auto-y" }, {
				Title = React.createElement(skeleton, {
					Size = UDim2.new(0.8, 0, 0, 40),
					radius = radius.Medium,
					LayoutOrder = 1
				}),
				Item1 = React.createElement(skeleton, {
					Size = UDim2.new(1, 0, 0, 50),
					radius = radius.Medium,
					LayoutOrder = 2
				}),
				Item2 = React.createElement(skeleton, {
					Size = UDim2.new(1, 0, 0, 50),
					radius = radius.Medium,
					LayoutOrder = 3
				}),
				Item3 = React.createElement(skeleton, {
					Size = UDim2.new(1, 0, 0, 50),
					radius = radius.Medium,
					LayoutOrder = 4
				}),
				Item4 = React.createElement(skeleton, {
					Size = UDim2.new(1, 0, 0, 50),
					radius = radius.Medium,
					LayoutOrder = 5
				}),
				Item5 = React.createElement(skeleton, {
					Size = UDim2.new(1, 0, 0, 50),
					radius = radius.Medium,
					LayoutOrder = 6
				})
			})
		)
	})
end

return React.memo(DynamicReportV2Loading)
