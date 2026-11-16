local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local Foundation = require(CorePackages.Packages.Foundation)
local LuauPolyfill = require(CorePackages.Packages.LuauPolyfill)
local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
local CoreScriptsRootProvider = CoreScriptsRoactCommon.CoreScriptsRootProvider
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local useSnackbarSlideMotionFromBottom = require(script.Parent.useSnackbarSlideMotionFromBottom)
local setTimeout = LuauPolyfill.setTimeout
local clearTimeout = LuauPolyfill.clearTimeout

local defineFastInt = game:DefineFastInt("VoiceRestrictionEndedSnackbarDismissSeconds", 4)

local v = nil
local v2 = nil
local signal, v3 = Signals.createSignal(0)

local function unmountSnackbar() -- 1 equivalent call inferred from this helper
	if v2 then
		v2:unmount()
		v2 = nil
	end

	if v then
		v:Destroy()
		v = nil
	end
end

local function dismissSnackbar(p: number)
	if signal(false) ~= p then
		return
	end

	unmountSnackbar() -- inferred equivalent call
end

local function VoiceRestrictionEndedSnackbar(p)
	local v4 = SignalsReact.useSignalState(signal)
	local v5 = useSnackbarSlideMotionFromBottom()
	local enter = v5.enter
	local exit = v5.exit

	React.useEffect(function()
		enter()
		local v6 = setTimeout(function()
			exit(function()
				p.onDismiss(v4)
			end)
		end, defineFastInt * 1000)
		return function()
			clearTimeout(v6)
		end
	end, { v4, enter, exit, p.onDismiss })

	return React.createElement(Foundation.Snackbar, {
		title = RobloxTranslator:FormatByKey("Feature.InExperienceIntervention.Description.StartNewGameToTurnOnVoiceChat"),
		AnchorPoint = v5.anchorPoint,
		Position = v5.position
	})
end

local function mountHost() -- 1 equivalent call inferred from this helper
	local voiceRestrictionEndedSnackbar = Instance.new("ScreenGui")
	voiceRestrictionEndedSnackbar.Name = "VoiceRestrictionEndedSnackbar"
	voiceRestrictionEndedSnackbar.DisplayOrder = 10
	voiceRestrictionEndedSnackbar.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	voiceRestrictionEndedSnackbar.ResetOnSpawn = false

	voiceRestrictionEndedSnackbar.ScreenInsets = Enum.ScreenInsets.None
	voiceRestrictionEndedSnackbar.ClipToDeviceSafeArea = false
	voiceRestrictionEndedSnackbar.Parent = CoreGui
	v = voiceRestrictionEndedSnackbar

	local root = ReactRoblox.createRoot(voiceRestrictionEndedSnackbar)
	v2 = root
	return root
end

local function showVoiceRestrictionEndedSnackbar()
	v3(signal(false) + 1)

	if v2 then
		return
	end

	mountHost():render(React.createElement(CoreScriptsRootProvider, {}, { -- inferred equivalent call
		Snackbar = React.createElement(VoiceRestrictionEndedSnackbar, {
			onDismiss = dismissSnackbar
		})
	}))
end

return showVoiceRestrictionEndedSnackbar
