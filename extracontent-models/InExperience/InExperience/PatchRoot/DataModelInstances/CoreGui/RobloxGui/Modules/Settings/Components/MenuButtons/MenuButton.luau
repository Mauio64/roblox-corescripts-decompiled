local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local RobloxGui = CoreGui:WaitForChild("RobloxGui")

local Utility = require(RobloxGui.Modules.Settings.Utility)
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local Responsive = require(CorePackages.Workspace.Packages.Responsive)

local useTokens = Foundation.Hooks.useTokens
local View = Foundation.View
local Text = Foundation.Text
local Image = Foundation.Image
local PopoverSide = Foundation.Enums.PopoverSide

local TraversalHistoryMenu = require(RobloxGui.Modules.Settings.Components.Traversal.TraversalHistoryMenu)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAddTraversalHistoryReactMenuButtons = require(RobloxGui.Modules.Settings.Flags.FFlagAddTraversalHistoryReactMenuButtons)
local FIntRelocateMobileMenuButtonsVariant = require(RobloxGui.Modules.Settings.Flags.FIntRelocateMobileMenuButtonsVariant)
local defineFastFlag = game:DefineFastFlag("MenuButtonsIncreaseIconSize", false)
local FFlagIEMFocusNavSupportNewButtons = require(RobloxGui.Modules.Settings.Flags.FFlagIEMFocusNavSupportNewButtons)
local FFlagGamepadIconSupportCheck = SharedFlags.FFlagGamepadIconSupportCheck

local function fn(transparency: number) -- 3 equivalent calls inferred from this helper
	return transparency + (1 - transparency) * 0.5
end

local function KeyLabelIcon(keyboardHint: string?, isDisabled: boolean)
	local v = useTokens()

	local createElement = React.createElement

	local backgroundStyle = { Color3 = v.Color.ActionStandard.Background.Color3, Transparency = 0 }
	local transparency

	if isDisabled then
		transparency = fn(v.Color.ActionStandard.Background.Transparency) -- inferred equivalent call
	else
		transparency = v.Color.ActionStandard.Background.Transparency
	end

	backgroundStyle.Transparency = transparency

	local createElement2 = React.createElement

	local textStyle = { Color3 = v.Color.ActionStandard.Foreground.Color3, Transparency = 0 }
	local transparency2

	if isDisabled then
		transparency2 = fn(v.Color.ActionStandard.Foreground.Transparency) -- inferred equivalent call
	else
		transparency2 = v.Color.ActionStandard.Foreground.Transparency
	end

	textStyle.Transparency = transparency2
	return createElement(
		View,
		{
			LayoutOrder = 1,
			backgroundStyle = backgroundStyle,
			tag = "size-1000-700 row align-x-center align-y-center radius-medium"
		},
		{
			HotkeyText = createElement2(Text, {
				Text = keyboardHint,
				textStyle = textStyle,
				tag = "text-title-small"
			})
		}
	)
end

local function Hint(props)
	if FIntRelocateMobileMenuButtonsVariant == 2 and Utility:IsSmallTouchScreen() then
		return nil
	end

	if props.lastInput == Responsive.Input.Pointer or props.lastInput == Responsive.Input.Directional then
		local v = defineFastFlag and props.lastInput ~= Responsive.Input.Directional

		local createElement = React.createElement
		local image

		if props.lastInput == Responsive.Input.Directional then
			image = props.gamepadButtonImageHint
		else
			image = props.keyboardButtonImageHint
		end

		return createElement(Image, {
			Image = image,
			imageStyle = {
				Color3 = props.foregroundStyle.Color3,
				Transparency = props.isDisabled and 0.5 or props.foregroundStyle.Transparency
			},
			tag = {
				["size-700"] = not v and props.isSmall,
				["size-800"] = not (v or props.isSmall),
				["size-900"] = v and props.isSmall,
				["size-1000"] = v and not props.isSmall
			}
		})
	end

	if props.lastInput == Responsive.Input.Pointer then
		return KeyLabelIcon(props.keyboardHint, props.isDisabled)
	end

	if props.lastInput == Responsive.Input.Directional then
		return React.createElement(Image, {
			Image = props.gamepadButtonImageHint,
			imageStyle = {
				Color3 = props.foregroundStyle.Color3,
				Transparency = props.isDisabled and 0.5 or props.foregroundStyle.Transparency
			},
			tag = {
				["size-600"] = not props.isSmall,
				["size-500"] = props.isSmall
			}
		})
	end

	return nil
