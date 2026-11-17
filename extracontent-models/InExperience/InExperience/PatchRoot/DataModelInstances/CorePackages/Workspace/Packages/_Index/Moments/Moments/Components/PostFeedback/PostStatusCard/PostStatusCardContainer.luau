local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)

local PostStatusCardView = require(script.Parent.PostStatusCardView)
local usePostStatusCardViewModel = require(script.Parent.usePostStatusCardViewModel)
local useHidePostStatusToast = require(Moments.Components.PostFeedback.PostStatusToast.useHidePostStatusToast)

local FFlagMomentsHidePostStatusToast = SharedFlags.FFlagMomentsHidePostStatusToast

local function PostStatusCardContainer()
	if FFlagMomentsHidePostStatusToast then
		useHidePostStatusToast()
	end

	local v = usePostStatusCardViewModel()

	if v == nil then
		return nil
	end

	return React.createElement(PostStatusCardView, v)
end

return PostStatusCardContainer
