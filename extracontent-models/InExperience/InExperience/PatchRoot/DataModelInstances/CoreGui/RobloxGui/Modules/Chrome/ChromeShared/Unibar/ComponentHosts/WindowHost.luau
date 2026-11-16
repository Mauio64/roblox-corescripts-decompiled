local ChromeShared = script:FindFirstAncestor("ChromeShared")

local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local ReactRoblox = require(CorePackages.Packages.ReactRoblox)
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VRService = game:GetService("VRService")

local ReactOtter = require(CorePackages.Packages.ReactOtter)
local Signals = require(CorePackages.Packages.Signals)
local Display = require(CorePackages.Workspace.Packages.Display)
local getUIScale = Display.GetDisplayStore(false).getUIScale

local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local Interactable = UIBlox.Core.Control.Interactable
local useStyleSheet = Foundation.Hooks.useStyleSheet

local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local MouseIconOverrideService = CoreScriptsCommon.MouseIconOverrideService
local AppCommonLib = require(CorePackages.Workspace.Packages.AppCommonLib)
local named = AppCommonLib.Symbol.named("SelfieViewCursorOverride")

local debounce = require(ChromeShared.Utility.debounce)
local Service = require(ChromeShared.Service)
local Constants = require(ChromeShared.Unibar.Constants)
require(CorePackages.Workspace.Packages.Chrome)
local ChromeAnalytics = require(ChromeShared.Analytics.ChromeAnalytics)
local shouldRejectMultiTouch = require(ChromeShared.Utility.shouldRejectMultiTouch)

local CoreScriptsCommon2 = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local SettingsShowSignal = CoreScriptsCommon2.SettingsShowSignal
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeMenuOpen = CoreGuiCommon.Flags.FFlagTopBarSignalizeMenuOpen

local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local defineFastInt = game:DefineFastInt("ChromeWindowLayoutOrder", 2)

local defineFastFlag = game:DefineFastFlag("FixWindowDragError", false)
local defineFastFlag2 = game:DefineFastFlag("FixWindowDragStaleConnection", false)

local Flags = require(ChromeShared.Flags)
local FFlagTokenizeUnibarConstantsWithStyleProvider = Flags.FFlagTokenizeUnibarConstantsWithStyleProvider

local useWindowSize = require(ChromeShared.Hooks.useWindowSize)

local v = { dampingRatio = 1, frequency = 3 }

local _ = { INTEGRATION = 1, CLOSE_BUTTON = 2, INPUT_SHIELD = 3, INPUT_WRAPPER = 4 }

local flag = false

