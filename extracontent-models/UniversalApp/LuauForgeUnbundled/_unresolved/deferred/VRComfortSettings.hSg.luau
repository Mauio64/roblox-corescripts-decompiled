local CorePackages = game:GetService("CorePackages")

local UserGameSettings = UserSettings():GetService("UserGameSettings")

local React = require(CorePackages.Packages.React)
local ReactUtils = require(CorePackages.Packages.ReactUtils)
local Foundation = require(CorePackages.Packages.Foundation)
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger
local UIBlox = require(CorePackages.Packages.UIBlox)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useStyle = UIBlox.Core.Style.useStyle
local createNextOrder = ReactUtils.createNextOrder

local module = require("@luauforge/deferred/fGx")
local module2 = require("@luauforge/deferred/hSh")

local divider = Foundation.Divider
local dropdown = Foundation.Dropdown
local inputSize = Foundation.Enums.InputSize
local inputVariant = Foundation.Enums.InputVariant
local orientation = Foundation.Enums.Orientation
local toggle = Foundation.Toggle
local view = Foundation.View

local enumItems = Enum.VRComfortSetting:GetEnumItems()
local enumItems2 = Enum.VRSafetyBubbleMode:GetEnumItems()

local function getComfortSettingFromName(p2)
	for k, enumItem in enumItems do
		if enumItem.Name == p2 then
			return enumItem
		end
	end

	return nil
end

local function getSafetyBubbleModeFromName(p2)
	for k, enumItem in enumItems2 do
		if enumItem.Name == p2 then
			return enumItem
		end
	end

	return nil
end

local function ComfortProfileSetting(p2)
	local v5 = useStyle()
	local v6 = useLocalization({
		profileTitle = "Application.Settings.VR.Comfort.Profile.Title",
		profileDescription = "Application.Settings.VR.Comfort.Profile.Description",
		profileComfortOption = "Application.Settings.VR.Comfort.Profile.Option.Comfort",
		profileDefaultOption = "Application.Settings.VR.Comfort.Profile.Option.Default",
		profileExpertOption = "Application.Settings.VR.Comfort.Profile.Option.Expert",
		profileCustomOption = "Application.Settings.VR.Comfort.Profile.Option.Custom"
	})

	local state, setState = React.useState(UserGameSettings.VRComfortSetting)

	React.useEffect(function()
		local vRComfortSettingChangedConnection = UserGameSettings:GetPropertyChangedSignal("VRComfortSetting"):Connect(function()
			setState(UserGameSettings.VRComfortSetting)
		end)
		return function()
			vRComfortSettingChangedConnection:Disconnect()
		end
	end, {})

	local v7 = React.useCallback(function(p3)
		if p3 == Enum.VRComfortSetting.Comfort then
			return v6.profileComfortOption
		end

		if p3 == Enum.VRComfortSetting.Normal then
			return v6.profileDefaultOption
		end

		if p3 == Enum.VRComfortSetting.Expert then
			return v6.profileExpertOption
		end

		if p3 == Enum.VRComfortSetting.Custom then
			return v6.profileCustomOption
		end

		return ""
	end, { v6 })

	local v8 = React.useCallback(function(p3)
		local v9 = tostring(p3)
		local v10 = nil

		for k, enumItem in enumItems do
			if enumItem.Name == v9 then
				v10 = enumItem
				break
			end
		end

		if not v10 then
			return
		end

		logger:info("[VRComfortSettings] comfort selected: " .. tostring(v10))
		UserGameSettings.VRComfortSetting = v10
		module2.onComfortProfileChanged(v10)
	end, {})

	return React.createElement(module, {
		style = v5,
		header = v6.profileTitle,
		description = v6.profileDescription,
		layoutOrder = p2.LayoutOrder,
		Control = React.createElement(dropdown.Root, {
			label = "",
			placeholder = v7(state),
			onItemChanged = v8,
			size = inputSize.Large,
			variant = inputVariant.Standard,
			width = UDim.new(0, 310),
			value = state.Name,
			items = {
				{
					id = Enum.VRComfortSetting.Comfort.Name,
					text = v6.profileComfortOption
				},
				{
					id = Enum.VRComfortSetting.Normal.Name,
					text = v6.profileDefaultOption
				},
				{
					id = Enum.VRComfortSetting.Expert.Name,
					text = v6.profileExpertOption
				},
				{
					id = Enum.VRComfortSetting.Custom.Name,
					text = v6.profileCustomOption
				}
			}
		})
	})
end

