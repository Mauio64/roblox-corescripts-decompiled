local Modules = game:GetService("CoreGui").RobloxGui.Modules
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local GenericWebPageWrapper = require(Modules.LuaApp.Components.GenericWebPageWrapper)
local UpdateLocalPlayerInfo = require(Modules.LuaApp.Thunks.UpdateLocalPlayerInfo)
local Roact = require(Modules.Common.Roact)
local CorePackages = game:GetService("CorePackages")
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local React = require(CorePackages.Packages.React)
local SettingsNativeWrapper = require(Modules.LuaApp.Components.SettingsNativeWrapper)
local GetFFlagLuaAppUseSettingsNativeWrapper = require(Modules.LuaApp.Flags.GetFFlagLuaAppUseSettingsNativeWrapper)

local function AccountInfoPage(p1) -- line: 20
	-- upvalues: useDispatch (copy), useRoactService (copy), RoactNetworking (copy), React (copy), UpdateLocalPlayerInfo (copy), GetFFlagLuaAppUseSettingsNativeWrapper (copy), Roact (copy), SettingsNativeWrapper (copy), GenericWebPageWrapper (copy)
	local v14 = useDispatch()
	local v15 = useRoactService(RoactNetworking)

	React.useEffect(function() -- line: 23
		-- upvalues: v14 (copy), UpdateLocalPlayerInfo (copy), v15 (copy)
		return function() -- line: 24
			-- upvalues: v14 (copy), UpdateLocalPlayerInfo (copy), v15 (copy)
			v14(UpdateLocalPlayerInfo(v15))
		end
	end, {})

	if GetFFlagLuaAppUseSettingsNativeWrapper() then
		return Roact.createElement(SettingsNativeWrapper, {
			url = p1.url,
			titleKey = p1.titleKey,
			windowCloseCallback = p1 and p1.onClose or nil,
			isVisible = p1.isVisible,
			displayOrder = p1.displayOrder
		})
	end

	return Roact.createElement(GenericWebPageWrapper, {
		isVisible = p1.isVisible,
		DisplayOrder = p1.displayOrder,
		url = p1.url,
		title = p1.title,
		titleKey = p1.titleKey
	})
end

return AccountInfoPage
