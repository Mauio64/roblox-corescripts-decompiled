local SongDetails = script:FindFirstAncestor("SongDetails")
local SongDetailsParent = SongDetails.Parent
local React = require(SongDetailsParent.React)
local Localization = require(SongDetailsParent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local useAbbreviatedNumberLocalization = Localization.Hooks.useAbbreviatedNumberLocalization

require(SongDetailsParent.DiscoveryTypes)

local formatting = require(SongDetails.Helpers.formatting)

return function(p1) -- line: 18
	-- upvalues: useLocalization (copy), useAbbreviatedNumberLocalization (copy), React (copy), formatting (copy)
	local v9 = p1 and p1.artistName or ""
	local v10 = useLocalization({
		dateUploadedLabel = "Feature.SongDetails.Label.DateUploaded",
		experiencesFeaturingLabel = "Feature.SongDetails.Label.ExperiencesFeaturing",
		lengthLabel = "Feature.SongDetails.Label.Length",
		monthlyListenersLabel = "Feature.SongDetails.Label.MonthlyListeners",
		thousandPlusLabel = "Feature.SongDetails.Label.ThousandPlus",
		vendorLabel = "Feature.SongDetails.Label.Vendor",
		genreLabel = "Feature.SongDetails.Label.Genre",
		songsAvailableByArtistLabel = {
			"Feature.SongDetails.Label.SongsAvailableBy",
			artistName = v9
		}
	})
	local v11 = p1 and (not not p1.songMetrics and p1.songMetrics.monthlyListeners) or nil
	local v12 = useAbbreviatedNumberLocalization(v11)

	return {
		rows = React.useMemo(function() -- line: 39
			-- upvalues: p1 (copy), v10 (copy), formatting (copy), v12 (copy), v9 (copy)
			if not p1 then
				return {}
			end

			local t1 = {}

			if p1.genre and p1.genre ~= "" then
				table.insert(t1, {
					infoName = v10.genreLabel,
					infoData = p1.genre
				})
			end

			if p1.durationSeconds and p1.durationSeconds > 0 then
				table.insert(t1, {
					infoName = v10.lengthLabel,
					infoData = formatting.formatDuration(p1.durationSeconds)
				})
			end

			if p1.uploadedTime and p1.uploadedTime ~= "" then
				table.insert(t1, {
					infoName = v10.dateUploadedLabel,
					infoData = formatting.formatDate(p1.uploadedTime)
				})
			end

			if p1.songMetrics then
				if p1.songMetrics.monthlyListeners and p1.songMetrics.monthlyListeners > 0 and v12 then
					table.insert(t1, {
						infoName = v10.monthlyListenersLabel,
						infoData = v12
					})
				end

				if p1.songMetrics.experiencesPlayed and p1.songMetrics.experiencesPlayed > 0 then
					table.insert(t1, {
						infoName = v10.experiencesFeaturingLabel,
						infoData = tostring(p1.songMetrics.experiencesPlayed)
					})
				end

				if p1.songMetrics.artistSongsCount and p1.songMetrics.artistSongsCount > 0 and v9 and v9 ~= "" then
					local v14 = if not (p1.songMetrics.artistSongsCount < 1000) then v10.thousandPlusLabel else tostring(p1.songMetrics.artistSongsCount)

					table.insert(t1, {
						infoName = v10.songsAvailableByArtistLabel,
						infoData = v14
					})
				end
			end

			if p1.creatorName and p1.creatorName ~= "" then
				table.insert(t1, {
					infoName = v10.vendorLabel,
					infoData = p1.creatorName
				})
			end

			return t1
		end, {
			v9,
			v10.dateUploadedLabel,
			v10.experiencesFeaturingLabel,
			v10.genreLabel,
			v10.lengthLabel,
			v10.monthlyListenersLabel,
			v10.songsAvailableByArtistLabel,
			v10.thousandPlusLabel,
			v10.vendorLabel,
			v12,
			p1
		})
	}
end
