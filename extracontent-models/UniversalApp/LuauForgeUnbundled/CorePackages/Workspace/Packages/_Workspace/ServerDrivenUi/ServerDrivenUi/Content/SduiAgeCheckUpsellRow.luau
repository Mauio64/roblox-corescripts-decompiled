local IXPService = game:GetService("IXPService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SignalsReact")

require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCompat")
local sduiContentRow = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedContent").SduiContentRow

local ageCheckUpsellDismissedData = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/GameDetail").AgeCheckUpsellDismissedData

local defineFastFlag = game:DefineFastFlag("LuaAppEdpFaeIxpEnabled", false)
local defineFastString = game:DefineFastString("LuaAppEdpFaeIxpLayer", "PlayerApp.GameDetailsPage.Exposure")

local function SduiAgeCheckUpsellRow(p2)
	local v5 = SignalsReact.useSignalState(ageCheckUpsellDismissedData.getIsAgeCheckUpsellDismissed)

	if defineFastFlag then
		React.useEffect(function()
			if not v5 then
				IXPService:LogFlagLinkedUserLayerExposure(defineFastString)
			end
		end, { v5 })
	end

	if v5 then
		return nil
	end

	return React.createElement(sduiContentRow, p2)
end

return React.memo(SduiAgeCheckUpsellRow)
