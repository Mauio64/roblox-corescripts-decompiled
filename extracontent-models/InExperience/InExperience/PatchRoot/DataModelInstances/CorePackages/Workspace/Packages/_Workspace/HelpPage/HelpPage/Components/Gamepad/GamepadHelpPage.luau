local parent = script.Parent.Parent.Parent
local parent2 = parent.Parent
local UserInputService = game:GetService("UserInputService")

local React = require(parent2.React)
local Foundation = require(parent2.Foundation)
local Display = require(parent2.Display)
require(parent.Configs.ConfigTypes)
require(parent.Components.Common.ActionText)
local GamepadList = require(parent.Components.Gamepad.GamepadList)
local DiagramLayoutView = require(parent.Components.Common.DiagramLayoutView)
local Constants = require(parent.Constants)
local useKeybinds = require(parent.Hooks.useKeybinds)
local SignalsReact = require(parent2.SignalsReact)
local RobloxAppHooks = require(parent2.RobloxAppHooks)
local RobloxAppEnums = require(parent2.RobloxAppEnums)
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation
local DeviceOrientationMode = RobloxAppEnums.DeviceOrientationMode

local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local FFlagHelpPageCCL = require(parent.Flags.FFlagHelpPageCCL)

local function getGamepadInput(p, flag: boolean, p2)
	local gamepadInput = p.gamepadInput

	if gamepadInput == nil then
		return nil
	end

	local v

	if FFlagHelpPageCCL and flag and gamepadInput.spatialGamepadInput ~= nil then
		v = gamepadInput.spatialGamepadInput
	else
		v = gamepadInput.input
	end

	if v ~= nil then
		return v
	end

	if flag then
		return gamepadInput.spatialGamepadInput
	end

	if Constants.HELP_PAGE.GAMEPAD_PLAYSTATION_PLATFORMS[p2] then
		return gamepadInput.playstationInput
	end

	return gamepadInput.xboxInput
end

local function getAbilitySlot(value: string) -- 1 equivalent call inferred from this helper
	return (tonumber(string.match(value, "^AbilityAction(%d+)$")))
end

local function getResolvedControls(controls, isSpatial: boolean, p)
	local resolvedControls = {}

	local function addControl(data)
		local v = isSpatial
		local gamepadInput = data.gamepadInput
		local v2

		if gamepadInput ~= nil then
			if FFlagHelpPageCCL and v and gamepadInput.spatialGamepadInput ~= nil then
				v2 = gamepadInput.spatialGamepadInput
			else
				v2 = gamepadInput.input
			end

			if v2 == nil then
				if v then
					v2 = gamepadInput.spatialGamepadInput
				elseif Constants.HELP_PAGE.GAMEPAD_PLAYSTATION_PLATFORMS[p] then
					v2 = gamepadInput.playstationInput
				else
					v2 = gamepadInput.xboxInput
				end
			end
		end

		if v2 == nil then
			return
		end

		for _, v3 in ipairs(v2) do
			if not (not isSpatial or Constants.HELP_PAGE.GAMEPAD_ICON_MAP_SPATIAL[v3] ~= nil) then
				continue
			end

			local input = { v3 }
			local v4 = tostring(v3)
			local resolvedControl = resolvedControls[v4]

			if resolvedControl == nil then
				resolvedControls[v4] = {
					label = data.label,
					gamepadInput = { input = input },
					actionLabels = {
						{ label = data.label, disabled = data.disabled }
					}
				}
			else
				table.insert(resolvedControl.actionLabels, {
					label = data.label,
					disabled = data.disabled
				})
			end
		end
	end

	local v = {}

	for k, item in controls do
		local abilitySlot = getAbilitySlot(k) -- inferred equivalent call

		if abilitySlot == nil then
			addControl(item)
		else
			v[abilitySlot] = item
		end
	end

	local v2 = {}

	for k in v do
		table.insert(v2, k)
	end

	table.sort(v2)

	for _, v3 in ipairs(v2) do
		addControl(v[v3])
	end

	return resolvedControls
end

