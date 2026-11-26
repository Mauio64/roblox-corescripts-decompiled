local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")

local PostStatusCardView = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostFeedback/PostStatusCard/PostStatusCardView")
local usePostStatusCardViewModel = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostFeedback/PostStatusCard/usePostStatusCardViewModel")
local useHidePostStatusToast = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostFeedback/PostStatusToast/useHidePostStatusToast")

local fFlagMomentsHidePostStatusToast = SharedFlags.FFlagMomentsHidePostStatusToast

local function PostStatusCardContainer()
	if fFlagMomentsHidePostStatusToast then
		useHidePostStatusToast()
	end

	local v5 = usePostStatusCardViewModel()

	if v5 == nil then
		return nil
	end

	return React.createElement(PostStatusCardView, v5)
end

return PostStatusCardContainer
