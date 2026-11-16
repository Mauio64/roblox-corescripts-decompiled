local React = require("@game/CorePackages/Workspace/Packages/_Workspace/MusicPicker/React")

local Songbird = require("@game/CorePackages/Workspace/Packages/_Workspace/MusicPicker/Songbird")
local sendAudioPlayerAnalytics = Songbird.Analytics.sendAudioPlayerAnalytics
local analyticActions = Songbird.Analytics.AnalyticActions

require("@game/CorePackages/Workspace/Packages/_Index/MusicPicker/MusicPicker/Types/MusicPickerTypes")

local function thumbnailIdFor(p2, p3)
	local v5 = p2[p3]

	if v5 == nil then
		return "-1"
	end

	return (tostring(v5.thumbnailAssetId))
end

local function useMusicPickerAnalytics(data)
	local source = data.source
	local previewingId = data.previewingId
	local savedIds = data.savedIds
	local itemsById = data.itemsById

	local ref = React.useRef(nil)
	React.useEffect(function()
		local current = ref.current
		local songId = if current ~= nil then current.songId else nil
		local v5 = if previewingId ~= nil then tostring(previewingId) else nil

		if songId == v5 then
			return
		end

		if current ~= nil then
			sendAudioPlayerAnalytics({
				action = analyticActions.AudioStopped,
				songId = current.songId,
				thumbnailId = current.thumbnailId,
				source = source
			})
		end

		if previewingId == nil then
			ref.current = nil

			return
		end

		local item = itemsById[previewingId]
		local v6 = item == nil and "-1" or tostring(item.thumbnailAssetId)

		sendAudioPlayerAnalytics({
			action = analyticActions.AudioPlay,
			songId = v5,
			thumbnailId = v6,
			source = source
		})

		ref.current = { songId = v5, thumbnailId = v6 }
	end, { previewingId, source, itemsById })

	local ref2 = React.useRef(source)
	ref2.current = source
	React.useEffect(function()
		return function()
			local current = ref.current

			if current ~= nil then
				sendAudioPlayerAnalytics({
					action = analyticActions.AudioStopped,
					songId = current.songId,
					thumbnailId = current.thumbnailId,
					source = ref2.current
				})

				ref.current = nil
			end
		end
	end, {})

	local ref3 = React.useRef(nil)
	React.useEffect(function()
		local current = ref3.current
		ref3.current = savedIds

		if current == nil then
			return
		end

		for k, savedId in savedIds do
			if not savedId or current[k] then
				continue
			end

			local v6 = {
				action = analyticActions.Like,
				songId = tostring(k),
				thumbnailId = 0,
				source = 0
			}
			local item = itemsById[k]
			v6.thumbnailId = item == nil and "-1" or tostring(item.thumbnailAssetId)
			v6.source = source
			sendAudioPlayerAnalytics(v6)
		end

		for k, v5 in current do
			if not v5 or savedIds[k] then
				continue
			end

			local v7 = {
				action = analyticActions.Unlike,
				songId = tostring(k),
				thumbnailId = 0,
				source = 0
			}
			local item = itemsById[k]
			v7.thumbnailId = item == nil and "-1" or tostring(item.thumbnailAssetId)
			v7.source = source
			sendAudioPlayerAnalytics(v7)
		end
	end, { savedIds, source, itemsById })

	return React.useCallback(function(p2)
		local v6 = {
			action = analyticActions.AudioPause,
			songId = tostring(p2),
			thumbnailId = 0,
			source = 0
		}
		local item = itemsById[p2]
		v6.thumbnailId = item == nil and "-1" or tostring(item.thumbnailAssetId)
		v6.source = source
		sendAudioPlayerAnalytics(v6)
	end, { source, itemsById })
end

return useMusicPickerAnalytics