local function GamepadHelpPage(p)
	local platform

	if p.getPlatform then
		platform = p.getPlatform()
	else
		platform = UserInputService:GetPlatform()
	end

	local v = useDeviceOrientation()
	local controls = useKeybinds().controls
	local v2 = useTokens()
	local state, setState = React.useState(1e999)
	local state2, setState2 = React.useState(nil)
	local state3, setState3 = React.useState(nil)
	local v3 = SignalsReact.useSignalState(Display.GetDisplayStore)
	local v4 = SignalsReact.useSignalState(v3.getViewportSize)
	local v5 = not p.isSpatial

	if v5 then
		if
			v4.X < Constants.HELP_PAGE.TOUCH_OFFSETS.SMALL_SCREEN_CUTOFF_X
			or v4.Y < Constants.HELP_PAGE.TOUCH_OFFSETS.SMALL_SCREEN_CUTOFF_Y
		then
			v5 = v == DeviceOrientationMode.Portrait
		else
			v5 = false
		end
	end

	local controls2, controls3, controls4 = React.useMemo(function()
		local result = {}
		local controls2 = {}
		local result2 = {}

		if FFlagHelpPageCCL then
			for k, v6 in pairs(getResolvedControls(controls, p.isSpatial, platform)) do
				local input = v6.gamepadInput.input

				if not (input ~= nil and #input > 0) then
					continue
				end

				if Constants.HELP_PAGE.GAMEPAD_LAYOUT_ORDER[input[1]] <= Constants.HELP_PAGE.GAMEPAD_CUTOFFS.LEFT_COL then
					result[k] = v6
				else
					result2[k] = v6
				end
			end
		else
			for k, control in controls do
				if control.gamepadInput == nil then
					continue
				end

				local gamepadInput = control.gamepadInput
				local v6 = gamepadInput.input

				if v6 == nil then
					if p.isSpatial then
						v6 = gamepadInput.spatialGamepadInput
					elseif Constants.HELP_PAGE.GAMEPAD_PLAYSTATION_PLATFORMS[platform] then
						v6 = gamepadInput.playstationInput
					else
						v6 = gamepadInput.xboxInput
					end
				end

				if not (v6 ~= nil and #v6 > 0) then
					continue
				end

				local v7 = Constants.HELP_PAGE.GAMEPAD_LAYOUT_ORDER[v6[1]]

				if v7 <= Constants.HELP_PAGE.GAMEPAD_CUTOFFS.LEFT_COL then
					result[k] = control
				elseif
					v7 <= Constants.HELP_PAGE.GAMEPAD_CUTOFFS.BOTTOM_RIGHT_COL
					and Constants.HELP_PAGE.GAMEPAD_PLAYSTATION_PLATFORMS[platform]
				then
					controls2[k] = control
				else
					result2[k] = control
				end
			end
		end

		return result, controls2, result2
	end, FFlagHelpPageCCL and { controls, platform, p.isSpatial } or { controls })

	local element = React.createElement("ImageLabel", {
		Name = "GamepadImage",
		Size = UDim2.fromScale(1, 1),
		ScaleType = Enum.ScaleType.Fit,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Image = p.isSpatial and "rbxasset://textures/ui/Gamepad/VRController.png" or "rbxasset://textures/ui/Gamepad/Controller@3x.png",
		BackgroundTransparency = 1
	})

	local v6 = React.useMemo(function()
		if
			p.isSpatial
			or not (v4.X < Constants.HELP_PAGE.TOUCH_OFFSETS.SMALL_SCREEN_CUTOFF_X or v4.Y < Constants.HELP_PAGE.GAMEPAD_SIZES.NO_PADDING_CUTOFF_Y)
		then
			return UDim.new(0, v2.Size.Size_2400)
		end

		return UDim.new(0, 0)
	end, FFlagHelpPageCCL and { v4, p.isSpatial, v2.Size.Size_2400 } or { v4 })

	local useMemo = React.useMemo
	local function fn()
		if p.isSpatial and not FFlagHelpPageCCL then
			return
				Vector2.new(1, 0.5),
				UDim2.new(
					Constants.HELP_PAGE.GAMEPAD_SIZES.LEFT_COL_SCALE,
					0,
					0,
					state * Constants.HELP_PAGE.GAMEPAD_SIZES.IMAGE_MULTIPLIER_VR * 0.5 / Constants.HELP_PAGE.GAMEPAD_SIZES.IMAGE_ASPECT_RATIO
				),
				Vector2.new(0, 0.5),
				UDim2.new(
					Constants.HELP_PAGE.GAMEPAD_SIZES.RIGHT_COL_SCALE_VR,
					0,
					0,
					state * Constants.HELP_PAGE.GAMEPAD_SIZES.IMAGE_MULTIPLIER_VR * 0.5 / Constants.HELP_PAGE.GAMEPAD_SIZES.IMAGE_ASPECT_RATIO
				),
				Constants.HELP_PAGE.GAMEPAD_SIZES.COL_SCALE_VR,
				Constants.HELP_PAGE.GAMEPAD_SIZES.IMAGE_MULTIPLIER_VR
		end

		if v5 then
			return
				Vector2.new(0, 0),
				UDim2.fromOffset(
					0,
					state * Constants.HELP_PAGE.GAMEPAD_SIZES.IMAGE_MULTIPLIER_PORTRAIT / Constants.HELP_PAGE.GAMEPAD_SIZES.IMAGE_ASPECT_RATIO
				),
				Vector2.new(1, 0),
				UDim2.new(
					1,
					0,
					0,
					state * Constants.HELP_PAGE.GAMEPAD_SIZES.IMAGE_MULTIPLIER_PORTRAIT / Constants.HELP_PAGE.GAMEPAD_SIZES.IMAGE_ASPECT_RATIO
				),
				Constants.HELP_PAGE.GAMEPAD_SIZES.COL_SCALE_PORTRAIT,
				Constants.HELP_PAGE.GAMEPAD_SIZES.IMAGE_MULTIPLIER_PORTRAIT
		end

		local v7 = state * Constants.HELP_PAGE.GAMEPAD_SIZES.LEFT_COL_SCALE
		local v8 = state * (1 - Constants.HELP_PAGE.GAMEPAD_SIZES.RIGHT_COL_SCALE)

		local v9 = (state2 == nil or state3 == nil or not (state2.X > 0 and state3.X > 0 and (v7 < state2.X or v8 < state3.X)))
			and 1
			or math.min(v7 / state2.X, v8 / state3.X)

		return
			Vector2.new(1, 0),
			UDim2.fromScale(Constants.HELP_PAGE.GAMEPAD_SIZES.LEFT_COL_SCALE, 0),
			Vector2.new(0, 0),
			UDim2.fromScale(Constants.HELP_PAGE.GAMEPAD_SIZES.RIGHT_COL_SCALE, 0),
			v9,
			Constants.HELP_PAGE.GAMEPAD_SIZES.IMAGE_MULTIPLIER_DEFAULT
	end

	local v7

	if FFlagHelpPageCCL then
		v7 = { state, p.isSpatial, v5, state2, state3 }
	else
		v7 = { v4, state, p.isSpatial }
	end

	local v8, v9, v10, v11, v12, v13 = useMemo(fn, v7)
	local columnWidth

	if FFlagHelpPageCCL and v5 then
		columnWidth = Constants.HELP_PAGE.GAMEPAD_SIZES.COL_SIZE_PORTRAIT
	elseif FFlagHelpPageCCL then
		columnWidth = Constants.HELP_PAGE.GAMEPAD_SIZES.COL_SIZE
	end

	if FFlagHelpPageCCL then
		return React.createElement(DiagramLayoutView, {
			layout = {
				leftAnchor = v8,
				leftPosition = v9,
				rightAnchor = v10,
				rightPosition = v11,
				columnWidth = columnWidth,
				columnTopPadding = UDim.new(0, v2.Padding.Large),
				columnScale = v12,
				diagramSize = Vector2.new(
					state * v13,
					state * v13 / Constants.HELP_PAGE.GAMEPAD_SIZES.IMAGE_ASPECT_RATIO
				),
				diagramOffsetY = nil,
				topPadding = v6,
				bottomPadding = nil
			},
			left = React.createElement(GamepadList, {
				controls = controls2,
				layoutOrderReversed = false,
				addBlankIcon = false,
				isSpatial = p.isSpatial,
				platform = platform
			}),
			right = React.createElement(GamepadList, {
				controls = controls4,
				layoutOrderReversed = true,
				addBlankIcon = false,
				isSpatial = p.isSpatial,
				platform = platform
			}),
			diagram = element,
			testId = "Gamepad",
			diagramTestId = "VRGamepadInstructions",
			onSizeChanged = function(p2)
				setState(p2.AbsoluteSize.X)
			end,
			onLeftSizeChanged = function(p2)
				if state2 == nil then
					setState2(p2.AbsoluteSize)
				end
			end,
			onRightSizeChanged = function(p2)
				if state3 == nil then
					setState3(p2.AbsoluteSize)
				end
			end
		})
	end

	return React.createElement(View, {
		tag = "size-full-0 auto-y",
		padding = { top = v6 },
		onAbsoluteSizeChanged = function(p2)
			setState(p2.AbsoluteSize.X)
		end
	}, {
		LeftColContainer = React.createElement(View, {
			tag = "auto-xy padding-top-large",
			AnchorPoint = v8,
			Position = v9,
			scale = v12,
			onAbsoluteSizeChanged = function(p2)
				if state2 == nil then
					setState2(p2.AbsoluteSize)
				end
			end
		}, {
			LeftCol = React.createElement(GamepadList, {
				controls = controls2,
				layoutOrderReversed = false,
				addBlankIcon = false,
				isSpatial = p.isSpatial,
				platform = platform
			})
		}),
		ImageComponentContainer = React.createElement(View, {
			Position = UDim2.fromScale(0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.fromOffset(state * v13, state * v13 / Constants.HELP_PAGE.GAMEPAD_SIZES.IMAGE_ASPECT_RATIO),
			testId = "VRGamepadInstructions"
		}, { ImageComponent = element }),
		RightColContainer = React.createElement(View, {
			tag = "auto-xy padding-top-large",
			AnchorPoint = v10,
			Position = v11,
			scale = v12,
			onAbsoluteSizeChanged = function(p2)
				if state3 == nil then
					setState3(p2.AbsoluteSize)
				end
			end
		}, {
			RightCol = React.createElement(View, { tag = "col auto-xy" }, {
				TopRightColContainer = React.createElement(View, {
					tag = "auto-xy",
					LayoutOrder = 1
				}, {
					TopRightCol = React.createElement(GamepadList, {
						controls = controls4,
						layoutOrderReversed = true,
						addBlankIcon = false,
						isSpatial = p.isSpatial,
						platform = platform
					})
				}),
				BottomRightColContainer = React.createElement(View, {
					tag = "auto-xy",
					LayoutOrder = 2
				}, {
					BottomRightCol = React.createElement(GamepadList, {
						controls = controls3,
						layoutOrderReversed = true,
						addBlankIcon = true,
						isSpatial = p.isSpatial,
						platform = platform
					})
				})
			})
		})
	})
end

return React.memo(GamepadHelpPage)
