local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local Players = game:GetService("Players")
local React = require(ServerDrivenUiParent.React)
local Foundation = require(ServerDrivenUiParent.Foundation)
local SignalsReact = require(ServerDrivenUiParent.SignalsReact)
local DataHydration = require(ServerDrivenUiParent.DataHydration)
local SduiSharedContent = require(ServerDrivenUiParent.SduiSharedContent)
local GameTile = require(ServerDrivenUiParent.GameTile)
local Localization = require(ServerDrivenUiParent.Localization)
local DiscoveryAnalytics = require(ServerDrivenUiParent.DiscoveryAnalytics)
local SduiChip = SduiSharedContent.SduiChip
local usePlayerCountText = GameTile.usePlayerCountText
local useLocalization = Localization.Hooks.useLocalization
local gameDetailsSubpage = DiscoveryAnalytics.Events.gameDetailsSubpage
local useNavigateToServers = require(ServerDrivenUi.Content.ExperienceDetails.Hooks.useNavigateToServers)

local function ExperienceDetailsActiveCountChip(t1: {[any]: any}) -- line: 26
	-- upvalues: SignalsReact (copy), DataHydration (copy), usePlayerCountText (copy), useLocalization (copy), useNavigateToServers (copy), React (copy), Players (copy), gameDetailsSubpage (copy), SduiChip (copy), Foundation (copy)
	local layoutOrder = t1.layoutOrder
	local universeId = t1.universeId
	local v21 = SignalsReact.useSignalState(DataHydration.Game.getGameInfoStore(false).getAndFetchGameInfo(universeId).data)
	local v22 = usePlayerCountText(v21 and v21.playerCount or 0)
	local v23 = useLocalization({
		numActivePlayers = {
			"Feature.GameDetails.Label.LowercaseNumberPlaying",
			numActivePlayers = v22
		}
	})
	local v24 = useNavigateToServers(universeId)
	local v25 = React.useCallback(function() -- line: 41
		-- upvalues: v21 (copy), Players (copy), gameDetailsSubpage (copy), universeId (copy), v24 (copy)
		local v26 = v21 and v21.rootPlaceId

		if v26 then
			local v27 = Players.LocalPlayer and Players.LocalPlayer.UserId

			gameDetailsSubpage({
				subpage = "Servers",
				action = "open",
				ctx = "ExperienceDetailsActiveCountChip",
				uid = tostring(v27),
				universeId = universeId,
				placeId = tostring(v26)
			}, "ExperienceDetailsActiveCountChip")
		end

		v24()
	end, {
		universeId,
		v21,
		v24
	})

	return React.createElement(SduiChip, {
		text = v23.numActivePlayers,
		layoutOrder = layoutOrder,
		leadingIconName = Foundation.Enums.IconName.TwoPeople,
		onActivated = v25
	})
end

return React.memo(ExperienceDetailsActiveCountChip)
