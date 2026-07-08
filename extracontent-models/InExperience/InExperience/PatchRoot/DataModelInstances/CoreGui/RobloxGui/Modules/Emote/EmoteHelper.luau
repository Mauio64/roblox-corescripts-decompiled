local t1 = {}
local CorePackages = game:GetService("CorePackages")
local v3 = require(CorePackages.Workspace.Packages.CoreScriptsInitializer).CoreLogger:new(script.Name)

t1.EMOTE_LOOP_TRANSITION_WAIT_TIME = 0.3
t1.EMOTE_LOOP_WAIT_TIMEOUT = 5
t1.LegacyDefaultEmotes = {
	wave = true,
	point = true,
	dance = true,
	dance2 = true,
	dance3 = true,
	laugh = true,
	cheer = true
}

local function clearConnection(p1) -- line: 21
	if p1 then
		p1:Disconnect()
	end
end

function t1.getAnyActiveDefaultChatTriggeredEmoteTrack(p2) -- line: 30
	-- upvalues: t1 (copy)
	if not p2.Character then
		return nil
	end

	local Humanoid = p2.Character:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		return nil
	end

	local Animator = Humanoid:FindFirstChildOfClass("Animator")

	if not Animator then
		return nil
	end

	local PlayingAnimationTracks = Animator:GetPlayingAnimationTracks()

	for _, v in pairs(PlayingAnimationTracks) do
		if not v.Animation or not v.Animation.Parent or not v:IsA("AnimationTrack") then
			continue
		end

		local ParentName = v.Animation.Parent.Name

		if t1.LegacyDefaultEmotes[ParentName] and v.IsPlaying then
			return v
		end
	end

	return nil
end

local function waitForEmoteEventInternal(p3, p4, p5, p6) -- line: 63
	-- upvalues: v3 (copy), t1 (copy), waitForEmoteEventInternal (copy)
	local BindableEvent = Instance.new("BindableEvent")
	local elapsed = os.clock()
	local u20 = true
	local connection = p4.Stopped:Connect(function() -- line: 80
		-- upvalues: v3 (copy), u20 (ref), BindableEvent (copy)
		v3:trace("EmoteHelper.waitForEmoteEventInternal: Stopped")

		if u20 and BindableEvent then
			u20 = false
			BindableEvent:Fire()
		end
	end)
	local connection2 = p4.KeyframeReached:Connect(function(keyframe) -- line: 90
		-- upvalues: p4 (copy), p5 (copy), v3 (copy), u20 (ref), BindableEvent (copy), elapsed (ref)
		if keyframe == "End" and (not p4.Looped or p5) then
			v3:trace("EmoteHelper.waitForEmoteEventInternal: KeyframeReached")

			if u20 and BindableEvent then
				u20 = false
				BindableEvent:Fire()

				return
			end
		else
			elapsed = os.clock()
		end
	end)

	task.spawn(function() -- line: 101
		-- upvalues: elapsed (ref), u20 (ref), t1 (copy), v3 (copy), BindableEvent (copy)
		local v29 = os.clock() - elapsed

		while u20 and v29 < t1.EMOTE_LOOP_WAIT_TIMEOUT do
			wait(t1.EMOTE_LOOP_WAIT_TIMEOUT - v29)
			v29 = os.clock() - elapsed
		end

		if u20 then
			v3:trace("EmoteHelper.waitForEmoteEventInternal: Timeout!")

			if u20 and BindableEvent then
				u20 = false
				BindableEvent:Fire()
			end
		end
	end)
	BindableEvent.Event:Wait()
	BindableEvent:Destroy()

	if connection then
		connection:Disconnect()
	end

	if connection2 then
		connection2:Disconnect()
	end

	if p5 then
		wait(t1.EMOTE_LOOP_TRANSITION_WAIT_TIME)

		local v23 = t1.getAnyActiveDefaultChatTriggeredEmoteTrack(p3)

		if v23 then
			waitForEmoteEventInternal(p3, v23, p5, p6)
		elseif p6 then
			p6()
		end
	elseif p6 then
		p6()
	end
end

function t1.createEmoteFinishEvent(p7, p8, p9) -- line: 139
	-- upvalues: waitForEmoteEventInternal (copy)
	local BindableEvent = Instance.new("BindableEvent")

	task.spawn(waitForEmoteEventInternal, p7, p8, p9, function() -- line: 144
		-- upvalues: BindableEvent (copy)
		BindableEvent:Fire()
		BindableEvent:Destroy()
	end)

	return BindableEvent.Event
end

return t1
