local InterventionShared = script:FindFirstAncestor("InterventionShared")
local parent = InterventionShared.Parent

local React = require(parent.React)

local Foundation = require(parent.Foundation)
local Radius = Foundation.Enums.Radius
local Skeleton = Foundation.Skeleton
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local FFlagUFRImprovements = require(InterventionShared.Flags.FFlagUFRImprovements)

local function InterventionDialogLoadingSkeleton()
	local v = useTokens()

	local createElement = React.createElement

	local children = {
		Heading = React.createElement(Skeleton, {
			Size = UDim2.new(0.6, 0, 0, v.Size.Size_1100),
			radius = Radius.Medium,
			LayoutOrder = 1
		}),
		Body = 0,
		Actions = 0
	}

	local createElement2 = React.createElement
	local v2

	if FFlagUFRImprovements then
		v2 = v.Size.Size_3000
	else
		v2 = v.Size.Size_2000
	end

	children.Body = createElement2(Skeleton, {
		Size = UDim2.new(1, 0, 0, v2),
		radius = Radius.Medium,
		LayoutOrder = 2
	})

	children.Actions = React.createElement(Skeleton, {
		Size = UDim2.new(1, 0, 0, v.Size.Size_800),
		radius = Radius.Medium,
		LayoutOrder = 3
	})
	return createElement(
		View,
		{
			tag = "col gap-medium size-full-0 auto-y margin-top-small",
			testId = "intervention-dialog-loading-skeleton"
		},
		children
	)
end

return React.memo(InterventionDialogLoadingSkeleton)
