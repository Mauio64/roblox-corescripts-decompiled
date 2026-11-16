local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
	Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	LocalPlayer = Players.LocalPlayer
end

local CanPlayEmotes = { Value = false, ChangedEvent = Instance.new("BindableEvent") }

local function getAnimateScript(instance) -- 4 equivalent calls inferred from this helper
	if not instance then
		return nil
	end

	local animate = instance:FindFirstChild("Animate")

	if
		animate and animate:IsA("LocalScript")
		or animate and animate:IsA("Script") and animate.RunContext == Enum.RunContext.Client
	then
		return animate
	end

	return nil
end

local function getPlayEmoteBindable(instance) -- 2 equivalent calls inferred from this helper
	local animateScript = getAnimateScript(instance) -- inferred equivalent call

	if not animateScript then
		return nil
	end

	local playEmote = animateScript:FindFirstChild("PlayEmote")

	if playEmote and playEmote:IsA("BindableFunction") then
		return playEmote
	end

	return nil
end

local function getCanPlayEmotes(p): boolean -- 1 equivalent call inferred from this helper
	return getPlayEmoteBindable(p) ~= nil -- inferred equivalent call
end

local childAddedConnection = nil
local childAddedConnection2 = nil
local ancestryChangedConnection = nil

local function disconnectListeners() -- 4 equivalent calls inferred from this helper
	if childAddedConnection then
		childAddedConnection:Disconnect()
		childAddedConnection = nil
	end

	if childAddedConnection2 then
		childAddedConnection2:Disconnect()
		childAddedConnection2 = nil
	end

	if ancestryChangedConnection then
		ancestryChangedConnection:Disconnect()
		ancestryChangedConnection = nil
	end
end

local fn

local function checkUpdate(p) -- 9 equivalent calls inferred from this helper
	local canPlayEmotes = getCanPlayEmotes(p) -- inferred equivalent call

	if CanPlayEmotes.Value ~= canPlayEmotes then
		CanPlayEmotes.Value = canPlayEmotes
		CanPlayEmotes.ChangedEvent:Fire(canPlayEmotes)
	end

	fn(canPlayEmotes, p)
end

local function connectAnimateAddedListener(instance) -- 1 equivalent call inferred from this helper
	if not getAnimateScript(instance) then -- inferred equivalent call
		childAddedConnection = instance.ChildAdded:Connect(function(Script)
			if
				(Script:IsA("LocalScript") or Script:IsA("Script") and Script.RunContext == Enum.RunContext.Client)
				and Script.Name == "Animate"
			then
				checkUpdate(instance) -- inferred equivalent call
			end
		end)
		return
	end

	checkUpdate(instance) -- inferred equivalent call
end

local function connectPlayEmoteAddedListener(p, animateScript) -- 1 equivalent call inferred from this helper
	if not getPlayEmoteBindable(p) then -- inferred equivalent call
		childAddedConnection2 = animateScript.ChildAdded:Connect(function(bindableFunction)
			if bindableFunction:IsA("BindableFunction") and bindableFunction.Name == "PlayEmote" then
				checkUpdate(p) -- inferred equivalent call
			end
		end)
		return
	end

	checkUpdate(p) -- inferred equivalent call
end

local function connectPlayEmoteRemovedListener(ancestor) -- 1 equivalent call inferred from this helper
	local animateScript = getAnimateScript(ancestor) -- inferred equivalent call
	local playEmote

	if animateScript then
		playEmote = animateScript:FindFirstChild("PlayEmote")

		if not (playEmote and playEmote:IsA("BindableFunction")) then
			playEmote = nil
		end
	else
		playEmote = nil
	end

	if playEmote then
		ancestryChangedConnection = playEmote.AncestryChanged:Connect(function(_, parent)
			if not (parent and playEmote:IsDescendantOf(ancestor)) then
				checkUpdate(ancestor) -- inferred equivalent call
			end
		end)
		return
	end

	checkUpdate(ancestor) -- inferred equivalent call
end

fn = function(canPlayEmotes, p)
	disconnectListeners() -- inferred equivalent call

	if not p then
		return
	end

	if canPlayEmotes then
		connectPlayEmoteRemovedListener(p) -- inferred equivalent call
	else
		local animateScript = getAnimateScript(p) -- inferred equivalent call

		if animateScript then
			connectPlayEmoteAddedListener(p, animateScript) -- inferred equivalent call
		else
			connectAnimateAddedListener(p) -- inferred equivalent call
		end
	end
end

local function onCharacterChanged(p)
	disconnectListeners() -- inferred equivalent call
	checkUpdate(p) -- inferred equivalent call
end

LocalPlayer:GetPropertyChangedSignal("Character"):Connect(function()
	local character = LocalPlayer.Character
	disconnectListeners() -- inferred equivalent call
	checkUpdate(character) -- inferred equivalent call
end)
local Character = LocalPlayer.Character
disconnectListeners() -- inferred equivalent call
checkUpdate(Character) -- inferred equivalent call
return CanPlayEmotes
