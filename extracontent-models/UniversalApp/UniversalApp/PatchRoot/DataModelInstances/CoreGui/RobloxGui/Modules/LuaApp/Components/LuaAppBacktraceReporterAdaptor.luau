local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local NotificationService = game:GetService("NotificationService")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local v8 = game:DefineFastFlag("EnableVirtualizedListBacktraceTag", false)
local LuaAppBacktraceReporter = require(Modules.LuaApp.LuaAppBacktraceReporter)
local safeCall = require(Modules.LuaApp.Util.safeCall)
local v11 = Roact.PureComponent:extend("LuaAppBacktraceReporterAdaptor")

function v11.updateAppGenericAttributes(_, _) -- line: 16
	-- upvalues: safeCall (copy), NotificationService (copy), LocalizationService (copy), LuaAppBacktraceReporter (copy), v8 (copy)
	local v14 = safeCall(function() -- line: 17
		-- upvalues: NotificationService (copy), LocalizationService (copy)
		return {
			AppTheme = tostring(NotificationService.SelectedTheme),
			Locale = tostring(LocalizationService.RobloxLocaleId)
		}
	end, {})

	LuaAppBacktraceReporter:updateSharedAttributes(v14)
	LuaAppBacktraceReporter:updateSharedAttributes({
		RoactNavigationVersion = "0.5.3"
	})
	LuaAppBacktraceReporter:updateSharedAttributes({
		Roact17Version = "17.0.1"
	})

	if v8 then
		LuaAppBacktraceReporter:updateSharedAttributes({
			VirtualizedListVersion = "1.1.2"
		})
	end
end
function v11.updateStoreAnnotations(p3) -- line: 42
	-- upvalues: LuaAppBacktraceReporter (copy)
	LuaAppBacktraceReporter:updateSharedAnnotations(p3.props)
end
function v11.didMount(p4) -- line: 46
	p4:updateAppGenericAttributes(p4.props)
end
function v11.render(_) -- line: 50
	return nil
end
function v11.didUpdate(p6, _) -- line: 54
	p6:updateStoreAnnotations()
end

return (RoactRodux.connect(function(p8, _) -- line: 58
	-- upvalues: safeCall (copy)
	return safeCall(function() -- line: 61
		-- upvalues: p8 (copy)
		return {
			FormFactor = p8.FormFactor,
			isLocalUserSoothsayer = p8.IsLocalUserSoothsayer,
			GlobalGuiInset = p8.GlobalGuiInset
		}
	end, {})
end)(v11))
