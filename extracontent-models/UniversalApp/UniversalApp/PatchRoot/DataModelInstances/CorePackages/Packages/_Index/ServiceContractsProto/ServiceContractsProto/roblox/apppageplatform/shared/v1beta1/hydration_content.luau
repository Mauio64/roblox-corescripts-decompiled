local proto = require(script.Parent.Parent.Parent.Parent.Parent.proto)
local typeRegistry = require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

local v = {}

local badge_data = require(script.Parent.badge_data)

local buy_robux_bonus_item_data = require(script.Parent.buy_robux_bonus_item_data)

local buy_robux_pending_transfer_data = require(script.Parent.buy_robux_pending_transfer_data)
local buy_robux_product_data = require(script.Parent.buy_robux_product_data)
local universe_data = require(script.Parent.universe_data)

local universe_user_favorite_data = require(script.Parent.universe_user_favorite_data)

local universe_user_follow_data = require(script.Parent.universe_user_follow_data)

local universe_user_follow_limit_data = require(script.Parent.universe_user_follow_limit_data)
local universe_user_vote_data = require(script.Parent.universe_user_vote_data)

local universe_user_vote_feedback_metadata_data = require(script.Parent.universe_user_vote_feedback_metadata_data)
local creator_data = require(script.Parent.creator_data)
local event_data = require(script.Parent.event_data)
local song_data = require(script.Parent.song_data)
local game_pass_data = require(script.Parent.game_pass_data)
local playability_data = require(script.Parent.playability_data)
local media_asset_data = require(script.Parent.media_asset_data)
local social_link_data = require(script.Parent.social_link_data)

local marketplace_catalog_category_data = require(script.Parent.marketplace_catalog_category_data)
local marketplace_asset_data = require(script.Parent.marketplace_asset_data)
local marketplace_bundle_data = require(script.Parent.marketplace_bundle_data)
local marketplace_look_data = require(script.Parent.marketplace_look_data)

local marketplace_item_user_favorite_data = require(script.Parent.marketplace_item_user_favorite_data)
local catalog_sort_data = require(script.Parent.catalog_sort_data)

local game_developer_product_data = require(script.Parent.game_developer_product_data)
local game_subscription_data = require(script.Parent.game_subscription_data)
local age_recommendation_data = require(script.Parent.age_recommendation_data)
local user_profile_data = require(script.Parent.user_profile_data)
local moment_data = require(script.Parent.moment_data)
local community_data = require(script.Parent.community_data)

local community_user_membership_data = require(script.Parent.community_user_membership_data)

local friend_recommendation_data = require(script.Parent.friend_recommendation_data)
local notification_badge_data = require(script.Parent.notification_badge_data)

local universe_private_server_data = require(script.Parent.universe_private_server_data)
local collectible_item_data = require(script.Parent.collectible_item_data)
local leaderboard_stats_data = require(script.Parent.leaderboard_stats_data)

local user_library_saved_state_data = require(script.Parent.user_library_saved_state_data)
local vote_data = require(script.Parent.vote_data)

local class = {}
class.__index = class

function class.new(data)
	return (setmetatable({
		badge = (data == nil or data.badge == nil) and {} or data.badge,
		universe = (data == nil or data.universe == nil) and {} or data.universe,
		creator = (data == nil or data.creator == nil) and {} or data.creator,
		event = (data == nil or data.event == nil) and {} or data.event,
		song = (data == nil or data.song == nil) and {} or data.song,
		game_pass = (data == nil or data.game_pass == nil) and {} or data.game_pass,
		media_asset = (data == nil or data.media_asset == nil) and {} or data.media_asset,
		social_link = (data == nil or data.social_link == nil) and {} or data.social_link,
		game_developer_product = (data == nil or data.game_developer_product == nil) and {} or data.game_developer_product,
		game_subscription = (data == nil or data.game_subscription == nil) and {} or data.game_subscription,
		marketplace_catalog_category = (data == nil or data.marketplace_catalog_category == nil) and {} or data.marketplace_catalog_category,
		marketplace_asset = (data == nil or data.marketplace_asset == nil) and {} or data.marketplace_asset,
		marketplace_bundle = (data == nil or data.marketplace_bundle == nil) and {} or data.marketplace_bundle,
		marketplace_look = (data == nil or data.marketplace_look == nil) and {} or data.marketplace_look,
		catalog_sort = (data == nil or data.catalog_sort == nil) and {} or data.catalog_sort,
		age_recommendation = (data == nil or data.age_recommendation == nil) and {} or data.age_recommendation,
		universe_user_follow = (data == nil or data.universe_user_follow == nil) and {} or data.universe_user_follow,
		universe_user_vote = (data == nil or data.universe_user_vote == nil) and {} or data.universe_user_vote,
		user_profile = (data == nil or data.user_profile == nil) and {} or data.user_profile,
		universe_user_favorite = (data == nil or data.universe_user_favorite == nil) and {} or data.universe_user_favorite,
		playability = (data == nil or data.playability == nil) and {} or data.playability,
		universe_user_follow_limit = (data == nil or data.universe_user_follow_limit == nil) and {} or data.universe_user_follow_limit,
		universe_user_vote_feedback_metadata = (data == nil or data.universe_user_vote_feedback_metadata == nil) and {} or data.universe_user_vote_feedback_metadata,
		moment = (data == nil or data.moment == nil) and {} or data.moment,
		community = (data == nil or data.community == nil) and {} or data.community,
		community_user_membership = (data == nil or data.community_user_membership == nil) and {} or data.community_user_membership,
		friend_recommendation = (data == nil or data.friend_recommendation == nil) and {} or data.friend_recommendation,
		universe_private_server = (data == nil or data.universe_private_server == nil) and {} or data.universe_private_server,
		notification_badge = (data == nil or data.notification_badge == nil) and {} or data.notification_badge,
		collectible_item = (data == nil or data.collectible_item == nil) and {} or data.collectible_item,
		leaderboard_stats = (data == nil or data.leaderboard_stats == nil) and {} or data.leaderboard_stats,
		marketplace_asset_user_favorite = (data == nil or data.marketplace_asset_user_favorite == nil) and {} or data.marketplace_asset_user_favorite,
		marketplace_bundle_user_favorite = (data == nil or data.marketplace_bundle_user_favorite == nil) and {} or data.marketplace_bundle_user_favorite,
		buy_robux_one_time_product = (data == nil or data.buy_robux_one_time_product == nil) and {} or data.buy_robux_one_time_product,
		buy_robux_subscription_product = (data == nil or data.buy_robux_subscription_product == nil) and {} or data.buy_robux_subscription_product,
		buy_robux_pending_transfer = (data == nil or data.buy_robux_pending_transfer == nil) and {} or data.buy_robux_pending_transfer,
		buy_robux_bonus_item = (data == nil or data.buy_robux_bonus_item == nil) and {} or data.buy_robux_bonus_item,
		user_library_saved_state = (data == nil or data.user_library_saved_state == nil) and {} or data.user_library_saved_state,
		game_pass_vote = (data == nil or data.game_pass_vote == nil) and {} or data.game_pass_vote
	}, class))
end

