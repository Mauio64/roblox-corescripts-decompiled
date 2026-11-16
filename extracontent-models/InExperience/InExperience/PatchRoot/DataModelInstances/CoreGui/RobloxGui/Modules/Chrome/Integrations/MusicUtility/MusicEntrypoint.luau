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

local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local MappedSignal = ChromeUtils.MappedSignal

local MUSIC_WINDOW_MAX_SIZE = Constants.MUSIC_WINDOW_MAX_SIZE

local useSignalState = SignalsReact.useSignalState

local windowSize = WindowSizeSignal.new(MUSIC_WINDOW_MAX_SIZE.X, MUSIC_WINDOW_MAX_SIZE.Y)

local isActivated = MappedSignal.new(Service:onIntegrationStatusChanged(), function()
	return Service:isWindowOpen("music_entrypoint")
end)

local signal, v = Signals.createSignal(false)

local function focusMusicWindow()
	GuiService:SetMenuIsOpen(true, "music_entrypoint")
	v(true)
end

local function unfocusMusicWindow() -- 1 equivalent call inferred from this helper
	v(false)
	GuiService:SetMenuIsOpen(false, "music_entrypoint")
end

return Service:register({
	initialAvailability = Service.AvailabilitySignal.Available,
	id = "music_entrypoint",
	sideSheetPlacement = SideSheetPlacement.BelowFold,
	draggable = true,
	cachePosition = true,
	windowSize = windowSize,
	label = "CoreScripts.TopBar.Music",
	activated = function()
		if Responsive.GetInputModeStore(false).getLastInputType(false) == Responsive.Input.Directional then
			Chrome2.FocusUtils.FocusOffChrome(focusMusicWindow)

			if not isActivated:get() then
				Service:toggleWindow("music_entrypoint")
			end
		else
			Service:toggleWindow("music_entrypoint")
		end
	end,
	isActivated = isActivated,
	components = {
		Icon = function(_)
			return CommonIcon("icons/common/music", "icons/common/musicFilled_medium", isActivated)
		end,
		Window = function()
			local isFocused = useSignalState(signal)

			return React.createElement(Foundation.View, {
				tag = "auto-xy",
				onAbsoluteSizeChanged = function(p)
					windowSize:requestSize(p.AbsoluteSize.X, p.AbsoluteSize.Y)
				end
			}, {
				ChromeWindowWrapper = React.createElement(Songbird.ChromeWindowWrapper, {
					isFocused = isFocused,
					onClose = function()
						unfocusMusicWindow() -- inferred equivalent call
						Service:toggleWindow("music_entrypoint")
					end,
					onUnfocus = unfocusMusicWindow
				})
			})
		end
	}
})
