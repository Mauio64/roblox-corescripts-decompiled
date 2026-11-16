local module = require("@luauforge/bundled/fsx")
local module2 = require("@luauforge/bundled/frC")
local module3 = require("@luauforge/bundled/fsy")
local module4 = require("@luauforge/bundled/edO")
local module5 = require("@luauforge/bundled/fsl")
local module6 = require("@luauforge/bundled/fsA")

local fFlagUseSignalsForAccountSecurityPrompt = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForAccountSecurityPrompt
local getAccountSecurityPromptStore

if fFlagUseSignalsForAccountSecurityPrompt then
	getAccountSecurityPromptStore = require("@luauforge/bundled/frE").Stores.GetAccountSecurityPromptStore
else
	getAccountSecurityPromptStore = nil
end

return function(p2, p3, p4, p5)
	local v5

	if p4 == nil then
		v5 = true
	else
		v5 = module5.isEnumValue(p4)

		if not v5 then
			if p3 then
				v5 = typeof(p5) == "table" and module2.isEnumValue(module2.fromRawValue(p5.displayType))
			else
				v5 = p3
			end
		end
	end

	assert(v5, "Invalid arguments for UpdatePromptTypeWithEvent")

	return function(object)
		local overlayType = object:getState().CentralOverlay.OverlayType
		local v6

		if fFlagUseSignalsForAccountSecurityPrompt then
			v6 = getAccountSecurityPromptStore(false).getPromptType(false)
		else
			v6 = object:getState().AccountSecurityPrompt.promptType
		end

		if p4 ~= nil and overlayType ~= module4.AccountSecurityPromptOverlay and p4 ~= v6 then
			local v7 = module5.toRawValue(p4)

			if v7 == nil then
				v7 = p4
			end

			module(p2.EventStream, module3.Context.ModalStateViewed, v7, "NONE")
		end

		if fFlagUseSignalsForAccountSecurityPrompt then
			getAccountSecurityPromptStore(false).updatePromptType(p3, p4, p5)
		else
			object:dispatch(module6(p3, p4, p5))
		end
	end
end
