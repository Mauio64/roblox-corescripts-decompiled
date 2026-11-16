local parent = script:FindFirstAncestor("Moments").Parent

require(script.Parent.FeedTypes)

local Moment = require(script.Parent.Items.Moment)
local EndState = require(script.Parent.Items.EndState)
local CaughtUp = require(script.Parent.Items.CaughtUp)
local UnavailableMoment = require(script.Parent.Items.UnavailableMoment)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed

local FeedItemRegistry = {}

local function register(items) -- 5 equivalent calls inferred from this helper
	for _, item in items do
		FeedItemRegistry[item.kind] = item
	end
end

register(Moment) -- inferred equivalent call
register(EndState) -- inferred equivalent call
register(CaughtUp) -- inferred equivalent call
register(UnavailableMoment) -- inferred equivalent call

if FFlagMomentsRenderAvatarPostsInFeed then
	local AvatarMoment = require(script.Parent.Items.AvatarMoment)
	register(AvatarMoment) -- inferred equivalent call
end

return FeedItemRegistry
