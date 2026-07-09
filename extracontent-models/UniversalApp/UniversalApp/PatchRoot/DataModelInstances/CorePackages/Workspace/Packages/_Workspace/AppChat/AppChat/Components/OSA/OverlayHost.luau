local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Cryo = require(AppChatParent.Cryo)
local React = require(AppChatParent.React)
local SignalsReact = require(AppChatParent.SignalsReact)
local ProviderContainer = require(AppChatParent.RoactUtils).Components.ProviderContainer
local GroupOSADialog = require(AppChat.Components.OSA.GroupOSADialog)
local GetOverlayStore = require(AppChat.Stores.GetOverlayStore)
local FFlagSupportViewingUserProfileOnOSA = require(AppChat.Flags.FFlagSupportViewingUserProfileOnOSA)
local FFlagAppChatShowOSAOnPageEntry = require(AppChatParent.SharedFlags).FFlagAppChatShowOSAOnPageEntry
local t1 = {
	GroupOSADialog = GroupOSADialog
}

local function OverlayHost(t2: {[any]: any}) -- line: 35
	-- upvalues: GetOverlayStore (copy), SignalsReact (copy), FFlagSupportViewingUserProfileOnOSA (copy), React (copy), t1 (copy), Cryo (copy), FFlagAppChatShowOSAOnPageEntry (copy), ProviderContainer (copy)
	local v14 = GetOverlayStore(false)
	local v15 = SignalsReact.useSignalState(v14.getCurrentOverlay)
	local v16 = if not FFlagSupportViewingUserProfileOnOSA then nil else SignalsReact.useSignalState(v14.getOverlayDefaultProps)
	local v17 = React.useCallback(function() -- line: 43
		-- upvalues: v14 (copy)
		v14.dismissOverlay()
	end, {})
	local v18 = v15 and v15.overlayType
	local v19 = v18 and t1[v18]

	if not v19 then
		return nil
	end

	local v20 = if not FFlagSupportViewingUserProfileOnOSA then table.clone(v15.overlayProps or {}) else Cryo.Dictionary.union(v16 or {}, v15.overlayProps or {})

	if FFlagAppChatShowOSAOnPageEntry then
		local onClose = v20.onClose

		function v20.onClose() -- line: 58
			-- upvalues: onClose (copy), v17 (copy)
			if onClose then
				onClose()
			end

			v17()
		end
	else
		v20.onClose = v17
	end

	v20.hasBackdrop = true
	v20.disablePortal = false

	local v22 = React.createElement(v19, v20)

	if t2.providers and #t2.providers > 0 then
		return React.createElement(ProviderContainer, {
			providers = t2.providers
		}, {
			Overlay = v22
		})
	end

	return v22
end

return OverlayHost
