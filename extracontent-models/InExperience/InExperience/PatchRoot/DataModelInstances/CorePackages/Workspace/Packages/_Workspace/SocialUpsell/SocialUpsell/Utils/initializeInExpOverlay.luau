local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")
local SocialUpsell = script:FindFirstAncestor("SocialUpsell")
local SocialUpsellParent = SocialUpsell.Parent
local ReactRoblox = require(SocialUpsellParent.ReactRoblox)
local React = require(SocialUpsellParent.React)
local Signals = require(SocialUpsellParent.Signals)
local InExpOverlay = require(SocialUpsell.Components.InExpOverlay)
local Constants = require(SocialUpsell.Constants)
local getOverlayStore = require(SocialUpsell.Store.getOverlayStore)
local u12 = nil
local Folder = nil

function mount() -- line: 20
	-- upvalues: u12 (ref), Folder (ref), CoreGui (copy), ReactRoblox (copy), GuiService (copy), Constants (copy), ContextActionService (copy), React (copy), InExpOverlay (copy)
	if not u12 then
		if not Folder then
			Folder = Instance.new("Folder")
			Folder.Name = "Overlay"
			Folder.Parent = CoreGui
		end

		u12 = ReactRoblox.createRoot(Folder)
	end

	GuiService:SetMenuIsOpen(true, Constants.OVERLAY_MENU_NAME)
	ContextActionService:BindCoreAction(Constants.OVERLAY_CORE_ACTION_NAME, function() -- line: 33
	end, false, Enum.KeyCode.ButtonB, Enum.KeyCode.Escape)
	u12:render(React.createElement(InExpOverlay, {
		gui = Folder
	}))
end
function unmount() -- line: 43
	-- upvalues: u12 (ref), ContextActionService (copy), Constants (copy), GuiService (copy)
	if u12 then
		u12:unmount()
		ContextActionService:UnbindCoreAction(Constants.OVERLAY_CORE_ACTION_NAME)
		GuiService:SetMenuIsOpen(false, Constants.OVERLAY_MENU_NAME)
	end
end

local u14 = nil

return function() -- line: 52
	-- upvalues: getOverlayStore (copy), u14 (ref), Signals (copy)
	local v15 = getOverlayStore(false)

	u14 = Signals.createEffect(function(p1) -- line: 55
		-- upvalues: v15 (copy)
		if v15.getCurrentOverlayType(p1) then
			mount()

			return
		end

		unmount()
	end)
end
