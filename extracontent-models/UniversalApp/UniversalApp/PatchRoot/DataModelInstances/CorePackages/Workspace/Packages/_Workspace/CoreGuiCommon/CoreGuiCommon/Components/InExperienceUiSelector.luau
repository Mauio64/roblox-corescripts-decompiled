local GamepadService = game:GetService("GamepadService")
local GuiService = game:GetService("GuiService")
local CoreGuiCommon = script:FindFirstAncestor("CoreGuiCommon")
local CoreGuiCommonParent = CoreGuiCommon.Parent
local Chrome = require(CoreGuiCommonParent.Chrome)
local Foundation = require(CoreGuiCommonParent.Foundation)
local Localization = require(CoreGuiCommonParent.Localization)
local React = require(CoreGuiCommonParent.React)
local SignalsReact = require(CoreGuiCommonParent.SignalsReact)
local useLocalization = Localization.Hooks.useLocalization
local FocusOnChrome = Chrome.FocusUtils.FocusOnChrome
local GetUiSelectorSignalStore = require(CoreGuiCommon.Stores).GetUiSelectorSignalStore
local BaseMenu = Foundation.UNSTABLE.BaseMenu
local InputSize = Foundation.Enums.InputSize

local function InExperienceUiSelector(_: {[any]: any}) -- line: 27
	-- upvalues: SignalsReact (copy), GetUiSelectorSignalStore (copy), React (copy), useLocalization (copy), GuiService (copy), FocusOnChrome (copy), GamepadService (copy), Foundation (copy), BaseMenu (copy), InputSize (copy)
	local v17 = SignalsReact.useSignalState(GetUiSelectorSignalStore)
	local v18 = SignalsReact.useSignalState(v17.getVisibility)
	local v19 = React.useRef(nil)
	local v20 = React.useRef(nil)
	local v21 = useLocalization({
		robloxMenu = "CoreScripts.InGameMenu.Controls.RobloxMenu",
		uiNavToggle = "CoreScripts.InGameMenu.GameSettings.UINavToggle"
	})

	React.useEffect(function() -- line: 37
		-- upvalues: v18 (copy), v20 (copy), GuiService (copy)
		if v18 and v20.current then
			GuiService.SelectedCoreObject = v20.current

			return
		end

		if not v18 then
			GuiService.SelectedCoreObject = nil
		end
	end, { v18 })

	local v22 = React.useMemo(function() -- line: 45
		-- upvalues: v21 (copy), v20 (copy), v17 (copy), FocusOnChrome (copy), GuiService (copy), GamepadService (copy)
		return {
			{
				id = "RobloxMenu",
				text = v21.robloxMenu,
				ref = v20,
				onActivated = function() -- line: 51
					-- upvalues: v17 (copy), FocusOnChrome (copy)
					v17.setVisibility(false)
					FocusOnChrome()
				end
			},
			{
				id = "UiNavigationMode",
				text = v21.uiNavToggle,
				onActivated = function() -- line: 59
					-- upvalues: v17 (copy), GuiService (copy), GamepadService (copy)
					v17.setVisibility(false)
					GuiService.SelectedCoreObject = nil

					local _, _ = pcall(function() -- line: 62
						-- upvalues: GamepadService (copy)
						GamepadService:AutoSelectGui()
					end)
				end
			}
		}
	end, {
		v17,
		v21
	})

	if v18 then
		return (React.createElement(Foundation.View, {
			tag = "position-center-center anchor-center-center auto-xy radius-medium bg-surface-200",
			testId = "in-experience-ui-selector",
			ref = v19,
			selectionGroup = {
				SelectionBehaviorDown = Enum.SelectionBehavior.Stop,
				SelectionBehaviorLeft = Enum.SelectionBehavior.Stop,
				SelectionBehaviorRight = Enum.SelectionBehavior.Stop,
				SelectionBehaviorUp = Enum.SelectionBehavior.Stop
			}
		}, {
			Menu = React.createElement(BaseMenu.Root, {
				items = v22,
				size = InputSize.Medium,
				radius = Foundation.Enums.Radius.Medium
			})
		}))
	end

	return nil
end

return InExperienceUiSelector
