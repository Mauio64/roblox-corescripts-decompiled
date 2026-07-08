local Parent = script:FindFirstAncestor("GenericAbuseReporting").Parent
local Foundation = require(Parent.Foundation)
local React = require(Parent.React)
local EnumsRadius = Foundation.Enums.Radius
local Sheet = Foundation.Sheet
local Skeleton = Foundation.Skeleton
local View = Foundation.View

local function DynamicReportV2Loading(_: {[any]: any}) -- line: 20
	-- upvalues: React (copy), Sheet (copy), Skeleton (copy), EnumsRadius (copy), View (copy)
	return React.createElement(React.Fragment, nil, {
		Header = React.createElement(Sheet.Header, {
			hasCloseAffordance = true
		}, React.createElement(Skeleton, {
			Size = UDim2.new(1, 0, 0, 24),
			radius = EnumsRadius.Medium
		})),
		Content = React.createElement(Sheet.Content, nil, React.createElement(View, {
			tag = "size-full-0 auto-y col gap-medium"
		}, {
			Title = React.createElement(Skeleton, {
				LayoutOrder = 1,
				Size = UDim2.new(0.8, 0, 0, 40),
				radius = EnumsRadius.Medium
			}),
			Item1 = React.createElement(Skeleton, {
				LayoutOrder = 2,
				Size = UDim2.new(1, 0, 0, 50),
				radius = EnumsRadius.Medium
			}),
			Item2 = React.createElement(Skeleton, {
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, 50),
				radius = EnumsRadius.Medium
			}),
			Item3 = React.createElement(Skeleton, {
				LayoutOrder = 4,
				Size = UDim2.new(1, 0, 0, 50),
				radius = EnumsRadius.Medium
			}),
			Item4 = React.createElement(Skeleton, {
				LayoutOrder = 5,
				Size = UDim2.new(1, 0, 0, 50),
				radius = EnumsRadius.Medium
			}),
			Item5 = React.createElement(Skeleton, {
				LayoutOrder = 6,
				Size = UDim2.new(1, 0, 0, 50),
				radius = EnumsRadius.Medium
			})
		}))
	})
end

return React.memo(DynamicReportV2Loading)
