local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local MomentsHeaderContainer = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/MomentsHeader/MomentsHeaderContainer")
local fFlagMomentsCreateAvatarPosts = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsCreateAvatarPosts

local function MomentsBackHeader(props)
	local createElement = React.createElement
	local v6 = {
		layoutOrder = props.layoutOrder,
		variant = "back",
		showTopScrim = true,
		onBack = props.onBack,
		onCreatePressed = props.onCreatePressed,
		onCreateAvatarMomentPressed = 0,
		onNavigateToTrending = 0,
		onNavigateToMyMoments = 0
	}

	local v7 = if fFlagMomentsCreateAvatarPosts then props.onCreateAvatarMomentPressed else nil
	v6.onCreateAvatarMomentPressed = v7

	v6.onNavigateToTrending = props.onNavigateToTrending
	v6.onNavigateToMyMoments = props.onNavigateToMyMoments
	return createElement(MomentsHeaderContainer, v6)
end

return MomentsBackHeader
