local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local Constants = require(AbuseReportMenu.Components.Constants)

local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

function getAvailableMethodsOfAbuse(flag: boolean, flag2: boolean)
	local availableMethodsOfAbuse = {
		{
			label = RobloxTranslator:FormatByKey(Constants.localizationKeys[Constants.AbuseMethods.TextChat]),
			subLabel = RobloxTranslator:FormatByKey("Feature.SettingsHub.MethodOfAbuse.Text.Subtitle"),
			identifier = Constants.AbuseMethods.TextChat
		}
	}

	if flag2 then
		availableMethodsOfAbuse[#availableMethodsOfAbuse + 1] = {
			label = RobloxTranslator:FormatByKey(Constants.localizationKeys[Constants.AbuseMethods.Avatar]),
			subLabel = RobloxTranslator:FormatByKey("Feature.SettingsHub.MethodOfAbuse.AvatarSubtitle"),
			identifier = Constants.AbuseMethods.Avatar
		}
	else
		availableMethodsOfAbuse[#availableMethodsOfAbuse + 1] = {
			label = RobloxTranslator:FormatByKey(Constants.localizationKeys[Constants.AbuseMethods.Other]),
			subLabel = RobloxTranslator:FormatByKey("Feature.SettingsHub.MethodOfAbuse.Other.Subtitle"),
			identifier = Constants.AbuseMethods.Other
		}
	end

	if flag then
		table.insert(availableMethodsOfAbuse, 1, {
			label = RobloxTranslator:FormatByKey(Constants.localizationKeys[Constants.AbuseMethods.VoiceChat]),
			subLabel = RobloxTranslator:FormatByKey("Feature.SettingsHub.MethodOfAbuse.VoiceChat.Subtitle"),
			identifier = Constants.AbuseMethods.VoiceChat
		})
	end

	return availableMethodsOfAbuse
end

return getAvailableMethodsOfAbuse
