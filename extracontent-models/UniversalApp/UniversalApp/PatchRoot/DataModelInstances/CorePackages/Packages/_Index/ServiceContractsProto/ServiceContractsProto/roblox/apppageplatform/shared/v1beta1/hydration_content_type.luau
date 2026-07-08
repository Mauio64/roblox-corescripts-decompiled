require(script.Parent.Parent.Parent.Parent.Parent.proto)
require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

return {
	HydrationContentType = ({
		HydrationContentType = {
			fromNumber = function(n1: number) -- line: 44
				if n1 == 0 then
					return "HYDRATION_CONTENT_TYPE_INVALID"
				end

				if n1 == 1 then
					return "HYDRATION_CONTENT_TYPE_BADGE"
				end

				if n1 == 2 then
					return "HYDRATION_CONTENT_TYPE_UNIVERSE"
				end

				if n1 == 3 then
					return "HYDRATION_CONTENT_TYPE_CREATOR"
				end

				if n1 == 4 then
					return "HYDRATION_CONTENT_TYPE_EVENT"
				end

				if n1 == 5 then
					return "HYDRATION_CONTENT_TYPE_SONG"
				end

				if n1 == 6 then
					return "HYDRATION_CONTENT_TYPE_GAME_PASS"
				end

				if n1 == 7 then
					return "HYDRATION_CONTENT_TYPE_MEDIA_ASSET"
				end

				if n1 == 8 then
					return "HYDRATION_CONTENT_TYPE_SOCIAL_LINK"
				end

				if n1 == 9 then
					return "HYDRATION_CONTENT_TYPE_GAME_DEVELOPER_PRODUCT"
				end

				if n1 == 10 then
					return "HYDRATION_CONTENT_TYPE_GAME_SUBSCRIPTION"
				end

				if n1 == 11 then
					return "HYDRATION_CONTENT_TYPE_MARKETPLACE_ASSET"
				end

				if n1 == 12 then
					return "HYDRATION_CONTENT_TYPE_MARKETPLACE_BUNDLE"
				end

				if n1 == 13 then
					return "HYDRATION_CONTENT_TYPE_MARKETPLACE_LOOK"
				end

				if n1 == 14 then
					return "HYDRATION_CONTENT_TYPE_MARKETPLACE_CATALOG_CATEGORY"
				end

				if n1 == 15 then
					return "HYDRATION_CONTENT_TYPE_MARKETPLACE_CATALOG_SORT"
				end

				if n1 == 16 then
					return "HYDRATION_CONTENT_TYPE_AGE_RECOMMENDATION"
				end

				if n1 == 17 then
					return "HYDRATION_CONTENT_TYPE_UNIVERSE_USER_FOLLOW"
				end

				if n1 == 18 then
					return "HYDRATION_CONTENT_TYPE_UNIVERSE_USER_VOTE"
				end

				if n1 == 19 then
					return "HYDRATION_CONTENT_TYPE_USER_PROFILE"
				end

				if n1 == 20 then
					return "HYDRATION_CONTENT_TYPE_UNIVERSE_USER_FAVORITE"
				end

				if n1 == 21 then
					return "HYDRATION_CONTENT_TYPE_PLAYABILITY"
				end

				if n1 == 22 then
					return "HYDRATION_CONTENT_TYPE_UNIVERSE_USER_FOLLOW_LIMIT"
				end

				if n1 == 23 then
					return "HYDRATION_CONTENT_TYPE_UNIVERSE_USER_VOTE_FEEDBACK_METADATA"
				end

				if n1 == 24 then
					return "HYDRATION_CONTENT_TYPE_MOMENT"
				end

				return nil
			end,
			toNumber = function(p1) -- line: 100
				if p1 == "HYDRATION_CONTENT_TYPE_INVALID" then
					return 0
				end

				if p1 == "HYDRATION_CONTENT_TYPE_BADGE" then
					return 1
				end

				if p1 == "HYDRATION_CONTENT_TYPE_UNIVERSE" then
					return 2
				end

				if p1 == "HYDRATION_CONTENT_TYPE_CREATOR" then
					return 3
				end

				if p1 == "HYDRATION_CONTENT_TYPE_EVENT" then
					return 4
				end

				if p1 == "HYDRATION_CONTENT_TYPE_SONG" then
					return 5
				end

				if p1 == "HYDRATION_CONTENT_TYPE_GAME_PASS" then
					return 6
				end

				if p1 == "HYDRATION_CONTENT_TYPE_MEDIA_ASSET" then
					return 7
				end

				if p1 == "HYDRATION_CONTENT_TYPE_SOCIAL_LINK" then
					return 8
				end

				if p1 == "HYDRATION_CONTENT_TYPE_GAME_DEVELOPER_PRODUCT" then
					return 9
				end

				if p1 == "HYDRATION_CONTENT_TYPE_GAME_SUBSCRIPTION" then
					return 10
				end

				if p1 == "HYDRATION_CONTENT_TYPE_MARKETPLACE_ASSET" then
					return 11
				end

				if p1 == "HYDRATION_CONTENT_TYPE_MARKETPLACE_BUNDLE" then
					return 12
				end

				if p1 == "HYDRATION_CONTENT_TYPE_MARKETPLACE_LOOK" then
					return 13
				end

				if p1 == "HYDRATION_CONTENT_TYPE_MARKETPLACE_CATALOG_CATEGORY" then
					return 14
				end

				if p1 == "HYDRATION_CONTENT_TYPE_MARKETPLACE_CATALOG_SORT" then
					return 15
				end

				if p1 == "HYDRATION_CONTENT_TYPE_AGE_RECOMMENDATION" then
					return 16
				end

				if p1 == "HYDRATION_CONTENT_TYPE_UNIVERSE_USER_FOLLOW" then
					return 17
				end

				if p1 == "HYDRATION_CONTENT_TYPE_UNIVERSE_USER_VOTE" then
					return 18
				end

				if p1 == "HYDRATION_CONTENT_TYPE_USER_PROFILE" then
					return 19
				end

				if p1 == "HYDRATION_CONTENT_TYPE_UNIVERSE_USER_FAVORITE" then
					return 20
				end

				if p1 == "HYDRATION_CONTENT_TYPE_PLAYABILITY" then
					return 21
				end

				if p1 == "HYDRATION_CONTENT_TYPE_UNIVERSE_USER_FOLLOW_LIMIT" then
					return 22
				end

				if p1 == "HYDRATION_CONTENT_TYPE_UNIVERSE_USER_VOTE_FEEDBACK_METADATA" then
					return 23
				end

				if p1 == "HYDRATION_CONTENT_TYPE_MOMENT" then
					return 24
				end

				return p1
			end,
			fromName = function(s1: string) -- line: 156
				if s1 == "HYDRATION_CONTENT_TYPE_INVALID" then
					return "HYDRATION_CONTENT_TYPE_INVALID"
				end

				if s1 == "HYDRATION_CONTENT_TYPE_BADGE" then
					return "HYDRATION_CONTENT_TYPE_BADGE"
				end

				if s1 == "HYDRATION_CONTENT_TYPE_UNIVERSE" then
					return "HYDRATION_CONTENT_TYPE_UNIVERSE"
				end

				if s1 == "HYDRATION_CONTENT_TYPE_CREATOR" then
					return "HYDRATION_CONTENT_TYPE_CREATOR"
				end

				if s1 == "HYDRATION_CONTENT_TYPE_EVENT" then
					return "HYDRATION_CONTENT_TYPE_EVENT"
				end

				if s1 == "HYDRATION_CONTENT_TYPE_SONG" then
					return "HYDRATION_CONTENT_TYPE_SONG"
				end

				if s1 == "HYDRATION_CONTENT_TYPE_GAME_PASS" then
					return "HYDRATION_CONTENT_TYPE_GAME_PASS"
				end

				if s1 == "HYDRATION_CONTENT_TYPE_MEDIA_ASSET" then
					return "HYDRATION_CONTENT_TYPE_MEDIA_ASSET"
				end

				if s1 == "HYDRATION_CONTENT_TYPE_SOCIAL_LINK" then
					return "HYDRATION_CONTENT_TYPE_SOCIAL_LINK"
				end

				if s1 == "HYDRATION_CONTENT_TYPE_GAME_DEVELOPER_PRODUCT" then
					return "HYDRATION_CONTENT_TYPE_GAME_DEVELOPER_PRODUCT"
				end

				if s1 == "HYDRATION_CONTENT_TYPE_GAME_SUBSCRIPTION" then
					return "HYDRATION_CONTENT_TYPE_GAME_SUBSCRIPTION"
				end

				if s1 == "HYDRATION_CONTENT_TYPE_MARKETPLACE_ASSET" then
					return "HYDRATION_CONTENT_TYPE_MARKETPLACE_ASSET"
				end

				if s1 == "HYDRATION_CONTENT_TYPE_MARKETPLACE_BUNDLE" then
					return "HYDRATION_CONTENT_TYPE_MARKETPLACE_BUNDLE"
				end

				if s1 == "HYDRATION_CONTENT_TYPE_MARKETPLACE_LOOK" then
					return "HYDRATION_CONTENT_TYPE_MARKETPLACE_LOOK"
				end

				if s1 == "HYDRATION_CONTENT_TYPE_MARKETPLACE_CATALOG_CATEGORY" then
					return "HYDRATION_CONTENT_TYPE_MARKETPLACE_CATALOG_CATEGORY"
				end

				if s1 == "HYDRATION_CONTENT_TYPE_MARKETPLACE_CATALOG_SORT" then
					return "HYDRATION_CONTENT_TYPE_MARKETPLACE_CATALOG_SORT"
				end

				if s1 == "HYDRATION_CONTENT_TYPE_AGE_RECOMMENDATION" then
					return "HYDRATION_CONTENT_TYPE_AGE_RECOMMENDATION"
				end

				if s1 == "HYDRATION_CONTENT_TYPE_UNIVERSE_USER_FOLLOW" then
					return "HYDRATION_CONTENT_TYPE_UNIVERSE_USER_FOLLOW"
				end

				if s1 == "HYDRATION_CONTENT_TYPE_UNIVERSE_USER_VOTE" then
					return "HYDRATION_CONTENT_TYPE_UNIVERSE_USER_VOTE"
				end

				if s1 == "HYDRATION_CONTENT_TYPE_USER_PROFILE" then
					return "HYDRATION_CONTENT_TYPE_USER_PROFILE"
				end

				if s1 == "HYDRATION_CONTENT_TYPE_UNIVERSE_USER_FAVORITE" then
					return "HYDRATION_CONTENT_TYPE_UNIVERSE_USER_FAVORITE"
				end

				if s1 == "HYDRATION_CONTENT_TYPE_PLAYABILITY" then
					return "HYDRATION_CONTENT_TYPE_PLAYABILITY"
				end

				if s1 == "HYDRATION_CONTENT_TYPE_UNIVERSE_USER_FOLLOW_LIMIT" then
					return "HYDRATION_CONTENT_TYPE_UNIVERSE_USER_FOLLOW_LIMIT"
				end

				if s1 == "HYDRATION_CONTENT_TYPE_UNIVERSE_USER_VOTE_FEEDBACK_METADATA" then
					return "HYDRATION_CONTENT_TYPE_UNIVERSE_USER_VOTE_FEEDBACK_METADATA"
				end

				if s1 == "HYDRATION_CONTENT_TYPE_MOMENT" then
					return "HYDRATION_CONTENT_TYPE_MOMENT"
				end

				return nil
			end
		}
	}).HydrationContentType
}
