local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local GameTranslator = require(RobloxGui.Modules.GameTranslator)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local PlayerList = require(CorePackages.Workspace.Packages.PlayerList)
require(CorePackages.Workspace.Packages.LeaderboardStore)

local useLeaderboardStore = PlayerList.Hooks.useLeaderboardStore

local StatEntryView = PlayerList.Presentation.StatEntryView

local function StatEntryContainer(p)
	local data = useLeaderboardStore().getGameStatsList().getData(p.statName, false)

	local v = {
		statName = React.useMemo(function()
			return GameTranslator:TranslateGameText(CoreGui, p.statName)
		end, { p.statName }),
		statValue = SignalsReact.useSignalBinding(Signals.createComputed(function(p2)
			if p.stat then
				return (p.stat(p2))
			end

			return "-"
		end)),
		layoutOrder = SignalsReact.useSignalBinding(Signals.createComputed(function(p2)
			if data then
				return (data.order(p2))
			end

			return 1e999
		end))
	}

	local joined = Cryo.Dictionary.join(v, p)

	return React.createElement(StatEntryView, joined)
end

return React.memo(StatEntryContainer)
