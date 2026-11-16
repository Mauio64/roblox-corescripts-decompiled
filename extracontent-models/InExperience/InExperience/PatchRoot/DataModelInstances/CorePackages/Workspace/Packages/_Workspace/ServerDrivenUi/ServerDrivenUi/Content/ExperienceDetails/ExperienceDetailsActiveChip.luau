local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent
local Players = game:GetService("Players")

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local SignalsReact = require(parent.SignalsReact)

local DataHydration = require(parent.DataHydration)
local SduiSharedContent = require(parent.SduiSharedContent)
local GameTile = require(parent.GameTile)
local Localization = require(parent.Localization)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)

local SduiChip = SduiSharedContent.SduiChip
local usePlayerCountText = GameTile.usePlayerCountText
local useLocalization = Localization.Hooks.useLocalization
local gameDetailsSubpage = DiscoveryAnalytics.Events.gameDetailsSubpage
local useNavigateToServers = require(ServerDrivenUi.Content.ExperienceDetails.Hooks.useNavigateToServers)

local function ExperienceDetailsActiveCountChip(p)
	local layoutOrder = p.layoutOrder
	local universeId = p.universeId

	local v = SignalsReact.useSignalState(DataHydration.Game.getGameInfoStore(false).getAndFetchGameInfo(universeId).data)

	local v2 = useLocalization({
		numActivePlayers = {
			"Feature.GameDetails.Label.LowercaseNumberPlaying",
			numActivePlayers = usePlayerCountText(v and v.playerCount or 0)
		}
	})

	local v3 = useNavigateToServers(universeId)

	local onActivated = React.useCallback(function()
		local rootPlaceId = v and v.rootPlaceId

		if rootPlaceId then
			gameDetailsSubpage({
				uid = tostring(Players.LocalPlayer and Players.LocalPlayer.UserId),
				universeId = universeId,
				placeId = tostring(rootPlaceId),
				subpage = "Servers",
				action = "open",
				ctx = "ExperienceDetailsActiveCountChip"
			}, "ExperienceDetailsActiveCountChip")
		end

		v3()
	end, { universeId, v, v3 })

	return React.createElement(SduiChip, {
		text = v2.numActivePlayers,
		layoutOrder = layoutOrder,
		leadingIconName = Foundation.Enums.IconName.TwoPeople,
		onActivated = onActivated
	})
end

return React.memo(ExperienceDetailsActiveCountChip)
