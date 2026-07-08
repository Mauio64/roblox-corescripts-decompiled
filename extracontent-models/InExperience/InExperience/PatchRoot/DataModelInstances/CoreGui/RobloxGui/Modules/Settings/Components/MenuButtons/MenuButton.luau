local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local Utility = require(RobloxGui.Modules.Settings.Utility)
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local CoreScriptsRoactCommon = require(CorePackages.Workspace.Packages.CoreScriptsRoactCommon)
local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local FoundationText = Foundation.Text
local FoundationImage = Foundation.Image
local PopoverSide = Foundation.Enums.PopoverSide
local Traversal = CoreScriptsRoactCommon.Traversal
local TraversalHistoryMenu = require(RobloxGui.Modules.Settings.Components.Traversal.TraversalHistoryMenu)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAddTraversalHistoryReactMenuButtons = require(RobloxGui.Modules.Settings.Flags.FFlagAddTraversalHistoryReactMenuButtons)
local FIntRelocateMobileMenuButtonsVariant = require(RobloxGui.Modules.Settings.Flags.FIntRelocateMobileMenuButtonsVariant)
local v20 = game:DefineFastFlag("MenuButtonsIncreaseIconSize", false)
local FFlagFixTraversalHistoryMenuFixesV3 = Traversal.Flags.FFlagFixTraversalHistoryMenuFixesV3
local FFlagIEMFocusNavSupportNewButtons = require(RobloxGui.Modules.Settings.Flags.FFlagIEMFocusNavSupportNewButtons)
local FFlagGamepadIconSupportCheck = SharedFlags.FFlagGamepadIconSupportCheck

local function KeyLabelIcon(s1: string?, b1: boolean) -- line: 55
	-- upvalues: useTokens (copy), React (copy), View (copy), FoundationText (copy)
	local v32 = useTokens()
	local createElement = React.createElement
	local v34 = View
	local t1 = {
		LayoutOrder = 1,
		tag = "size-1000-700 row align-x-center align-y-center radius-medium"
	}
	local t2 = {
		Color3 = v32.Color.ActionStandard.Background.Color3
	}
	local v38

	if b1 then
		local BackgroundTransparency = v32.Color.ActionStandard.Background.Transparency

		v38 = BackgroundTransparency + (1 - BackgroundTransparency) * 0.5
	else
		v38 = v32.Color.ActionStandard.Background.Transparency
	end

	t2.Transparency = v38
	t1.backgroundStyle = t2

	local t3 = {}
	local createElement2 = React.createElement
	local v41 = FoundationText
	local t4 = {
		tag = "text-title-small",
		Text = s1
	}
	local t5 = {
		Color3 = v32.Color.ActionStandard.Foreground.Color3
	}
	local v45

	if b1 then
		local ForegroundTransparency = v32.Color.ActionStandard.Foreground.Transparency

		v45 = ForegroundTransparency + (1 - ForegroundTransparency) * 0.5
	else
		v45 = v32.Color.ActionStandard.Foreground.Transparency
	end

	t5.Transparency = v45
	t4.textStyle = t5
	t3.HotkeyText = createElement2(v41, t4)

	return createElement(v34, t1, t3)
end
local function Hint(p1) -- line: 77
	-- upvalues: FIntRelocateMobileMenuButtonsVariant (copy), Utility (copy), Responsive (copy), v20 (copy), React (copy), FoundationImage (copy), KeyLabelIcon (copy)
	if FIntRelocateMobileMenuButtonsVariant == 2 and Utility:IsSmallTouchScreen() then
		return nil
	end

	if p1.lastInput == Responsive.Input.Pointer or p1.lastInput == Responsive.Input.Directional then
		local v47 = v20 and p1.lastInput ~= Responsive.Input.Directional

		return React.createElement(FoundationImage, {
			Image = if p1.lastInput ~= Responsive.Input.Directional then p1.keyboardButtonImageHint else p1.gamepadButtonImageHint,
			imageStyle = {
				Color3 = p1.foregroundStyle.Color3,
				Transparency = if not p1.isDisabled then p1.foregroundStyle.Transparency else 0.5
			},
			tag = {
				["size-700"] = not v47 and p1.isSmall,
				["size-800"] = not v47 and not p1.isSmall,
				["size-900"] = v47 and p1.isSmall,
				["size-1000"] = v47 and not p1.isSmall
			}
		})
	end

	if p1.lastInput == Responsive.Input.Pointer then
		return KeyLabelIcon(p1.keyboardHint, p1.isDisabled)
	end

	if p1.lastInput == Responsive.Input.Directional then
		return React.createElement(FoundationImage, {
			Image = p1.gamepadButtonImageHint,
			imageStyle = {
				Color3 = p1.foregroundStyle.Color3,
				Transparency = if not p1.isDisabled then p1.foregroundStyle.Transparency else 0.5
			},
			tag = {
				["size-600"] = not p1.isSmall,
				["size-500"] = p1.isSmall
			}
		})
	end

	return nil
