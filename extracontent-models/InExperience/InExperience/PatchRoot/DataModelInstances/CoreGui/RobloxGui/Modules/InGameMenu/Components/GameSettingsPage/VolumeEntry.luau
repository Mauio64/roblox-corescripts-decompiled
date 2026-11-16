local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t

local UserGameSettings = UserSettings():GetService("UserGameSettings")
local propertyChangedSignal = UserGameSettings:GetPropertyChangedSignal("MasterVolume")

local parent = script.Parent.Parent.Parent

local FFlagRenameVolumeToMainVolume = require(CoreGui.RobloxGui.Modules.Flags.FFlagRenameVolumeToMainVolume)

local ExternalEventConnection = require(parent.Utility.ExternalEventConnection)
local SliderEntry = require(script.Parent.SliderEntry)

local SendAnalytics = require(parent.Utility.SendAnalytics)
local Constants = require(parent.Resources.Constants)

if CoreGui.RobloxGui:FindFirstChild("Sounds") == nil then
	local sounds = Instance.new("Folder")
	sounds.Name = "Sounds"
	sounds.Parent = CoreGui.RobloxGui
end

local volumeChangeSound = Instance.new("Sound", CoreGui.RobloxGui.Sounds)
volumeChangeSound.Name = "VolumeChangeSound"
volumeChangeSound.Volume = 1
volumeChangeSound.SoundId = "rbxasset://sounds/uuhhh.mp3"

local extended = Roact.PureComponent:extend("VolumeEntry")
extended.validateProps = t.strictInterface({
	LayoutOrder = t.integer,
	canCaptureFocus = t.optional(t.boolean),
	isMenuOpen = t.optional(t.boolean),
	buttonRef = t.optional(t.table)
})

function extended:init()
	function self.onVolumeChanged()
		self:setState({
			volume = math.floor(UserGameSettings.MasterVolume * 10 + 0.5)
		})
	end

	self.onVolumeChanged()
end

function extended.render(props)
	return Roact.createFragment({
		VolumeSlider = Roact.createElement(SliderEntry, {
			labelKey = FFlagRenameVolumeToMainVolume and "CoreScripts.InGameMenu.GameSettings.MainVolume" or "CoreScripts.InGameMenu.GameSettings.Volume",
			LayoutOrder = props.props.LayoutOrder,
			min = 0,
			max = 10,
			stepInterval = 1,
			value = props.state.volume,
			valueChanged = function(p)
				UserGameSettings.MasterVolume = p / 10
				volumeChangeSound:Play()
				SendAnalytics(Constants.AnalyticsSettingsChangeName, nil, {}, true)
			end,
			canCaptureFocus = props.props.canCaptureFocus,
			isMenuOpen = props.props.isMenuOpen,
			buttonRef = props.props.buttonRef
		}),
		VolumeListener = Roact.createElement(ExternalEventConnection, {
			event = propertyChangedSignal,
			callback = props.onVolumeChanged
		})
	})
end

return extended
