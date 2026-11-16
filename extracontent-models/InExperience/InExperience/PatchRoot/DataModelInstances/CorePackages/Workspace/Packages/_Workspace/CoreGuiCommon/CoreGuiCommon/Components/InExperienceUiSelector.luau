local GamepadService = game:GetService("GamepadService")
local GuiService = game:GetService("GuiService")

local CoreGuiCommon = script:FindFirstAncestor("CoreGuiCommon")
local parent = CoreGuiCommon.Parent

local Chrome = require(parent.Chrome)
local Foundation = require(parent.Foundation)
local Localization = require(parent.Localization)
local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)

local useLocalization = Localization.Hooks.useLocalization

local FocusOnChrome = Chrome.FocusUtils.FocusOnChrome

local Stores = require(CoreGuiCommon.Stores)
local GetUiSelectorSignalStore = Stores.GetUiSelectorSignalStore

local BaseMenu = Foundation.UNSTABLE.BaseMenu
local InputSize = Foundation.Enums.InputSize

local function InExperienceUiSelector(_)
	local v = SignalsReact.useSignalState(GetUiSelectorSignalStore)
	local v2 = SignalsReact.useSignalState(v.getVisibility)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local v3 = useLocalization({
		robloxMenu = "CoreScripts.InGameMenu.Controls.RobloxMenu",
		uiNavToggle = "CoreScripts.InGameMenu.GameSettings.UINavToggle"
	})

	React.useEffect(function()
		if v2 and ref2.current then
			GuiService.SelectedCoreObject = ref2.current
		elseif not v2 then
			GuiService.SelectedCoreObject = nil
		end
	end, { v2 })

	local items = React.useMemo(function()
		return {
			{
				id = "RobloxMenu",
				text = v3.robloxMenu,
				ref = ref2,
				onActivated = function()
					v.setVisibility(false)
					FocusOnChrome()
				end
			},
			{
				id = "UiNavigationMode",
				text = v3.uiNavToggle,
				onActivated = function()
					v.setVisibility(false)
					GuiService.SelectedCoreObject = nil
					local _, _ = pcall(function()
						GamepadService:AutoSelectGui()
					end)
				end
			}
		}
	end, { v, v3 })

	if v2 then
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
			Menu = React.createElement(BaseMenu.Root, {
				items = items,
				size = InputSize.Medium,
				radius = Foundation.Enums.Radius.Medium
			})
		}))
	end

	return nil
end

return InExperienceUiSelector