function class:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.badge ~= nil and next(self.badge) ~= nil then
		for k, v4 in self.badge do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.universe ~= nil and next(self.universe) ~= nil then
		for k, v4 in self.universe do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.creator ~= nil and next(self.creator) ~= nil then
		for k, v4 in self.creator do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 3, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.event ~= nil and next(self.event) ~= nil then
		for k, v4 in self.event do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 4, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.song ~= nil and next(self.song) ~= nil then
		for k, v4 in self.song do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 5, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.game_pass ~= nil and next(self.game_pass) ~= nil then
		for k, v4 in self.game_pass do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 6, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.media_asset ~= nil and next(self.media_asset) ~= nil then
		for k, v4 in self.media_asset do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 7, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.social_link ~= nil and next(self.social_link) ~= nil then
		for k, v4 in self.social_link do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 8, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.game_developer_product ~= nil and next(self.game_developer_product) ~= nil then
		for k, v4 in self.game_developer_product do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 9, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.game_subscription ~= nil and next(self.game_subscription) ~= nil then
		for k, v4 in self.game_subscription do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 10, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.marketplace_catalog_category ~= nil and next(self.marketplace_catalog_category) ~= nil then
		for k, v4 in self.marketplace_catalog_category do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 11, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.marketplace_asset ~= nil and next(self.marketplace_asset) ~= nil then
		for k, v4 in self.marketplace_asset do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 12, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.marketplace_bundle ~= nil and next(self.marketplace_bundle) ~= nil then
		for k, v4 in self.marketplace_bundle do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 13, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.marketplace_look ~= nil and next(self.marketplace_look) ~= nil then
		for k, v4 in self.marketplace_look do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 14, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.catalog_sort ~= nil and next(self.catalog_sort) ~= nil then
		for k, v4 in self.catalog_sort do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 15, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.age_recommendation ~= nil and next(self.age_recommendation) ~= nil then
		for k, v4 in self.age_recommendation do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 16, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.universe_user_follow ~= nil and next(self.universe_user_follow) ~= nil then
		for k, v4 in self.universe_user_follow do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 17, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.universe_user_vote ~= nil and next(self.universe_user_vote) ~= nil then
		for k, v4 in self.universe_user_vote do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 18, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.user_profile ~= nil and next(self.user_profile) ~= nil then
		for k, v4 in self.user_profile do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 19, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.universe_user_favorite ~= nil and next(self.universe_user_favorite) ~= nil then
		for k, v4 in self.universe_user_favorite do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 20, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.playability ~= nil and next(self.playability) ~= nil then
		for k, v4 in self.playability do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 21, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.universe_user_follow_limit ~= nil and next(self.universe_user_follow_limit) ~= nil then
		for k, v4 in self.universe_user_follow_limit do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 22, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.universe_user_vote_feedback_metadata ~= nil and next(self.universe_user_vote_feedback_metadata) ~= nil then
		for k, v4 in self.universe_user_vote_feedback_metadata do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 23, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.moment ~= nil and next(self.moment) ~= nil then
		for k, v4 in self.moment do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 24, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.community ~= nil and next(self.community) ~= nil then
		for k, v4 in self.community do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 25, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.community_user_membership ~= nil and next(self.community_user_membership) ~= nil then
		for k, v4 in self.community_user_membership do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 26, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.friend_recommendation ~= nil and next(self.friend_recommendation) ~= nil then
		for k, v4 in self.friend_recommendation do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 27, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.universe_private_server ~= nil and next(self.universe_private_server) ~= nil then
		for k, v4 in self.universe_private_server do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 28, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.notification_badge ~= nil and next(self.notification_badge) ~= nil then
		for k, v4 in self.notification_badge do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 29, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.collectible_item ~= nil and next(self.collectible_item) ~= nil then
		for k, v4 in self.collectible_item do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 30, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.leaderboard_stats ~= nil and next(self.leaderboard_stats) ~= nil then
		for k, leaderboard_stat in self.leaderboard_stats do
			local buf = buffer.create(0)

			local v4, v5 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v6, v7 = proto.writeString(v4, v5, k)
			local encoded = leaderboard_stat:encode()
			local v8, v9 = proto.writeTag(v6, v7, 2, proto.wireTypes.lengthDelimited)
			local v10, v11 = proto.writeBuffer(v8, v9, encoded, buffer.len(encoded))
			local v12, v13 = proto.writeTag(v2, v3, 31, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v12, v13, v10, v11)
		end
	end

	if self.marketplace_asset_user_favorite ~= nil and next(self.marketplace_asset_user_favorite) ~= nil then
		for k, v4 in self.marketplace_asset_user_favorite do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 32, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.marketplace_bundle_user_favorite ~= nil and next(self.marketplace_bundle_user_favorite) ~= nil then
		for k, v4 in self.marketplace_bundle_user_favorite do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 33, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.buy_robux_one_time_product ~= nil and next(self.buy_robux_one_time_product) ~= nil then
		for k, v4 in self.buy_robux_one_time_product do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 34, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.buy_robux_subscription_product ~= nil and next(self.buy_robux_subscription_product) ~= nil then
		for k, v4 in self.buy_robux_subscription_product do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 35, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.buy_robux_pending_transfer ~= nil and next(self.buy_robux_pending_transfer) ~= nil then
		for k, v4 in self.buy_robux_pending_transfer do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 36, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.buy_robux_bonus_item ~= nil and next(self.buy_robux_bonus_item) ~= nil then
		for k, v4 in self.buy_robux_bonus_item do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 37, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.user_library_saved_state ~= nil and next(self.user_library_saved_state) ~= nil then
		for k, v4 in self.user_library_saved_state do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 38, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	if self.game_pass_vote ~= nil and next(self.game_pass_vote) ~= nil then
		for k, v4 in self.game_pass_vote do
			local buf = buffer.create(0)

			local v5, v6 = proto.writeTag(buf, 0, 1, proto.wireTypes.lengthDelimited)
			local v7, v8 = proto.writeString(v5, v6, k)
			local encoded = v4:encode()
			local v9, v10 = proto.writeTag(v7, v8, 2, proto.wireTypes.lengthDelimited)
			local v11, v12 = proto.writeBuffer(v9, v10, encoded, buffer.len(encoded))
			local v13, v14 = proto.writeTag(v2, v3, 39, proto.wireTypes.lengthDelimited)
			v2, v3 = proto.writeBuffer(v13, v14, v11, v12)
		end
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class.decode(buf: buffer)
	local v2 = class.new()
	local v3 = 0

	while v3 < buffer.len(buf) do
		local v4, v5
		v4, v5, v3 = proto.readTag(buf, v3)

		if v5 == proto.wireTypes.varint then
			local _
			_, v3 = proto.readVarInt(buf, v3)
		elseif v5 == proto.wireTypes.lengthDelimited then
			if v4 == 1 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_BadgeEntry.decode(v6)

				local badgeData = badge_data.BadgeData.new()

				v2.badge[decoded.key or ""] = decoded.value or badgeData
			elseif v4 == 2 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_UniverseEntry.decode(v6)

				local universeData = universe_data.UniverseData.new()

				v2.universe[decoded.key or ""] = decoded.value or universeData
			elseif v4 == 3 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_CreatorEntry.decode(v6)

				local creatorData = creator_data.CreatorData.new()

				v2.creator[decoded.key or ""] = decoded.value or creatorData
			elseif v4 == 4 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_EventEntry.decode(v6)

				local eventData = event_data.EventData.new()

				v2.event[decoded.key or ""] = decoded.value or eventData
			elseif v4 == 5 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_SongEntry.decode(v6)

				local songData = song_data.SongData.new()

				v2.song[decoded.key or ""] = decoded.value or songData
			elseif v4 == 6 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_GamePassEntry.decode(v6)

				local gamePassData = game_pass_data.GamePassData.new()

				v2.game_pass[decoded.key or ""] = decoded.value or gamePassData
			elseif v4 == 7 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_MediaAssetEntry.decode(v6)

				local mediaAssetData = media_asset_data.MediaAssetData.new()

				v2.media_asset[decoded.key or ""] = decoded.value or mediaAssetData
			elseif v4 == 8 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_SocialLinkEntry.decode(v6)

				local socialLinkData = social_link_data.SocialLinkData.new()

				v2.social_link[decoded.key or ""] = decoded.value or socialLinkData
			elseif v4 == 9 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_GameDeveloperProductEntry.decode(v6)

				local gameDeveloperProductData = game_developer_product_data.GameDeveloperProductData.new()

				v2.game_developer_product[decoded.key or ""] = decoded.value or gameDeveloperProductData
			elseif v4 == 10 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_GameSubscriptionEntry.decode(v6)

				local gameSubscriptionData = game_subscription_data.GameSubscriptionData.new()

				v2.game_subscription[decoded.key or ""] = decoded.value or gameSubscriptionData
			elseif v4 == 11 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_MarketplaceCatalogCategoryEntry.decode(v6)

				local marketplaceCatalogCategoryData = marketplace_catalog_category_data.MarketplaceCatalogCategoryData.new()

				v2.marketplace_catalog_category[decoded.key or ""] = decoded.value or marketplaceCatalogCategoryData
			elseif v4 == 12 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_MarketplaceAssetEntry.decode(v6)

				local marketplaceAssetData = marketplace_asset_data.MarketplaceAssetData.new()

				v2.marketplace_asset[decoded.key or ""] = decoded.value or marketplaceAssetData
			elseif v4 == 13 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_MarketplaceBundleEntry.decode(v6)

				local marketplaceBundleData = marketplace_bundle_data.MarketplaceBundleData.new()

				v2.marketplace_bundle[decoded.key or ""] = decoded.value or marketplaceBundleData
			elseif v4 == 14 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_MarketplaceLookEntry.decode(v6)

				local marketplaceLookData = marketplace_look_data.MarketplaceLookData.new()

				v2.marketplace_look[decoded.key or ""] = decoded.value or marketplaceLookData
			elseif v4 == 15 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_CatalogSortEntry.decode(v6)

				local catalogSortData = catalog_sort_data.CatalogSortData.new()

				v2.catalog_sort[decoded.key or ""] = decoded.value or catalogSortData
			elseif v4 == 16 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_AgeRecommendationEntry.decode(v6)

				local ageRecommendationData = age_recommendation_data.AgeRecommendationData.new()

				v2.age_recommendation[decoded.key or ""] = decoded.value or ageRecommendationData
			elseif v4 == 17 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_UniverseUserFollowEntry.decode(v6)

				local universeUserFollowData = universe_user_follow_data.UniverseUserFollowData.new()

				v2.universe_user_follow[decoded.key or ""] = decoded.value or universeUserFollowData
			elseif v4 == 18 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_UniverseUserVoteEntry.decode(v6)

				local universeUserVoteData = universe_user_vote_data.UniverseUserVoteData.new()

				v2.universe_user_vote[decoded.key or ""] = decoded.value or universeUserVoteData
			elseif v4 == 19 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_UserProfileEntry.decode(v6)

				local userProfileData = user_profile_data.UserProfileData.new()

				v2.user_profile[decoded.key or ""] = decoded.value or userProfileData
			elseif v4 == 20 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_UniverseUserFavoriteEntry.decode(v6)

				local universeUserFavoriteData = universe_user_favorite_data.UniverseUserFavoriteData.new()

				v2.universe_user_favorite[decoded.key or ""] = decoded.value or universeUserFavoriteData
			elseif v4 == 21 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_PlayabilityEntry.decode(v6)

				local playabilityData = playability_data.PlayabilityData.new()

				v2.playability[decoded.key or ""] = decoded.value or playabilityData
			elseif v4 == 22 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_UniverseUserFollowLimitEntry.decode(v6)

				local universeUserFollowLimitData = universe_user_follow_limit_data.UniverseUserFollowLimitData.new()

				v2.universe_user_follow_limit[decoded.key or ""] = decoded.value or universeUserFollowLimitData
			elseif v4 == 23 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_UniverseUserVoteFeedbackMetadataEntry.decode(v6)

				local universeUserVoteFeedbackMetadataData = universe_user_vote_feedback_metadata_data.UniverseUserVoteFeedbackMetadataData.new()

				v2.universe_user_vote_feedback_metadata[decoded.key or ""] = decoded.value
					or universeUserVoteFeedbackMetadataData
			elseif v4 == 24 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_MomentEntry.decode(v6)

				local momentData = moment_data.MomentData.new()

				v2.moment[decoded.key or ""] = decoded.value or momentData
			elseif v4 == 25 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_CommunityEntry.decode(v6)

				local communityData = community_data.CommunityData.new()

				v2.community[decoded.key or ""] = decoded.value or communityData
			elseif v4 == 26 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_CommunityUserMembershipEntry.decode(v6)

				local communityUserMembershipData = community_user_membership_data.CommunityUserMembershipData.new()

				v2.community_user_membership[decoded.key or ""] = decoded.value or communityUserMembershipData
			elseif v4 == 27 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_FriendRecommendationEntry.decode(v6)

				local friendRecommendationData = friend_recommendation_data.FriendRecommendationData.new()

				v2.friend_recommendation[decoded.key or ""] = decoded.value or friendRecommendationData
			elseif v4 == 28 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_UniversePrivateServerEntry.decode(v6)

				local universePrivateServerData = universe_private_server_data.UniversePrivateServerData.new()

				v2.universe_private_server[decoded.key or ""] = decoded.value or universePrivateServerData
			elseif v4 == 29 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_NotificationBadgeEntry.decode(v6)

				local notificationBadgeData = notification_badge_data.NotificationBadgeData.new()

				v2.notification_badge[decoded.key or ""] = decoded.value or notificationBadgeData
			elseif v4 == 30 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_CollectibleItemEntry.decode(v6)

				local collectibleItemData = collectible_item_data.CollectibleItemData.new()

				v2.collectible_item[decoded.key or ""] = decoded.value or collectibleItemData
			elseif v4 == 31 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_LeaderboardStatsEntry.decode(v6)

				local leaderboardStatsData = leaderboard_stats_data.LeaderboardStatsData.new()

				v2.leaderboard_stats[decoded.key or ""] = decoded.value or leaderboardStatsData
			elseif v4 == 32 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_MarketplaceAssetUserFavoriteEntry.decode(v6)

				local marketplaceItemUserFavoriteData = marketplace_item_user_favorite_data.MarketplaceItemUserFavoriteData.new()

				v2.marketplace_asset_user_favorite[decoded.key or ""] = decoded.value or marketplaceItemUserFavoriteData
			elseif v4 == 33 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_MarketplaceBundleUserFavoriteEntry.decode(v6)

				local marketplaceItemUserFavoriteData = marketplace_item_user_favorite_data.MarketplaceItemUserFavoriteData.new()

				v2.marketplace_bundle_user_favorite[decoded.key or ""] = decoded.value
					or marketplaceItemUserFavoriteData
			elseif v4 == 34 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_BuyRobuxOneTimeProductEntry.decode(v6)

				local buyRobuxOneTimeProductData = buy_robux_product_data.BuyRobuxOneTimeProductData.new()

				v2.buy_robux_one_time_product[decoded.key or ""] = decoded.value or buyRobuxOneTimeProductData
			elseif v4 == 35 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_BuyRobuxSubscriptionProductEntry.decode(v6)

				local buyRobuxSubscriptionProductData = buy_robux_product_data.BuyRobuxSubscriptionProductData.new()

				v2.buy_robux_subscription_product[decoded.key or ""] = decoded.value or buyRobuxSubscriptionProductData
			elseif v4 == 36 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_BuyRobuxPendingTransferEntry.decode(v6)

				local buyRobuxPendingTransferData = buy_robux_pending_transfer_data.BuyRobuxPendingTransferData.new()

				v2.buy_robux_pending_transfer[decoded.key or ""] = decoded.value or buyRobuxPendingTransferData
			elseif v4 == 37 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_BuyRobuxBonusItemEntry.decode(v6)

				local buyRobuxBonusItemData = buy_robux_bonus_item_data.BuyRobuxBonusItemData.new()

				v2.buy_robux_bonus_item[decoded.key or ""] = decoded.value or buyRobuxBonusItemData
			elseif v4 == 38 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_UserLibrarySavedStateEntry.decode(v6)

				local userLibrarySavedStateData = user_library_saved_state_data.UserLibrarySavedStateData.new()

				v2.user_library_saved_state[decoded.key or ""] = decoded.value or userLibrarySavedStateData
			elseif v4 == 39 then
				local v6
				v6, v3 = proto.readBuffer(buf, v3)

				local decoded = v.HydrationContent_GamePassVoteEntry.decode(v6)

				local voteData = vote_data.VoteData.new()

				v2.game_pass_vote[decoded.key or ""] = decoded.value or voteData
			else
				local varInt, v6 = proto.readVarInt(buf, v3)

				v3 = v6 + varInt
			end
		elseif v5 == proto.wireTypes.i32 then
			local _
			_, v3 = proto.readFixed32(buf, v3)
		elseif v5 == proto.wireTypes.i64 then
			local _
			_, v3 = proto.readFixed64(buf, v3)
		else
			error("Unsupported wire type: " .. v5)
		end
	end

	return v2
