local TransientUIOverlay = script:FindFirstAncestor("TransientUIOverlay")
local parent = TransientUIOverlay.Parent

require(parent.Foundation)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local GetTransientUIOverlayStore = require(TransientUIOverlay.Stores.GetTransientUIOverlayStore)
local TransientDialog = require(TransientUIOverlay.Components.TransientDialog)
local TransientSnackbar = require(TransientUIOverlay.Components.TransientSnackbar)

local function OverlayScreen(p)
	local transientUIOverlayStore = GetTransientUIOverlayStore(false)
	local v = SignalsReact.useSignalState(transientUIOverlayStore.currentSnackbar)
	local v2 = SignalsReact.useSignalState(transientUIOverlayStore.currentDialog)
	local formatted = `Dialog-{SignalsReact.useSignalState(transientUIOverlayStore.dialogPresentationId)}`
	local clone

	if v ~= nil then
		clone = table.clone(v)
		clone.device = p.device
	end

	local clone2

	if v2 ~= nil then
		clone2 = table.clone(v2)
		clone2.device = p.device
	end

	React.useEffect(function()
		return function()
			transientUIOverlayStore.clearSnackbar()
			transientUIOverlayStore.clearDialog()
		end
	end, { transientUIOverlayStore })

	local createElement = React.createElement
	local v3 = {
		[React.Tag] = "data-testid=transient-ui-overlay",
		DisplayOrder = p.displayOrder or 202,
		IgnoreGuiInset = true,
		Name = "TransientUIOverlay",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}
	local snackbar

	if clone ~= nil then
		snackbar = React.createElement(TransientSnackbar, clone)
	end

	local v4

	if clone2 ~= nil then
		v4 = React.createElement(TransientDialog, clone2)
	end

	return createElement("ScreenGui", v3, { Snackbar = snackbar, [formatted] = v4 })
end

return OverlayScreen
