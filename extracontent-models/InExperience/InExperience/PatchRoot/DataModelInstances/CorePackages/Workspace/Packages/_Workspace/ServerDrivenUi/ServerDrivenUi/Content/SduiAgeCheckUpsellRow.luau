local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local IXPService = game:GetService("IXPService")
local parent = ServerDrivenUi.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

require(parent.SduiCompat)
local SduiSharedContent = require(parent.SduiSharedContent)
local SduiContentRow = SduiSharedContent.SduiContentRow

local GameDetail = require(parent.GameDetail)
local AgeCheckUpsellDismissedData = GameDetail.AgeCheckUpsellDismissedData

local defineFastFlag = game:DefineFastFlag("LuaAppEdpFaeIxpEnabled", false)
local defineFastString = game:DefineFastString("LuaAppEdpFaeIxpLayer", "PlayerApp.GameDetailsPage.Exposure")

local function SduiAgeCheckUpsellRow(p)
	local v = SignalsReact.useSignalState(AgeCheckUpsellDismissedData.getIsAgeCheckUpsellDismissed)

	if defineFastFlag then
		React.useEffect(function()
			if not v then
				IXPService:LogFlagLinkedUserLayerExposure(defineFastString)
			end
		end, { v })
	end

	if v then
		return nil
	end

	return React.createElement(SduiContentRow, p)
end

return React.memo(SduiAgeCheckUpsellRow)
