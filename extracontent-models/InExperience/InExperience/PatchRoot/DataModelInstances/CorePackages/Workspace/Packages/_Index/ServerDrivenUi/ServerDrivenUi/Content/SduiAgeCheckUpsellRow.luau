local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local IXPService = game:GetService("IXPService")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local React = require(ServerDrivenUiParent.React)
local SignalsReact = require(ServerDrivenUiParent.SignalsReact)
local SduiContentRow = require(ServerDrivenUiParent.SduiSharedContent).SduiContentRow
local AgeCheckUpsellDismissedData = require(ServerDrivenUiParent.GameDetail).AgeCheckUpsellDismissedData
local v8 = game:DefineFastFlag("LuaAppEdpFaeIxpEnabled", false)
local v9 = game:DefineFastString("LuaAppEdpFaeIxpLayer", "PlayerApp.GameDetailsPage.Exposure")

local function SduiAgeCheckUpsellRow(t1: {[any]: any}) -- line: 37
	-- upvalues: SignalsReact (copy), AgeCheckUpsellDismissedData (copy), v8 (copy), React (copy), IXPService (copy), v9 (copy), SduiContentRow (copy)
	local v12 = SignalsReact.useSignalState(AgeCheckUpsellDismissedData.getIsAgeCheckUpsellDismissed)

	if v8 then
		React.useEffect(function() -- line: 41
			-- upvalues: v12 (copy), IXPService (copy), v9 (copy)
			if not v12 then
				IXPService:LogFlagLinkedUserLayerExposure(v9)
			end
		end, { v12 })
	end

	if v12 then
		return nil
	end

	return React.createElement(SduiContentRow, t1)
end

return React.memo(SduiAgeCheckUpsellRow)
