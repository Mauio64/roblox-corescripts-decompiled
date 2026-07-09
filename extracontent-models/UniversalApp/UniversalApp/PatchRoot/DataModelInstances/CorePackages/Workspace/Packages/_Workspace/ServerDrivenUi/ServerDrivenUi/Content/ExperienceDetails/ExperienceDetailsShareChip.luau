local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local React = require(ServerDrivenUiParent.React)
local Foundation = require(ServerDrivenUiParent.Foundation)
local SignalsReact = require(ServerDrivenUiParent.SignalsReact)
local Game = require(ServerDrivenUiParent.DataHydration).Game
local SduiSharedContent = require(ServerDrivenUiParent.SduiSharedContent)
local Localization = require(ServerDrivenUiParent.Localization)
local SduiChip = SduiSharedContent.SduiChip
local useLocalization = Localization.Hooks.useLocalization
local useExperienceDetailsShare = require(ServerDrivenUi.Content.ExperienceDetails.Hooks.useExperienceDetailsShare)

local function ExperienceDetailsShareChip(t1: {[any]: any}) -- line: 22
	-- upvalues: useLocalization (copy), SignalsReact (copy), Game (copy), useExperienceDetailsShare (copy), React (copy), SduiChip (copy), Foundation (copy)
	local layoutOrder = t1.layoutOrder
	local universeId = t1.universeId
	local v16 = useLocalization({
		share = "Feature.SocialShare.Action.Share"
	})
	local v17 = SignalsReact.useSignalState(Game.getGameInfoStore(false).getAndFetchGameInfo(universeId).data)
	local v18 = v17 and v17.rootPlaceId or nil
	local v19 = useExperienceDetailsShare(universeId, v18, "ExperienceDetailsShareChip")

	return React.createElement(SduiChip, {
		text = v16.share,
		leadingIconName = Foundation.Enums.IconName.ArrowThickToRight,
		onActivated = v19,
		layoutOrder = layoutOrder
	})
end

return React.memo(ExperienceDetailsShareChip)
