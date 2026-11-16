local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local LayoutSlots = require(GenericAbuseReporting.BeduiV2.Components.LayoutSlots)

local layout = LayoutSlots.inlineSlots.Layout
local OverlaidControlsProvider = LayoutSlots.OverlaidControlsProvider
local Radius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local View = Foundation.View

local function DynamicReportV2InExpLoading(p)
	return React.createElement(OverlaidControlsProvider, { value = p.shouldUseOverlaidControls }, {
		Layout = React.createElement(layout, {
			body = React.createElement(React.Fragment, nil, {
				Title = React.createElement(Skeleton, {
					Size = UDim2.new(0.8, 0, 0, 40),
					radius = Radius.Medium,
					LayoutOrder = 1
				}),
				Items = React.createElement(View, {
					tag = "col gap-medium size-full-0 auto-y",
					LayoutOrder = 2
				}, {
					Item1 = React.createElement(Skeleton, {
						Size = UDim2.new(1, 0, 0, 50),
						radius = Radius.Medium
					}),
					Item2 = React.createElement(Skeleton, {
						Size = UDim2.new(1, 0, 0, 50),
						radius = Radius.Medium
					}),
					Item3 = React.createElement(Skeleton, {
						Size = UDim2.new(1, 0, 0, 50),
						radius = Radius.Medium
					}),
					Item4 = React.createElement(Skeleton, {
						Size = UDim2.new(1, 0, 0, 50),
						radius = Radius.Medium
					}),
					Item5 = React.createElement(Skeleton, {
						Size = UDim2.new(1, 0, 0, 50),
						radius = Radius.Medium
					})
				})
			})
		})
	})
end

return React.memo(DynamicReportV2InExpLoading)