end

function class:jsonEncode()
	local v2 = {}

	if self.badge ~= nil and next(self.badge) ~= nil then
		local badge = {}

		for k, v3 in self.badge do
			badge[k] = v3:jsonEncode()
		end

		v2.badge = badge
	end

	if self.universe ~= nil and next(self.universe) ~= nil then
		local universe = {}

		for k, v3 in self.universe do
			universe[k] = v3:jsonEncode()
		end

		v2.universe = universe
	end

	if self.creator ~= nil and next(self.creator) ~= nil then
		local creator = {}

		for k, v3 in self.creator do
			creator[k] = v3:jsonEncode()
		end

		v2.creator = creator
	end

	if self.event ~= nil and next(self.event) ~= nil then
		local event = {}

		for k, v3 in self.event do
			event[k] = v3:jsonEncode()
		end

		v2.event = event
	end

	if self.song ~= nil and next(self.song) ~= nil then
		local song = {}

		for k, v3 in self.song do
			song[k] = v3:jsonEncode()
		end

		v2.song = song
	end

	if self.game_pass ~= nil and next(self.game_pass) ~= nil then
		local gamePass = {}

		for k, v3 in self.game_pass do
			gamePass[k] = v3:jsonEncode()
		end

		v2.gamePass = gamePass
	end

	if self.media_asset ~= nil and next(self.media_asset) ~= nil then
		local mediaAsset = {}

		for k, v3 in self.media_asset do
			mediaAsset[k] = v3:jsonEncode()
		end

		v2.mediaAsset = mediaAsset
	end

	if self.social_link ~= nil and next(self.social_link) ~= nil then
		local socialLink = {}

		for k, v3 in self.social_link do
			socialLink[k] = v3:jsonEncode()
		end

		v2.socialLink = socialLink
	end

	if self.game_developer_product ~= nil and next(self.game_developer_product) ~= nil then
		local gameDeveloperProduct = {}

		for k, v3 in self.game_developer_product do
			gameDeveloperProduct[k] = v3:jsonEncode()
		end

		v2.gameDeveloperProduct = gameDeveloperProduct
	end

	if self.game_subscription ~= nil and next(self.game_subscription) ~= nil then
		local gameSubscription = {}

		for k, v3 in self.game_subscription do
			gameSubscription[k] = v3:jsonEncode()
		end

		v2.gameSubscription = gameSubscription
	end

	if self.marketplace_catalog_category ~= nil and next(self.marketplace_catalog_category) ~= nil then
		local marketplaceCatalogCategory = {}

		for k, v3 in self.marketplace_catalog_category do
			marketplaceCatalogCategory[k] = v3:jsonEncode()
		end

		v2.marketplaceCatalogCategory = marketplaceCatalogCategory
	end

	if self.marketplace_asset ~= nil and next(self.marketplace_asset) ~= nil then
		local marketplaceAsset = {}

		for k, v3 in self.marketplace_asset do
			marketplaceAsset[k] = v3:jsonEncode()
		end

		v2.marketplaceAsset = marketplaceAsset
	end

	if self.marketplace_bundle ~= nil and next(self.marketplace_bundle) ~= nil then
		local marketplaceBundle = {}

		for k, v3 in self.marketplace_bundle do
			marketplaceBundle[k] = v3:jsonEncode()
		end

		v2.marketplaceBundle = marketplaceBundle
	end

	if self.marketplace_look ~= nil and next(self.marketplace_look) ~= nil then
		local marketplaceLook = {}

		for k, v3 in self.marketplace_look do
			marketplaceLook[k] = v3:jsonEncode()
		end

		v2.marketplaceLook = marketplaceLook
	end

	if self.catalog_sort ~= nil and next(self.catalog_sort) ~= nil then
		local catalogSort = {}

		for k, v3 in self.catalog_sort do
			catalogSort[k] = v3:jsonEncode()
		end

		v2.catalogSort = catalogSort
	end

	if self.age_recommendation ~= nil and next(self.age_recommendation) ~= nil then
		local ageRecommendation = {}

		for k, v3 in self.age_recommendation do
			ageRecommendation[k] = v3:jsonEncode()
		end

		v2.ageRecommendation = ageRecommendation
	end

	if self.universe_user_follow ~= nil and next(self.universe_user_follow) ~= nil then
		local universeUserFollow = {}

		for k, v3 in self.universe_user_follow do
			universeUserFollow[k] = v3:jsonEncode()
		end

		v2.universeUserFollow = universeUserFollow
	end

	if self.universe_user_vote ~= nil and next(self.universe_user_vote) ~= nil then
		local universeUserVote = {}

		for k, v3 in self.universe_user_vote do
			universeUserVote[k] = v3:jsonEncode()
		end

		v2.universeUserVote = universeUserVote
	end

	if self.user_profile ~= nil and next(self.user_profile) ~= nil then
		local userProfile = {}

		for k, v3 in self.user_profile do
			userProfile[k] = v3:jsonEncode()
		end

		v2.userProfile = userProfile
	end

	if self.universe_user_favorite ~= nil and next(self.universe_user_favorite) ~= nil then
		local universeUserFavorite = {}

		for k, v3 in self.universe_user_favorite do
			universeUserFavorite[k] = v3:jsonEncode()
		end

		v2.universeUserFavorite = universeUserFavorite
	end

	if self.playability ~= nil and next(self.playability) ~= nil then
		local playability = {}

		for k, v3 in self.playability do
			playability[k] = v3:jsonEncode()
		end

		v2.playability = playability
	end

	if self.universe_user_follow_limit ~= nil and next(self.universe_user_follow_limit) ~= nil then
		local universeUserFollowLimit = {}

		for k, v3 in self.universe_user_follow_limit do
			universeUserFollowLimit[k] = v3:jsonEncode()
		end

		v2.universeUserFollowLimit = universeUserFollowLimit
	end

	if self.universe_user_vote_feedback_metadata ~= nil and next(self.universe_user_vote_feedback_metadata) ~= nil then
		local universeUserVoteFeedbackMetadata = {}

		for k, v3 in self.universe_user_vote_feedback_metadata do
			universeUserVoteFeedbackMetadata[k] = v3:jsonEncode()
		end

		v2.universeUserVoteFeedbackMetadata = universeUserVoteFeedbackMetadata
	end

	if self.moment ~= nil and next(self.moment) ~= nil then
		local moment = {}

		for k, v3 in self.moment do
			moment[k] = v3:jsonEncode()
		end

		v2.moment = moment
	end

	if self.community ~= nil and next(self.community) ~= nil then
		local community = {}

		for k, v3 in self.community do
			community[k] = v3:jsonEncode()
		end

		v2.community = community
	end

	if self.community_user_membership ~= nil and next(self.community_user_membership) ~= nil then
		local communityUserMembership = {}

		for k, v3 in self.community_user_membership do
			communityUserMembership[k] = v3:jsonEncode()
		end

		v2.communityUserMembership = communityUserMembership
	end

	if self.friend_recommendation ~= nil and next(self.friend_recommendation) ~= nil then
		local friendRecommendation = {}

		for k, v3 in self.friend_recommendation do
			friendRecommendation[k] = v3:jsonEncode()
		end

		v2.friendRecommendation = friendRecommendation
	end

	if self.universe_private_server ~= nil and next(self.universe_private_server) ~= nil then
		local universePrivateServer = {}

		for k, v3 in self.universe_private_server do
			universePrivateServer[k] = v3:jsonEncode()
		end

		v2.universePrivateServer = universePrivateServer
	end

	if self.notification_badge ~= nil and next(self.notification_badge) ~= nil then
		local notificationBadge = {}

		for k, v3 in self.notification_badge do
			notificationBadge[k] = v3:jsonEncode()
		end

		v2.notificationBadge = notificationBadge
	end

	if self.collectible_item ~= nil and next(self.collectible_item) ~= nil then
		local collectibleItem = {}

		for k, v3 in self.collectible_item do
			collectibleItem[k] = v3:jsonEncode()
		end

		v2.collectibleItem = collectibleItem
	end

	if self.leaderboard_stats ~= nil and next(self.leaderboard_stats) ~= nil then
		local leaderboardStats = {}

		for k, leaderboard_stat in self.leaderboard_stats do
			leaderboardStats[k] = leaderboard_stat:jsonEncode()
		end

		v2.leaderboardStats = leaderboardStats
	end

	if self.marketplace_asset_user_favorite ~= nil and next(self.marketplace_asset_user_favorite) ~= nil then
		local marketplaceAssetUserFavorite = {}

		for k, v3 in self.marketplace_asset_user_favorite do
			marketplaceAssetUserFavorite[k] = v3:jsonEncode()
		end

		v2.marketplaceAssetUserFavorite = marketplaceAssetUserFavorite
	end

	if self.marketplace_bundle_user_favorite ~= nil and next(self.marketplace_bundle_user_favorite) ~= nil then
		local marketplaceBundleUserFavorite = {}

		for k, v3 in self.marketplace_bundle_user_favorite do
			marketplaceBundleUserFavorite[k] = v3:jsonEncode()
		end

		v2.marketplaceBundleUserFavorite = marketplaceBundleUserFavorite
	end

	if self.buy_robux_one_time_product ~= nil and next(self.buy_robux_one_time_product) ~= nil then
		local buyRobuxOneTimeProduct = {}

		for k, v3 in self.buy_robux_one_time_product do
			buyRobuxOneTimeProduct[k] = v3:jsonEncode()
		end

		v2.buyRobuxOneTimeProduct = buyRobuxOneTimeProduct
	end

	if self.buy_robux_subscription_product ~= nil and next(self.buy_robux_subscription_product) ~= nil then
		local buyRobuxSubscriptionProduct = {}

		for k, v3 in self.buy_robux_subscription_product do
			buyRobuxSubscriptionProduct[k] = v3:jsonEncode()
		end

		v2.buyRobuxSubscriptionProduct = buyRobuxSubscriptionProduct
	end

	if self.buy_robux_pending_transfer ~= nil and next(self.buy_robux_pending_transfer) ~= nil then
		local buyRobuxPendingTransfer = {}

		for k, v3 in self.buy_robux_pending_transfer do
			buyRobuxPendingTransfer[k] = v3:jsonEncode()
		end

		v2.buyRobuxPendingTransfer = buyRobuxPendingTransfer
	end

	if self.buy_robux_bonus_item ~= nil and next(self.buy_robux_bonus_item) ~= nil then
		local buyRobuxBonusItem = {}

		for k, v3 in self.buy_robux_bonus_item do
			buyRobuxBonusItem[k] = v3:jsonEncode()
		end

		v2.buyRobuxBonusItem = buyRobuxBonusItem
	end

	if self.user_library_saved_state ~= nil and next(self.user_library_saved_state) ~= nil then
		local userLibrarySavedState = {}

		for k, v3 in self.user_library_saved_state do
			userLibrarySavedState[k] = v3:jsonEncode()
		end

		v2.userLibrarySavedState = userLibrarySavedState
	end

	if self.game_pass_vote == nil or next(self.game_pass_vote) == nil then
		return v2
	end

	local gamePassVote = {}

	for k, v3 in self.game_pass_vote do
		gamePassVote[k] = v3:jsonEncode()
	end

	v2.gamePassVote = gamePassVote

	return v2
