local module = require("@luauforge/deferred/fxM")
local module2 = require("@luauforge/deferred/fxN")

local module3 = require("@luauforge/deferred/fxH")
local OfferTermsDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/InExperienceShop/Components/OfferDialogs/OfferTermsDialog")
local module5 = require("@luauforge/deferred/fxQ")

local function OverlayScreen(p2)
	local v5 = module3(false)
	local v6 = module2.useSignalState(v5.currentSnackbar)
	local v7 = module2.useSignalState(v5.currentDialog)
	local formatted = `Dialog-{module2.useSignalState(v5.dialogPresentationId)}`

	module.useEffect(function()
		return function()
			v5.clearSnackbar()
			v5.clearDialog()
		end
	end, { v5 })

	local createElement = module.createElement
	local v9 = {
		[module.Tag] = "data-testid=transient-ui-overlay",
		DisplayOrder = p2.displayOrder or 202,
		IgnoreGuiInset = true,
		Name = "TransientUIOverlay",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}

	local v11 = if v6 ~= nil then module.createElement(module5, v6) else nil
	local v12 = if v7 ~= nil then module.createElement(OfferTermsDialog, v7) else nil
	return createElement("ScreenGui", v9, { Snackbar = v11, [formatted] = v12 })
end

return OverlayScreen
