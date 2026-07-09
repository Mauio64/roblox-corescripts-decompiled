local ParentParent = script.Parent.Parent.Parent
local ParentParentParent = ParentParent.Parent
local UserInputService = game:GetService("UserInputService")
local React = require(ParentParentParent.React)
local Foundation = require(ParentParentParent.Foundation)
local Display = require(ParentParentParent.Display)
local GamepadList = require(ParentParent.Components.Gamepad.GamepadList)
local Constants = require(ParentParent.Constants)
local useKeybinds = require(ParentParent.Hooks.useKeybinds)
local SignalsReact = require(ParentParentParent.SignalsReact)
local RobloxAppHooks = require(ParentParentParent.RobloxAppHooks)
local RobloxAppEnums = require(ParentParentParent.RobloxAppEnums)
local useDeviceOrientation = RobloxAppHooks.useDeviceOrientation
local DeviceOrientationMode = RobloxAppEnums.DeviceOrientationMode
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

local function GamepadHelpPage(t1: {[any]: any}) -- line: 29
	-- upvalues: UserInputService (copy), useDeviceOrientation (copy), useKeybinds (copy), useTokens (copy), React (copy), SignalsReact (copy), Display (copy), Constants (copy), DeviceOrientationMode (copy), View (copy), GamepadList (copy)
	local Platform = UserInputService:GetPlatform()
	local v20 = useDeviceOrientation()
	local controls = useKeybinds().controls
	local v22 = useTokens()
	local v23, v24 = React.useState(1e999)
	local v25, v26 = React.useState(nil)
	local v27, v28 = React.useState(nil)
	local v29 = SignalsReact.useSignalState(Display.GetDisplayStore)
	local v30 = SignalsReact.useSignalState(v29.getViewportSize)
	local v31, v32, v33 = React.useMemo(function() -- line: 42
		-- upvalues: controls (copy), t1 (copy), Constants (copy), Platform (copy)
		local t2 = {}
		local t3 = {}
		local t4 = {}

		for v45, v46 in controls do
			if v46.gamepadInput ~= nil then
				local gamepadInput = v46.gamepadInput
				local input = gamepadInput.input

				if input == nil then
					input = if not t1.isSpatial then if not Constants.HELP_PAGE.GAMEPAD_PLAYSTATION_PLATFORMS[Platform] then gamepadInput.xboxInput else gamepadInput.playstationInput else gamepadInput.spatialGamepadInput
				end

				if input ~= nil and #input > 0 then
					local v49 = Constants.HELP_PAGE.GAMEPAD_LAYOUT_ORDER[input[1]]

					if v49 <= Constants.HELP_PAGE.GAMEPAD_CUTOFFS.LEFT_COL then
						t2[v45] = v46
					elseif v49 <= Constants.HELP_PAGE.GAMEPAD_CUTOFFS.BOTTOM_RIGHT_COL and Constants.HELP_PAGE.GAMEPAD_PLAYSTATION_PLATFORMS[Platform] then
						t3[v45] = v46
					else
						t4[v45] = v46
					end
				end
			end
		end

		return t2, t3, t4
	end, { controls })
	local v34 = React.createElement("ImageLabel", {
		Name = "GamepadImage",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ScaleType = Enum.ScaleType.Fit,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Image = not t1.isSpatial and "rbxasset://textures/ui/Gamepad/Controller@3x.png" or "rbxasset://textures/ui/Gamepad/VRController.png"
	})
	local v35 = React.useMemo(function() -- line: 101
		-- upvalues: t1 (copy), v30 (copy), Constants (copy), v22 (copy)
		if not t1.isSpatial and (v30.X < Constants.HELP_PAGE.TOUCH_OFFSETS.SMALL_SCREEN_CUTOFF_X or v30.Y < Constants.HELP_PAGE.GAMEPAD_SIZES.NO_PADDING_CUTOFF_Y) then
			return UDim.new(0, 0)
		end

		return UDim.new(0, v22.Size.Size_2400)
	end, { v30 })
	local v36, v37, v38, v39, v40, v41 = React.useMemo(function() -- line: 116
		-- upvalues: t1 (copy), Constants (copy), v23 (copy), v30 (copy), v20 (copy), DeviceOrientationMode (copy), v25 (copy), v27 (copy)
		if t1.isSpatial then
			return Vector2.new(1, 0.5), UDim2.new(Constants.HELP_PAGE.GAMEPAD_SIZES.LEFT_COL_SCALE, 0, 0, v23 * Constants.HELP_PAGE.GAMEPAD_SIZES.IMAGE_MULTIPLIER_VR * 0.5 / Constants.HELP_PAGE.GAMEPAD_SIZES.IMAGE_ASPECT_RATIO), Vector2.new(0, 0.5), UDim2.new(Constants.HELP_PAGE.GAMEPAD_SIZES.RIGHT_COL_SCALE_VR, 0, 0, v23 * Constants.HELP_PAGE.GAMEPAD_SIZES.IMAGE_MULTIPLIER_VR * 0.5 / Constants.HELP_PAGE.GAMEPAD_SIZES.IMAGE_ASPECT_RATIO), Constants.HELP_PAGE.GAMEPAD_SIZES.COL_SCALE_VR, Constants.HELP_PAGE.GAMEPAD_SIZES.IMAGE_MULTIPLIER_VR
		end

		if (v30.X < Constants.HELP_PAGE.TOUCH_OFFSETS.SMALL_SCREEN_CUTOFF_X or v30.Y < Constants.HELP_PAGE.TOUCH_OFFSETS.SMALL_SCREEN_CUTOFF_Y) and v20 == DeviceOrientationMode.Portrait then
			return Vector2.new(0, 0), UDim2.fromOffset(0, v23 * Constants.HELP_PAGE.GAMEPAD_SIZES.IMAGE_MULTIPLIER_PORTRAIT / Constants.HELP_PAGE.GAMEPAD_SIZES.IMAGE_ASPECT_RATIO), Vector2.new(1, 0), UDim2.new(1, 0, 0, v23 * Constants.HELP_PAGE.GAMEPAD_SIZES.IMAGE_MULTIPLIER_PORTRAIT / Constants.HELP_PAGE.GAMEPAD_SIZES.IMAGE_ASPECT_RATIO), Constants.HELP_PAGE.GAMEPAD_SIZES.COL_SCALE_PORTRAIT, Constants.HELP_PAGE.GAMEPAD_SIZES.IMAGE_MULTIPLIER_PORTRAIT
		end

		local v50 = v23 * Constants.HELP_PAGE.GAMEPAD_SIZES.LEFT_COL_SCALE
		local v51 = v23 * (1 - Constants.HELP_PAGE.GAMEPAD_SIZES.RIGHT_COL_SCALE)
		local n1 = 1

		if v25 ~= nil and v27 ~= nil and v25.X > 0 and v27.X > 0 and (v50 < v25.X or v51 < v27.X) then
			n1 = math.min(v50 / v25.X, v51 / v27.X)
		end

		return Vector2.new(1, 0), UDim2.fromScale(Constants.HELP_PAGE.GAMEPAD_SIZES.LEFT_COL_SCALE, 0), Vector2.new(0, 0), UDim2.fromScale(Constants.HELP_PAGE.GAMEPAD_SIZES.RIGHT_COL_SCALE, 0), n1, Constants.HELP_PAGE.GAMEPAD_SIZES.IMAGE_MULTIPLIER_DEFAULT
	end, {
		v30,
		v23,
		t1.isSpatial
	})

	return React.createElement(View, {
		tag = "size-full-0 auto-y",
		padding = {
			top = v35
		},
		onAbsoluteSizeChanged = function(p1) -- line: 193
			-- upvalues: v24 (copy)
			v24(p1.AbsoluteSize.X)
		end
	}, {
		LeftColContainer = React.createElement(View, {
			tag = "auto-xy padding-top-large",
			AnchorPoint = v36,
			Position = v37,
			scale = v40,
			onAbsoluteSizeChanged = function(p2) -- line: 202
				-- upvalues: v25 (copy), v26 (copy)
				if v25 == nil then
					v26(p2.AbsoluteSize)
				end
			end
		}, {
			LeftCol = React.createElement(GamepadList, {
				layoutOrderReversed = false,
				addBlankIcon = false,
				controls = v31,
				isSpatial = t1.isSpatial,
				platform = Platform
			})
		}),
		ImageComponentContainer = React.createElement(View, {
			testId = "VRGamepadInstructions",
			Position = UDim2.fromScale(0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.fromOffset(v23 * v41, v23 * v41 / Constants.HELP_PAGE.GAMEPAD_SIZES.IMAGE_ASPECT_RATIO)
		}, {
			ImageComponent = v34
		}),
		RightColContainer = React.createElement(View, {
			tag = "auto-xy padding-top-large",
			AnchorPoint = v38,
			Position = v39,
			scale = v40,
			onAbsoluteSizeChanged = function(p3) -- line: 233
				-- upvalues: v27 (copy), v28 (copy)
				if v27 == nil then
					v28(p3.AbsoluteSize)
				end
			end
		}, {
			RightCol = React.createElement(View, {
				tag = "col auto-xy"
			}, {
				TopRightColContainer = React.createElement(View, {
					tag = "auto-xy",
					LayoutOrder = 1
				}, {
					TopRightCol = React.createElement(GamepadList, {
						layoutOrderReversed = true,
						addBlankIcon = false,
						controls = v33,
						isSpatial = t1.isSpatial,
						platform = Platform
					})
				}),
				BottomRightColContainer = React.createElement(View, {
					tag = "auto-xy",
					LayoutOrder = 2
				}, {
					BottomRightCol = React.createElement(GamepadList, {
						layoutOrderReversed = true,
						addBlankIcon = true,
						controls = v32,
						isSpatial = t1.isSpatial,
						platform = Platform
					})
				})
			})
		})
	})
end

return React.memo(GamepadHelpPage)