end

function class.jsonDecode(data)
	local v2 = class.new()

	if data.badge ~= nil then
		local badge = {}

		for k, v3 in data.badge do
			badge[k] = badge_data.BadgeData.jsonDecode(v3)
		end

		v2.badge = badge
	end

	if data.universe ~= nil then
		local universe = {}

		for k, v3 in data.universe do
			universe[k] = universe_data.UniverseData.jsonDecode(v3)
		end

		v2.universe = universe
	end

	if data.creator ~= nil then
		local creator = {}

		for k, v3 in data.creator do
			creator[k] = creator_data.CreatorData.jsonDecode(v3)
		end

		v2.creator = creator
	end

	if data.event ~= nil then
		local event = {}

		for k, v3 in data.event do
			event[k] = event_data.EventData.jsonDecode(v3)
		end

		v2.event = event
	end

	if data.song ~= nil then
		local song = {}

		for k, v3 in data.song do
			song[k] = song_data.SongData.jsonDecode(v3)
		end

		v2.song = song
	end

	if data.game_pass ~= nil then
		local game_pass = {}

		for k, v3 in data.game_pass do
			game_pass[k] = game_pass_data.GamePassData.jsonDecode(v3)
		end

		v2.game_pass = game_pass
	end

	if data.gamePass ~= nil then
		local game_pass = {}

		for k, v3 in data.gamePass do
			game_pass[k] = game_pass_data.GamePassData.jsonDecode(v3)
		end

		v2.game_pass = game_pass
	end

	if data.media_asset ~= nil then
		local media_asset = {}

		for k, v3 in data.media_asset do
			media_asset[k] = media_asset_data.MediaAssetData.jsonDecode(v3)
		end

		v2.media_asset = media_asset
	end

	if data.mediaAsset ~= nil then
		local media_asset = {}

		for k, v3 in data.mediaAsset do
			media_asset[k] = media_asset_data.MediaAssetData.jsonDecode(v3)
		end

		v2.media_asset = media_asset
	end

	if data.social_link ~= nil then
		local social_link = {}

		for k, v3 in data.social_link do
			social_link[k] = social_link_data.SocialLinkData.jsonDecode(v3)
		end

		v2.social_link = social_link
	end

	if data.socialLink ~= nil then
		local social_link = {}

		for k, v3 in data.socialLink do
			social_link[k] = social_link_data.SocialLinkData.jsonDecode(v3)
		end

		v2.social_link = social_link
	end

	if data.game_developer_product ~= nil then
		local game_developer_product = {}

		for k, v3 in data.game_developer_product do
			game_developer_product[k] = game_developer_product_data.GameDeveloperProductData.jsonDecode(v3)
		end

		v2.game_developer_product = game_developer_product
	end

	if data.gameDeveloperProduct ~= nil then
		local game_developer_product = {}

		for k, v3 in data.gameDeveloperProduct do
			game_developer_product[k] = game_developer_product_data.GameDeveloperProductData.jsonDecode(v3)
		end

		v2.game_developer_product = game_developer_product
	end

	if data.game_subscription ~= nil then
		local game_subscription = {}

		for k, v3 in data.game_subscription do
			game_subscription[k] = game_subscription_data.GameSubscriptionData.jsonDecode(v3)
		end

		v2.game_subscription = game_subscription
	end

	if data.gameSubscription ~= nil then
		local game_subscription = {}

		for k, v3 in data.gameSubscription do
			game_subscription[k] = game_subscription_data.GameSubscriptionData.jsonDecode(v3)
		end

		v2.game_subscription = game_subscription
	end

	if data.marketplace_catalog_category ~= nil then
		local marketplace_catalog_category = {}

		for k, v3 in data.marketplace_catalog_category do
			marketplace_catalog_category[k] = marketplace_catalog_category_data.MarketplaceCatalogCategoryData.jsonDecode(v3)
		end

		v2.marketplace_catalog_category = marketplace_catalog_category
	end

	if data.marketplaceCatalogCategory ~= nil then
		local marketplace_catalog_category = {}

		for k, v3 in data.marketplaceCatalogCategory do
			marketplace_catalog_category[k] = marketplace_catalog_category_data.MarketplaceCatalogCategoryData.jsonDecode(v3)
		end

		v2.marketplace_catalog_category = marketplace_catalog_category
	end

	if data.marketplace_asset ~= nil then
		local marketplace_asset = {}

		for k, v3 in data.marketplace_asset do
			marketplace_asset[k] = marketplace_asset_data.MarketplaceAssetData.jsonDecode(v3)
		end

		v2.marketplace_asset = marketplace_asset
	end

	if data.marketplaceAsset ~= nil then
		local marketplace_asset = {}

		for k, v3 in data.marketplaceAsset do
			marketplace_asset[k] = marketplace_asset_data.MarketplaceAssetData.jsonDecode(v3)
		end

		v2.marketplace_asset = marketplace_asset
	end

	if data.marketplace_bundle ~= nil then
		local marketplace_bundle = {}

		for k, v3 in data.marketplace_bundle do
			marketplace_bundle[k] = marketplace_bundle_data.MarketplaceBundleData.jsonDecode(v3)
		end

		v2.marketplace_bundle = marketplace_bundle
	end

	if data.marketplaceBundle ~= nil then
		local marketplace_bundle = {}

		for k, v3 in data.marketplaceBundle do
			marketplace_bundle[k] = marketplace_bundle_data.MarketplaceBundleData.jsonDecode(v3)
		end

		v2.marketplace_bundle = marketplace_bundle
	end

	if data.marketplace_look ~= nil then
		local marketplace_look = {}

		for k, v3 in data.marketplace_look do
			marketplace_look[k] = marketplace_look_data.MarketplaceLookData.jsonDecode(v3)
		end

		v2.marketplace_look = marketplace_look
	end

	if data.marketplaceLook ~= nil then
		local marketplace_look = {}

		for k, v3 in data.marketplaceLook do
			marketplace_look[k] = marketplace_look_data.MarketplaceLookData.jsonDecode(v3)
		end

		v2.marketplace_look = marketplace_look
	end

	if data.catalog_sort ~= nil then
		local catalog_sort = {}

		for k, v3 in data.catalog_sort do
			catalog_sort[k] = catalog_sort_data.CatalogSortData.jsonDecode(v3)
		end

		v2.catalog_sort = catalog_sort
	end

	if data.catalogSort ~= nil then
		local catalog_sort = {}

		for k, v3 in data.catalogSort do
			catalog_sort[k] = catalog_sort_data.CatalogSortData.jsonDecode(v3)
		end

		v2.catalog_sort = catalog_sort
	end

	if data.age_recommendation ~= nil then
		local age_recommendation = {}

		for k, v3 in data.age_recommendation do
			age_recommendation[k] = age_recommendation_data.AgeRecommendationData.jsonDecode(v3)
		end

		v2.age_recommendation = age_recommendation
	end

	if data.ageRecommendation ~= nil then
		local age_recommendation = {}

		for k, v3 in data.ageRecommendation do
			age_recommendation[k] = age_recommendation_data.AgeRecommendationData.jsonDecode(v3)
		end

		v2.age_recommendation = age_recommendation
	end

	if data.universe_user_follow ~= nil then
		local universe_user_follow = {}

		for k, v3 in data.universe_user_follow do
			universe_user_follow[k] = universe_user_follow_data.UniverseUserFollowData.jsonDecode(v3)
		end

		v2.universe_user_follow = universe_user_follow
	end

	if data.universeUserFollow ~= nil then
		local universe_user_follow = {}

		for k, v3 in data.universeUserFollow do
			universe_user_follow[k] = universe_user_follow_data.UniverseUserFollowData.jsonDecode(v3)
		end

		v2.universe_user_follow = universe_user_follow
	end

	if data.universe_user_vote ~= nil then
		local universe_user_vote = {}

		for k, v3 in data.universe_user_vote do
			universe_user_vote[k] = universe_user_vote_data.UniverseUserVoteData.jsonDecode(v3)
		end

		v2.universe_user_vote = universe_user_vote
	end

	if data.universeUserVote ~= nil then
		local universe_user_vote = {}

		for k, v3 in data.universeUserVote do
			universe_user_vote[k] = universe_user_vote_data.UniverseUserVoteData.jsonDecode(v3)
		end

		v2.universe_user_vote = universe_user_vote
	end

	if data.user_profile ~= nil then
		local user_profile = {}

		for k, v3 in data.user_profile do
			user_profile[k] = user_profile_data.UserProfileData.jsonDecode(v3)
		end

		v2.user_profile = user_profile
	end

	if data.userProfile ~= nil then
		local user_profile = {}

		for k, v3 in data.userProfile do
			user_profile[k] = user_profile_data.UserProfileData.jsonDecode(v3)
		end

		v2.user_profile = user_profile
	end

	if data.universe_user_favorite ~= nil then
		local universe_user_favorite = {}

		for k, v3 in data.universe_user_favorite do
			universe_user_favorite[k] = universe_user_favorite_data.UniverseUserFavoriteData.jsonDecode(v3)
		end

		v2.universe_user_favorite = universe_user_favorite
	end

	if data.universeUserFavorite ~= nil then
		local universe_user_favorite = {}

		for k, v3 in data.universeUserFavorite do
			universe_user_favorite[k] = universe_user_favorite_data.UniverseUserFavoriteData.jsonDecode(v3)
		end

		v2.universe_user_favorite = universe_user_favorite
	end

	if data.playability ~= nil then
		local playability = {}

		for k, v3 in data.playability do
			playability[k] = playability_data.PlayabilityData.jsonDecode(v3)
		end

		v2.playability = playability
	end

	if data.universe_user_follow_limit ~= nil then
		local universe_user_follow_limit = {}

		for k, v3 in data.universe_user_follow_limit do
			universe_user_follow_limit[k] = universe_user_follow_limit_data.UniverseUserFollowLimitData.jsonDecode(v3)
		end

		v2.universe_user_follow_limit = universe_user_follow_limit
	end

	if data.universeUserFollowLimit ~= nil then
		local universe_user_follow_limit = {}

		for k, v3 in data.universeUserFollowLimit do
			universe_user_follow_limit[k] = universe_user_follow_limit_data.UniverseUserFollowLimitData.jsonDecode(v3)
		end

		v2.universe_user_follow_limit = universe_user_follow_limit
	end

	if data.universe_user_vote_feedback_metadata ~= nil then
		local universe_user_vote_feedback_metadata = {}

		for k, v3 in data.universe_user_vote_feedback_metadata do
			universe_user_vote_feedback_metadata[k] = universe_user_vote_feedback_metadata_data.UniverseUserVoteFeedbackMetadataData.jsonDecode(v3)
		end

		v2.universe_user_vote_feedback_metadata = universe_user_vote_feedback_metadata
	end

	if data.universeUserVoteFeedbackMetadata ~= nil then
		local universe_user_vote_feedback_metadata = {}

		for k, v3 in data.universeUserVoteFeedbackMetadata do
			universe_user_vote_feedback_metadata[k] = universe_user_vote_feedback_metadata_data.UniverseUserVoteFeedbackMetadataData.jsonDecode(v3)
		end

		v2.universe_user_vote_feedback_metadata = universe_user_vote_feedback_metadata
	end

	if data.moment ~= nil then
		local moment = {}

		for k, v3 in data.moment do
			moment[k] = moment_data.MomentData.jsonDecode(v3)
		end

		v2.moment = moment
	end

	if data.community ~= nil then
		local community = {}

		for k, v3 in data.community do
			community[k] = community_data.CommunityData.jsonDecode(v3)
		end

		v2.community = community
	end

	if data.community_user_membership ~= nil then
		local community_user_membership = {}

		for k, v3 in data.community_user_membership do
			community_user_membership[k] = community_user_membership_data.CommunityUserMembershipData.jsonDecode(v3)
		end

		v2.community_user_membership = community_user_membership
	end

	if data.communityUserMembership ~= nil then
		local community_user_membership = {}

		for k, v3 in data.communityUserMembership do
			community_user_membership[k] = community_user_membership_data.CommunityUserMembershipData.jsonDecode(v3)
		end

		v2.community_user_membership = community_user_membership
	end

	if data.friend_recommendation ~= nil then
		local friend_recommendation = {}

		for k, v3 in data.friend_recommendation do
			friend_recommendation[k] = friend_recommendation_data.FriendRecommendationData.jsonDecode(v3)
		end

		v2.friend_recommendation = friend_recommendation
	end

	if data.friendRecommendation ~= nil then
		local friend_recommendation = {}

		for k, v3 in data.friendRecommendation do
			friend_recommendation[k] = friend_recommendation_data.FriendRecommendationData.jsonDecode(v3)
		end

		v2.friend_recommendation = friend_recommendation
	end

	if data.universe_private_server ~= nil then
		local universe_private_server = {}

		for k, v3 in data.universe_private_server do
			universe_private_server[k] = universe_private_server_data.UniversePrivateServerData.jsonDecode(v3)
		end

		v2.universe_private_server = universe_private_server
	end

	if data.universePrivateServer ~= nil then
		local universe_private_server = {}

		for k, v3 in data.universePrivateServer do
			universe_private_server[k] = universe_private_server_data.UniversePrivateServerData.jsonDecode(v3)
		end

		v2.universe_private_server = universe_private_server
	end

	if data.notification_badge ~= nil then
		local notification_badge = {}

		for k, v3 in data.notification_badge do
			notification_badge[k] = notification_badge_data.NotificationBadgeData.jsonDecode(v3)
		end

		v2.notification_badge = notification_badge
	end

	if data.notificationBadge ~= nil then
		local notification_badge = {}

		for k, v3 in data.notificationBadge do
			notification_badge[k] = notification_badge_data.NotificationBadgeData.jsonDecode(v3)
		end

		v2.notification_badge = notification_badge
	end

	if data.collectible_item ~= nil then
		local collectible_item = {}

		for k, v3 in data.collectible_item do
			collectible_item[k] = collectible_item_data.CollectibleItemData.jsonDecode(v3)
		end

		v2.collectible_item = collectible_item
	end

	if data.collectibleItem ~= nil then
		local collectible_item = {}

		for k, v3 in data.collectibleItem do
			collectible_item[k] = collectible_item_data.CollectibleItemData.jsonDecode(v3)
		end

		v2.collectible_item = collectible_item
	end

	if data.leaderboard_stats ~= nil then
		local leaderboard_stats = {}

		for k, leaderboard_stat in data.leaderboard_stats do
			leaderboard_stats[k] = leaderboard_stats_data.LeaderboardStatsData.jsonDecode(leaderboard_stat)
		end

		v2.leaderboard_stats = leaderboard_stats
	end

	if data.leaderboardStats ~= nil then
		local leaderboard_stats = {}

		for k, leaderboardStat in data.leaderboardStats do
			leaderboard_stats[k] = leaderboard_stats_data.LeaderboardStatsData.jsonDecode(leaderboardStat)
		end

		v2.leaderboard_stats = leaderboard_stats
	end

	if data.marketplace_asset_user_favorite ~= nil then
		local marketplace_asset_user_favorite = {}

		for k, v3 in data.marketplace_asset_user_favorite do
			marketplace_asset_user_favorite[k] = marketplace_item_user_favorite_data.MarketplaceItemUserFavoriteData.jsonDecode(v3)
		end

		v2.marketplace_asset_user_favorite = marketplace_asset_user_favorite
	end

	if data.marketplaceAssetUserFavorite ~= nil then
		local marketplace_asset_user_favorite = {}

		for k, v3 in data.marketplaceAssetUserFavorite do
			marketplace_asset_user_favorite[k] = marketplace_item_user_favorite_data.MarketplaceItemUserFavoriteData.jsonDecode(v3)
		end

		v2.marketplace_asset_user_favorite = marketplace_asset_user_favorite
	end

	if data.marketplace_bundle_user_favorite ~= nil then
		local marketplace_bundle_user_favorite = {}

		for k, v3 in data.marketplace_bundle_user_favorite do
			marketplace_bundle_user_favorite[k] = marketplace_item_user_favorite_data.MarketplaceItemUserFavoriteData.jsonDecode(v3)
		end

		v2.marketplace_bundle_user_favorite = marketplace_bundle_user_favorite
	end

	if data.marketplaceBundleUserFavorite ~= nil then
		local marketplace_bundle_user_favorite = {}

		for k, v3 in data.marketplaceBundleUserFavorite do
			marketplace_bundle_user_favorite[k] = marketplace_item_user_favorite_data.MarketplaceItemUserFavoriteData.jsonDecode(v3)
		end

		v2.marketplace_bundle_user_favorite = marketplace_bundle_user_favorite
	end

	if data.buy_robux_one_time_product ~= nil then
		local buy_robux_one_time_product = {}

		for k, v3 in data.buy_robux_one_time_product do
			buy_robux_one_time_product[k] = buy_robux_product_data.BuyRobuxOneTimeProductData.jsonDecode(v3)
		end

		v2.buy_robux_one_time_product = buy_robux_one_time_product
	end

	if data.buyRobuxOneTimeProduct ~= nil then
		local buy_robux_one_time_product = {}

		for k, v3 in data.buyRobuxOneTimeProduct do
			buy_robux_one_time_product[k] = buy_robux_product_data.BuyRobuxOneTimeProductData.jsonDecode(v3)
		end

		v2.buy_robux_one_time_product = buy_robux_one_time_product
	end

	if data.buy_robux_subscription_product ~= nil then
		local buy_robux_subscription_product = {}

		for k, v3 in data.buy_robux_subscription_product do
			buy_robux_subscription_product[k] = buy_robux_product_data.BuyRobuxSubscriptionProductData.jsonDecode(v3)
		end

		v2.buy_robux_subscription_product = buy_robux_subscription_product
	end

	if data.buyRobuxSubscriptionProduct ~= nil then
		local buy_robux_subscription_product = {}

		for k, v3 in data.buyRobuxSubscriptionProduct do
			buy_robux_subscription_product[k] = buy_robux_product_data.BuyRobuxSubscriptionProductData.jsonDecode(v3)
		end

		v2.buy_robux_subscription_product = buy_robux_subscription_product
	end

	if data.buy_robux_pending_transfer ~= nil then
		local buy_robux_pending_transfer = {}

		for k, v3 in data.buy_robux_pending_transfer do
			buy_robux_pending_transfer[k] = buy_robux_pending_transfer_data.BuyRobuxPendingTransferData.jsonDecode(v3)
		end

		v2.buy_robux_pending_transfer = buy_robux_pending_transfer
	end

	if data.buyRobuxPendingTransfer ~= nil then
		local buy_robux_pending_transfer = {}

		for k, v3 in data.buyRobuxPendingTransfer do
			buy_robux_pending_transfer[k] = buy_robux_pending_transfer_data.BuyRobuxPendingTransferData.jsonDecode(v3)
		end

		v2.buy_robux_pending_transfer = buy_robux_pending_transfer
	end

	if data.buy_robux_bonus_item ~= nil then
		local buy_robux_bonus_item = {}

		for k, v3 in data.buy_robux_bonus_item do
			buy_robux_bonus_item[k] = buy_robux_bonus_item_data.BuyRobuxBonusItemData.jsonDecode(v3)
		end

		v2.buy_robux_bonus_item = buy_robux_bonus_item
	end

	if data.buyRobuxBonusItem ~= nil then
		local buy_robux_bonus_item = {}

		for k, v3 in data.buyRobuxBonusItem do
			buy_robux_bonus_item[k] = buy_robux_bonus_item_data.BuyRobuxBonusItemData.jsonDecode(v3)
		end

		v2.buy_robux_bonus_item = buy_robux_bonus_item
	end

	if data.user_library_saved_state ~= nil then
		local user_library_saved_state = {}

		for k, v3 in data.user_library_saved_state do
			user_library_saved_state[k] = user_library_saved_state_data.UserLibrarySavedStateData.jsonDecode(v3)
		end

		v2.user_library_saved_state = user_library_saved_state
	end

	if data.userLibrarySavedState ~= nil then
		local user_library_saved_state = {}

		for k, v3 in data.userLibrarySavedState do
			user_library_saved_state[k] = user_library_saved_state_data.UserLibrarySavedStateData.jsonDecode(v3)
		end

		v2.user_library_saved_state = user_library_saved_state
	end

	if data.game_pass_vote ~= nil then
		local game_pass_vote = {}

		for k, v3 in data.game_pass_vote do
			game_pass_vote[k] = vote_data.VoteData.jsonDecode(v3)
		end

		v2.game_pass_vote = game_pass_vote
	end

	if data.gamePassVote == nil then
		return v2
	end

	local game_pass_vote = {}

	for k, v3 in data.gamePassVote do
		game_pass_vote[k] = vote_data.VoteData.jsonDecode(v3)
	end

	v2.game_pass_vote = game_pass_vote

	return v2
