local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")

local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/ReactRoblox")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/Signals")

local InExpOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Components/InExpOverlay")
local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Constants")

local getOverlayStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialUpsell/SocialUpsell/Store/getOverlayStore")

local v5 = nil
local overlay = nil

function LUAUFORGE_MODULE_GLOBALS_cQq_mount()
	if not v5 then
		if not overlay then
			overlay = Instance.new("Folder")
			overlay.Name = "Overlay"
			overlay.Parent = CoreGui
		end

		v5 = ReactRoblox.createRoot(overlay)
	end

	GuiService:SetMenuIsOpen(true, Constants.OVERLAY_MENU_NAME)
	ContextActionService:BindCoreAction(
		Constants.OVERLAY_CORE_ACTION_NAME,
		function() end,
		false,
		Enum.KeyCode.ButtonB,
		Enum.KeyCode.Escape
	)

	v5:render(React.createElement(InExpOverlay, { gui = overlay }))
end

function LUAUFORGE_MODULE_GLOBALS_cQq_unmount()
	if v5 then
		v5:unmount()
		ContextActionService:UnbindCoreAction(Constants.OVERLAY_CORE_ACTION_NAME)
		GuiService:SetMenuIsOpen(false, Constants.OVERLAY_MENU_NAME)
	end
end

local v6 = nil
return function()
	local v7 = getOverlayStore(false)

	v6 = Signals.createEffect(function(p2)
		if v7.getCurrentOverlayType(p2) then
			LUAUFORGE_MODULE_GLOBALS_cQq_mount()
		else
			LUAUFORGE_MODULE_GLOBALS_cQq_unmount()
		end
	end)
end
