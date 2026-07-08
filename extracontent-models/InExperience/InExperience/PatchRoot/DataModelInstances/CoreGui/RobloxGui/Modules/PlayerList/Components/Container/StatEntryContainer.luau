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

local function StatEntryContainer(t1: {[any]: any}) -- line: 43
	-- upvalues: useLeaderboardStore (copy), React (copy), GameTranslator (copy), CoreGui (copy), SignalsReact (copy), Signals (copy), Cryo (copy), StatEntryView (copy)
	local v14 = useLeaderboardStore().getGameStatsList().getData(t1.statName, false)
	local v15 = React.useMemo(function() -- line: 48
		-- upvalues: GameTranslator (copy), CoreGui (copy), t1 (copy)
		return GameTranslator:TranslateGameText(CoreGui, t1.statName)
	end, { t1.statName })
	local v16 = SignalsReact.useSignalBinding(Signals.createComputed(function(p1) -- line: 52
		-- upvalues: t1 (copy)
		if t1.stat then
			return (t1.stat(p1))
		end

		return "-"
	end))
	local v17 = SignalsReact.useSignalBinding(Signals.createComputed(function(p2) -- line: 55
		-- upvalues: v14 (copy)
		if v14 then
			return (v14.order(p2))
		end

		return 1e999
	end))
	local t2 = {
		statName = v15,
		statValue = v16,
		layoutOrder = v17
	}
	local v19 = Cryo.Dictionary.join(t2, t1)

	return React.createElement(StatEntryView, v19)
end

return React.memo(StatEntryContainer)
