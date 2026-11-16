local createVideoEditMusic = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/createVideoEditMusic")
local getVideoEdits = require("@game/CorePackages/Workspace/Packages/_Index/VideoUtils/VideoUtils/getVideoEdits")

local function createVideoEditPlayback(object, p2, p3, callback, p4)
	local v5

	if p4 then
		v5 = p4.step
	else
		local RunService = game:GetService("RunService")
		v5 = RunService.RenderStepped
	end

	local v6 = if p4 then p4.createMusic else createVideoEditMusic
	local connections = {}
	local v7 = nil
	local v8 = true
	local flag = false
	local flag2 = false
	local flag3 = false
	local v9 = 0
	local v10 = 0

	local function musicPosition()
		return (not p2.music and 0 or p2.music.startTime) + math.max(0, object.TimePosition - v9)
	end

	local function syncMusic()
		if v7 then
			v7.setPosition((not p2.music and 0 or p2.music.startTime) + math.max(0, object.TimePosition - v9))
		end
	end

	local function updateMusic()
		if not v8 and flag and object.Playing and not flag2 and p2.music and v7 == nil then
			v7 = v6(p2.music.assetId, musicPosition)

			if v7 then
				v7.setPosition((not p2.music and 0 or p2.music.startTime) + math.max(0, object.TimePosition - v9))
			end
		end

		if v7 then
			v7.setPlaying(not v8 and flag and object.Playing and not flag2)
		end
	end

	local function finish()
		if flag2 then
			return
		end

		flag2 = true
		object:Pause()
		updateMusic()
		local onEnded = callback().onEnded

		if onEnded then
			onEnded()
		end
	end

	local function onLooped()
		if v7 then
			v7.setPosition((not p2.music and 0 or p2.music.startTime) + math.max(0, object.TimePosition - v9))
		end

		updateMusic()
		local onLooped2 = callback().onLooped

		if onLooped2 then
			onLooped2()
		end
	end

	local function onLoaded()
		if flag then
			return
		end

		flag = true
		v9, v10 = getVideoEdits.getPlaybackRange(object.TimeLength, p2.trim)
		object.TimePosition = v9

		if v10 <= v9 then
			if flag2 then
				return
			end

			flag2 = true
			object:Pause()
			updateMusic()
			local onEnded = callback().onEnded

			if onEnded then
				onEnded()
			end
		else
			object:Play()
		end
	end

	table.insert(connections, object.Loaded:Connect(onLoaded))
	table.insert(connections, object.Played:Connect(function()
		if flag2 then
			flag2 = false
			object.TimePosition = v9
		end

		if v7 then
			v7.setPosition((not p2.music and 0 or p2.music.startTime) + math.max(0, object.TimePosition - v9))
		end

		updateMusic()
	end))

	table.insert(connections, object.Paused:Connect(updateMusic))
	table.insert(connections, object.Ended:Connect(function()
		if p3 and p2.trim and v9 < v10 and not flag2 then
			object.TimePosition = v9

			if v7 then
				v7.setPosition((not p2.music and 0 or p2.music.startTime) + math.max(0, object.TimePosition - v9))
			end

			updateMusic()
			local onLooped2 = callback().onLooped

			if onLooped2 then
				onLooped2()
			end

			object:Play()
		else
			if flag2 then
				return
			end

			flag2 = true
			object:Pause()
			updateMusic()
			local onEnded = callback().onEnded

			if onEnded then
				onEnded()
			end
		end
	end))

	table.insert(connections, object.DidLoop:Connect(onLooped))
	table.insert(connections, v5:Connect(function()
		if flag and object.Playing and not flag2 and p2.trim then
			local timePosition = object.TimePosition

			if v10 <= timePosition then
				if p3 then
					object.TimePosition = v9

					if v7 then
						v7.setPosition((not p2.music and 0 or p2.music.startTime) + math.max(0, object.TimePosition - v9))
					end

					updateMusic()
					local onLooped2 = callback().onLooped

					if onLooped2 then
						onLooped2()
					end
				else
					object.TimePosition = v10

					if flag2 then
						return
					end

					flag2 = true
					object:Pause()
					updateMusic()
					local onEnded = callback().onEnded

					if onEnded then
						onEnded()
					end
				end
			end
		end
	end))

	if object.IsLoaded and not flag then
		flag = true
		v9, v10 = getVideoEdits.getPlaybackRange(object.TimeLength, p2.trim)
		object.TimePosition = v9

		if v10 <= v9 then
			if not flag2 then
				flag2 = true
				object:Pause()
				updateMusic()
				local onEnded = callback().onEnded

				if onEnded then
					onEnded()
				end
			end
		else
			object:Play()
		end
	end

	return {
		setMuted = function(p5)
			v8 = p5

			if not v8 and v7 then
				v7.setPosition((not p2.music and 0 or p2.music.startTime) + math.max(0, object.TimePosition - v9))
			end

			updateMusic()
		end,
		destroy = function()
			if flag3 then
				return
			end

			flag3 = true

			for k, connection in connections do
				connection:Disconnect()
			end

			object:Pause()

			if v7 then
				v7.destroy()
			end
		end
	}
end

return createVideoEditPlayback