end

class.descriptor = {
	name = "HydrationContent",
	fullName = "roblox.apppageplatform.shared.v1beta1.HydrationContent"
}

v.HydrationContent = class

typeRegistry.default:register(v.HydrationContent)

local class2 = {}
class2.__index = class2

function class2.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class2))
end

function class2:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class2.decode(buf: buffer)
	local result = class2.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = badge_data.BadgeData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class2:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class2.jsonDecode(p)
	local v2 = class2.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = badge_data.BadgeData.jsonDecode(p.value)
	end

	return v2
end

class2.descriptor = {
	name = "HydrationContent_BadgeEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.BadgeEntry"
}

v.HydrationContent_BadgeEntry = class2

typeRegistry.default:register(v.HydrationContent_BadgeEntry)

local class3 = {}
class3.__index = class3

function class3.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class3))
end

function class3:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class3.decode(buf: buffer)
	local result = class3.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = universe_data.UniverseData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class3:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class3.jsonDecode(p)
	local v2 = class3.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = universe_data.UniverseData.jsonDecode(p.value)
	end

	return v2
end

class3.descriptor = {
	name = "HydrationContent_UniverseEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseEntry"
}

v.HydrationContent_UniverseEntry = class3

typeRegistry.default:register(v.HydrationContent_UniverseEntry)

