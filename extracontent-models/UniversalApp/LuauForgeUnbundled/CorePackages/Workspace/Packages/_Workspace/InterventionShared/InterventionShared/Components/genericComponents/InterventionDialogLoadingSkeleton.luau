local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/React")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/Foundation")
local radius = Foundation.Enums.Radius
local skeleton = Foundation.Skeleton
local view = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local FFlagUFRImprovements = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Flags/FFlagUFRImprovements")

local function InterventionDialogLoadingSkeleton()
	local v5 = useTokens()

	local createElement = React.createElement

	local children = {
		Heading = React.createElement(skeleton, {
			Size = UDim2.new(0.6, 0, 0, v5.Size.Size_1100),
			radius = radius.Medium,
			LayoutOrder = 1
		}),
		Body = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local newUDim2 = UDim2.new
	local v13 = if FFlagUFRImprovements then v5.Size.Size_3000 else v5.Size.Size_2000
	children.Body = createElement2(skeleton, {
		Size = newUDim2(1, 0, 0, v13),
		radius = radius.Medium,
		LayoutOrder = 2
	})

	children.Actions = React.createElement(skeleton, {
		Size = UDim2.new(1, 0, 0, v5.Size.Size_800),
		radius = radius.Medium,
		LayoutOrder = 3
	})
	return createElement(
		view,
		{
			tag = "col gap-medium size-full-0 auto-y margin-top-small",
			testId = "intervention-dialog-loading-skeleton"
		},
		children
	)
end

return React.memo(InterventionDialogLoadingSkeleton)
