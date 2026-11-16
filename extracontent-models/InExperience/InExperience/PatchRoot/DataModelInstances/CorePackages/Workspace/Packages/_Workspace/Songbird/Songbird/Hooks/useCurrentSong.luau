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

local function useCurrentSong()
	local v = useAudibleSounds()

	local v2 = useMemo(function()
		return Cryo.List.filter(v, function(p): boolean
			return getAssetIdForAudioSource(p) ~= nil
		end)
	end, { v })

	local v3 = useMemo(function()
		return Cryo.List.map(v2, function(p)
			return getAssetIdForAudioSource(p)
		end)
	end, { v2 })

	local v4 = useAudioMetadata(v3)

	local v5 = useAssetFavoriting(v3)

	return (useMemo(function()
		logger:info(`determining currently playing song from {#v2} audio sources...`)

		for _, sound in v2 do
			local assetIdForAudioSource = getAssetIdForAudioSource(sound)

			if not assetIdForAudioSource then
				continue
			end

			local metadata = v4.getByAssetId(assetIdForAudioSource)
			local flag = true

			logger:info(`processing audio source: {sound} (AssetId: {assetIdForAudioSource}, Path: {sound:GetFullName()})`)

			if metadata then
				if metadata.AudioType then
					if metadata.AudioType == Enum.AudioSubType.Music then
						logger:debug(`{metadata.Title} is classified as music. checking if it meets criteria...`)

						if not metadata.RecordingCode or metadata.RecordingCode == "" then
							logger:debug(`{metadata.Title} does not meet criteria (no recording code found)`)
							flag = false
						end

						if flag then
							logger:info(`{metadata.Title} meets criteria`)
						end

						local function toggleFavorite()
							return v5.toggleFavorite(assetIdForAudioSource):andThen(function(p)
								if p then
									sendChromeWindowAnalytics({
										assetId = assetIdForAudioSource,
										action = AnalyticActions.Like
									})
								else
									sendChromeWindowAnalytics({
										assetId = assetIdForAudioSource,
										action = AnalyticActions.Unlike
									})
								end
							end):catch(function(p)
								logger:warning(p)
							end)
						end

						return {
							sound = sound,
							metadata = metadata,
							meetsCriteria = flag,
							isFavorited = v5.getByAssetId(assetIdForAudioSource),
							toggleFavorite = toggleFavorite
						}
					end

					logger:debug(`{metadata.Title} is not classified as music. instead classified as: {metadata.AudioType.Name}. skipping...`)
				else
					logger:debug(`{metadata.Title} has no AudioSubType classification. skipping...`)
				end
			else
				logger:warning("no metadata found. skipping...")
			end
		end

		return nil
	end, { v4.getByAssetId, v2, v5.getByAssetId, v5.toggleFavorite }))
end

return useCurrentSong
