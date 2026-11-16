local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")

local SocialUpsell = script:FindFirstAncestor("SocialUpsell")

local parent = SocialUpsell.Parent
local ReactRoblox = require(parent.ReactRoblox)
local React = require(parent.React)
local Signals = require(parent.Signals)

local InExpOverlay = require(SocialUpsell.Components.InExpOverlay)
local Constants = require(SocialUpsell.Constants)

local getOverlayStore = require(SocialUpsell.Store.getOverlayStore)

local v = nil
local overlay = nil

function mount()
	if not v then
		if not overlay then
			overlay = Instance.new("Folder")
			overlay.Name = "Overlay"
			overlay.Parent = CoreGui
		end

		v = ReactRoblox.createRoot(overlay)
	end

	GuiService:SetMenuIsOpen(true, Constants.OVERLAY_MENU_NAME)
	ContextActionService:BindCoreAction(
		Constants.OVERLAY_CORE_ACTION_NAME,
		function() end,
		false,
		Enum.KeyCode.ButtonB,
		Enum.KeyCode.Escape
	)

	v:render(React.createElement(InExpOverlay, { gui = overlay }))
end

function unmount()
	if v then
		v:unmount()
		ContextActionService:UnbindCoreAction(Constants.OVERLAY_CORE_ACTION_NAME)
		GuiService:SetMenuIsOpen(false, Constants.OVERLAY_MENU_NAME)
	end
end

local _ = nil
return function()
	local overlayStore = getOverlayStore(false)

	_ = Signals.createEffect(function(p)
		if overlayStore.getCurrentOverlayType(p) then
			mount()
		else
			unmount()
		end
	end)
end
