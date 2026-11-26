local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local Localization = require("@game/CorePackages/Workspace/Packages/Localization")
local useLocalization = Localization.Hooks.useLocalization
local useAbbreviatedNumberLocalization = Localization.Hooks.useAbbreviatedNumberLocalization
local usePlayerCountText = require("@luauforge/bundled/gDC").usePlayerCountText
local infoCarousel = require("@game/CorePackages/Workspace/Packages/AppBlox").InfoCarousel
local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")
local UIBlox = require(CorePackages.Packages.UIBlox)
local images = UIBlox.App.ImageSet.Images

return function(props)
	local showIcons = props.showIcons or false

	local v5 = {}

	local v6 = useLocalization({
		rating = "Feature.GameDetails.Label.Rating",
		active = "Feature.GameDetails.Label.Playing",
		visits = "Feature.GameDetails.Label.Visits",
		maturity = "Feature.GameDetails.Label.Maturity",
		unavailable = "Feature.GameDetails.Label.Unavailable",
		age = "Feature.GameDetails.Label.Age"
	})

	local v7 = useSelector(function(p2)
		local gameVote = p2.GameVotes[props.universeId]

		if not gameVote then
			return "--"
		end

		local upVotes = gameVote.upVotes
		local downVotes = gameVote.downVotes

		if upVotes and downVotes then
			local v8 = upVotes + downVotes

			if v8 > 0 then
				return math.floor(upVotes / v8 * 100) .. "%"
			end
		end

		return "--"
	end)

	local rating = v6.rating
	local iconsstatusgamesrating_small = if showIcons then images["icons/status/games/rating_small"] else nil

	if rating and v7 then
		table.insert(v5, {
			headerText = rating,
			bodyText = v7,
			icon = iconsstatusgamesrating_small,
			onActivated = nil
		})
	end

	local v8 = useSelector(function(p2)
		return p2.GameDetailsV2[props.universeId]
	end)

	local v9 = GameHydrationReact.useGameInfo(props.universeId)
	local playing = v8 and v8.playing or v9 and v9.playerCount
	local v10 = usePlayerCountText(playing)
	local active = v6.active
	local iconsstatusgamespeopleplaying_small = if showIcons then images["icons/status/games/people-playing_small"] else nil

	if active and v10 then
		table.insert(v5, {
			headerText = active,
			bodyText = v10,
			icon = iconsstatusgamespeopleplaying_small,
			onActivated = nil
		})
	end

	local v11 = useSelector(function(p2)
		local ageRecommendation = p2.AgeRecommendations[props.universeId]
		return ageRecommendation and ageRecommendation.summary
	end)

	local minimumAgeDisplay = if v11 and v11.ageRecommendation then v11.ageRecommendation.minimumAgeDisplay else nil

	local v12 = useSelector(function(p2)
		return p2.AgeRecommendationHeaders.headerDisplayNameShort
	end) or v6.maturity
	local v13

	if v11 and v11.ageRecommendation then
		v13 = v11.ageRecommendation.displayName
	else
		v13 = v6.unavailable
	end

	local visits = v8 and v8.visits
	local v14 = useAbbreviatedNumberLocalization(visits) or "--"

	if minimumAgeDisplay and minimumAgeDisplay ~= "" then
		local age = v6.age

		if age and minimumAgeDisplay then
			table.insert(v5, {
				headerText = age,
				bodyText = minimumAgeDisplay,
				icon = nil,
				onActivated = nil
			})
		end

		if v12 and v13 then
			table.insert(v5, {
				headerText = v12,
				bodyText = v13,
				icon = nil,
				onActivated = nil
			})
		end

		local visits2 = v6.visits
		local iconsstatusgamessessions_small = if showIcons then images["icons/status/games/sessions_small"] else nil

		if visits2 and v14 then
			table.insert(v5, {
				headerText = visits2,
				bodyText = v14,
				icon = iconsstatusgamessessions_small,
				onActivated = nil
			})
		end
	else
		local visits2 = v6.visits
		local iconsstatusgamessessions_small = if showIcons then images["icons/status/games/sessions_small"] else nil

		if visits2 and v14 then
			table.insert(v5, {
				headerText = visits2,
				bodyText = v14,
				icon = iconsstatusgamessessions_small,
				onActivated = nil
			})
		end

		if v12 and v13 then
			table.insert(v5, {
				headerText = v12,
				bodyText = v13,
				icon = nil,
				onActivated = nil
			})
		end
	end

	return React.createElement(infoCarousel, {
		LayoutOrder = props.LayoutOrder,
		data = v5
	})
end
