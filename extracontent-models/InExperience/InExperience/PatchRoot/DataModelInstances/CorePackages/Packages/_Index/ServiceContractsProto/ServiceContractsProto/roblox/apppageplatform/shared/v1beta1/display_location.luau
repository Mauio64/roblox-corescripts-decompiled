require(script.Parent.Parent.Parent.Parent.Parent.proto)
require(script.Parent.Parent.Parent.Parent.Parent.proto.typeRegistry)

return {
	DisplayLocation = ({
		DisplayLocation = {
			fromNumber = function(n1: number) -- line: 37
				if n1 == 0 then
					return "DISPLAY_LOCATION_INVALID"
				end

				if n1 == 1 then
					return "DISPLAY_LOCATION_GLOBAL"
				end

				if n1 == 2 then
					return "DISPLAY_LOCATION_BADGE_SEE_ALL"
				end

				if n1 == 3 then
					return "DISPLAY_LOCATION_BADGE_DETAILS"
				end

				if n1 == 4 then
					return "DISPLAY_LOCATION_PROMPTS"
				end

				if n1 == 5 then
					return "DISPLAY_LOCATION_EXPERIENCE_DETAILS"
				end

				if n1 == 6 then
					return "DISPLAY_LOCATION_DEV_STORE_SEE_ALL"
				end

				if n1 == 7 then
					return "DISPLAY_LOCATION_CHARTS"
				end

				if n1 == 8 then
					return "DISPLAY_LOCATION_EVENT_DETAILS"
				end

				if n1 == 9 then
					return "DISPLAY_LOCATION_MARKETPLACE_LANDING"
				end

				if n1 == 10 then
					return "DISPLAY_LOCATION_SEARCH_RESULTS"
				end

				if n1 == 11 then
					return "DISPLAY_LOCATION_SEARCH_LANDING"
				end

				if n1 == 12 then
					return "DISPLAY_LOCATION_SPOTLIGHT"
				end

				if n1 == 13 then
					return "DISPLAY_LOCATION_HOME"
				end

				if n1 == 14 then
					return "DISPLAY_LOCATION_SPOTLIGHT_COLLECTION"
				end

				if n1 == 15 then
					return "DISPLAY_LOCATION_PARTY_CHAT"
				end

				if n1 == 16 then
					return "DISPLAY_LOCATION_MARKETPLACE_FAVORITES_SAVED"
				end

				if n1 == 17 then
					return "DISPLAY_LOCATION_PRE_AUTH_LANDING"
				end

				return nil
			end,
			toNumber = function(p1) -- line: 79
				if p1 == "DISPLAY_LOCATION_INVALID" then
					return 0
				end

				if p1 == "DISPLAY_LOCATION_GLOBAL" then
					return 1
				end

				if p1 == "DISPLAY_LOCATION_BADGE_SEE_ALL" then
					return 2
				end

				if p1 == "DISPLAY_LOCATION_BADGE_DETAILS" then
					return 3
				end

				if p1 == "DISPLAY_LOCATION_PROMPTS" then
					return 4
				end

				if p1 == "DISPLAY_LOCATION_EXPERIENCE_DETAILS" then
					return 5
				end

				if p1 == "DISPLAY_LOCATION_DEV_STORE_SEE_ALL" then
					return 6
				end

				if p1 == "DISPLAY_LOCATION_CHARTS" then
					return 7
				end

				if p1 == "DISPLAY_LOCATION_EVENT_DETAILS" then
					return 8
				end

				if p1 == "DISPLAY_LOCATION_MARKETPLACE_LANDING" then
					return 9
				end

				if p1 == "DISPLAY_LOCATION_SEARCH_RESULTS" then
					return 10
				end

				if p1 == "DISPLAY_LOCATION_SEARCH_LANDING" then
					return 11
				end

				if p1 == "DISPLAY_LOCATION_SPOTLIGHT" then
					return 12
				end

				if p1 == "DISPLAY_LOCATION_HOME" then
					return 13
				end

				if p1 == "DISPLAY_LOCATION_SPOTLIGHT_COLLECTION" then
					return 14
				end

				if p1 == "DISPLAY_LOCATION_PARTY_CHAT" then
					return 15
				end

				if p1 == "DISPLAY_LOCATION_MARKETPLACE_FAVORITES_SAVED" then
					return 16
				end

				if p1 == "DISPLAY_LOCATION_PRE_AUTH_LANDING" then
					return 17
				end

				return p1
			end,
			fromName = function(s1: string) -- line: 121
				if s1 == "DISPLAY_LOCATION_INVALID" then
					return "DISPLAY_LOCATION_INVALID"
				end

				if s1 == "DISPLAY_LOCATION_GLOBAL" then
					return "DISPLAY_LOCATION_GLOBAL"
				end

				if s1 == "DISPLAY_LOCATION_BADGE_SEE_ALL" then
					return "DISPLAY_LOCATION_BADGE_SEE_ALL"
				end

				if s1 == "DISPLAY_LOCATION_BADGE_DETAILS" then
					return "DISPLAY_LOCATION_BADGE_DETAILS"
				end

				if s1 == "DISPLAY_LOCATION_PROMPTS" then
					return "DISPLAY_LOCATION_PROMPTS"
				end

				if s1 == "DISPLAY_LOCATION_EXPERIENCE_DETAILS" then
					return "DISPLAY_LOCATION_EXPERIENCE_DETAILS"
				end

				if s1 == "DISPLAY_LOCATION_DEV_STORE_SEE_ALL" then
					return "DISPLAY_LOCATION_DEV_STORE_SEE_ALL"
				end

				if s1 == "DISPLAY_LOCATION_CHARTS" then
					return "DISPLAY_LOCATION_CHARTS"
				end

				if s1 == "DISPLAY_LOCATION_EVENT_DETAILS" then
					return "DISPLAY_LOCATION_EVENT_DETAILS"
				end

				if s1 == "DISPLAY_LOCATION_MARKETPLACE_LANDING" then
					return "DISPLAY_LOCATION_MARKETPLACE_LANDING"
				end

				if s1 == "DISPLAY_LOCATION_SEARCH_RESULTS" then
					return "DISPLAY_LOCATION_SEARCH_RESULTS"
				end

				if s1 == "DISPLAY_LOCATION_SEARCH_LANDING" then
					return "DISPLAY_LOCATION_SEARCH_LANDING"
				end

				if s1 == "DISPLAY_LOCATION_SPOTLIGHT" then
					return "DISPLAY_LOCATION_SPOTLIGHT"
				end

				if s1 == "DISPLAY_LOCATION_HOME" then
					return "DISPLAY_LOCATION_HOME"
				end

				if s1 == "DISPLAY_LOCATION_SPOTLIGHT_COLLECTION" then
					return "DISPLAY_LOCATION_SPOTLIGHT_COLLECTION"
				end

				if s1 == "DISPLAY_LOCATION_PARTY_CHAT" then
					return "DISPLAY_LOCATION_PARTY_CHAT"
				end

				if s1 == "DISPLAY_LOCATION_MARKETPLACE_FAVORITES_SAVED" then
					return "DISPLAY_LOCATION_MARKETPLACE_FAVORITES_SAVED"
				end

				if s1 == "DISPLAY_LOCATION_PRE_AUTH_LANDING" then
					return "DISPLAY_LOCATION_PRE_AUTH_LANDING"
				end

				return nil
			end
		}
	}).DisplayLocation
}
