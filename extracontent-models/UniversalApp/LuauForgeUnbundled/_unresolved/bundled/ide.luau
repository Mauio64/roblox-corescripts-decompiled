local CorePackages = game:GetService("CorePackages")
local LocalizationService = game:GetService("LocalizationService")
local NotificationService = game:GetService("NotificationService")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local Cryo = require(CorePackages.Packages.Cryo)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local fFlagUseSignalsForIsLocalUserSoothsayer = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForIsLocalUserSoothsayer
local getIsLocalUserSoothsayerStore

if fFlagUseSignalsForIsLocalUserSoothsayer then
	getIsLocalUserSoothsayerStore = require("@luauforge/bundled/fDR").GetIsLocalUserSoothsayerStore
else
	getIsLocalUserSoothsayerStore = nil
end

local defineFastFlag = game:DefineFastFlag("EnableVirtualizedListBacktraceTag", false)

local module = require("@luauforge/bundled/hWE")
local module2 = require("@luauforge/bundled/vM")

local extended = Roact.PureComponent:extend("LuaAppBacktraceReporterAdaptor")

function extended:updateAppGenericAttributes(p3)
	module:updateSharedAttributes((module2(function()
		return {
			AppTheme = tostring(NotificationService.SelectedTheme),
			Locale = tostring(LocalizationService.RobloxLocaleId)
		}
	end, {})))

	module:updateSharedAttributes({ RoactNavigationVersion = "0.5.3" })

	module:updateSharedAttributes({ Roact17Version = "17.0.1" })

	if defineFastFlag then
		module:updateSharedAttributes({ VirtualizedListVersion = "1.1.2" })
	end
end

function extended:updateStoreAnnotations()
	module:updateSharedAnnotations(self.props)
end

function extended:didMount()
	self:updateAppGenericAttributes(self.props)
end

function extended.render(p2): nil
	return nil
end

function extended:didUpdate(p2)
	self:updateStoreAnnotations()
end

local v5 = RoactRodux.connect(function(data, p2)
	return module2(function()
		local v6 = {
			FormFactor = data.FormFactor,
			isLocalUserSoothsayer = 0,
			GlobalGuiInset = 0
		}

		local v7 = if not fFlagUseSignalsForIsLocalUserSoothsayer then data.IsLocalUserSoothsayer else nil
		v6.isLocalUserSoothsayer = v7

		v6.GlobalGuiInset = data.GlobalGuiInset
		return v6
	end, {})
end)(extended)
local v6

if fFlagUseSignalsForIsLocalUserSoothsayer then
	v6 = React.memo(function(p2)
		local v7 = useSignalState(getIsLocalUserSoothsayerStore(false).getIsLocalUserSoothsayer)
		return Roact.createElement(v5, Cryo.Dictionary.union(p2, {
			isLocalUserSoothsayer = v7
		}))
	end)
else
	v6 = v5
end

return v6