end

local function ButtonText(props)
	return React.createElement(Text, {
		Text = props.text,
		LayoutOrder = 2,
		textStyle = {
			Color3 = props.foregroundStyle.Color3,
			Transparency = props.isDisabled and 0.5 or props.foregroundStyle.Transparency
		},
		tag = {
			["auto-x"] = true,
			["text-title-medium"] = not props.isSmall,
			["text-title-small"] = props.isSmall,
			["content-action-standard"] = not props.isEmphasized,
			["content-action-soft-emphasis"] = props.isEmphasized
		}
	})
end

local function supportsButton(lastInput: string, gamepadButton)
	if FFlagGamepadIconSupportCheck and gamepadButton and lastInput == Responsive.Input.Directional then
		return UserInputService:GamepadSupports(UserInputService:GetLastInputType(), gamepadButton)
	end

	return true
end

local function MenuButton(props)
	local v = useTokens()
	local anchorRef

	if FFlagIEMFocusNavSupportNewButtons then
		anchorRef = props.buttonRef
	elseif FFlagAddTraversalHistoryReactMenuButtons then
		anchorRef = React.useRef(nil)
	end

	local background

	if props.isEmphasized then
		background = v.Color.ActionSoftEmphasis.Background
	else
		background = v.Color.ActionStandard.Background
	end

	local foreground

	if props.isEmphasized then
		foreground = v.Color.ActionSoftEmphasis.Foreground
	else
		foreground = v.Color.ActionStandard.Foreground
	end

	local state, setState = React.useState(supportsButton(props.lastInput, props.gamepadButton))

	React.useEffect(function()
		local lastInputTypeChangedConnection

		if FFlagGamepadIconSupportCheck and props.gamepadButton then
			lastInputTypeChangedConnection = UserInputService.LastInputTypeChanged:Connect(function()
				setState(supportsButton(props.lastInput, props.gamepadButton))
			end)
		else
			lastInputTypeChangedConnection = nil
		end

		return function()
			if lastInputTypeChangedConnection then
				lastInputTypeChangedConnection:Disconnect()
			end
		end
	end, { props.gamepadButton, props.lastInput })

	local v2 = defineFastFlag and props.lastInput ~= Responsive.Input.Directional

	local createElement = React.createElement
	local v3 = {
		onActivated = props.onActivated,
		isDisabled = props.isDisabled,
		LayoutOrder = props.layoutOrder,
		backgroundStyle = 0,
		tag = 0,
		ref = 0,
		Selectable = 0
	}
	local backgroundStyle = { Color3 = background.Color3, Transparency = 0 }
	local transparency

	if props.isDisabled then
		transparency = fn(background.Transparency) -- inferred equivalent call
	else
		transparency = background.Transparency
	end

	backgroundStyle.Transparency = transparency
	v3.backgroundStyle = backgroundStyle

	v3.tag = {
		["fill auto-x row align-y-center align-x-center gap-small radius-medium"] = true,
		["size-0-1200"] = not props.isSmall,
		["size-0-1000"] = props.isSmall,
		["bg-action-standard"] = not props.isEmphasized,
		["bg-action-soft-emphasis"] = props.isEmphasized
	}
	local ref

	if FFlagAddTraversalHistoryReactMenuButtons or FFlagIEMFocusNavSupportNewButtons then
		ref = anchorRef
	end

	v3.ref = ref
	v3.Selectable = FFlagIEMFocusNavSupportNewButtons and true or nil
	local button

	if FFlagAddTraversalHistoryReactMenuButtons then
		local createElement2 = React.createElement
		local hint

		if not (FFlagGamepadIconSupportCheck and not state) then
			hint = React.createElement(Hint, {
				lastInput = props.lastInput,
				gamepadButtonImageHint = props.gamepadButtonImageHint,
				keyboardButtonImageHint = props.keyboardButtonImageHint,
				isDisabled = props.isDisabled,
				foregroundStyle = foreground,
				isSmall = props.isSmall
			})
		end

		button = createElement2(View, {
			tag = "auto-xy row align-y-center align-x-center grow gap-small"
		}, {
			Hint = hint,
			ButtonText = React.createElement(ButtonText, {
				text = props.text,
				isDisabled = props.isDisabled,
				foregroundStyle = foreground,
				isEmphasized = props.isEmphasized,
				isSmall = props.isSmall
			})
		})
	end

	local hint

	if not (FFlagGamepadIconSupportCheck and not state or FFlagAddTraversalHistoryReactMenuButtons or FIntRelocateMobileMenuButtonsVariant == 2 and Utility:IsSmallTouchScreen()) then
		if props.lastInput == Responsive.Input.Pointer or props.lastInput == Responsive.Input.Directional then
			local createElement2 = React.createElement
			local image

			if props.lastInput == Responsive.Input.Directional then
				image = props.gamepadButtonImageHint
			else
				image = props.keyboardButtonImageHint
			end

			hint = createElement2(Image, {
				Image = image,
				imageStyle = {
					Color3 = foreground.Color3,
					Transparency = props.isDisabled and 0.5 or foreground.Transparency
				},
				tag = {
					["size-700"] = not v2 and props.isSmall,
					["size-800"] = not (v2 or props.isSmall),
					["size-900"] = v2 and props.isSmall,
					["size-1000"] = v2 and not props.isSmall
				}
			})
		elseif props.lastInput == Responsive.Input.Pointer then
			hint = KeyLabelIcon(props.keyboardHint, props.isDisabled)
		elseif props.lastInput == Responsive.Input.Directional then
			hint = React.createElement(Image, {
				Image = props.gamepadButtonImageHint,
				imageStyle = {
					Color3 = foreground.Color3,
					Transparency = props.isDisabled and 0.5 or foreground.Transparency
				},
				tag = {
					["size-600"] = not props.isSmall,
					["size-500"] = props.isSmall
				}
			})
		end
	end

	local buttonText

	if not FFlagAddTraversalHistoryReactMenuButtons then
		buttonText = React.createElement(Text, {
			Text = props.text,
			LayoutOrder = 2,
			textStyle = {
				Color3 = foreground.Color3,
				Transparency = props.isDisabled and 0.5 or foreground.Transparency
			},
			tag = {
				["auto-x"] = true,
				["text-title-medium"] = not props.isSmall,
				["text-title-small"] = props.isSmall,
				["content-action-standard"] = not props.isEmphasized,
				["content-action-soft-emphasis"] = props.isEmphasized
			}
		})
	end

	local traversalHistoryMenu

	if FFlagAddTraversalHistoryReactMenuButtons and props.addTraversalHistoryMenu then
		local createElement2 = React.createElement
		local v4 = {
			anchorRef = anchorRef,
			idleButtonStateIsDown = true,
			currentPageChangeSignal = props.currentPageChangeSignal,
			isDarkOnDarkMode = true,
			menuSide = 0
		}
		local menuSide

		if props.isSmall then
			menuSide = PopoverSide.Bottom
		else
			menuSide = PopoverSide.Top
		end

		v4.menuSide = menuSide
		traversalHistoryMenu = createElement2(TraversalHistoryMenu, v4)
	end

	return createElement(View, v3, {
		Button = button,
		Hint = hint,
		ButtonText = buttonText,
		TraversalHistoryMenu = traversalHistoryMenu
	})
end

return React.memo(MenuButton)
