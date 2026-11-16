local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useTokens = Foundation.Hooks.useTokens
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useLocalUserId
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/Loggers").Logger
local dropdownMenu = UIBlox.App.Menu.DropdownMenu
local module = require("@luauforge/deferred/fyH")
local module2 = require("@luauforge/bundled/fzj")
local module3 = require("@luauforge/bundled/fzk")
local skyStyleEnum = module2.SkyStyleEnum

local function SkyStyleSetting(props)
	local v5 = useStyle()
	local v6 = useTokens()
	local v7 = useLocalUserId()
	local udim = UDim.new(0, v6.Size.Size_1200)
	local v8 = useLocalization({
		skyStyleHeading = "Feature.Accessibility.Heading.SkyStyle",
		skyStyleDescription = "Feature.Accessibility.Description.SkyStyle",
		skyStyleDay = "Feature.Accessibility.SkyStyle.Day",
		skyStyleNight = "Feature.Accessibility.SkyStyle.Night"
	})

	local state, setState = React.useState(function()
		return module2.getCachedSkyStyle(v7)
	end)

	React.useEffect(function()
		setState((module2.getCachedSkyStyle(v7)))
	end, { v7 })
	local v9

	if state == skyStyleEnum.Day then
		v9 = v8.skyStyleDay
	else
		v9 = state ~= skyStyleEnum.Night and "" or v8.skyStyleNight
	end

	local v10 = React.useCallback(function(p2)
		local skyStyleFromName = module2.getSkyStyleFromName(p2)

		if skyStyleFromName then
			logger:info("[SkyStyleSetting] The user selected sky style: " .. skyStyleFromName)

			if module3.FFlagEnableSkyStyleTelemetry then
				module3.reportSelected(skyStyleFromName)
			end

			setState(skyStyleFromName)
			module2.setCachedSkyStyle(v7, skyStyleFromName)
			module2.applySkyStyle(skyStyleFromName)
		else
			logger:warning("[SkyStyleSetting] Invalid sky style: " .. p2)

			if module3.FFlagEnableSkyStyleTelemetry then
				module3.reportError("invalidSelection", p2, "settingDropdown")
			end
		end
	end, { v7 })

	local createElement = React.createElement
	local v12 = {
		style = v5,
		header = v8.skyStyleHeading,
		description = v8.skyStyleDescription,
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
				{ key = skyStyleEnum.Day, text = v8.skyStyleDay },
				{ key = skyStyleEnum.Night, text = v8.skyStyleNight }
			}
		})
	})
	return createElement(module, v12)
end

return SkyStyleSetting
