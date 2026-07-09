local Modules = game:GetService("CoreGui").RobloxGui.Modules
local accountSecurityPromptEvent = require(Modules.LuaApp.Analytics.Events.accountSecurityPromptEvent)
local DisplayType = require(Modules.LuaApp.Enum.AccountSecurity.DisplayType)
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local PromptType = require(Modules.LuaApp.Enum.AccountSecurity.PromptType)
local UpdatePromptType = require(Modules.LuaApp.Actions.AccountSecurity.UpdatePromptType)

return function(p1, p2, p3, p4) -- line: 12
	-- upvalues: PromptType (copy), DisplayType (copy), OverlayType (copy), accountSecurityPromptEvent (copy), EventStreamConstants (copy), UpdatePromptType (copy)
	assert(p3 == nil or (PromptType.isEnumValue(p3) or p2 and (typeof(p4) == "table" and DisplayType.isEnumValue(DisplayType.fromRawValue(p4.displayType)))), "Invalid arguments for UpdatePromptTypeWithEvent")

	return function(p5) -- line: 24
		-- upvalues: p3 (copy), OverlayType (copy), PromptType (copy), accountSecurityPromptEvent (copy), p1 (copy), EventStreamConstants (copy), UpdatePromptType (copy), p2 (copy), p4 (copy)
		local AccountSecurityPrompt = p5:getState().AccountSecurityPrompt
		local OverlayType2 = p5:getState().CentralOverlay.OverlayType
		local promptType = AccountSecurityPrompt.promptType

		if p3 ~= nil and (OverlayType2 ~= OverlayType.AccountSecurityPromptOverlay and promptType ~= p3) then
			local v16 = PromptType.toRawValue(p3)

			if v16 == nil then
				v16 = p3
			end

			accountSecurityPromptEvent(p1.EventStream, EventStreamConstants.Context.ModalStateViewed, v16, "NONE")
		end

		p5:dispatch(UpdatePromptType(p2, p3, p4))
	end
end