end
local function ButtonText(p2) -- line: 115
	-- upvalues: React (copy), FoundationText (copy)
	return React.createElement(FoundationText, {
		LayoutOrder = 2,
		Text = p2.text,
		textStyle = {
			Color3 = p2.foregroundStyle.Color3,
			Transparency = if not p2.isDisabled then p2.foregroundStyle.Transparency else 0.5
		},
		tag = {
			["auto-x"] = true,
			["text-title-medium"] = not p2.isSmall,
			["text-title-small"] = p2.isSmall,
			["content-action-standard"] = not p2.isEmphasized,
			["content-action-soft-emphasis"] = p2.isEmphasized
		}
	})
end
local function supportsButton(s2: string, p3) -- line: 150
	-- upvalues: FFlagGamepadIconSupportCheck (copy), Responsive (copy), UserInputService (copy)
	if not FFlagGamepadIconSupportCheck or (not p3 or s2 ~= Responsive.Input.Directional) then
		return true
	end

	return UserInputService:GamepadSupports(UserInputService:GetLastInputType(), p3)
end
local function MenuButton(t6: {[any]: any}) -- line: 157
	-- upvalues: useTokens (copy), FFlagIEMFocusNavSupportNewButtons (copy), FFlagAddTraversalHistoryReactMenuButtons (copy), React (copy), supportsButton (copy), FFlagGamepadIconSupportCheck (copy), UserInputService (copy), v20 (copy), Responsive (copy), View (copy), Hint (copy), ButtonText (copy), FIntRelocateMobileMenuButtonsVariant (copy), Utility (copy), FoundationImage (copy), KeyLabelIcon (copy), FoundationText (copy), TraversalHistoryMenu (copy), FFlagFixTraversalHistoryMenuFixesV3 (copy), PopoverSide (copy)
	local v52 = useTokens()
	local v53 = if not FFlagIEMFocusNavSupportNewButtons then if not FFlagAddTraversalHistoryReactMenuButtons then nil else React.useRef(nil) else t6.buttonRef
	local v54 = if not t6.isEmphasized then v52.Color.ActionStandard.Background else v52.Color.ActionSoftEmphasis.Background
	local v55 = if not t6.isEmphasized then v52.Color.ActionStandard.Foreground else v52.Color.ActionSoftEmphasis.Foreground
	local v56, v57 = React.useState(supportsButton(t6.lastInput, t6.gamepadButton))

	React.useEffect(function() -- line: 167
		-- upvalues: FFlagGamepadIconSupportCheck (copy), t6 (copy), UserInputService (copy), v57 (copy), supportsButton (copy)
		local connection = nil

		if FFlagGamepadIconSupportCheck and t6.gamepadButton then
			connection = UserInputService.LastInputTypeChanged:Connect(function() -- line: 170
				-- upvalues: v57 (copy), supportsButton (copy), t6 (copy)
				v57(supportsButton(t6.lastInput, t6.gamepadButton))
			end)
		end

		return function() -- line: 175
			-- upvalues: connection (ref)
			if connection then
				connection:Disconnect()
			end
		end
	end, {
		t6.gamepadButton,
		t6.lastInput
	})

	local v58 = v20 and t6.lastInput ~= Responsive.Input.Directional
	local createElement = React.createElement
	local v60 = View
	local t7 = {
		onActivated = t6.onActivated,
		isDisabled = t6.isDisabled,
		LayoutOrder = t6.layoutOrder
	}
	local t8 = {
		Color3 = v54.Color3
	}
	local v64

	if t6.isDisabled then
		local Transparency = v54.Transparency

		v64 = Transparency + (1 - Transparency) * 0.5
	else
		v64 = v54.Transparency
	end

	t8.Transparency = v64
	t7.backgroundStyle = t8
	t7.tag = {
		["fill auto-x row align-y-center align-x-center gap-small radius-medium"] = true,
		["size-0-1200"] = not t6.isSmall,
		["size-0-1000"] = t6.isSmall,
		["bg-action-standard"] = not t6.isEmphasized,
		["bg-action-soft-emphasis"] = t6.isEmphasized
	}
	t7.ref = if not FFlagAddTraversalHistoryReactMenuButtons and not FFlagIEMFocusNavSupportNewButtons then nil else v53
	t7.Selectable = not not FFlagIEMFocusNavSupportNewButtons or nil

	return createElement(v60, t7, {
		Button = if not FFlagAddTraversalHistoryReactMenuButtons then nil else React.createElement(View, {
			tag = "auto-xy row align-y-center align-x-center grow gap-small"
		}, {
			Hint = if not not FFlagGamepadIconSupportCheck and not v56 then nil else React.createElement(Hint, {
				lastInput = t6.lastInput,
				gamepadButtonImageHint = t6.gamepadButtonImageHint,
				keyboardButtonImageHint = t6.keyboardButtonImageHint,
				isDisabled = t6.isDisabled,
				foregroundStyle = v55,
				isSmall = t6.isSmall
			}),
			ButtonText = React.createElement(ButtonText, {
				text = t6.text,
				isDisabled = t6.isDisabled,
				foregroundStyle = v55,
				isEmphasized = t6.isEmphasized,
				isSmall = t6.isSmall
			})
		}),
		Hint = if FFlagGamepadIconSupportCheck and not v56 or FFlagAddTraversalHistoryReactMenuButtons then nil else if FIntRelocateMobileMenuButtonsVariant ~= 2 or not Utility:IsSmallTouchScreen() then if t6.lastInput ~= Responsive.Input.Pointer and t6.lastInput ~= Responsive.Input.Directional then if t6.lastInput ~= Responsive.Input.Pointer then if t6.lastInput ~= Responsive.Input.Directional then nil else React.createElement(FoundationImage, {
			Image = t6.gamepadButtonImageHint,
			imageStyle = {
				Color3 = v55.Color3,
				Transparency = if not t6.isDisabled then v55.Transparency else 0.5
			},
			tag = {
				["size-600"] = not t6.isSmall,
				["size-500"] = t6.isSmall
			}
		}) else KeyLabelIcon(t6.keyboardHint, t6.isDisabled) else React.createElement(FoundationImage, {
			Image = if t6.lastInput ~= Responsive.Input.Directional then t6.keyboardButtonImageHint else t6.gamepadButtonImageHint,
			imageStyle = {
				Color3 = v55.Color3,
				Transparency = if not t6.isDisabled then v55.Transparency else 0.5
			},
			tag = {
				["size-700"] = not v58 and t6.isSmall,
				["size-800"] = not v58 and not t6.isSmall,
				["size-900"] = v58 and t6.isSmall,
				["size-1000"] = v58 and not t6.isSmall
			}
		}) else nil,
		ButtonText = if FFlagAddTraversalHistoryReactMenuButtons then nil else React.createElement(FoundationText, {
			LayoutOrder = 2,
			Text = t6.text,
			textStyle = {
				Color3 = v55.Color3,
				Transparency = if not t6.isDisabled then v55.Transparency else 0.5
			},
			tag = {
				["auto-x"] = true,
				["text-title-medium"] = not t6.isSmall,
				["text-title-small"] = t6.isSmall,
				["content-action-standard"] = not t6.isEmphasized,
				["content-action-soft-emphasis"] = t6.isEmphasized
			}
		}),
		TraversalHistoryMenu = if not FFlagAddTraversalHistoryReactMenuButtons or not t6.addTraversalHistoryMenu then nil else React.createElement(TraversalHistoryMenu, {
			idleButtonStateIsDown = true,
			isDarkOnDarkMode = true,
			anchorRef = v53,
			currentPageChangeSignal = t6.currentPageChangeSignal,
			menuSide = if not FFlagFixTraversalHistoryMenuFixesV3 then nil else if not t6.isSmall then PopoverSide.Top else PopoverSide.Bottom
		})
	})
end

return React.memo(MenuButton)
