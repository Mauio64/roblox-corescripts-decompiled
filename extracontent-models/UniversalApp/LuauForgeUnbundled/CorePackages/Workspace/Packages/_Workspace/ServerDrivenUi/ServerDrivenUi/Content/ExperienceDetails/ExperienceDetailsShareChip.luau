local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Foundation")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SignalsReact")

local Game = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DataHydration").Game
local SduiSharedContent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/Localization")

local sduiChip = SduiSharedContent.SduiChip
local useLocalization = Localization.Hooks.useLocalization
local useExperienceDetailsShare = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Content/ExperienceDetails/Hooks/useExperienceDetailsShare")

local function ExperienceDetailsShareChip(p2)
	local layoutOrder = p2.layoutOrder
	local universeId = p2.universeId

	local v5 = useLocalization({ share = "Feature.SocialShare.Action.Share" })

	local v6 = SignalsReact.useSignalState(Game.getGameInfoStore(false).getAndFetchGameInfo(universeId).data)
	local rootPlaceId = v6 and v6.rootPlaceId or nil

	local v7 = useExperienceDetailsShare(universeId, rootPlaceId, "ExperienceDetailsShareChip")

	return React.createElement(sduiChip, {
		text = v5.share,
		leadingIconName = Foundation.Enums.IconName.ArrowThickToRight,
		onActivated = v7,
		layoutOrder = layoutOrder
	})
end

return React.memo(ExperienceDetailsShareChip)
