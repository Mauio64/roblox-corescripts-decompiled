local createVideoEditMusic = require(script.Parent.createVideoEditMusic)
local getVideoEdits = require(script.Parent.getVideoEdits)

local function createVideoEditPlayback(object, p, flag: boolean, callback, p2)
	local v

	if p2 then
		v = p2.step
	else
		local RunService = game:GetService("RunService")
		v = RunService.RenderStepped
	end

	local v2

	if p2 then
		v2 = p2.createMusic
	else
		v2 = createVideoEditMusic
	end

	local connections = {}
	local v3 = nil
	local v4 = true
	local flag2 = false
	local flag3 = false
	local flag4 = false
	local timePosition2 = 0
	local timePosition3 = 0

	local function musicPosition() -- 1 equivalent call inferred from this helper
		return (not p.music and 0 or p.music.startTime) + math.max(0, object.TimePosition - timePosition2)
	end

	local function syncMusic() -- 4 equivalent calls inferred from this helper
		if v3 then
			v3.setPosition(musicPosition()) -- inferred equivalent call
		end
	end

	local function updateMusic()
		if not v4 and flag2 and object.Playing and not flag3 and p.music and v3 == nil then
			v3 = v2(p.music.assetId, musicPosition)
			syncMusic() -- inferred equivalent call
		end

		if v3 then
			v3.setPlaying(not v4 and flag2 and object.Playing and not flag3)
		end
	end

	local function finish() -- 3 equivalent calls inferred from this helper
		if flag3 then
			return
		end

		flag3 = true
		object:Pause()
		updateMusic()
		local onEnded = callback().onEnded

		if onEnded then
			onEnded()
		end
	end

	local function onLooped() -- 2 equivalent calls inferred from this helper
		syncMusic() -- inferred equivalent call
		updateMusic()
		local onLooped2 = callback().onLooped

		if onLooped2 then
			onLooped2()
		end
	end

	local function onLoaded() -- 1 equivalent call inferred from this helper
		if flag2 then
			return
		end

		flag2 = true
		timePosition2, timePosition3 = getVideoEdits.getPlaybackRange(object.TimeLength, p.trim)
		object.TimePosition = timePosition2

		if timePosition3 <= timePosition2 then
			finish() -- inferred equivalent call
		else
			object:Play()
		end
	end

	table.insert(connections, object.Loaded:Connect(onLoaded))
	table.insert(connections, object.Played:Connect(function()
		if flag3 then
			flag3 = false
			object.TimePosition = timePosition2
		end

		syncMusic() -- inferred equivalent call
		updateMusic()
	end))

	table.insert(connections, object.Paused:Connect(updateMusic))
	table.insert(connections, object.Ended:Connect(function()
		if flag and p.trim and timePosition2 < timePosition3 and not flag3 then
			object.TimePosition = timePosition2
			onLooped() -- inferred equivalent call
			object:Play()
		else
			finish() -- inferred equivalent call
		end
	end))

	table.insert(connections, object.DidLoop:Connect(onLooped))
	table.insert(connections, v:Connect(function()
		if flag2 and object.Playing and not flag3 and p.trim then
			local timePosition = object.TimePosition

			if timePosition3 <= timePosition then
				if flag then
					object.TimePosition = timePosition2
					onLooped() -- inferred equivalent call
				else
					object.TimePosition = timePosition3
					finish() -- inferred equivalent call
				end
			end
		end
	end))

	if object.IsLoaded then
		onLoaded() -- inferred equivalent call
	end

	return {
		setMuted = function(flag5: boolean)
			v4 = flag5

			if not v4 then
				syncMusic() -- inferred equivalent call
			end

			updateMusic()
		end,
		destroy = function()
			if flag4 then
				return
			end

			flag4 = true

			for _, connection in connections do
				connection:Disconnect()
			end

			object:Pause()

			if v3 then
				v3.destroy()
			end
		end
	}
end

return createVideoEditPlayback