local class4 = {}
class4.__index = class4

function class4.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class4))
end

function class4:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class4.decode(buf: buffer)
	local result = class4.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = creator_data.CreatorData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class4:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class4.jsonDecode(p)
	local v2 = class4.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = creator_data.CreatorData.jsonDecode(p.value)
	end

	return v2
end

class4.descriptor = {
	name = "HydrationContent_CreatorEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.CreatorEntry"
}

v.HydrationContent_CreatorEntry = class4

typeRegistry.default:register(v.HydrationContent_CreatorEntry)

local class5 = {}
class5.__index = class5

function class5.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class5))
end

function class5:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class5.decode(buf: buffer)
	local result = class5.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = event_data.EventData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class5:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class5.jsonDecode(p)
	local v2 = class5.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = event_data.EventData.jsonDecode(p.value)
	end

	return v2
end

class5.descriptor = {
	name = "HydrationContent_EventEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.EventEntry"
}

v.HydrationContent_EventEntry = class5

typeRegistry.default:register(v.HydrationContent_EventEntry)

local class6 = {}
class6.__index = class6

function class6.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class6))
end

function class6:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class6.decode(buf: buffer)
	local result = class6.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = song_data.SongData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class6:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class6.jsonDecode(p)
	local v2 = class6.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = song_data.SongData.jsonDecode(p.value)
	end

	return v2
end

class6.descriptor = {
	name = "HydrationContent_SongEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.SongEntry"
}

v.HydrationContent_SongEntry = class6

typeRegistry.default:register(v.HydrationContent_SongEntry)

local class7 = {}
class7.__index = class7

function class7.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class7))
end

function class7:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class7.decode(buf: buffer)
	local result = class7.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = game_pass_data.GamePassData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class7:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class7.jsonDecode(p)
	local v2 = class7.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = game_pass_data.GamePassData.jsonDecode(p.value)
	end

	return v2
end

class7.descriptor = {
	name = "HydrationContent_GamePassEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.GamePassEntry"
}

v.HydrationContent_GamePassEntry = class7

typeRegistry.default:register(v.HydrationContent_GamePassEntry)

local class8 = {}
class8.__index = class8

function class8.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class8))
end

function class8:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class8.decode(buf: buffer)
	local result = class8.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = media_asset_data.MediaAssetData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class8:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class8.jsonDecode(p)
	local v2 = class8.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = media_asset_data.MediaAssetData.jsonDecode(p.value)
	end

	return v2
end

class8.descriptor = {
	name = "HydrationContent_MediaAssetEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.MediaAssetEntry"
}

v.HydrationContent_MediaAssetEntry = class8

typeRegistry.default:register(v.HydrationContent_MediaAssetEntry)

local class9 = {}
class9.__index = class9

function class9.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class9))
end

function class9:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class9.decode(buf: buffer)
	local result = class9.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = social_link_data.SocialLinkData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class9:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class9.jsonDecode(p)
	local v2 = class9.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = social_link_data.SocialLinkData.jsonDecode(p.value)
	end

	return v2
end

class9.descriptor = {
	name = "HydrationContent_SocialLinkEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.SocialLinkEntry"
}

v.HydrationContent_SocialLinkEntry = class9

typeRegistry.default:register(v.HydrationContent_SocialLinkEntry)

local class10 = {}
class10.__index = class10

function class10.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class10))
end

function class10:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class10.decode(buf: buffer)
	local result = class10.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = game_developer_product_data.GameDeveloperProductData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class10:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class10.jsonDecode(p)
	local v2 = class10.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = game_developer_product_data.GameDeveloperProductData.jsonDecode(p.value)
	end

	return v2
end

class10.descriptor = {
	name = "HydrationContent_GameDeveloperProductEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.GameDeveloperProductEntry"
}

v.HydrationContent_GameDeveloperProductEntry = class10

typeRegistry.default:register(v.HydrationContent_GameDeveloperProductEntry)

local class11 = {}
class11.__index = class11

function class11.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class11))
end

function class11:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class11.decode(buf: buffer)
	local result = class11.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = game_subscription_data.GameSubscriptionData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class11:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class11.jsonDecode(p)
	local v2 = class11.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = game_subscription_data.GameSubscriptionData.jsonDecode(p.value)
	end

	return v2
end

class11.descriptor = {
	name = "HydrationContent_GameSubscriptionEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.GameSubscriptionEntry"
}

v.HydrationContent_GameSubscriptionEntry = class11

typeRegistry.default:register(v.HydrationContent_GameSubscriptionEntry)

local class12 = {}
class12.__index = class12

function class12.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class12))
end

