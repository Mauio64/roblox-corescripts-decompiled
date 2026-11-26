local module = require("@luauforge/bundled/ggX")
local useStyle = require("@luauforge/bundled/gjF").Core.Style.useStyle
local useSelector = require("@luauforge/bundled/ggY").Hooks.RoactRodux.useSelector
local centralOverlayType = require("@luauforge/bundled/ggZ").CentralOverlayType
local module2 = require("@luauforge/bundled/gjM")
local module3 = require("@luauforge/bundled/gjK")

local set = {
	[centralOverlayType.CrossDeviceCodePrompt] = true,
	[centralOverlayType.DeviceSelectorPeekView] = true,
	[centralOverlayType.MagicLoginRequestPopup] = true,
	[centralOverlayType.MagicLoginApprovePopup] = true,
	[centralOverlayType.AccountSelector] = true,
	[centralOverlayType.AccountSwitcher] = true
}

local function selectIsSurfaceReplacingOverlayOpen(p2)
	local centralOverlay = p2.CentralOverlay
	local overlayType = centralOverlay and centralOverlay.OverlayType
	local isSurfaceReplacingOverlayOpen = not (overlayType == nil) and set[overlayType] == true
	return isSurfaceReplacingOverlayOpen
end

local function useLoginV2ModalPageViewModel()
	local v5 = useStyle()
	local v6 = module2()
	local v7 = module.useContext(module3)
	local v8 = useSelector(selectIsSurfaceReplacingOverlayOpen)

	local v9 = {
		useModalLayout = v6,
		isPageObscured = v7.isPageVisible == false or v8,
		backgroundColor3 = 0,
		backgroundTransparency = 0
	}

	local v10 = if not v6 then v5.Theme.BackgroundDefault.Color else nil
	v9.backgroundColor3 = v10
	v9.backgroundTransparency = v6 and 1 or nil
	return v9
end

return useLoginV2ModalPageViewModel
