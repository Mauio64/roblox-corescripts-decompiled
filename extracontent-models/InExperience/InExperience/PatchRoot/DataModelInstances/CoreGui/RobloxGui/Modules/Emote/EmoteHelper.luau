local EmoteHelper = {}

local CorePackages = game:GetService("CorePackages")

local CoreScriptsInitializer = require(CorePackages.Workspace.Packages.CoreScriptsInitializer)
local v = CoreScriptsInitializer.CoreLogger:new(script.Name)

EmoteHelper.EMOTE_LOOP_TRANSITION_WAIT_TIME = 0.3
EmoteHelper.EMOTE_LOOP_WAIT_TIMEOUT = 5

EmoteHelper.LegacyDefaultEmotes = {
	wave = true,
	point = true,
	dance = true,
	dance2 = true,
	dance3 = true,
	laugh = true,
	cheer = true
}

local function clearConnection(connection) -- 2 equivalent calls inferred from this helper
	if connection then
		connection:Disconnect()
	end
end

function EmoteHelper.getAnyActiveDefaultChatTriggeredEmoteTrack(player)
	if not player.Character then
		return nil
	end

	local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

	if not humanoid then
		return nil
	end

	local animator = humanoid:FindFirstChildOfClass("Animator")

	if not animator then
		return nil
	end

	local playingAnimationTracks = animator:GetPlayingAnimationTracks()

	for _, animationTrack in pairs(playingAnimationTracks) do
		if not (animationTrack.Animation and animationTrack.Animation.Parent and animationTrack:IsA("AnimationTrack")) then
			continue
		end

		local name = animationTrack.Animation.Parent.Name

		if EmoteHelper.LegacyDefaultEmotes[name] and animationTrack.IsPlaying then
			return animationTrack
		end
	end

	return nil
end

local function waitForEmoteEventInternal(p, anyActiveDefaultChatTriggeredEmoteTrack, p2, callback)
	local bindableEvent = Instance.new("BindableEvent")

	local lastTime = os.clock()
	local flag = true

	local function fn() -- 3 equivalent calls inferred from this helper
		if flag and bindableEvent then
			flag = false
			bindableEvent:Fire()
		end
	end

	local stoppedConnection = anyActiveDefaultChatTriggeredEmoteTrack.Stopped:Connect(function()
		v:trace("EmoteHelper.waitForEmoteEventInternal: Stopped")
		fn() -- inferred equivalent call
	end)

	local keyframeReachedConnection = anyActiveDefaultChatTriggeredEmoteTrack.KeyframeReached:Connect(function(p3)
		if p3 == "End" and (not anyActiveDefaultChatTriggeredEmoteTrack.Looped or p2) then
			v:trace("EmoteHelper.waitForEmoteEventInternal: KeyframeReached")
			fn() -- inferred equivalent call
		else
			lastTime = os.clock()
		end
	end)

	task.spawn(function()
		local v2 = os.clock() - lastTime

		while flag and v2 < EmoteHelper.EMOTE_LOOP_WAIT_TIMEOUT do
			wait(EmoteHelper.EMOTE_LOOP_WAIT_TIMEOUT - v2)

			v2 = os.clock() - lastTime
		end

		if flag then
			v:trace("EmoteHelper.waitForEmoteEventInternal: Timeout!")
			fn() -- inferred equivalent call
		end
	end)

	bindableEvent.Event:Wait()
	bindableEvent:Destroy()
	clearConnection(stoppedConnection) -- inferred equivalent call
	clearConnection(keyframeReachedConnection) -- inferred equivalent call

	if p2 then
		wait(EmoteHelper.EMOTE_LOOP_TRANSITION_WAIT_TIME)
		local anyActiveDefaultChatTriggeredEmoteTrack2 = EmoteHelper.getAnyActiveDefaultChatTriggeredEmoteTrack(p)

		if anyActiveDefaultChatTriggeredEmoteTrack2 then
			waitForEmoteEventInternal(p, anyActiveDefaultChatTriggeredEmoteTrack2, p2, callback)
		elseif callback then
			callback()
		end
	elseif callback then
		callback()
	end
end

function EmoteHelper.createEmoteFinishEvent(p, p2, p3)
	local bindableEvent = Instance.new("BindableEvent")

	task.spawn(waitForEmoteEventInternal, p, p2, p3, function()
		bindableEvent:Fire()
		bindableEvent:Destroy()
	end)

	return bindableEvent.Event
end

return EmoteHelper
