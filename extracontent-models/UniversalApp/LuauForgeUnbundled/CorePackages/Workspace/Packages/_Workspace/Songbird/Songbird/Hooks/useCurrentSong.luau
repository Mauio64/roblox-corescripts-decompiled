local AssetFavorites = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/AssetFavorites")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/React")
local ReactSceneUnderstanding = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/ReactSceneUnderstanding")
local useAudioMetadata = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Hooks/useAudioMetadata")
local getAssetIdForAudioSource = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Common/getAssetIdForAudioSource")
require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/types")
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/logger")
local AnalyticActions = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Analytics/AnalyticActions")
local sendChromeWindowAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/Songbird/Songbird/Analytics/sendChromeWindowAnalytics")

local useMemo = React.useMemo
local useAudibleSounds = ReactSceneUnderstanding.useAudibleSounds
local useAssetFavoriting = AssetFavorites.useAssetFavoriting

local function useCurrentSong()
	local v5 = useAudibleSounds()

	local v6 = useMemo(function()
		return Cryo.List.filter(v5, function(p2): boolean
			return getAssetIdForAudioSource(p2) ~= nil
		end)
	end, { v5 })

	local v7 = useMemo(function()
		return Cryo.List.map(v6, function(p2)
			return getAssetIdForAudioSource(p2)
		end)
	end, { v6 })

	local v8 = useAudioMetadata(v7)

	local v9 = useAssetFavoriting(v7)

	return (useMemo(function()
		logger:info(`determining currently playing song from {#v6} audio sources...`)

		for k, v10 in v6 do
			local v11 = getAssetIdForAudioSource(v10)

			if not v11 then
				continue
			end

			local v12 = v8.getByAssetId(v11)
			local flag = true

			logger:info(`processing audio source: {v10} (AssetId: {v11}, Path: {v10:GetFullName()})`)

			if v12 then
				if v12.AudioType then
					if v12.AudioType == Enum.AudioSubType.Music then
						logger:debug(`{v12.Title} is classified as music. checking if it meets criteria...`)

						if not v12.RecordingCode or v12.RecordingCode == "" then
							logger:debug(`{v12.Title} does not meet criteria (no recording code found)`)
							flag = false
						end

						if flag then
							logger:info(`{v12.Title} meets criteria`)
						end

						local function toggleFavorite()
							return v9.toggleFavorite(v11):andThen(function(p2)
								if p2 then
									sendChromeWindowAnalytics({ assetId = v11, action = AnalyticActions.Like })
								else
									sendChromeWindowAnalytics({ assetId = v11, action = AnalyticActions.Unlike })
								end
							end):catch(function(p2)
								logger:warning(p2)
							end)
						end

						return {
							sound = v10,
							metadata = v12,
							meetsCriteria = flag,
							isFavorited = v9.getByAssetId(v11),
							toggleFavorite = toggleFavorite
						}
					end

					logger:debug(`{v12.Title} is not classified as music. instead classified as: {v12.AudioType.Name}. skipping...`)
				else
					logger:debug(`{v12.Title} has no AudioSubType classification. skipping...`)
				end
			else
				logger:warning("no metadata found. skipping...")
			end
		end

		return nil
	end, { v8.getByAssetId, v6, v9.getByAssetId, v9.toggleFavorite }))
end

return useCurrentSong
