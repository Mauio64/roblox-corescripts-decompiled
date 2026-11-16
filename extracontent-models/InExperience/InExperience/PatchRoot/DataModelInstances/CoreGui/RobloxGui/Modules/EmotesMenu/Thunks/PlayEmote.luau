local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local LocalPlayer = Players.LocalPlayer

local parent = script.Parent.Parent

local actions = parent.Actions

local Analytics = require(parent.Analytics)
local Constants = require(parent.Constants)

local Analytics2 = require(CorePackages.Workspace.Packages.Analytics)
local EventStream = Analytics2.AnalyticsReporters.EventStream

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

local MaybeSendEmoteFailureAnalyticsFromPlayer = require(CoreGui.RobloxGui.Modules.EmotesMenu.Utility.MaybeSendEmoteFailureAnalyticsFromPlayer)

local HideMenu = require(actions.HideMenu)
local HideError = require(actions.HideError)
local ShowError = require(actions.ShowError)

local v = Analytics.new():withEventStream(EventStream.new(RbxAnalyticsService))

local function handlePlayFailure(object, p, p2, p3)
	if p then
		v:onEmoteFailed(p2, p3, p)

		local locale = object:getState().locale
		object:dispatch(ShowError((RobloxTranslator:FormatByKeyForLocale(
			Constants.LocalizationKeys.ErrorMessages[p],
			locale
		))))
		delay(Constants.ErrorDisplayTimeSeconds, function()
			object:dispatch(HideError())
		end)
	end

	object:dispatch(HideMenu())
end

local function PlayEmote(_, p, p2, _, _)
	return function(object)
		local v2 = LocalPlayer

		if MaybeSendEmoteFailureAnalyticsFromPlayer(v2, function(p3)
			handlePlayFailure(object, p3, p, p2)
		end) then
			return
		end

		object:dispatch(HideMenu())

		local humanoid = v2.Character:FindFirstChildOfClass("Humanoid")
		local function fn()
			return humanoid:PlayEmoteAndGetAnimTrackById(p2)
		end

		local success, result, _ = pcall(fn)

		if success and result then
			v:onEmotePlayed(p, p2)
		else
			handlePlayFailure(object, Constants.ErrorTypes.TemporarilyUnavailable, p, p2)
		end
	end
end

return PlayEmote
