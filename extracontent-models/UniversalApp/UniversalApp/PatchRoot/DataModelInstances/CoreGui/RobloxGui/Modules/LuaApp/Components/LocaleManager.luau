local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local LocalizationService = game:GetService("LocalizationService")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local ExternalEventConnection = require(Modules.Common.RoactUtilities.ExternalEventConnection)
local LuaAppBacktraceReporter = require(Modules.LuaApp.LuaAppBacktraceReporter)

function UpdateLocalizationWithLocale(p1) -- line: 12
	-- upvalues: LocalizationService (copy), LuaAppBacktraceReporter (copy)
	local RobloxLocaleId = LocalizationService.RobloxLocaleId

	p1:SetLocale(RobloxLocaleId)
	LuaAppBacktraceReporter:updateSharedAttributes({
		Locale = RobloxLocaleId
	})
end

return function(p2) -- line: 21
	-- upvalues: React (copy), LocalizationService (copy), Roact (copy), ExternalEventConnection (copy)
	local localization = p2.localization

	React.useEffect(function() -- line: 24
		-- upvalues: localization (copy), LocalizationService (copy)
		if localization:GetLocale() ~= LocalizationService.RobloxLocaleId then
			UpdateLocalizationWithLocale(localization)
		end
	end, { p2.localization })

	return Roact.createElement(ExternalEventConnection, {
		event = LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"),
		callback = function() -- line: 35
			-- upvalues: localization (copy)
			UpdateLocalizationWithLocale(localization)
		end
	})
end
