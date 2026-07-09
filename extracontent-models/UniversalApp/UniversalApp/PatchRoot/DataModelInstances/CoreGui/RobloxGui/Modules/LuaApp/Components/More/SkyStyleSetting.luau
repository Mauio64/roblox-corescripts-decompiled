local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useTokens = Foundation.Hooks.useTokens
local useLocalUserId = require(CorePackages.Workspace.Packages.RobloxAppHooks).useLocalUserId
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local Logger = require(CorePackages.Workspace.Packages.Loggers).Logger
local DropdownMenu = UIBlox.App.Menu.DropdownMenu
local DeviceSettingsPageSetting = require(Modules.LuaApp.Components.More.DeviceSettings.DeviceSettingsPageSetting)
local SkyStyleUtils = require(Modules.LuaApp.Components.More.SkyStyleUtils)
local SkyStyleEnum = SkyStyleUtils.SkyStyleEnum

local function SkyStyleSetting(t1: {[any]: any}) -- line: 26
	-- upvalues: useStyle (copy), useTokens (copy), useLocalUserId (copy), useLocalization (copy), React (copy), SkyStyleUtils (copy), SkyStyleEnum (copy), Logger (copy), DeviceSettingsPageSetting (copy), DropdownMenu (copy)
	local v17 = useStyle()
	local v18 = useTokens()
	local v19 = useLocalUserId()
	local uDim = UDim.new(0, v18.Size.Size_1200)
	local v21 = useLocalization({
		skyStyleHeading = "Feature.Accessibility.Heading.SkyStyle",
		skyStyleDescription = "Feature.Accessibility.Description.SkyStyle",
		skyStyleDay = "Feature.Accessibility.SkyStyle.Day",
		skyStyleNight = "Feature.Accessibility.SkyStyle.Night"
	})
	local v22, v23 = React.useState(function() -- line: 37
		-- upvalues: SkyStyleUtils (copy), v19 (copy)
		return SkyStyleUtils.getCachedSkyStyle(v19)
	end)

	React.useEffect(function() -- line: 41
		-- upvalues: SkyStyleUtils (copy), v19 (copy), v23 (copy)
		local v26 = SkyStyleUtils.getCachedSkyStyle(v19)

		v23(v26)
	end, { v19 })

	local v24 = if v22 ~= SkyStyleEnum.Day then v22 ~= SkyStyleEnum.Night and "" or v21.skyStyleNight else v21.skyStyleDay
	local v25 = React.useCallback(function(s1: string) -- line: 52
		-- upvalues: SkyStyleUtils (copy), Logger (copy), v23 (copy), v19 (copy)
		local v28 = SkyStyleUtils.getSkyStyleFromName(s1)

		if not v28 then
			Logger:warning("[SkyStyleSetting] Invalid sky style: " .. s1)

			return
		end

		Logger:info("[SkyStyleSetting] The user selected sky style: " .. v28)
		v23(v28)
		SkyStyleUtils.setCachedSkyStyle(v19, v28)
		SkyStyleUtils.applySkyStyle(v28)
	end, { v19 })

	return React.createElement(DeviceSettingsPageSetting, {
		style = v17,
		header = v21.skyStyleHeading,
		description = v21.skyStyleDescription,
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
			placeholder = v24,
			onChange = v25,
			height = uDim,
			screenSize = t1.screenSize,
			onMenuOpenChange = t1.onMenuOpenChange,
			defaultKey = v22,
			cellDatas = {
				{
					key = SkyStyleEnum.Day,
					text = v21.skyStyleDay
				},
				{
					key = SkyStyleEnum.Night,
					text = v21.skyStyleNight
				}
			}
		}) })
	})
end

return SkyStyleSetting
