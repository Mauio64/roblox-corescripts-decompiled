local Chrome = script:FindFirstAncestor("Chrome")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local SideSheetPlacement = Chrome2.Enums.SideSheetPlacement
local Foundation = require(CorePackages.Packages.Foundation)
local React = require(CorePackages.Packages.React)
local Songbird = require(CorePackages.Workspace.Packages.Songbird)
local Service = require(Chrome.Service)
local Constants = require(Chrome.Integrations.MusicUtility.Constants)
local CommonIcon = require(Chrome.Integrations.CommonIcon)
local WindowSizeSignal = require(Chrome.ChromeShared.Service.WindowSizeSignal)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local MappedSignal = require(Chrome.ChromeShared.Service.ChromeUtils).MappedSignal
local FFlagChromeActivatedMappedSignal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagChromeActivatedMappedSignal
local MUSIC_WINDOW_MAX_SIZE = Constants.MUSIC_WINDOW_MAX_SIZE
local useSignalState = SignalsReact.useSignalState
local v20 = WindowSizeSignal.new(MUSIC_WINDOW_MAX_SIZE.X, MUSIC_WINDOW_MAX_SIZE.Y)
local v21 = MappedSignal.new(Service:onIntegrationStatusChanged(), function() -- line: 31
	-- upvalues: Service (copy)
	return Service:isWindowOpen("music_entrypoint")
end)
local v22, v23 = Signals.createSignal(false)

local function focusMusicWindow() -- line: 37
	-- upvalues: GuiService (copy), v23 (copy)
	GuiService:SetMenuIsOpen(true, "music_entrypoint")
	v23(true)
end
local function unfocusMusicWindow() -- line: 42
	-- upvalues: v23 (copy), GuiService (copy)
	v23(false)
	GuiService:SetMenuIsOpen(false, "music_entrypoint")
end

return Service:register({
	id = "music_entrypoint",
	draggable = true,
	cachePosition = true,
	label = "CoreScripts.TopBar.Music",
	initialAvailability = Service.AvailabilitySignal.Available,
	sideSheetPlacement = SideSheetPlacement.Vertical,
	windowSize = v20,
	activated = function() -- line: 55
		-- upvalues: Responsive (copy), Chrome2 (copy), focusMusicWindow (copy), v21 (copy), Service (copy)
		if Responsive.GetInputModeStore(false).getLastInputType(false) == Responsive.Input.Directional then
			Chrome2.FocusUtils.FocusOffChrome(focusMusicWindow)

			if not v21:get() then
				Service:toggleWindow("music_entrypoint")

				return
			end
		else
			Service:toggleWindow("music_entrypoint")
		end
	end,
	isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 73
		-- upvalues: v21 (copy)
		return v21:get()
	end or v21,
	components = {
		Icon = function(_) -- line: 77
			-- upvalues: CommonIcon (copy), v21 (copy)
			return CommonIcon("icons/common/music", "icons/common/musicFilled_medium", v21)
		end,
		Window = function() -- line: 80
			-- upvalues: useSignalState (copy), v22 (copy), React (copy), Foundation (copy), v20 (copy), Songbird (copy), v23 (copy), GuiService (copy), Service (copy), unfocusMusicWindow (copy)
			local v27 = useSignalState(v22)

			return React.createElement(Foundation.View, {
				tag = "auto-xy",
				onAbsoluteSizeChanged = function(p2) -- line: 85
					-- upvalues: v20 (copy)
					v20:requestSize(p2.AbsoluteSize.X, p2.AbsoluteSize.Y)
				end
			}, {
				ChromeWindowWrapper = React.createElement(Songbird.ChromeWindowWrapper, {
					isFocused = v27,
					onClose = function() -- line: 91
						-- upvalues: v23 (copy), GuiService (copy), Service (copy)
						v23(false)
						GuiService:SetMenuIsOpen(false, "music_entrypoint")
						Service:toggleWindow("music_entrypoint")
					end,
					onUnfocus = unfocusMusicWindow
				})
			})
		end
	}
})
