local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local MomentsHeaderContainer = require(Moments.Components.MomentsHeader.MomentsHeaderContainer)

local function MomentsBackHeader(props)
	return React.createElement(MomentsHeaderContainer, {
		layoutOrder = props.layoutOrder,
		variant = "back",
		showTopScrim = true,
		onBack = props.onBack,
		onCreatePressed = props.onCreatePressed,
		onNavigateToTrending = props.onNavigateToTrending,
		onNavigateToMyMoments = props.onNavigateToMyMoments
	})
end

return MomentsBackHeader
