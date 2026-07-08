local Songbird = script:FindFirstAncestor("Songbird")
local AssetFavorites = require(Songbird.Parent.AssetFavorites)
local Cryo = require(Songbird.Parent.Cryo)
local React = require(Songbird.Parent.React)
local ReactSceneUnderstanding = require(Songbird.Parent.ReactSceneUnderstanding)
local useAudioMetadata = require(Songbird.Hooks.useAudioMetadata)
local getAssetIdForAudioSource = require(Songbird.Common.getAssetIdForAudioSource)

require(Songbird.types)

local logger = require(Songbird.logger)
local AnalyticActions = require(Songbird.Analytics.AnalyticActions)
local sendChromeWindowAnalytics = require(Songbird.Analytics.sendChromeWindowAnalytics)
local useMemo = React.useMemo
local useAudibleSounds = ReactSceneUnderstanding.useAudibleSounds
local useAssetFavoriting = AssetFavorites.useAssetFavoriting

local function useCurrentSong() -- line: 21
	-- upvalues: useAudibleSounds (copy), useMemo (copy), Cryo (copy), getAssetIdForAudioSource (copy), useAudioMetadata (copy), useAssetFavoriting (copy), logger (copy), sendChromeWindowAnalytics (copy), AnalyticActions (copy)
	local v15 = useAudibleSounds()
	local v16 = useMemo(function() -- line: 30
		-- upvalues: Cryo (copy), v15 (copy), getAssetIdForAudioSource (copy)
		return Cryo.List.filter(v15, function(p1) -- line: 31
			-- upvalues: getAssetIdForAudioSource (copy)
			return getAssetIdForAudioSource(p1) ~= nil
		end)
	end, { v15 })
	local v17 = useMemo(function() -- line: 36
		-- upvalues: Cryo (copy), v16 (copy), getAssetIdForAudioSource (copy)
		return Cryo.List.map(v16, function(p2) -- line: 37
			-- upvalues: getAssetIdForAudioSource (copy)
			return getAssetIdForAudioSource(p2)
		end)
	end, { v16 })
	local v18 = useAudioMetadata(v17)
	local v19 = useAssetFavoriting(v17)

	return (useMemo(function() -- line: 47
		-- upvalues: logger (copy), v16 (copy), getAssetIdForAudioSource (copy), v18 (copy), v19 (copy), sendChromeWindowAnalytics (copy), AnalyticActions (copy)
		logger:info(`determining currently playing song from { #v16 } audio sources...`)

		for _, v21 in v16 do
			local v22 = getAssetIdForAudioSource(v21)

			if not v22 then
				continue
			end

			local v23 = v18.getByAssetId(v22)
			local v24 = true

			logger:info(`processing audio source: { v21 } (AssetId: { v22 }, Path: { v21:GetFullName() })`)

			if v23 then
				if not v23.AudioType then
					logger:debug(`{ v23.Title } has no AudioSubType classification. skipping...`)

					continue
				end

				if v23.AudioType == Enum.AudioSubType.Music then
					logger:debug(`{ v23.Title } is classified as music. checking if it meets criteria...`)

					if not v23.RecordingCode or v23.RecordingCode == "" then
						logger:debug(`{ v23.Title } does not meet criteria (no recording code found)`)
						v24 = false
					end

					if v24 then
						logger:info(`{ v23.Title } meets criteria`)
					end

					return {
						sound = v21,
						metadata = v23,
						meetsCriteria = v24,
						isFavorited = v19.getByAssetId(v22),
						toggleFavorite = function() -- line: 93
							-- upvalues: v19 (copy), v22 (copy), sendChromeWindowAnalytics (copy), AnalyticActions (copy), logger (copy)
							return v19.toggleFavorite(v22):andThen(function(p3) -- line: 96
								-- upvalues: sendChromeWindowAnalytics (copy), v22 (copy), AnalyticActions (copy)
								if p3 then
									sendChromeWindowAnalytics({
										assetId = v22,
										action = AnalyticActions.Like
									})

									return
								end

								sendChromeWindowAnalytics({
									assetId = v22,
									action = AnalyticActions.Unlike
								})
							end):catch(function(p4) -- line: 103
								-- upvalues: logger (copy)
								logger:warning(p4)
							end)
						end
					}
				end

				logger:debug(`{ v23.Title } is not classified as music. instead classified as: { v23.AudioType.Name }. skipping...`)

				continue
			end

			logger:warning("no metadata found. skipping...")
		end

		return nil
	end, {
		v18.getByAssetId,
		v16,
		v19.getByAssetId,
		v19.toggleFavorite
	}))
end

return useCurrentSong
