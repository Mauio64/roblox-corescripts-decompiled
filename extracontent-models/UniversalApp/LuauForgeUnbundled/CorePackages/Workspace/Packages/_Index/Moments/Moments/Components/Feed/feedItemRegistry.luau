require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")

local Moment = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/Moment")
local EndState = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/EndState")
local CaughtUp = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/CaughtUp")
local UnavailableMoment = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/UnavailableMoment")
local fFlagMomentsRenderAvatarPostsInFeed = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsRenderAvatarPostsInFeed

local result = {}

local function register(items)
	for k, item in items do
		result[item.kind] = item
	end
end

for k, v5 in Moment do
	result[v5.kind] = v5
end

for k, v5 in EndState do
	result[v5.kind] = v5
end

for k, v5 in CaughtUp do
	result[v5.kind] = v5
end

for k, v5 in UnavailableMoment do
	result[v5.kind] = v5
end

if fFlagMomentsRenderAvatarPostsInFeed then
	local AvatarMoment = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Items/AvatarMoment")

	for k, v5 in AvatarMoment do
		result[v5.kind] = v5
	end
end

return result
