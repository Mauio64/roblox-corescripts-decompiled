local Players = game:GetService("Players")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SignalsReact")

local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DataHydration")
local SduiSharedContent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent")
local GameTile = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GameTile")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Localization")
local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics")

local sduiChip = SduiSharedContent.SduiChip
local usePlayerCountText = GameTile.usePlayerCountText
local useLocalization = Localization.Hooks.useLocalization
local gameDetailsSubpage = DiscoveryAnalytics.Events.gameDetailsSubpage
local useNavigateToServers = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/ExperienceDetails/Hooks/useNavigateToServers")

local function ExperienceDetailsActiveCountChip(p2)
	local layoutOrder = p2.layoutOrder
	local universeId = p2.universeId

	local v5 = SignalsReact.useSignalState(DataHydration.Game.getGameInfoStore(false).getAndFetchGameInfo(universeId).data)

	local v7 = useLocalization({
		numActivePlayers = {
			"Feature.GameDetails.Label.LowercaseNumberPlaying",
			numActivePlayers = usePlayerCountText(v5 and v5.playerCount or 0)
		}
	})

	local v8 = useNavigateToServers(universeId)

	local v9 = React.useCallback(function()
		local rootPlaceId = v5 and v5.rootPlaceId

		if rootPlaceId then
			local userId = Players.LocalPlayer and Players.LocalPlayer.UserId
			gameDetailsSubpage({
				uid = tostring(userId),
				universeId = universeId,
				placeId = tostring(rootPlaceId),
				subpage = "Servers",
				action = "open",
				ctx = "ExperienceDetailsActiveCountChip"
			}, "ExperienceDetailsActiveCountChip")
		end

		v8()
	end, { universeId, v5, v8 })

	return React.createElement(sduiChip, {
		text = v7.numActivePlayers,
		layoutOrder = layoutOrder,
		leadingIconName = Foundation.Enums.IconName.TwoPeople,
		onActivated = v9
	})
end

return React.memo(ExperienceDetailsActiveCountChip)
