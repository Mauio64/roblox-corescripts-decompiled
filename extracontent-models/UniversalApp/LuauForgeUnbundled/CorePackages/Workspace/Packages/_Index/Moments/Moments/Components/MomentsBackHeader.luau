local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local MomentsHeaderContainer = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/MomentsHeader/MomentsHeaderContainer")

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
