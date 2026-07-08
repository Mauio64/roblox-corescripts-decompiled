local AbuseReportMenu = script:FindFirstAncestor("AbuseReportMenu")
local CorePackages = game:GetService("CorePackages")
local Constants = require(AbuseReportMenu.Components.Constants)
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)

function getAvailableMethodsOfAbuse(b1: boolean, b2: boolean) -- line: 7
	-- upvalues: RobloxTranslator (copy), Constants (copy)
	local t1 = {{
		label = RobloxTranslator:FormatByKey(Constants.localizationKeys[Constants.AbuseMethods.TextChat]),
		subLabel = RobloxTranslator:FormatByKey("Feature.SettingsHub.MethodOfAbuse.Text.Subtitle"),
		identifier = Constants.AbuseMethods.TextChat
	}}

	if b2 then
		t1[#t1 + 1] = {
			label = RobloxTranslator:FormatByKey(Constants.localizationKeys[Constants.AbuseMethods.Avatar]),
			subLabel = RobloxTranslator:FormatByKey("Feature.SettingsHub.MethodOfAbuse.AvatarSubtitle"),
			identifier = Constants.AbuseMethods.Avatar
		}
	else
		t1[#t1 + 1] = {
			label = RobloxTranslator:FormatByKey(Constants.localizationKeys[Constants.AbuseMethods.Other]),
			subLabel = RobloxTranslator:FormatByKey("Feature.SettingsHub.MethodOfAbuse.Other.Subtitle"),
			identifier = Constants.AbuseMethods.Other
		}
	end

	if b1 then
		table.insert(t1, 1, {
			label = RobloxTranslator:FormatByKey(Constants.localizationKeys[Constants.AbuseMethods.VoiceChat]),
			subLabel = RobloxTranslator:FormatByKey("Feature.SettingsHub.MethodOfAbuse.VoiceChat.Subtitle"),
			identifier = Constants.AbuseMethods.VoiceChat
		})
	end

	return t1
end

return getAvailableMethodsOfAbuse
