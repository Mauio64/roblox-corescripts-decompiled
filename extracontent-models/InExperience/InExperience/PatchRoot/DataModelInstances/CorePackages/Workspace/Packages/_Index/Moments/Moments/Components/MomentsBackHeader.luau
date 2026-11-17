local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local MomentsHeaderContainer = require(Moments.Components.MomentsHeader.MomentsHeaderContainer)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsCreateAvatarPosts = SharedFlags.FFlagMomentsCreateAvatarPosts

local function MomentsBackHeader(props)
	local createElement = React.createElement
	local v = {
		layoutOrder = props.layoutOrder,
		variant = "back",
		showTopScrim = true,
		onBack = props.onBack,
		onCreatePressed = props.onCreatePressed,
		onCreateAvatarMomentPressed = 0,
		onNavigateToTrending = 0,
		onNavigateToMyMoments = 0
	}
	local onCreateAvatarMomentPressed

	if FFlagMomentsCreateAvatarPosts then
		onCreateAvatarMomentPressed = props.onCreateAvatarMomentPressed
	end

	v.onCreateAvatarMomentPressed = onCreateAvatarMomentPressed

	v.onNavigateToTrending = props.onNavigateToTrending
	v.onNavigateToMyMoments = props.onNavigateToMyMoments
	return createElement(MomentsHeaderContainer, v)
end

return MomentsBackHeader
