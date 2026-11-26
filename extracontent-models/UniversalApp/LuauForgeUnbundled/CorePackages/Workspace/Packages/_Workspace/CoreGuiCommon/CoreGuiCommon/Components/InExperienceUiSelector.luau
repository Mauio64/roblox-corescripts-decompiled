local GamepadService = game:GetService("GamepadService")
local GuiService = game:GetService("GuiService")

local Chrome = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/Chrome")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/Foundation")
local Localization = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/Localization")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/React")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/SignalsReact")

local useLocalization = Localization.Hooks.useLocalization

local focusOnChrome = Chrome.FocusUtils.FocusOnChrome

local fFlagUseSelectModeToggleLabel = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/CoreGuiCommon/Flags").FFlagUseSelectModeToggleLabel

local getUiSelectorSignalStore = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreGuiCommon/CoreGuiCommon/Stores").GetUiSelectorSignalStore

local baseMenu = Foundation.UNSTABLE.BaseMenu
local inputSize = Foundation.Enums.InputSize

local function InExperienceUiSelector(p2)
	local v5 = SignalsReact.useSignalState(getUiSelectorSignalStore)
	local v6 = SignalsReact.useSignalState(v5.getVisibility)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v7 = useLocalization({
		robloxMenu = "CoreScripts.InGameMenu.Controls.RobloxMenu",
		uiNavToggle = fFlagUseSelectModeToggleLabel and "Feature.Accessibility.Menu.SelectModeToggle" or "CoreScripts.InGameMenu.GameSettings.UINavToggle"
	})

	React.useEffect(function()
		if v6 and ref2.current then
			GuiService.SelectedCoreObject = ref2.current
		elseif not v6 then
			GuiService.SelectedCoreObject = nil
		end
	end, { v6 })

	local v8 = React.useMemo(function()
		return {
			{
				id = "RobloxMenu",
				text = v7.robloxMenu,
				ref = ref2,
				onActivated = function()
					v5.setVisibility(false)
					focusOnChrome()
				end
			},
			{
				id = "UiNavigationMode",
				text = v7.uiNavToggle,
				onActivated = function()
					v5.setVisibility(false)
					GuiService.SelectedCoreObject = nil
					local success, result = pcall(function()
						GamepadService:AutoSelectGui()
					end)
				end
			}
		}
	end, { v5, v7 })

	if v6 then
		return (React.createElement(Foundation.View, {
			tag = "position-center-center anchor-center-center auto-xy radius-medium bg-surface-200",
			ref = ref,
			selectionGroup = {
				SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
				SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
				SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
				SelectionBehaviorUp = Enum.SelectionBehavior.Stop
			},
			testId = "in-experience-ui-selector"
		}, {
			Menu = React.createElement(baseMenu.Root, {
				items = v8,
				size = inputSize.Medium,
				radius = Foundation.Enums.Radius.Medium
			})
		}))
	end

	return nil
end

return InExperienceUiSelector