function class12:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class12.decode(buf: buffer)
	local result = class12.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = marketplace_catalog_category_data.MarketplaceCatalogCategoryData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class12:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class12.jsonDecode(p)
	local v2 = class12.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = marketplace_catalog_category_data.MarketplaceCatalogCategoryData.jsonDecode(p.value)
	end

	return v2
end

class12.descriptor = {
	name = "HydrationContent_MarketplaceCatalogCategoryEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceCatalogCategoryEntry"
}

v.HydrationContent_MarketplaceCatalogCategoryEntry = class12

typeRegistry.default:register(v.HydrationContent_MarketplaceCatalogCategoryEntry)

local class13 = {}
class13.__index = class13

function class13.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class13))
end

function class13:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class13.decode(buf: buffer)
	local result = class13.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = marketplace_asset_data.MarketplaceAssetData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class13:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class13.jsonDecode(p)
	local v2 = class13.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = marketplace_asset_data.MarketplaceAssetData.jsonDecode(p.value)
	end

	return v2
end

class13.descriptor = {
	name = "HydrationContent_MarketplaceAssetEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceAssetEntry"
}

v.HydrationContent_MarketplaceAssetEntry = class13

typeRegistry.default:register(v.HydrationContent_MarketplaceAssetEntry)

local class14 = {}
class14.__index = class14

function class14.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class14))
end

function class14:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class14.decode(buf: buffer)
	local result = class14.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = marketplace_bundle_data.MarketplaceBundleData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class14:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class14.jsonDecode(p)
	local v2 = class14.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = marketplace_bundle_data.MarketplaceBundleData.jsonDecode(p.value)
	end

	return v2
end

class14.descriptor = {
	name = "HydrationContent_MarketplaceBundleEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceBundleEntry"
}

v.HydrationContent_MarketplaceBundleEntry = class14

typeRegistry.default:register(v.HydrationContent_MarketplaceBundleEntry)

local class15 = {}
class15.__index = class15

function class15.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class15))
end

function class15:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class15.decode(buf: buffer)
	local result = class15.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = marketplace_look_data.MarketplaceLookData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class15:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class15.jsonDecode(p)
	local v2 = class15.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = marketplace_look_data.MarketplaceLookData.jsonDecode(p.value)
	end

	return v2
end

class15.descriptor = {
	name = "HydrationContent_MarketplaceLookEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceLookEntry"
}

v.HydrationContent_MarketplaceLookEntry = class15

typeRegistry.default:register(v.HydrationContent_MarketplaceLookEntry)

local class16 = {}
class16.__index = class16

function class16.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class16))
end

function class16:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class16.decode(buf: buffer)
	local result = class16.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = catalog_sort_data.CatalogSortData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class16:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class16.jsonDecode(p)
	local v2 = class16.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = catalog_sort_data.CatalogSortData.jsonDecode(p.value)
	end

	return v2
end

class16.descriptor = {
	name = "HydrationContent_CatalogSortEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.CatalogSortEntry"
}

v.HydrationContent_CatalogSortEntry = class16

typeRegistry.default:register(v.HydrationContent_CatalogSortEntry)

local class17 = {}
class17.__index = class17

function class17.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class17))
end

function class17:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class17.decode(buf: buffer)
	local result = class17.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = age_recommendation_data.AgeRecommendationData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class17:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class17.jsonDecode(p)
	local v2 = class17.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = age_recommendation_data.AgeRecommendationData.jsonDecode(p.value)
	end

	return v2
end

class17.descriptor = {
	name = "HydrationContent_AgeRecommendationEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.AgeRecommendationEntry"
}

v.HydrationContent_AgeRecommendationEntry = class17

typeRegistry.default:register(v.HydrationContent_AgeRecommendationEntry)

local class18 = {}
class18.__index = class18

function class18.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class18))
end

function class18:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class18.decode(buf: buffer)
	local result = class18.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = universe_user_follow_data.UniverseUserFollowData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class18:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class18.jsonDecode(p)
	local v2 = class18.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = universe_user_follow_data.UniverseUserFollowData.jsonDecode(p.value)
	end

	return v2
end

class18.descriptor = {
	name = "HydrationContent_UniverseUserFollowEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseUserFollowEntry"
}

v.HydrationContent_UniverseUserFollowEntry = class18

typeRegistry.default:register(v.HydrationContent_UniverseUserFollowEntry)

local class19 = {}
class19.__index = class19

function class19.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class19))
end

function class19:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class19.decode(buf: buffer)
	local result = class19.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = universe_user_vote_data.UniverseUserVoteData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class19:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class19.jsonDecode(p)
	local v2 = class19.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = universe_user_vote_data.UniverseUserVoteData.jsonDecode(p.value)
	end

	return v2
end

class19.descriptor = {
	name = "HydrationContent_UniverseUserVoteEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseUserVoteEntry"
}

v.HydrationContent_UniverseUserVoteEntry = class19

typeRegistry.default:register(v.HydrationContent_UniverseUserVoteEntry)

local class20 = {}
class20.__index = class20

function class20.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class20))
end

function class20:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class20.decode(buf: buffer)
	local result = class20.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = user_profile_data.UserProfileData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class20:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class20.jsonDecode(p)
	local v2 = class20.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = user_profile_data.UserProfileData.jsonDecode(p.value)
	end

	return v2
end

class20.descriptor = {
	name = "HydrationContent_UserProfileEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UserProfileEntry"
}

v.HydrationContent_UserProfileEntry = class20

typeRegistry.default:register(v.HydrationContent_UserProfileEntry)

local class21 = {}
class21.__index = class21

function class21.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class21))
end

function class21:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class21.decode(buf: buffer)
	local result = class21.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = universe_user_favorite_data.UniverseUserFavoriteData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class21:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class21.jsonDecode(p)
	local v2 = class21.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = universe_user_favorite_data.UniverseUserFavoriteData.jsonDecode(p.value)
	end

	return v2
end

class21.descriptor = {
	name = "HydrationContent_UniverseUserFavoriteEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseUserFavoriteEntry"
}

v.HydrationContent_UniverseUserFavoriteEntry = class21

typeRegistry.default:register(v.HydrationContent_UniverseUserFavoriteEntry)

local class22 = {}
class22.__index = class22

function class22.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class22))
end

function class22:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class22.decode(buf: buffer)
	local result = class22.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = playability_data.PlayabilityData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class22:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class22.jsonDecode(p)
	local v2 = class22.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = playability_data.PlayabilityData.jsonDecode(p.value)
	end

	return v2
end

class22.descriptor = {
	name = "HydrationContent_PlayabilityEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.PlayabilityEntry"
}

v.HydrationContent_PlayabilityEntry = class22

typeRegistry.default:register(v.HydrationContent_PlayabilityEntry)

local class23 = {}
class23.__index = class23

function class23.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class23))
end

function class23:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class23.decode(buf: buffer)
	local result = class23.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = universe_user_follow_limit_data.UniverseUserFollowLimitData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class23:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class23.jsonDecode(p)
	local v2 = class23.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = universe_user_follow_limit_data.UniverseUserFollowLimitData.jsonDecode(p.value)
	end

	return v2
end

class23.descriptor = {
	name = "HydrationContent_UniverseUserFollowLimitEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseUserFollowLimitEntry"
}

v.HydrationContent_UniverseUserFollowLimitEntry = class23

typeRegistry.default:register(v.HydrationContent_UniverseUserFollowLimitEntry)

local class24 = {}
class24.__index = class24

function class24.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class24))
end

function class24:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class24.decode(buf: buffer)
	local result = class24.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = universe_user_vote_feedback_metadata_data.UniverseUserVoteFeedbackMetadataData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class24:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class24.jsonDecode(p)
	local v2 = class24.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = universe_user_vote_feedback_metadata_data.UniverseUserVoteFeedbackMetadataData.jsonDecode(p.value)
	end

	return v2
end

class24.descriptor = {
	name = "HydrationContent_UniverseUserVoteFeedbackMetadataEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniverseUserVoteFeedbackMetadataEntry"
}

v.HydrationContent_UniverseUserVoteFeedbackMetadataEntry = class24

typeRegistry.default:register(v.HydrationContent_UniverseUserVoteFeedbackMetadataEntry)

local class25 = {}
class25.__index = class25

function class25.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class25))
end

function class25:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class25.decode(buf: buffer)
	local result = class25.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = moment_data.MomentData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class25:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class25.jsonDecode(p)
	local v2 = class25.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = moment_data.MomentData.jsonDecode(p.value)
	end

	return v2
end

class25.descriptor = {
	name = "HydrationContent_MomentEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.MomentEntry"
}

v.HydrationContent_MomentEntry = class25

typeRegistry.default:register(v.HydrationContent_MomentEntry)

local class26 = {}
class26.__index = class26

function class26.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class26))
end

function class26:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class26.decode(buf: buffer)
	local result = class26.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = community_data.CommunityData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class26:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class26.jsonDecode(p)
	local v2 = class26.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = community_data.CommunityData.jsonDecode(p.value)
	end

	return v2
end

class26.descriptor = {
	name = "HydrationContent_CommunityEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.CommunityEntry"
}

v.HydrationContent_CommunityEntry = class26

typeRegistry.default:register(v.HydrationContent_CommunityEntry)

local class27 = {}
class27.__index = class27

function class27.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class27))
end

function class27:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class27.decode(buf: buffer)
	local result = class27.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = community_user_membership_data.CommunityUserMembershipData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class27:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class27.jsonDecode(p)
	local v2 = class27.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = community_user_membership_data.CommunityUserMembershipData.jsonDecode(p.value)
	end

	return v2
end

class27.descriptor = {
	name = "HydrationContent_CommunityUserMembershipEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.CommunityUserMembershipEntry"
}

v.HydrationContent_CommunityUserMembershipEntry = class27

typeRegistry.default:register(v.HydrationContent_CommunityUserMembershipEntry)

local class28 = {}
class28.__index = class28

function class28.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class28))
end

function class28:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class28.decode(buf: buffer)
	local result = class28.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = friend_recommendation_data.FriendRecommendationData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class28:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class28.jsonDecode(p)
	local v2 = class28.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = friend_recommendation_data.FriendRecommendationData.jsonDecode(p.value)
	end

	return v2
end

class28.descriptor = {
	name = "HydrationContent_FriendRecommendationEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.FriendRecommendationEntry"
}

v.HydrationContent_FriendRecommendationEntry = class28

