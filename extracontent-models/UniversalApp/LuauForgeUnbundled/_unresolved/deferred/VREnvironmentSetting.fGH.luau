local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useTokens = Foundation.Hooks.useTokens
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useLocalUserId
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local dropdownMenu = UIBlox.App.Menu.DropdownMenu
local module = require("@luauforge/deferred/fGx")
local module2 = require("@luauforge/bundled/fGI")
local vrEnvironmentSettingEnum = module2.VREnvironmentSettingEnum

local function VREnvironmentSetting(props)
	local v5 = useStyle()
	local v6 = useTokens()
	local v7 = useLocalUserId()
	local udim = UDim.new(0, v6.Size.Size_1200)
	local v8 = useLocalization({
		vrEnvironmentSettingHeading = "Feature.Accessibility.Heading.VREnvironmentSetting",
		vrEnvironmentSettingDescription = "Feature.Accessibility.Description.VREnvironmentSetting",
		vrEnvironmentSettingSystem = "Feature.Accessibility.VREnvironmentSetting.System",
		vrEnvironmentSettingLight = "Feature.Accessibility.VREnvironmentSetting.Light",
		vrEnvironmentSettingDark = "Feature.Accessibility.VREnvironmentSetting.Dark"
	})

	local state, setState = React.useState(function()
		return module2.getCachedEnvironmentSetting(v7)
	end)

	React.useEffect(function()
		setState((module2.getCachedEnvironmentSetting(v7)))
	end, { v7 })
	local v9

	if state == vrEnvironmentSettingEnum.System then
		v9 = v8.vrEnvironmentSettingSystem
	elseif state == vrEnvironmentSettingEnum.Light then
		v9 = v8.vrEnvironmentSettingLight
	else
		v9 = state ~= vrEnvironmentSettingEnum.Dark and "" or v8.vrEnvironmentSettingDark
	end

	local v10 = React.useCallback(function(p2)
		local environmentSettingFromName = module2.getEnvironmentSettingFromName(p2)

		if not environmentSettingFromName then
			error("Invalid VR environment setting: " .. p2)
		end

		setState(environmentSettingFromName)
		module2.setCachedEnvironmentSetting(v7, environmentSettingFromName)

		module2.applyEnvironmentSetting(environmentSettingFromName)
	end, { v7 })

	local createElement = React.createElement
	local v12 = {
		style = v5,
		header = v8.vrEnvironmentSettingHeading,
		description = v8.vrEnvironmentSettingDescription,
		layoutOrder = props.layoutOrder,
		zIndex = props.zIndex,
		topToBottom = not props.isWideView,
		Control = 0
	}
	local createElement2 = React.createElement
	local v15 = if props.isWideView then UDim2.new(0, props.contextualSliderWidth, 0, udim.Offset) else UDim2.new(1, 0, 0, udim.Offset)
	v12.Control = createElement2("Frame", {
		Size = v15,
		BorderSizePixel = 0,
		BackgroundTransparency = 1
	}, {
		React.createElement(dropdownMenu, {
			placeholder = v9,
			onChange = v10,
			height = udim,
			screenSize = props.screenSize,
			errorState = false,
			showDropShadow = false,
			dropdownMenuListPositionFixed = true,
			onMenuOpenChange = props.onMenuOpenChange,
			defaultKey = state,
			cellDatas = {
				{
					key = vrEnvironmentSettingEnum.System,
					text = v8.vrEnvironmentSettingSystem
				},
				{
					key = vrEnvironmentSettingEnum.Light,
					text = v8.vrEnvironmentSettingLight
				},
				{
					key = vrEnvironmentSettingEnum.Dark,
					text = v8.vrEnvironmentSettingDark
				}
			}
		})
	})
	return createElement(module, v12)
end

return VREnvironmentSetting
