local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local Localization = require(CorePackages.Workspace.Packages.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useAbbreviatedNumberLocalization = Localization.Hooks.useAbbreviatedNumberLocalization
local usePlayerCountText = require(CorePackages.Workspace.Packages.GameTile).usePlayerCountText
local InfoCarousel = require(CorePackages.Workspace.Packages.AppBlox).InfoCarousel
local useGameInfosSelector = require(CorePackages.Workspace.Packages.GameInfosRodux).useGameInfosSelector
local Images = require(CorePackages.Packages.UIBlox).App.ImageSet.Images
local FFlagLuaAppEdpBackendV2HydrateLegacyDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyDefault
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp

return function(t1: {[any]: any}) -- line: 30
	-- upvalues: useLocalization (copy), useSelector (copy), Images (copy), FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), useGameInfosSelector (copy), usePlayerCountText (copy), useAbbreviatedNumberLocalization (copy), React (copy), InfoCarousel (copy)
	local v14 = t1.showIcons or false
	local t2 = {}
	local v16 = useLocalization({
		rating = "Feature.GameDetails.Label.Rating",
		active = "Feature.GameDetails.Label.Playing",
		visits = "Feature.GameDetails.Label.Visits",
		maturity = "Feature.GameDetails.Label.Maturity",
		unavailable = "Feature.GameDetails.Label.Unavailable",
		age = "Feature.GameDetails.Label.Age"
	})
	local v17 = useSelector(function(p1) -- line: 54
		-- upvalues: t1 (copy)
		local v42 = p1.GameVotes[t1.universeId]

		if v42 then
			local upVotes = v42.upVotes
			local downVotes = v42.downVotes

			if upVotes and downVotes then
				local v45 = upVotes + downVotes

				if v45 > 0 then
					return math.floor(upVotes / v45 * 100) .. "%"
				end
			end
		end

		return "--"
	end)
	local rating = v16.rating
	local v19 = if not v14 then nil else Images["icons/status/games/rating_small"]

	if rating and v17 then
		table.insert(t2, {
			onActivated = nil,
			headerText = rating,
			bodyText = v17,
			icon = v19
		})
	end

	local v20 = useSelector(function(p2) -- line: 70
		-- upvalues: FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), t1 (copy)
		if FFlagLuaAppEdpBackendV2HydrateLegacyDefault or FFlagLuaAppEdpBackendV2HydrateLegacyIxp and t1.shouldHydrateLegacyIxp then
			return p2.GameDetailsV2[t1.universeId]
		end

		return p2.GameDetails[t1.universeId]
	end)
	local v21 = useGameInfosSelector(t1.universeId)
	local v22 = v20 and v20.playing or v21 and v21.playerCount
	local v23 = usePlayerCountText(v22)
	local active = v16.active
	local v25 = if not v14 then nil else Images["icons/status/games/people-playing_small"]

	if active and v23 then
		table.insert(t2, {
			onActivated = nil,
			headerText = active,
			bodyText = v23,
			icon = v25
		})
	end

	local v26 = useSelector(function(p3) -- line: 84
		-- upvalues: t1 (copy)
		local v48 = p3.AgeRecommendations[t1.universeId]

		return v48 and v48.summary
	end)
	local v27 = if not v26 or not v26.ageRecommendation then nil else v26.ageRecommendation.minimumAgeDisplay
	local v28 = useSelector(function(p4) -- line: 93
		return p4.AgeRecommendationHeaders.headerDisplayNameShort
	end) or v16.maturity
	local v29 = if not v26 or not v26.ageRecommendation then v16.unavailable else v26.ageRecommendation.displayName
	local v30 = v20 and v20.visits
	local v31 = useAbbreviatedNumberLocalization(v30) or "--"

	if v27 and v27 ~= "" then
		local age = v16.age

		if age and v27 then
			table.insert(t2, {
				icon = nil,
				onActivated = nil,
				headerText = age,
				bodyText = v27
			})
		end

		if v28 and v29 then
			table.insert(t2, {
				icon = nil,
				onActivated = nil,
				headerText = v28,
				bodyText = v29
			})
		end

		local visits = v16.visits
		local v34 = if not v14 then nil else Images["icons/status/games/sessions_small"]

		if visits and v31 then
			table.insert(t2, {
				onActivated = nil,
				headerText = visits,
				bodyText = v31,
				icon = v34
			})
		end
	else
		local visits = v16.visits
		local v36 = if not v14 then nil else Images["icons/status/games/sessions_small"]

		if visits and v31 then
			table.insert(t2, {
				onActivated = nil,
				headerText = visits,
				bodyText = v31,
				icon = v36
			})
		end

		if v28 and v29 then
			table.insert(t2, {
				icon = nil,
				onActivated = nil,
				headerText = v28,
				bodyText = v29
			})
		end
	end

	return React.createElement(InfoCarousel, {
		LayoutOrder = t1.LayoutOrder,
		data = t2
	})
end
