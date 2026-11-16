local module = require("@luauforge/bundled/hRF")
require("@luauforge/bundled/hSt")
local module2 = require("@luauforge/bundled/hSe")

local focusNavigationEventNameEnum = require("@luauforge/bundled/hSu").FocusNavigationEventNameEnum
local module3 = require("@luauforge/bundled/hSv")

local splitPaneStore = require("@luauforge/bundled/hSi").SplitPaneStore
local supportPaneMode = require("@luauforge/bundled/hSj").Enums.SupportPaneMode

local module4 = require("@luauforge/bundled/hSp")

return function()
	local store = splitPaneStore.getStore()
	local v5 = module2.useSignalState(store.getSupportPaneMode)
	local v6 = module2.useSignalState(store.getIsSplitEnabled)
	local v7 = module4(false)
	local v8 = module2.useSignalState(v7.getRegistration) ~= nil

	return {
		eventMap = module.useMemo(function()
			if not v6 then
				return {}
			end

			if v5 == supportPaneMode.Collapsed then
				return {
					[Enum.KeyCode.ButtonR3] = focusNavigationEventNameEnum.ExpandAvatar
				}
			else
				if not v8 then
					return {}
				end

				local v9 = {
					[Enum.KeyCode.ButtonL2] = focusNavigationEventNameEnum.SwitchOutfitPrevious,
					[Enum.KeyCode.ButtonR2] = focusNavigationEventNameEnum.SwitchOutfitNext
				}

				if v5 == supportPaneMode.Normal then
					v9[Enum.KeyCode.ButtonR3] = focusNavigationEventNameEnum.CollapseAvatar
				end

				return v9
			end
		end, { v5, v6, v8 }),
		eventHandlers = module.useMemo(function()
			local v9 = {}
			v9[focusNavigationEventNameEnum.SwitchOutfitPrevious] = {
				handler = module3.onRelease(function()
					local registration = v7.getRegistration(false)
					local v10 = if registration ~= nil then registration.getBindings() else nil

					if v10 ~= nil and v10.showLeftChevron and not v10.isSwitchingOutfit then
						v10.onLeftChevronActivated()
					end
				end)
			}

			v9[focusNavigationEventNameEnum.SwitchOutfitNext] = {
				handler = module3.onRelease(function()
					local registration = v7.getRegistration(false)
					local v10 = if registration ~= nil then registration.getBindings() else nil

					if v10 ~= nil and not v10.isSwitchingOutfit then
						v10.onRightChevronActivated()
					end
				end)
			}

			if v5 == supportPaneMode.Normal then
				v9[focusNavigationEventNameEnum.CollapseAvatar] = {
					handler = module3.onRelease(function()
						store.toggleSupportPaneMode(supportPaneMode.Collapsed)
					end)
				}
				return v9
			end

			if v5 == supportPaneMode.Collapsed then
				v9[focusNavigationEventNameEnum.ExpandAvatar] = {
					handler = module3.onRelease(function()
						store.toggleSupportPaneMode(supportPaneMode.Normal)
					end)
				}
			end

			return v9
		end, { v5, v7, store })
	}
end
