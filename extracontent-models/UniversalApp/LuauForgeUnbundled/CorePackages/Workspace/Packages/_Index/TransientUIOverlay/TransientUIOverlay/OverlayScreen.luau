require("@game/CorePackages/Workspace/Packages/_Workspace/TransientUIOverlay/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/TransientUIOverlay/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/TransientUIOverlay/SignalsReact")

local GetTransientUIOverlayStore = require("@game/CorePackages/Workspace/Packages/_Index/TransientUIOverlay/TransientUIOverlay/Stores/GetTransientUIOverlayStore")
local TransientDialog = require("@game/CorePackages/Workspace/Packages/_Index/TransientUIOverlay/TransientUIOverlay/Components/TransientDialog")
local TransientSnackbar = require("@game/CorePackages/Workspace/Packages/_Index/TransientUIOverlay/TransientUIOverlay/Components/TransientSnackbar")

local function OverlayScreen(p2)
	local v5 = GetTransientUIOverlayStore(false)
	local v6 = SignalsReact.useSignalState(v5.currentSnackbar)
	local v7 = SignalsReact.useSignalState(v5.currentDialog)
	local formatted = `Dialog-{module2.useSignalState(v5.dialogPresentationId)}`
	local clone

	if v6 ~= nil then
		clone = table.clone(v6)
		clone.device = p2.device
	end

	local clone2

	if v7 ~= nil then
		clone2 = table.clone(v7)
		clone2.device = p2.device
	end

	React.useEffect(function()
		return function()
			v5.clearSnackbar()
			v5.clearDialog()
		end
	end, { v5 })

	local createElement = React.createElement
	local v9 = {
		[React.Tag] = "data-testid=transient-ui-overlay",
		DisplayOrder = p2.displayOrder or 202,
		IgnoreGuiInset = true,
		Name = "TransientUIOverlay",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}

	local v11 = if clone ~= nil then React.createElement(TransientSnackbar, clone) else nil

	local v12 = if clone2 ~= nil then React.createElement(TransientDialog, clone2) else nil
	return createElement("ScreenGui", v9, { Snackbar = v11, [formatted] = v12 })
end

return OverlayScreen
