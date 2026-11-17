local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local SignalsReact = require(parent.SignalsReact)

local DataHydration = require(parent.DataHydration)
local Game = DataHydration.Game
local SduiSharedContent = require(parent.SduiSharedContent)
local Localization = require(parent.Localization)

local SduiChip = SduiSharedContent.SduiChip
local useLocalization = Localization.Hooks.useLocalization
local useExperienceDetailsShare = require(ServerDrivenUi.Content.ExperienceDetails.Hooks.useExperienceDetailsShare)

local function ExperienceDetailsShareChip(p)
	local layoutOrder = p.layoutOrder
	local universeId = p.universeId

	local v = useLocalization({ share = "Feature.SocialShare.Action.Share" })

	local v2 = SignalsReact.useSignalState(Game.getGameInfoStore(false).getAndFetchGameInfo(universeId).data)
	local rootPlaceId = v2 and v2.rootPlaceId or nil

	local onActivated = useExperienceDetailsShare(universeId, rootPlaceId, "ExperienceDetailsShareChip")

	return React.createElement(SduiChip, {
		text = v.share,
		leadingIconName = Foundation.Enums.IconName.ArrowThickToRight,
		onActivated = onActivated,
		layoutOrder = layoutOrder
	})
end

return React.memo(ExperienceDetailsShareChip)