local function VignetteEnabledSetting(p2)
	local v5 = useStyle()
	local v6 = useLocalization({
		vignetteEnabledTitle = "Application.Settings.VR.Comfort.VignetteEnabled.Title",
		vignetteEnabledDescription = "Application.Settings.VR.Comfort.VignetteEnabled.Description"
	})

	local state, setState = React.useState(UserGameSettings.VignetteEnabled)

	React.useEffect(function()
		local vignetteEnabledChangedConnection = UserGameSettings:GetPropertyChangedSignal("VignetteEnabled"):Connect(function()
			setState(UserGameSettings.VignetteEnabled)
		end)
		return function()
			vignetteEnabledChangedConnection:Disconnect()
		end
	end, {})

	local v7 = React.useCallback(function()
		if p2.isDisabled then
			return
		end

		local v8 = not state
		logger:info("[VRComfortSettings] vignette selected: " .. tostring(v8))
		UserGameSettings.VignetteEnabledCustomOption = v8
		module2.onVignetteEnabledChanged(v8)
	end, { p2.isDisabled, state })

	return React.createElement(module, {
		style = v5,
		header = v6.vignetteEnabledTitle,
		description = v6.vignetteEnabledDescription,
		layoutOrder = p2.LayoutOrder,
		Control = React.createElement(toggle, {
			isChecked = state,
			isDisabled = p2.isDisabled,
			onActivated = v7,
			label = "",
			size = inputSize.Large
		})
	})
end

local function SteppedRotationEnabledSetting(p2)
	local v5 = useStyle()
	local v6 = useLocalization({
		steppedRotationEnabledTitle = "Application.Settings.VR.Comfort.SteppedRotationEnabled.Title",
		steppedRotationEnabledDescription = "Application.Settings.VR.Comfort.SteppedRotationEnabled.Description"
	})

	local state, setState = React.useState(not UserGameSettings.VRSmoothRotationEnabled)

	React.useEffect(function()
		local vRSmoothRotationEnabledChangedConnection = UserGameSettings:GetPropertyChangedSignal("VRSmoothRotationEnabled"):Connect(function()
			setState(not UserGameSettings.VRSmoothRotationEnabled)
		end)
		return function()
			vRSmoothRotationEnabledChangedConnection:Disconnect()
		end
	end, {})

	local v7 = React.useCallback(function()
		if p2.isDisabled then
			return
		end

		logger:info("[VRComfortSettings] stepped rotation selected: " .. tostring(not state))
		UserGameSettings.VRSmoothRotationEnabledCustomOption = state
		module2.onSteppedRotationEnabledChanged(not state)
	end, { p2.isDisabled, state })

	return React.createElement(module, {
		style = v5,
		header = v6.steppedRotationEnabledTitle,
		description = v6.steppedRotationEnabledDescription,
		layoutOrder = p2.LayoutOrder,
		Control = React.createElement(toggle, {
			isChecked = state,
			isDisabled = p2.isDisabled,
			onActivated = v7,
			label = "",
			size = inputSize.Large
		})
	})
end

local function ThirdPersonFixedCamEnabledSetting(p2)
	local v5 = useStyle()
	local v6 = useLocalization({
		thirdPersonFixedCamEnabledTitle = "Application.Settings.VR.Comfort.ThirdPersonFixedCamEnabled.Title",
		thirdPersonFixedCamEnabledDescription = "Application.Settings.VR.Comfort.ThirdPersonFixedCamEnabled.Description"
	})

	local state, setState = React.useState(not UserGameSettings.VRThirdPersonFollowCamEnabled)

	React.useEffect(function()
		local vRThirdPersonFollowCamEnabledChangedConnection = UserGameSettings:GetPropertyChangedSignal("VRThirdPersonFollowCamEnabled"):Connect(function()
			setState(not UserGameSettings.VRThirdPersonFollowCamEnabled)
		end)
		return function()
			vRThirdPersonFollowCamEnabledChangedConnection:Disconnect()
		end
	end, {})

	local v7 = React.useCallback(function()
		if p2.isDisabled then
			return
		end

		logger:info("[VRComfortSettings] third person fixed cam selected: " .. tostring(not state))
		UserGameSettings.VRThirdPersonFollowCamEnabledCustomOption = state
		module2.onThirdPersonFixedCamEnabledChanged(not state)
	end, { p2.isDisabled, state })

	return React.createElement(module, {
		style = v5,
		header = v6.thirdPersonFixedCamEnabledTitle,
		description = v6.thirdPersonFixedCamEnabledDescription,
		layoutOrder = p2.LayoutOrder,
		Control = React.createElement(toggle, {
			isChecked = state,
			isDisabled = p2.isDisabled,
			onActivated = v7,
			label = "",
			size = inputSize.Large
		})
	})
end

