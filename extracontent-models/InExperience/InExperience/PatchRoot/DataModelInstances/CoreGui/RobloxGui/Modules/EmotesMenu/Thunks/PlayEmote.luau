local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local LocalPlayer = Players.LocalPlayer
local ParentParent = script.Parent.Parent
local Actions = ParentParent.Actions
local Analytics = require(ParentParent.Analytics)
local Constants = require(ParentParent.Constants)
local EventStream = require(CorePackages.Workspace.Packages.Analytics).AnalyticsReporters.EventStream
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local MaybeSendEmoteFailureAnalyticsFromPlayer = require(CoreGui.RobloxGui.Modules.EmotesMenu.Utility.MaybeSendEmoteFailureAnalyticsFromPlayer)
local HideMenu = require(Actions.HideMenu)
local HideError = require(Actions.HideError)
local ShowError = require(Actions.ShowError)
local v16 = Analytics.new():withEventStream(EventStream.new(RbxAnalyticsService))

local function handlePlayFailure(p1, p2, p3, p4) -- line: 29
	-- upvalues: v16 (copy), Constants (copy), RobloxTranslator (copy), ShowError (copy), HideError (copy), HideMenu (copy)
	if p2 then
		v16:onEmoteFailed(p3, p4, p2)

		local locale = p1:getState().locale
		local v24 = Constants.LocalizationKeys.ErrorMessages[p2]
		local v25 = RobloxTranslator:FormatByKeyForLocale(v24, locale)

		p1:dispatch(ShowError(v25))
		delay(Constants.ErrorDisplayTimeSeconds, function() -- line: 38
			-- upvalues: p1 (copy), HideError (copy)
			p1:dispatch(HideError())
		end)
	end

	p1:dispatch(HideMenu())
end
local function PlayEmote(_, p6, p7, _, _) -- line: 46
	-- upvalues: LocalPlayer (copy), MaybeSendEmoteFailureAnalyticsFromPlayer (copy), handlePlayFailure (copy), HideMenu (copy), v16 (copy), Constants (copy)
	return function(p10) -- line: 47
		-- upvalues: LocalPlayer (copy), MaybeSendEmoteFailureAnalyticsFromPlayer (copy), handlePlayFailure (copy), p6 (copy), p7 (copy), HideMenu (copy), v16 (copy), Constants (copy)
		local v32 = LocalPlayer

		if MaybeSendEmoteFailureAnalyticsFromPlayer(v32, function(p11) -- line: 49
			-- upvalues: handlePlayFailure (copy), p10 (copy), p6 (copy), p7 (copy)
			handlePlayFailure(p10, p11, p6, p7)
		end) then
			return
		end

		p10:dispatch(HideMenu())

		local Humanoid = v32.Character:FindFirstChildOfClass("Humanoid")
		local ok, result, _ = pcall(function() -- line: 59
			-- upvalues: Humanoid (copy), p7 (copy)
			return Humanoid:PlayEmoteAndGetAnimTrackById(p7)
		end)

		if ok and result then
			v16:onEmotePlayed(p6, p7)

			return
		end

		handlePlayFailure(p10, Constants.ErrorTypes.TemporarilyUnavailable, p6, p7)
	end
end

return PlayEmote