typeRegistry.default:register(v.HydrationContent_FriendRecommendationEntry)

local class29 = {}
class29.__index = class29

function class29.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class29))
end

function class29:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class29.decode(buf: buffer)
	local result = class29.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = universe_private_server_data.UniversePrivateServerData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class29:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class29.jsonDecode(p)
	local v2 = class29.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = universe_private_server_data.UniversePrivateServerData.jsonDecode(p.value)
	end

	return v2
end

class29.descriptor = {
	name = "HydrationContent_UniversePrivateServerEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UniversePrivateServerEntry"
}

v.HydrationContent_UniversePrivateServerEntry = class29

typeRegistry.default:register(v.HydrationContent_UniversePrivateServerEntry)

local class30 = {}
class30.__index = class30

function class30.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class30))
end

function class30:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class30.decode(buf: buffer)
	local result = class30.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = notification_badge_data.NotificationBadgeData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class30:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class30.jsonDecode(p)
	local v2 = class30.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = notification_badge_data.NotificationBadgeData.jsonDecode(p.value)
	end

	return v2
end

class30.descriptor = {
	name = "HydrationContent_NotificationBadgeEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.NotificationBadgeEntry"
}

v.HydrationContent_NotificationBadgeEntry = class30

typeRegistry.default:register(v.HydrationContent_NotificationBadgeEntry)

local class31 = {}
class31.__index = class31

function class31.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class31))
end

function class31:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class31.decode(buf: buffer)
	local result = class31.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = collectible_item_data.CollectibleItemData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class31:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class31.jsonDecode(p)
	local v2 = class31.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = collectible_item_data.CollectibleItemData.jsonDecode(p.value)
	end

	return v2
end

class31.descriptor = {
	name = "HydrationContent_CollectibleItemEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.CollectibleItemEntry"
}

v.HydrationContent_CollectibleItemEntry = class31

typeRegistry.default:register(v.HydrationContent_CollectibleItemEntry)

local class32 = {}
class32.__index = class32

function class32.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class32))
end

function class32:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class32.decode(buf: buffer)
	local result = class32.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = leaderboard_stats_data.LeaderboardStatsData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class32:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class32.jsonDecode(p)
	local v2 = class32.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = leaderboard_stats_data.LeaderboardStatsData.jsonDecode(p.value)
	end

	return v2
end

class32.descriptor = {
	name = "HydrationContent_LeaderboardStatsEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.LeaderboardStatsEntry"
}

v.HydrationContent_LeaderboardStatsEntry = class32

typeRegistry.default:register(v.HydrationContent_LeaderboardStatsEntry)

local class33 = {}
class33.__index = class33

function class33.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class33))
end

function class33:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class33.decode(buf: buffer)
	local result = class33.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = marketplace_item_user_favorite_data.MarketplaceItemUserFavoriteData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class33:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class33.jsonDecode(p)
	local v2 = class33.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = marketplace_item_user_favorite_data.MarketplaceItemUserFavoriteData.jsonDecode(p.value)
	end

	return v2
end

class33.descriptor = {
	name = "HydrationContent_MarketplaceAssetUserFavoriteEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceAssetUserFavoriteEntry"
}

v.HydrationContent_MarketplaceAssetUserFavoriteEntry = class33

typeRegistry.default:register(v.HydrationContent_MarketplaceAssetUserFavoriteEntry)

local class34 = {}
class34.__index = class34

function class34.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class34))
end

function class34:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class34.decode(buf: buffer)
	local result = class34.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = marketplace_item_user_favorite_data.MarketplaceItemUserFavoriteData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class34:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class34.jsonDecode(p)
	local v2 = class34.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = marketplace_item_user_favorite_data.MarketplaceItemUserFavoriteData.jsonDecode(p.value)
	end

	return v2
end

class34.descriptor = {
	name = "HydrationContent_MarketplaceBundleUserFavoriteEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.MarketplaceBundleUserFavoriteEntry"
}

v.HydrationContent_MarketplaceBundleUserFavoriteEntry = class34

typeRegistry.default:register(v.HydrationContent_MarketplaceBundleUserFavoriteEntry)

local class35 = {}
class35.__index = class35

function class35.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class35))
end

function class35:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class35.decode(buf: buffer)
	local result = class35.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = buy_robux_product_data.BuyRobuxOneTimeProductData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class35:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class35.jsonDecode(p)
	local v2 = class35.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = buy_robux_product_data.BuyRobuxOneTimeProductData.jsonDecode(p.value)
	end

	return v2
end

class35.descriptor = {
	name = "HydrationContent_BuyRobuxOneTimeProductEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.BuyRobuxOneTimeProductEntry"
}

v.HydrationContent_BuyRobuxOneTimeProductEntry = class35

typeRegistry.default:register(v.HydrationContent_BuyRobuxOneTimeProductEntry)

local class36 = {}
class36.__index = class36

function class36.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class36))
end

function class36:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class36.decode(buf: buffer)
	local result = class36.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = buy_robux_product_data.BuyRobuxSubscriptionProductData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class36:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class36.jsonDecode(p)
	local v2 = class36.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = buy_robux_product_data.BuyRobuxSubscriptionProductData.jsonDecode(p.value)
	end

	return v2
end

class36.descriptor = {
	name = "HydrationContent_BuyRobuxSubscriptionProductEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.BuyRobuxSubscriptionProductEntry"
}

v.HydrationContent_BuyRobuxSubscriptionProductEntry = class36

typeRegistry.default:register(v.HydrationContent_BuyRobuxSubscriptionProductEntry)

local class37 = {}
class37.__index = class37

function class37.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class37))
end

function class37:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class37.decode(buf: buffer)
	local result = class37.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = buy_robux_pending_transfer_data.BuyRobuxPendingTransferData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class37:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class37.jsonDecode(p)
	local v2 = class37.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = buy_robux_pending_transfer_data.BuyRobuxPendingTransferData.jsonDecode(p.value)
	end

	return v2
end

class37.descriptor = {
	name = "HydrationContent_BuyRobuxPendingTransferEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.BuyRobuxPendingTransferEntry"
}

v.HydrationContent_BuyRobuxPendingTransferEntry = class37

typeRegistry.default:register(v.HydrationContent_BuyRobuxPendingTransferEntry)

local class38 = {}
class38.__index = class38

function class38.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class38))
end

function class38:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class38.decode(buf: buffer)
	local result = class38.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = buy_robux_bonus_item_data.BuyRobuxBonusItemData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class38:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class38.jsonDecode(p)
	local v2 = class38.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = buy_robux_bonus_item_data.BuyRobuxBonusItemData.jsonDecode(p.value)
	end

	return v2
end

class38.descriptor = {
	name = "HydrationContent_BuyRobuxBonusItemEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.BuyRobuxBonusItemEntry"
}

v.HydrationContent_BuyRobuxBonusItemEntry = class38

typeRegistry.default:register(v.HydrationContent_BuyRobuxBonusItemEntry)

local class39 = {}
class39.__index = class39

function class39.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class39))
end

function class39:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class39.decode(buf: buffer)
	local result = class39.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = user_library_saved_state_data.UserLibrarySavedStateData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class39:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class39.jsonDecode(p)
	local v2 = class39.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = user_library_saved_state_data.UserLibrarySavedStateData.jsonDecode(p.value)
	end

	return v2
end

class39.descriptor = {
	name = "HydrationContent_UserLibrarySavedStateEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.UserLibrarySavedStateEntry"
}

v.HydrationContent_UserLibrarySavedStateEntry = class39

typeRegistry.default:register(v.HydrationContent_UserLibrarySavedStateEntry)

local class40 = {}
class40.__index = class40

function class40.new(p)
	local v2 = {
		key = (p == nil or p.key == nil) and "" or p.key,
		value = 0
	}
	local v3

	if not (p == nil or p.value == nil) then
		v3 = p.value
	end

	v2.value = v3
	return (setmetatable(v2, class40))
end

function class40:encode()
	local v2 = buffer.create(0)
	local v3 = 0

	if self.key ~= nil and self.key ~= "" then
		local v4, v5 = proto.writeTag(v2, v3, 1, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeString(v4, v5, self.key)
	end

	if self.value ~= nil then
		local encoded = self.value:encode()
		local v4, v5 = proto.writeTag(v2, v3, 2, proto.wireTypes.lengthDelimited)
		v2, v3 = proto.writeBuffer(v4, v5, encoded, buffer.len(encoded))
	end

	local buf = buffer.create(v3)
	buffer.copy(buf, 0, v2, 0, v3)
	return buf
end

function class40.decode(buf: buffer)
	local result = class40.new()
	local v2 = 0

	while v2 < buffer.len(buf) do
		local v3, v4
		v3, v4, v2 = proto.readTag(buf, v2)

		if v4 == proto.wireTypes.varint then
			local _
			_, v2 = proto.readVarInt(buf, v2)
		elseif v4 == proto.wireTypes.lengthDelimited then
			if v3 == 1 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.key = buffer.tostring(v5)
			elseif v3 == 2 then
				local v5
				v5, v2 = proto.readBuffer(buf, v2)
				result.value = vote_data.VoteData.decode(v5)
			else
				local varInt, v5 = proto.readVarInt(buf, v2)

				v2 = v5 + varInt
			end
		elseif v4 == proto.wireTypes.i32 then
			local _
			_, v2 = proto.readFixed32(buf, v2)
		elseif v4 == proto.wireTypes.i64 then
			local _
			_, v2 = proto.readFixed64(buf, v2)
		else
			error("Unsupported wire type: " .. v4)
		end
	end

	return result
end

function class40:jsonEncode()
	local v2 = {}

	if self.key ~= nil and self.key ~= "" then
		v2.key = self.key
	end

	if self.value ~= nil then
		v2.value = self.value:jsonEncode()
	end

	return v2
end

function class40.jsonDecode(p)
	local v2 = class40.new()

	if p.key ~= nil then
		v2.key = p.key
	end

	if p.value ~= nil then
		v2.value = vote_data.VoteData.jsonDecode(p.value)
	end

	return v2
end

class40.descriptor = {
	name = "HydrationContent_GamePassVoteEntry",
	fullName = "roblox.apppageplatform.shared.v1beta1.GamePassVoteEntry"
}

v.HydrationContent_GamePassVoteEntry = class40

typeRegistry.default:register(v.HydrationContent_GamePassVoteEntry)

return { HydrationContent = v.HydrationContent }