local function SafetyBubbleModeSetting(p2)
	local v5 = useStyle()
	local v6 = useLocalization({
		safetyBubbleModeTitle = "Application.Settings.VR.Comfort.SafetyBubbleMode.Title",
		safetyBubbleModeDescription = "Application.Settings.VR.Comfort.SafetyBubbleMode.Description",
		safetyBubbleModeNoOneOption = "Application.Settings.VR.Comfort.SafetyBubbleMode.Option.NoOne",
		safetyBubbleModeOnlyFriendsOption = "Application.Settings.VR.Comfort.SafetyBubbleMode.Option.OnlyFriends",
		safetyBubbleModeAnyoneOption = "Application.Settings.VR.Comfort.SafetyBubbleMode.Option.Anyone"
	})

	local state, setState = React.useState(UserGameSettings.VRSafetyBubbleMode)

	React.useEffect(function()
		local vRSafetyBubbleModeChangedConnection = UserGameSettings:GetPropertyChangedSignal("VRSafetyBubbleMode"):Connect(function()
			setState(UserGameSettings.VRSafetyBubbleMode)
		end)
		return function()
			vRSafetyBubbleModeChangedConnection:Disconnect()
		end
	end, {})

	local v7 = React.useCallback(function(p3)
		if p3 == Enum.VRSafetyBubbleMode.NoOne then
			return v6.safetyBubbleModeNoOneOption
		end

		if p3 == Enum.VRSafetyBubbleMode.OnlyFriends then
			return v6.safetyBubbleModeOnlyFriendsOption
		end

		if p3 == Enum.VRSafetyBubbleMode.Anyone then
			return v6.safetyBubbleModeAnyoneOption
		end

		return ""
	end, { v6 })

	local v8 = React.useCallback(function(p3)
		local v9 = tostring(p3)
		local v10 = nil

		for k, enumItem in enumItems2 do
			if enumItem.Name == v9 then
				v10 = enumItem
				break
			end
		end

		if not v10 then
			return
		end

		logger:info("[VRComfortSettings] safety bubble selected: " .. tostring(v10))
		UserGameSettings.VRSafetyBubbleMode = v10
		module2.onSafetyBubbleModeChanged(v10)
	end, {})

	return React.createElement(module, {
		style = v5,
		header = v6.safetyBubbleModeTitle,
		description = v6.safetyBubbleModeDescription,
		layoutOrder = p2.LayoutOrder,
		Control = React.createElement(dropdown.Root, {
			label = "",
			placeholder = v7(state),
			onItemChanged = v8,
			size = inputSize.Large,
			variant = inputVariant.Standard,
			width = UDim.new(0, 310),
			value = state.Name,
			items = {
				{
					id = Enum.VRSafetyBubbleMode.NoOne.Name,
					text = v6.safetyBubbleModeNoOneOption
				},
				{
					id = Enum.VRSafetyBubbleMode.OnlyFriends.Name,
					text = v6.safetyBubbleModeOnlyFriendsOption
				},
				{
					id = Enum.VRSafetyBubbleMode.Anyone.Name,
					text = v6.safetyBubbleModeAnyoneOption
				}
			}
		})
	})
end

local function VRComfortSettings(p2)
	local state, setState = React.useState(UserGameSettings.VRComfortSetting)

	React.useEffect(function()
		local vRComfortSettingChangedConnection = UserGameSettings:GetPropertyChangedSignal("VRComfortSetting"):Connect(function()
			setState(UserGameSettings.VRComfortSetting)
		end)
		return function()
			vRComfortSettingChangedConnection:Disconnect()
		end
	end, {})

	local v5 = state ~= Enum.VRComfortSetting.Custom
	local nextOrder = createNextOrder()

	return React.createElement(
		view,
		{ tag = "col gap-small size-full-0 auto-y", LayoutOrder = p2.LayoutOrder },
		{
			ComfortProfile = React.createElement(ComfortProfileSetting, {
				LayoutOrder = nextOrder()
			}),
			VignetteEnabledDivider = React.createElement(divider, {
				orientation = orientation.Horizontal,
				LayoutOrder = nextOrder()
			}),
			VignetteEnabled = React.createElement(VignetteEnabledSetting, {
				LayoutOrder = nextOrder(),
				isDisabled = v5
			}),
			SteppedRotationEnabledDivider = React.createElement(divider, {
				orientation = orientation.Horizontal,
				LayoutOrder = nextOrder()
			}),
			SteppedRotationEnabled = React.createElement(SteppedRotationEnabledSetting, {
				LayoutOrder = nextOrder(),
				isDisabled = v5
			}),
			ThirdPersonFixedCamEnabledDivider = React.createElement(divider, {
				orientation = orientation.Horizontal,
				LayoutOrder = nextOrder()
			}),
			ThirdPersonFixedCamEnabled = React.createElement(ThirdPersonFixedCamEnabledSetting, {
				LayoutOrder = nextOrder(),
				isDisabled = v5
			}),
			SafetyBubbleModeDivider = React.createElement(divider, {
				orientation = orientation.Horizontal,
				LayoutOrder = nextOrder()
			}),
			SafetyBubbleMode = React.createElement(SafetyBubbleModeSetting, {
				LayoutOrder = nextOrder()
			})
		}
	)
end

return VRComfortSettings
