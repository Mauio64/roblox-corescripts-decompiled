local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local RoactUtils = require(parent.RoactUtils)
local ProviderContainer = RoactUtils.Components.ProviderContainer

local GroupOSADialog = require(AppChat.Components.OSA.GroupOSADialog)
local GetOverlayStore = require(AppChat.Stores.GetOverlayStore)

local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatShowOSAOnPageEntry = SharedFlags.FFlagAppChatShowOSAOnPageEntry

local v = { GroupOSADialog = GroupOSADialog }

local function OverlayHost(p)
	local overlayStore = GetOverlayStore(false)
	local v2 = SignalsReact.useSignalState(overlayStore.getCurrentOverlay)

	local v3 = SignalsReact.useSignalState(overlayStore.getOverlayDefaultProps)

	local onClose2 = React.useCallback(function()
		overlayStore.dismissOverlay()
	end, {})

	local overlayType = v2 and v2.overlayType
	local v4 = overlayType and v[overlayType]

	if not v4 then
		return nil
	end

	local union = Cryo.Dictionary.union(v3 or {}, v2.overlayProps or {})

	if FFlagAppChatShowOSAOnPageEntry then
		local onClose = union.onClose
		function union.onClose()
			if onClose then
				onClose()
			end

			onClose2()
		end
	else
		union.onClose = onClose2
	end

	union.hasBackdrop = true
	union.disablePortal = false

	local element = React.createElement(v4, union)

	if p.providers and #p.providers > 0 then
		return React.createElement(ProviderContainer, { providers = p.providers }, {
			Overlay = element
		})
	end

	return element
end

return OverlayHost
