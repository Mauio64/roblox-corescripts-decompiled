local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local UserGameSettings = UserSettings():GetService("UserGameSettings")
local PropertyChangedSignal = UserGameSettings:GetPropertyChangedSignal("MasterVolume")
local ParentParent = script.Parent.Parent.Parent
local FFlagRenameVolumeToMainVolume = require(CoreGui.RobloxGui.Modules.Flags.FFlagRenameVolumeToMainVolume)
local ExternalEventConnection = require(ParentParent.Utility.ExternalEventConnection)
local SliderEntry = require(script.Parent.SliderEntry)
local SendAnalytics = require(ParentParent.Utility.SendAnalytics)
local Constants = require(ParentParent.Resources.Constants)

if CoreGui.RobloxGui:FindFirstChild("Sounds") == nil then
	local Folder = Instance.new("Folder")

	Folder.Name = "Sounds"
	Folder.Parent = CoreGui.RobloxGui
end

local Sound = Instance.new("Sound", CoreGui.RobloxGui.Sounds)

Sound.Name = "VolumeChangeSound"
Sound.Volume = 1
Sound.SoundId = "rbxasset://sounds/uuhhh.mp3"

local v16 = Roact.PureComponent:extend("VolumeEntry")

v16.validateProps = t.strictInterface({
	LayoutOrder = t.integer,
	canCaptureFocus = t.optional(t.boolean),
	isMenuOpen = t.optional(t.boolean),
	buttonRef = t.optional(t.table)
})

function v16.init(p1) -- line: 41
	-- upvalues: UserGameSettings (copy)
	function p1.onVolumeChanged() -- line: 42
		-- upvalues: p1 (copy), UserGameSettings (copy)
		p1:setState({
			volume = math.floor(UserGameSettings.MasterVolume * 10 + 0.5)
		})
	end

	p1.onVolumeChanged()
end
function v16.render(p2) -- line: 51
	-- upvalues: Roact (copy), SliderEntry (copy), FFlagRenameVolumeToMainVolume (copy), UserGameSettings (copy), Sound (copy), SendAnalytics (copy), Constants (copy), ExternalEventConnection (copy), PropertyChangedSignal (copy)
	return Roact.createFragment({
		VolumeSlider = Roact.createElement(SliderEntry, {
			min = 0,
			max = 10,
			stepInterval = 1,
			labelKey = not FFlagRenameVolumeToMainVolume and "CoreScripts.InGameMenu.GameSettings.Volume" or "CoreScripts.InGameMenu.GameSettings.MainVolume",
			LayoutOrder = p2.props.LayoutOrder,
			value = p2.state.volume,
			valueChanged = function(p3) -- line: 62
				-- upvalues: UserGameSettings (copy), Sound (copy), SendAnalytics (copy), Constants (copy)
				UserGameSettings.MasterVolume = p3 / 10
				Sound:Play()
				SendAnalytics(Constants.AnalyticsSettingsChangeName, nil, {}, true)
			end,
			canCaptureFocus = p2.props.canCaptureFocus,
			isMenuOpen = p2.props.isMenuOpen,
			buttonRef = p2.props.buttonRef
		}),
		VolumeListener = Roact.createElement(ExternalEventConnection, {
			event = PropertyChangedSignal,
			callback = p2.onVolumeChanged
		})
	})
end

return v16
