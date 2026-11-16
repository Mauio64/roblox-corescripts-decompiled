local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local VerifiedBadges = require(CorePackages.Workspace.Packages.VerifiedBadges)
local UserLib = require(CorePackages.Workspace.Packages.UserLib)
require(AbuseReportMenu.Components.Types)
local Constants = require(AbuseReportMenu.Components.Constants)

local InExperienceCapabilities = require(CorePackages.Workspace.Packages.InExperienceCapabilities)
local inExperienceCapabilities = InExperienceCapabilities.InExperienceCapabilities
local PlayerModalSelectorMenuConfig = {}
PlayerModalSelectorMenuConfig.componentType = "modalSelector"

function PlayerModalSelectorMenuConfig.getIsVisible(_): boolean
	return true
end

function PlayerModalSelectorMenuConfig.getMenuItems(p)
	return (Cryo.List.map(p.playerObjects, function(p2)
		local v = not UserLib.Utils.isPlayerVerified(p2) and "" or VerifiedBadges.emoji.verified

		local v2 = {
			label = p2.DisplayName .. v,
			subLabel = 0,
			identifier = 0
		}
		local subLabel

		if inExperienceCapabilities.canDisplayPeoplesUsernames then
			subLabel = "[@" .. p2.Name .. "]"
		end

		v2.subLabel = subLabel

		v2.identifier = p2.Name
		return v2
	end))
end

function PlayerModalSelectorMenuConfig.getSelectedValue(p)
	local allegedAbuser = p.allegedAbuser

	if not allegedAbuser then
		return nil
	end

	local displayName = allegedAbuser.DisplayName
	local name = allegedAbuser.Name

	return displayName .. (not inExperienceCapabilities.canDisplayPeoplesUsernames and "" or "[@" .. name .. "]")
end

function PlayerModalSelectorMenuConfig.onUpdateSelectedOption(p, p2, callback, p3)
	if p.identifier then
		local identifier = p.identifier

		for _, playerObject in p2.playerObjects do
			if identifier ~= playerObject.Name then
				continue
			end

			local userId = playerObject.UserId
			p3.analyticsDispatch({ type = Constants.AnalyticsActions.IncrementPersonChanged })
			callback({
				type = Constants.PlayerMenuActions.UpdateAbuser,
				abuseId = userId,
				abuser = playerObject
			})
		end
	end
end

PlayerModalSelectorMenuConfig.fieldLabel = "WhichPerson"
PlayerModalSelectorMenuConfig.componentName = "PlayerSelector"
return PlayerModalSelectorMenuConfig
