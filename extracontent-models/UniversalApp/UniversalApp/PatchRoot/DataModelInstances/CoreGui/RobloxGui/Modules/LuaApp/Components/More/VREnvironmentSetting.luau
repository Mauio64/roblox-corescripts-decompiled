local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useTokens = Foundation.Hooks.useTokens
local useLocalUserId = require(CorePackages.Workspace.Packages.RobloxAppHooks).useLocalUserId
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local DropdownMenu = UIBlox.App.Menu.DropdownMenu
local DeviceSettingsPageSetting = require(Modules.LuaApp.Components.More.DeviceSettings.DeviceSettingsPageSetting)
local VREnvironmentSettingUtils = require(Modules.LuaApp.Components.More.VREnvironmentSettingUtils)
local VREnvironmentSettingEnum = VREnvironmentSettingUtils.VREnvironmentSettingEnum

local function VREnvironmentSetting(t1: {[any]: any}) -- line: 25
	-- upvalues: useStyle (copy), useTokens (copy), useLocalUserId (copy), useLocalization (copy), React (copy), VREnvironmentSettingUtils (copy), VREnvironmentSettingEnum (copy), DeviceSettingsPageSetting (copy), DropdownMenu (copy)
	local v16 = useStyle()
	local v17 = useTokens()
	local v18 = useLocalUserId()
	local uDim = UDim.new(0, v17.Size.Size_1200)
	local v20 = useLocalization({
		vrEnvironmentSettingHeading = "Feature.Accessibility.Heading.VREnvironmentSetting",
		vrEnvironmentSettingDescription = "Feature.Accessibility.Description.VREnvironmentSetting",
		vrEnvironmentSettingSystem = "Feature.Accessibility.VREnvironmentSetting.System",
		vrEnvironmentSettingLight = "Feature.Accessibility.VREnvironmentSetting.Light",
		vrEnvironmentSettingDark = "Feature.Accessibility.VREnvironmentSetting.Dark"
	})
	local v21, v22 = React.useState(function() -- line: 37
		-- upvalues: VREnvironmentSettingUtils (copy), v18 (copy)
		return VREnvironmentSettingUtils.getCachedEnvironmentSetting(v18)
	end)

	React.useEffect(function() -- line: 41
		-- upvalues: VREnvironmentSettingUtils (copy), v18 (copy), v22 (copy)
		local v25 = VREnvironmentSettingUtils.getCachedEnvironmentSetting(v18)

		v22(v25)
	end, { v18 })

	local v23 = if v21 ~= VREnvironmentSettingEnum.System then if v21 ~= VREnvironmentSettingEnum.Light then v21 ~= VREnvironmentSettingEnum.Dark and "" or v20.vrEnvironmentSettingDark else v20.vrEnvironmentSettingLight else v20.vrEnvironmentSettingSystem
	local v24 = React.useCallback(function(s1: string) -- line: 53
		-- upvalues: VREnvironmentSettingUtils (copy), v22 (copy), v18 (copy)
		local v27 = VREnvironmentSettingUtils.getEnvironmentSettingFromName(s1)

		if not v27 then
			error("Invalid VR environment setting: " .. s1)
		end

		v22(v27)
		VREnvironmentSettingUtils.setCachedEnvironmentSetting(v18, v27)
		VREnvironmentSettingUtils.applyEnvironmentSetting(v27)
	end, { v18 })

	return React.createElement(DeviceSettingsPageSetting, {
		style = v16,
		header = v20.vrEnvironmentSettingHeading,
		description = v20.vrEnvironmentSettingDescription,
		layoutOrder = t1.layoutOrder,
		zIndex = t1.zIndex,
		topToBottom = not t1.isWideView,
		Control = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = if not t1.isWideView then UDim2.new(1, 0, 0, uDim.Offset) else UDim2.new(0, t1.contextualSliderWidth, 0, uDim.Offset)
		}, { React.createElement(DropdownMenu, {
			errorState = false,
			showDropShadow = false,
			dropdownMenuListPositionFixed = true,
			placeholder = v23,
			onChange = v24,
			height = uDim,
			screenSize = t1.screenSize,
			onMenuOpenChange = t1.onMenuOpenChange,
			defaultKey = v21,
			cellDatas = {
				{
					key = VREnvironmentSettingEnum.System,
					text = v20.vrEnvironmentSettingSystem
				},
				{
					key = VREnvironmentSettingEnum.Light,
					text = v20.vrEnvironmentSettingLight
				},
				{
					key = VREnvironmentSettingEnum.Dark,
					text = v20.vrEnvironmentSettingDark
				}
			}
		}) })
	})
end

return VREnvironmentSetting
