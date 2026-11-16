local module = require("@luauforge/deferred/fZw")

local module2 = require("@luauforge/deferred/gab")
local useLocalization = module2.Hooks.useLocalization
local useAbbreviatedNumberLocalization = module2.Hooks.useAbbreviatedNumberLocalization

require("@luauforge/deferred/gad")

local formatUpdatedDate = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/InExperienceShop/Utils/formatUpdatedDate")

return function(data)
	local artistName = data and data.artistName or ""

	local v5 = useLocalization({
		dateUploadedLabel = "Feature.SongDetails.Label.DateUploaded",
		experiencesFeaturingLabel = "Feature.SongDetails.Label.ExperiencesFeaturing",
		lengthLabel = "Feature.SongDetails.Label.Length",
		monthlyListenersLabel = "Feature.SongDetails.Label.MonthlyListeners",
		songsAvailableByArtistLabel = {
			"Feature.SongDetails.Label.SongsAvailableBy",
			artistName = artistName
		},
		thousandPlusLabel = "Feature.SongDetails.Label.ThousandPlus",
		vendorLabel = "Feature.SongDetails.Label.Vendor",
		genreLabel = "Feature.SongDetails.Label.Genre"
	})

	local v6 = if data and data.songMetrics then data.songMetrics.monthlyListeners or nil else nil
	local v7 = useAbbreviatedNumberLocalization(v6)

	return {
		rows = module.useMemo(function()
			if not data then
				return {}
			end

			local v8 = {}

			if data.genre and data.genre ~= "" then
				table.insert(v8, { infoName = v5.genreLabel, infoData = data.genre })
			end

			if data.durationSeconds and data.durationSeconds > 0 then
				table.insert(v8, {
					infoName = v5.lengthLabel,
					infoData = formatUpdatedDate.formatDuration(data.durationSeconds)
				})
			end

			if data.uploadedTime and data.uploadedTime ~= "" then
				table.insert(v8, {
					infoName = v5.dateUploadedLabel,
					infoData = formatUpdatedDate.formatDate(data.uploadedTime)
				})
			end

			if data.songMetrics then
				if data.songMetrics.monthlyListeners and data.songMetrics.monthlyListeners > 0 and v7 then
					table.insert(v8, {
						infoName = v5.monthlyListenersLabel,
						infoData = v7
					})
				end

				if data.songMetrics.experiencesPlayed and data.songMetrics.experiencesPlayed > 0 then
					table.insert(v8, {
						infoName = v5.experiencesFeaturingLabel,
						infoData = tostring(data.songMetrics.experiencesPlayed)
					})
				end

				if
					data.songMetrics.artistSongsCount
					and data.songMetrics.artistSongsCount > 0
					and artistName
					and artistName ~= ""
				then
					local v9 = if data.songMetrics.artistSongsCount < 1000 then tostring(data.songMetrics.artistSongsCount) else v5.thousandPlusLabel
					table.insert(v8, {
						infoName = v5.songsAvailableByArtistLabel,
						infoData = v9
					})
				end
			end

			if data.creatorName and data.creatorName ~= "" then
				table.insert(v8, {
					infoName = v5.vendorLabel,
					infoData = data.creatorName
				})
			end

			return v8
		end, {
			artistName,
			v5.dateUploadedLabel,
			v5.experiencesFeaturingLabel,
			v5.genreLabel,
			v5.lengthLabel,
			v5.monthlyListenersLabel,
			v5.songsAvailableByArtistLabel,
			v5.thousandPlusLabel,
			v5.vendorLabel,
			v7,
			data
		})
	}
end
