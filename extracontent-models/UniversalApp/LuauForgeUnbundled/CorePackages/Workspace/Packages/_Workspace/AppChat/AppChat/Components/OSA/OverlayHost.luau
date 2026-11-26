local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact")
local providerContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Components.ProviderContainer

local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/OSA/GroupOSADialog")
local GetOverlayStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetOverlayStore")

local fFlagAppChatShowOSAOnPageEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagAppChatShowOSAOnPageEntry

local v5 = { GroupOSADialog = module4 }

local function OverlayHost(p2)
	local v6 = GetOverlayStore(false)
	local v7 = SignalsReact.useSignalState(v6.getCurrentOverlay)

	local v8 = SignalsReact.useSignalState(v6.getOverlayDefaultProps)

	local v9 = React.useCallback(function()
		v6.dismissOverlay()
	end, {})

	local overlayType = v7 and v7.overlayType
	local v10 = overlayType and v5[overlayType]

	if not v10 then
		return nil
	end

	local union = Cryo.Dictionary.union(v8 or {}, v7.overlayProps or {})

	if fFlagAppChatShowOSAOnPageEntry then
		local onClose = union.onClose
		function union.onClose()
			if onClose then
				onClose()
			end

			v9()
		end
	else
		union.onClose = v9
	end

	union.hasBackdrop = true
	union.disablePortal = false

	local element = React.createElement(v10, union)

	if p2.providers and #p2.providers > 0 then
		return React.createElement(providerContainer, { providers = p2.providers }, {
			Overlay = element
		})
	end

	return element
end

return OverlayHost
