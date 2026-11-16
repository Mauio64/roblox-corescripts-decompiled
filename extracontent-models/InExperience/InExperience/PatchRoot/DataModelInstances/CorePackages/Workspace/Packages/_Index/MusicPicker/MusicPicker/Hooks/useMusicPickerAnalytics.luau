local MusicPicker = script:FindFirstAncestor("MusicPicker")
local parent = MusicPicker.Parent

local React = require(parent.React)

local Songbird = require(parent.Songbird)
local sendAudioPlayerAnalytics = Songbird.Analytics.sendAudioPlayerAnalytics
local AnalyticActions = Songbird.Analytics.AnalyticActions

require(MusicPicker.Types.MusicPickerTypes)

local function thumbnailIdFor(itemsById, p: number) -- 4 equivalent calls inferred from this helper
	local v = itemsById[p]

	if v == nil then
		return "-1"
	end

	return (tostring(v.thumbnailAssetId))
end

local function useMusicPickerAnalytics(data)
	local source = data.source
	local previewingId = data.previewingId
	local savedIds = data.savedIds
	local itemsById = data.itemsById

	local ref = React.useRef(nil)
	React.useEffect(function()
		local current = ref.current
		local songId

		if current ~= nil then
			songId = current.songId
		end

		local songId2

		if previewingId ~= nil then
			songId2 = tostring(previewingId)
		end

		if songId == songId2 then
			return
		end

		if current ~= nil then
			sendAudioPlayerAnalytics({
				action = AnalyticActions.AudioStopped,
				songId = current.songId,
				thumbnailId = current.thumbnailId,
				source = source
			})
		end

		if previewingId == nil then
			ref.current = nil

			return
		end

		local thumbnailId = thumbnailIdFor(itemsById, previewingId) -- inferred equivalent call
		sendAudioPlayerAnalytics({
			action = AnalyticActions.AudioPlay,
			songId = songId2,
			thumbnailId = thumbnailId,
			source = source
		})

		ref.current = { songId = songId2, thumbnailId = thumbnailId }
	end, { previewingId, source, itemsById })

	local ref2 = React.useRef(source)
	ref2.current = source
	React.useEffect(function()
		return function()
			local current = ref.current

			if current ~= nil then
				sendAudioPlayerAnalytics({
					action = AnalyticActions.AudioStopped,
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

			sendAudioPlayerAnalytics({
				action = AnalyticActions.Like,
				songId = tostring(k),
				thumbnailId = thumbnailIdFor(itemsById, k), -- inferred equivalent call
				source = source
			})
		end

		for k, v in current do
			if not v or savedIds[k] then
				continue
			end

			sendAudioPlayerAnalytics({
				action = AnalyticActions.Unlike,
				songId = tostring(k),
				thumbnailId = thumbnailIdFor(itemsById, k), -- inferred equivalent call
				source = source
			})
		end
	end, { savedIds, source, itemsById })

	return React.useCallback(function(p: number)
		sendAudioPlayerAnalytics({
			action = AnalyticActions.AudioPause,
			songId = tostring(p),
			thumbnailId = thumbnailIdFor(itemsById, p), -- inferred equivalent call
			source = source
		})
	end, { source, itemsById })
end

return useMusicPickerAnalytics
