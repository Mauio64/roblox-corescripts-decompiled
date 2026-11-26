local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)

local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local focusable = RoactGamepad.Focusable

local ItemInfoRow = require("@game/CorePackages/Workspace/Packages/_Workspace/ItemDetails/ItemDetails/ItemInfoRow")
local module2 = require("@luauforge/deferred/gDz")
require("@luauforge/bundled/dEZ")

local GameHydrationReact = require("@game/CorePackages/Workspace/Packages/GameHydrationReact")
require("@luauforge/bundled/dPs")

local module4 = require("@luauforge/deferred/gPe")

local forwardRef = React.forwardRef(function(props, p2)
	local v5 = GameHydrationReact.useGameIcon(props.creatingUniverseId)
	local v6, v7

	if props.playabilityStatus then
		local playabilityStatus = props.playabilityStatus.playabilityStatus

		v6 = module4.ShowPlayableAttributionMapper[playabilityStatus]

		v7 = module4.ShowTraversalAlertMapper[playabilityStatus]
	else
		v7 = nil
	end

	local v8 = useNavigation()
	local function onClickAttribution()
		if v7 then
			v8.navigate(avatarScreen.OpenExperienceTraversalPrompt, {
				onPlayButtonActivated = props.onPlayButtonActivated,
				gameName = props.gameName,
				gameUniverseId = props.creatingUniverseId,
				thumbnailUrl = v5
			})
		else
			props.onPlayButtonActivated()
		end
	end

	return v6 and React.createElement(focusable[ItemInfoRow], {
		infoName = props.infoName,
		infoData = not props.gameName and "" or props.gameName,
		onActivate = onClickAttribution,
		LayoutOrder = props.LayoutOrder,
		hideDivider = props.hideDivider,
		ref = props.attributionRef,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown
	})
end)

return (module2.connect(function(p2)
	return {
		extraParams = p2.gameJoinContext and { gameJoinContext = p2.gameJoinContext } or nil,
		universeId = p2.creatingUniverseId,
		launchSource = "AttributionItemRow",
		referralSource = "ItemDetailsPage"
	}
end, function(data, p2)
	return {
		playabilityStatus = data.playabilityStatus,
		playButtonState = data.playButtonState,
		gameName = data.gameName,
		onPlayButtonActivated = data.onPlayButtonActivated
	}
end)(forwardRef))
