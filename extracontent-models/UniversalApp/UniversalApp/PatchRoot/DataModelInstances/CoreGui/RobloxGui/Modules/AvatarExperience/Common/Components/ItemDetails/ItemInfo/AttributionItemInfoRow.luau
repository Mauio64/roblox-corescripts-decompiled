local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Focusable = RoactGamepad.Focusable
local ItemInfoRow = require(Modules.AvatarExperience.Common.Components.ItemDetails.ItemInfo.ItemInfoRow)
local LaunchExperienceConnector = require(Modules.LuaApp.Common.Experience.Connectors.LaunchExperienceConnector)

require(CorePackages.Workspace.Packages.PlayabilityRodux)

local GameIconReducer = require(CorePackages.Workspace.Packages.GameIconRodux).GameIcons.GameIconReducer

require(Modules.AvatarExperience.Common.Types)

local AttributionConstants = require(Modules.AvatarExperience.Catalog.AttributionConstants)
local v13 = React.forwardRef(function(t1: {[any]: any}, _) -- line: 48
	-- upvalues: AttributionConstants (copy), useNavigation (copy), AvatarScreen (copy), React (copy), Focusable (copy), ItemInfoRow (copy)
	local v17 = nil
	local u18 = nil

	if t1.playabilityStatus then
		local playabilityStatus = t1.playabilityStatus.playabilityStatus

		v17 = AttributionConstants.ShowPlayableAttributionMapper[playabilityStatus]
		u18 = AttributionConstants.ShowTraversalAlertMapper[playabilityStatus]
	end

	local v20 = useNavigation()

	local function onClickAttribution() -- line: 62
		-- upvalues: u18 (ref), v20 (copy), AvatarScreen (copy), t1 (copy)
		if u18 then
			v20.navigate(AvatarScreen.OpenExperienceTraversalPrompt, {
				onPlayButtonActivated = t1.onPlayButtonActivated,
				gameName = t1.gameName,
				gameUniverseId = t1.creatingUniverseId,
				thumbnailUrl = t1.thumbnailUrl
			})

			return
		end

		t1.onPlayButtonActivated()
	end

	return v17 and React.createElement(Focusable[ItemInfoRow], {
		infoName = t1.infoName,
		infoData = not t1.gameName and "" or t1.gameName,
		onActivate = onClickAttribution,
		LayoutOrder = t1.LayoutOrder,
		hideDivider = t1.hideDivider,
		ref = t1.attributionRef,
		NextSelectionUp = t1.NextSelectionUp,
		NextSelectionDown = t1.NextSelectionDown
	})
end)
local v14 = LaunchExperienceConnector.connect(function(p2) -- line: 95
	return {
		launchSource = "AttributionItemRow",
		referralSource = "ItemDetailsPage",
		extraParams = if not p2.gameJoinContext then nil else {
			gameJoinContext = p2.gameJoinContext
		},
		universeId = p2.creatingUniverseId
	}
end, function(p3, _) -- line: 102
	return {
		playabilityStatus = p3.playabilityStatus,
		playButtonState = p3.playButtonState,
		gameName = p3.gameName,
		onPlayButtonActivated = p3.onPlayButtonActivated
	}
end)(v13)

return (RoactRodux.connect(function(p5, p6) -- line: 112
	-- upvalues: GameIconReducer (copy)
	local v27 = p5[GameIconReducer.key][p6.creatingUniverseId]

	return {
		thumbnailUrl = if not v27 then nil else v27.url
	}
end)(v14))