return function(p)
	local v2 = useWindowSize(p.integration.integration)
	local ref = React.useRef(nil)
	local v3 = React.useRef(nil)
	local visible, v4 = React.useBinding(false)
	local v5 = 0
	local v6 = React.useMemo(function(): nil
		return nil
	end, {})

	local v7, v8 = React.useBinding(false)
	local v9, v10 = React.useBinding(false)
	local v11

	if FFlagTopBarSignalizeMenuOpen then
		v11 = React.joinBindings({ v7, v9 }):map(function(list)
			return list[1] or list[2]
		end)
	end

	local v12

	if not FFlagTopBarSignalizeMenuOpen then
		v12 = useSelector(function(p2)
			return p2.displayOptions.menuOpen or p2.displayOptions.inspectMenuOpen
		end)
	end

	local v13, v14 = React.useBinding(false)

	local v15, v16 = ReactOtter.useAnimatedBinding(v2.X.Offset)
	local v17, v18 = ReactOtter.useAnimatedBinding(v2.Y.Offset)

	local v19 = React.useCallback(function()
		return Vector2.new(v15:getValue(), v17:getValue()) * (p.integration.integration.windowAnchorPoint or Vector2.zero)
	end, { v15, v17, p.integration })

	React.useEffect(function()
		if v15:getValue() == 0 then
			v16((ReactOtter.instant(v2.X.Offset)))
		else
			v16(ReactOtter.spring(v2.X.Offset, v))
		end
	end, { v2.X.Offset })

	React.useEffect(function()
		if v17:getValue() == 0 then
			v18((ReactOtter.instant(v2.Y.Offset)))
		else
			v18(ReactOtter.spring(v2.Y.Offset, v))
		end
	end, { v2.Y.Offset })

	if FFlagTopBarSignalizeMenuOpen then
		React.useEffect(function()
			local effect = Signals.createEffect(function(p2)
				v10((CoreGuiCommon.Stores.GetInspectAndBuyStore(p2).getInspectAndBuyOpen(p2)))
			end)

			SettingsShowSignal:connect(function(p2)
				v8(p2)
			end)

			return function()
				effect()
			end
		end, {})
	end

	React.useEffect(function()
		local dragConnection = Service:dragConnection(p.integration.id)
		local connection, inputObject

		if dragConnection then
			connection = dragConnection.connection
			inputObject = dragConnection.inputObject
		else
			inputObject = nil
		end

		assert(ref.current ~= nil)
		assert(ref.current.Parent ~= nil)

		local current = ref.current
		local absoluteSize = ref.current:FindFirstAncestorWhichIsA("ScreenGui").AbsoluteSize

		if connection == nil then
			local v20

			if FFlagTokenizeUnibarConstantsWithStyleProvider and p.position then
				local uiScale = getUIScale(false)
				local v21 = uiScale * p.position.X.Offset
				local v22 = uiScale * p.position.Y.Offset

				v20 = UDim2.new(p.position.X.Scale, v21, p.position.Y.Scale, v22)
			else
				v20 = p.position or UDim2.new()
			end

			if p.integration.integration.cachePosition then
				local v21 = Service:windowPosition(p.integration.id) or UDim2.new()
				local v22 = v21.X.Scale ~= 1 and 0 or absoluteSize.X
				current.Position = UDim2.new(0, v22 + v21.X.Offset, 0, v21.Y.Offset)
			else
				local v21 = v20.X.Scale ~= 1 and 0 or absoluteSize.X
				current.Position = UDim2.new(0, v21 + v20.X.Offset, 0, v20.Y.Offset)
			end
		else
			v3 = connection
			v4(true)

			if v3 then
				v16((ReactOtter.instant(Constants.WINDOW_ICON_SIZE)))
				v18((ReactOtter.instant(Constants.WINDOW_ICON_SIZE)))

				task.defer(v16, ReactOtter.spring(v2.X.Offset, v))
				task.defer(v18, ReactOtter.spring(v2.Y.Offset, v))

				local vector3 = Vector3.new(ref.current.AbsolutePosition.X, ref.current.AbsolutePosition.Y, 0)

				ChromeAnalytics.default:setWindowDefaultPosition(p.integration.id, Vector2.new(vector3.X, vector3.Y))

				v3.current = UserInputService.InputChanged:Connect(function(input, _)
					local position = input.Position

					if shouldRejectMultiTouch(inputObject, input) then
						return
					end

					local v20 = position - vector3
					local v21 = {
						X = math.clamp((v20 + vector3).X, 0, absoluteSize.X),
						Y = math.clamp((v20 + vector3).Y, 0, absoluteSize.Y)
					}

					current.Position = UDim2.fromOffset(v21.X, v21.Y)
				end)
			end
		end
	end, {})

	local v20 = React.useCallback(function(udim: UDim2)
		if p.integration.integration.cachePosition then
			Service:updateWindowPosition(p.integration.id, udim)
		end
	end, { p.integration })

	local v21 = React.useCallback(function()
		if not VRService.VREnabled then
			flag = true
			MouseIconOverrideService.push(named, Enum.OverrideMouseIconBehavior.ForceShow)
		end
	end)

	local v22 = React.useCallback(function()
		if flag then
			flag = false
			MouseIconOverrideService.pop(named)
		end
	end)

	local v23 = React.useCallback(function(_, p2)
		assert(ref.current ~= nil)
		assert(ref.current.Parent ~= nil)

		local current = ref.current
		local absoluteSize = ref.current:FindFirstAncestorWhichIsA("ScreenGui").AbsoluteSize

		local v23 = v19()

		local position = p2.Position
		local vector3 = Vector3.new(ref.current.AbsolutePosition.X + v23.X, ref.current.AbsolutePosition.Y + v23.Y, 0)

		if p2.UserInputType == Enum.UserInputType.MouseButton1 or p2.UserInputType == Enum.UserInputType.Touch then
			ChromeAnalytics.default:onWindowTouchBegan(
				p.integration.id,
				Vector2.new(ref.current.AbsolutePosition.X, ref.current.AbsolutePosition.Y)
			)

			if defineFastFlag2 and v3.current then
				v3.current:Disconnect()
				v3.current = nil
				v4(false)
			end

			if (defineFastFlag2 or not v3.current) and not v13:getValue() then
				local x = vector3.X
				local v24

				if defineFastFlag then
					v24 = math.max(0, absoluteSize.X - (v15:getValue() - v23.X))
				else
					v24 = absoluteSize.X - (v15:getValue() - v23.X)
				end

				local v25 = { X = math.clamp(x, 0, v24), Y = 0 }

				local y = vector3.Y
				local v26

				if defineFastFlag then
					v26 = math.max(0, absoluteSize.Y - (v17:getValue() - v23.Y))
				else
					v26 = absoluteSize.Y - (v17:getValue() - v23.Y)
				end

				v25.Y = math.clamp(y, 0, v26)

				current.Position = UDim2.fromOffset(v25.X, v25.Y)
				v3.current = UserInputService.InputChanged:Connect(function(input, _)
					if shouldRejectMultiTouch(p2, input) then
						return
					end

					local position2 = input.Position
					local v27 = position2 - position
					local v28

					if defineFastFlag2 then
						v28 = v27.Magnitude
					else
						v28 = v5 + v27.Magnitude
					end

					v5 = v28

					if v5 > Constants.WINDOW_MIN_DRAG_DISTANCE then
						v4(true)

						local x2 = (v27 + vector3).X
						local x3 = v23.X
						local v29

						if defineFastFlag then
							v29 = math.max(v23.X, absoluteSize.X - (v15:getValue() - v23.X))
						else
							v29 = absoluteSize.X - (v15:getValue() - v23.X)
						end

						local v30 = { X = math.clamp(x2, x3, v29), Y = 0 }

						local y2 = (v27 + vector3).Y
						local y3 = v23.Y
						local v31

						if defineFastFlag then
							v31 = math.max(v23.Y, absoluteSize.Y - (v17:getValue() - v23.Y))
						else
							v31 = absoluteSize.Y - (v17:getValue() - v23.Y)
						end

						v30.Y = math.clamp(y2, y3, v31)

						current.Position = UDim2.fromOffset(v30.X, v30.Y)
						ChromeAnalytics.default:onWindowDrag(p.integration.id, position2)
					end
				end)
			end
		end
	end, { v19 })

	local function fn(current): boolean
		local parent = current.Parent

		local offset = current.Position.X.Offset
		local offset2 = current.Position.Y.Offset

		local v24 = v19()

		local absoluteSize = parent.AbsoluteSize

		return offset < v24.X
			or absoluteSize.X - (v15:getValue() - v24.X) < offset
			or offset2 < v24.Y
			or absoluteSize.Y - (v17:getValue() - v24.Y) < offset2
	end

	local v24 = React.useCallback(function(flag2: boolean?)
		if ref == nil or ref.current == nil then
			return
		end

		assert(ref.current ~= nil)
		assert(ref.current.Parent ~= nil)

		local current = ref.current

		local offset = current.Position.X.Offset
		local offset2 = current.Position.Y.Offset

		if v6 and v6.PlaybackState == Enum.PlaybackState.Playing then
			v6:Cancel()
		end

		if not fn(current) then
			v20(UDim2.new(0, offset, 0, offset2))

			return
		end

		if current == nil then
			return
		end

		local parent = ref.current.Parent

		local v24 = v19()

		local absoluteSize = parent.AbsoluteSize

		local v25 = not (absoluteSize.X > v15:getValue()) and 0
			or math.clamp(offset, v24.X, absoluteSize.X - (v15:getValue() - v24.X))

		local v26 = not (absoluteSize.Y > v17:getValue()) and 0
			or math.clamp(offset2, v24.Y, absoluteSize.Y - (v17:getValue() - v24.Y))

		local udim = UDim2.new(0, v25, 0, v26)

		v20(udim)

		if flag2 then
			current.Position = udim
			return
		end

		v14(true)

		v6 = TweenService:Create(current, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
			Position = udim
		})
		assert(v6 ~= nil)
		v6.Completed:Connect(function(_)
			v14(false)
			v6 = nil
		end)
		v6:Play()
	end, { v19 })

	local v25 = React.useCallback(function(_, p2)
		v5 = 0

		if p2.UserInputType == Enum.UserInputType.MouseButton1 or p2.UserInputType == Enum.UserInputType.Touch then
			if ref.current then
				ChromeAnalytics.default:onWindowTouchEnded(
					p.integration.id,
					Vector2.new(ref.current.AbsolutePosition.X, ref.current.AbsolutePosition.Y),
					fn(ref.current)
				)
			end

			if v3.current then
				v3.current:Disconnect()
				v3.current = nil
				v4(false)
				Service:gesture(p.integration.id, nil)
				v24()
			end
		end
	end, {})

	local v26 = defineFastInt

	local styleSheet = useStyleSheet()

	local createPortal = ReactRoblox.createPortal
	local createElement = React.createElement
	local v27 = {
		["Name"] = nil,
		Name = Constants.WINDOW_HOST_GUI_NAME .. ":" .. p.integration.id,
		[React.Change.AbsoluteSize] = debounce(function()
			v24()
		end, 0.2)
	}
	local displayOrder

	if FFlagTopBarSignalizeMenuOpen and v11 then
		displayOrder = v11:map(function(p2)
			return if p2 then -1 else v26
		end)
	else
		displayOrder = v12 and -1 or v26
	end

	v27.DisplayOrder = displayOrder

	v27.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local createElement2 = React.createElement
	local v28 = {
		Size = React.joinBindings({ v15, v17 }):map(function(list)
			v24(true)
			return UDim2.fromOffset(list[1], list[2])
		end),
		LayoutOrder = 1,
		ref = ref,
		BorderSizePixel = 0,
		AnchorPoint = 0,
		BackgroundTransparency = 1
	}
	local anchorPoint

	if p.integration.integration.windowAnchorPoint then
		anchorPoint = p.integration.integration.windowAnchorPoint
	end

	v28.AnchorPoint = anchorPoint
	return createPortal({
		Name = createElement("ScreenGui", v27, {
			WindowFrame = createElement2("Frame", v28, {
				WindowWrapper = React.createElement(
					"Frame",
					{
						Size = UDim2.new(1, 0, 1, 0),
						BackgroundTransparency = 1,
						BorderSizePixel = 0
					},
					{
						Integration = p.integration.component(p) or nil,
						InputShield = React.createElement(Interactable, {
							ZIndex = 3,
							Size = UDim2.fromScale(1, 1),
							BackgroundTransparency = 1,
							Visible = visible
						}),
						InputWrapper = React.createElement("Frame", {
							ZIndex = 4,
							Size = UDim2.fromScale(1, 1),
							BackgroundTransparency = 1,
							[React.Event.InputBegan] = v23,
							[React.Event.InputEnded] = v25,
							[React.Event.MouseEnter] = v21,
							[React.Event.MouseLeave] = v22,
							[React.Event.Destroying] = v22
						})
					}
				)
			}),
			FoundationStyleLink = React.createElement("StyleLink", { StyleSheet = styleSheet })
		})
	}, CoreGui)
end
