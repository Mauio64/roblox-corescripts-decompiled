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
local getUIScale = require(CorePackages.Workspace.Packages.Display).GetDisplayStore(false).getUIScale
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local Interactable = UIBlox.Core.Control.Interactable
local useStyleSheet = Foundation.Hooks.useStyleSheet
local MouseIconOverrideService = require(CorePackages.Workspace.Packages.CoreScriptsCommon).MouseIconOverrideService
local v17 = require(CorePackages.Workspace.Packages.AppCommonLib).Symbol.named("SelfieViewCursorOverride")
local debounce = require(ChromeShared.Utility.debounce)
local Service = require(ChromeShared.Service)
local Constants = require(ChromeShared.Unibar.Constants)

require(CorePackages.Workspace.Packages.Chrome)

local ChromeAnalytics = require(ChromeShared.Analytics.ChromeAnalytics)
local shouldRejectMultiTouch = require(ChromeShared.Utility.shouldRejectMultiTouch)
local SettingsShowSignal = require(CorePackages.Workspace.Packages.CoreScriptsCommon).SettingsShowSignal
local CoreGuiCommon = require(CorePackages.Workspace.Packages.CoreGuiCommon)
local FFlagTopBarSignalizeMenuOpen = CoreGuiCommon.Flags.FFlagTopBarSignalizeMenuOpen
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local v27 = game:DefineFastInt("ChromeWindowLayoutOrder", 2)
local v28 = game:DefineFastFlag("FixWindowDragError", false)
local v29 = game:DefineFastFlag("FixWindowDragStaleConnection", false)
local FFlagTokenizeUnibarConstantsWithStyleProvider = require(ChromeShared.Flags).FFlagTokenizeUnibarConstantsWithStyleProvider
local useWindowSize = require(ChromeShared.Hooks.useWindowSize)
local t1 = {
	dampingRatio = 1,
	frequency = 3
}
local _ = {
	INTEGRATION = 1,
	CLOSE_BUTTON = 2,
	INPUT_SHIELD = 3,
	INPUT_WRAPPER = 4
}
local u34 = false

return function(t2: {[any]: any}) -- line: 71
	-- upvalues: useWindowSize (copy), React (copy), FFlagTopBarSignalizeMenuOpen (copy), useSelector (copy), ReactOtter (copy), t1 (copy), Signals (copy), CoreGuiCommon (copy), SettingsShowSignal (copy), Service (copy), Constants (copy), ChromeAnalytics (copy), UserInputService (copy), shouldRejectMultiTouch (copy), FFlagTokenizeUnibarConstantsWithStyleProvider (copy), getUIScale (copy), VRService (copy), u34 (ref), MouseIconOverrideService (copy), v17 (copy), v29 (copy), v28 (copy), TweenService (copy), v27 (copy), useStyleSheet (copy), ReactRoblox (copy), debounce (copy), Interactable (copy), CoreGui (copy)
	local v36 = useWindowSize(t2.integration.integration)
	local v37 = React.useRef(nil)
	local u38 = React.useRef(nil)
	local v39, v40 = React.useBinding(false)
	local n1 = 0
	local u42 = React.useMemo(function() -- line: 77
		return nil
	end, {})
	local v43, v44 = React.useBinding(false)
	local v45, v46 = React.useBinding(false)
	local v47 = if not FFlagTopBarSignalizeMenuOpen then nil else React.joinBindings({
		v43,
		v45
	}):map(function(p1) -- line: 85
		return p1[1] or p1[2]
	end)
	local v48 = if FFlagTopBarSignalizeMenuOpen then nil else useSelector(function(p2) -- line: 91
		return p2.displayOptions.menuOpen or p2.displayOptions.inspectMenuOpen
	end)
	local v49, v50 = React.useBinding(false)
	local v51, v52 = ReactOtter.useAnimatedBinding(v36.X.Offset)
	local v53, v54 = ReactOtter.useAnimatedBinding(v36.Y.Offset)
	local v55 = React.useCallback(function() -- line: 102
		-- upvalues: v51 (copy), v53 (copy), t2 (copy)
		return Vector2.new(v51:getValue(), v53:getValue()) * (t2.integration.integration.windowAnchorPoint or Vector2.zero)
	end, {
		v51,
		v53,
		t2.integration
	})

	React.useEffect(function() -- line: 107
		-- upvalues: v51 (copy), v52 (copy), ReactOtter (copy), v36 (copy), t1 (copy)
		if v51:getValue() == 0 then
			v52((ReactOtter.instant(v36.X.Offset)))

			return
		end

		v52(ReactOtter.spring(v36.X.Offset, t1))
	end, { v36.X.Offset })
	React.useEffect(function() -- line: 115
		-- upvalues: v53 (copy), v54 (copy), ReactOtter (copy), v36 (copy), t1 (copy)
		if v53:getValue() == 0 then
			v54((ReactOtter.instant(v36.Y.Offset)))

			return
		end

		v54(ReactOtter.spring(v36.Y.Offset, t1))
	end, { v36.Y.Offset })

	if FFlagTopBarSignalizeMenuOpen then
		React.useEffect(function() -- line: 124
			-- upvalues: Signals (copy), CoreGuiCommon (copy), v46 (copy), SettingsShowSignal (copy), v44 (copy)
			local v67 = Signals.createEffect(function(p3) -- line: 125
				-- upvalues: CoreGuiCommon (copy), v46 (copy)
				local v112 = CoreGuiCommon.Stores.GetInspectAndBuyStore(p3).getInspectAndBuyOpen(p3)

				v46(v112)
			end)

			SettingsShowSignal:connect(function(p4) -- line: 130
				-- upvalues: v44 (copy)
				v44(p4)
			end)

			return function() -- line: 134
				-- upvalues: v67 (copy)
				v67()
			end
		end, {})
	end

	React.useEffect(function() -- line: 144
		-- upvalues: Service (copy), t2 (copy), v37 (copy), u38 (ref), v40 (copy), v52 (copy), ReactOtter (copy), Constants (copy), v54 (copy), v36 (copy), t1 (copy), ChromeAnalytics (copy), UserInputService (copy), shouldRejectMultiTouch (copy), FFlagTokenizeUnibarConstantsWithStyleProvider (copy), getUIScale (copy)
		local connection = nil
		local inputObject = nil
		local v70 = Service:dragConnection(t2.integration.id)

		if v70 then
			connection = v70.connection
			inputObject = v70.inputObject
		end

		assert(v37.current ~= nil)
		assert(v37.current.Parent ~= nil)

		local current = v37.current
		local AbsoluteSize = v37.current:FindFirstAncestorWhichIsA("ScreenGui").AbsoluteSize

		if connection ~= nil then
			u38 = connection
			v40(true)

			if u38 then
				v52((ReactOtter.instant(Constants.WINDOW_ICON_SIZE)))
				v54((ReactOtter.instant(Constants.WINDOW_ICON_SIZE)))
				task.defer(v52, ReactOtter.spring(v36.X.Offset, t1))
				task.defer(v54, ReactOtter.spring(v36.Y.Offset, t1))

				local vector3 = Vector3.new(v37.current.AbsolutePosition.X, v37.current.AbsolutePosition.Y, 0)

				ChromeAnalytics.default:setWindowDefaultPosition(t2.integration.id, Vector2.new(vector3.X, vector3.Y))
				u38.current = UserInputService.InputChanged:Connect(function(input, _) -- line: 179
					-- upvalues: shouldRejectMultiTouch (copy), inputObject (ref), vector3 (copy), vector3 (copy), AbsoluteSize (copy), current (copy)
					local inputPosition = input.Position

					if shouldRejectMultiTouch(inputObject, input) then
						return
					end

					local v117 = inputPosition - vector3
					local t3 = {
						X = math.clamp((v117 + vector3).X, 0, AbsoluteSize.X),
						Y = math.clamp((v117 + vector3).Y, 0, AbsoluteSize.Y)
					}

					current.Position = UDim2.fromOffset(t3.X, t3.Y)
				end)
			end
		else
			local uDim2

			if FFlagTokenizeUnibarConstantsWithStyleProvider and t2.position then
				local v74 = getUIScale(false)
				local v75 = v74 * t2.position.X.Offset
				local v76 = v74 * t2.position.Y.Offset

				uDim2 = UDim2.new(t2.position.X.Scale, v75, t2.position.Y.Scale, v76)
			else
				uDim2 = t2.position or UDim2.new()
			end

			if t2.integration.integration.cachePosition then
				local v78 = Service:windowPosition(t2.integration.id) or UDim2.new()
				local v79 = v78.X.Scale ~= 1 and 0 or AbsoluteSize.X

				current.Position = UDim2.new(0, v79 + v78.X.Offset, 0, v78.Y.Offset)
			else
				local v80 = uDim2.X.Scale ~= 1 and 0 or AbsoluteSize.X

				current.Position = UDim2.new(0, v80 + uDim2.X.Offset, 0, uDim2.Y.Offset)
			end
		end
	end, {})

	local v56 = React.useCallback(function(uDim2: UDim2) -- line: 220
		-- upvalues: t2 (copy), Service (copy)
		if t2.integration.integration.cachePosition then
			Service:updateWindowPosition(t2.integration.id, uDim2)
		end
	end, { t2.integration })
	local v57 = React.useCallback(function() -- line: 226
		-- upvalues: VRService (copy), u34 (ref), MouseIconOverrideService (copy), v17 (copy)
		if not VRService.VREnabled then
			u34 = true
			MouseIconOverrideService.push(v17, Enum.OverrideMouseIconBehavior.ForceShow)
		end
	end)
	local v58 = React.useCallback(function() -- line: 233
		-- upvalues: u34 (ref), MouseIconOverrideService (copy), v17 (copy)
		if u34 then
			u34 = false
			MouseIconOverrideService.pop(v17)
		end
	end)
	local v59 = React.useCallback(function(_, p7) -- line: 240
		-- upvalues: v37 (copy), v55 (copy), ChromeAnalytics (copy), t2 (copy), v29 (copy), u38 (ref), v40 (copy), v49 (copy), v28 (copy), v51 (copy), v53 (copy), UserInputService (copy), shouldRejectMultiTouch (copy), n1 (ref), Constants (copy)
		assert(v37.current ~= nil)
		assert(v37.current.Parent ~= nil)

		local current = v37.current
		local AbsoluteSize = v37.current:FindFirstAncestorWhichIsA("ScreenGui").AbsoluteSize
		local v86 = v55()
		local p7Position = p7.Position
		local vector3 = Vector3.new(v37.current.AbsolutePosition.X + v86.X, v37.current.AbsolutePosition.Y + v86.Y, 0)

		if p7.UserInputType == Enum.UserInputType.MouseButton1 or p7.UserInputType == Enum.UserInputType.Touch then
			ChromeAnalytics.default:onWindowTouchBegan(t2.integration.id, Vector2.new(v37.current.AbsolutePosition.X, v37.current.AbsolutePosition.Y))

			if v29 and u38.current then
				u38.current:Disconnect()
				u38.current = nil
				v40(false)
			end

			if (v29 or not u38.current) and not v49:getValue() then
				local t4 = {
					X = math.clamp(vector3.X, 0, if not v28 then AbsoluteSize.X - (v51:getValue() - v86.X) else math.max(0, AbsoluteSize.X - (v51:getValue() - v86.X))),
					Y = math.clamp(vector3.Y, 0, if not v28 then AbsoluteSize.Y - (v53:getValue() - v86.Y) else math.max(0, AbsoluteSize.Y - (v53:getValue() - v86.Y)))
				}

				current.Position = UDim2.fromOffset(t4.X, t4.Y)
				u38.current = UserInputService.InputChanged:Connect(function(input, _) -- line: 300
					-- upvalues: shouldRejectMultiTouch (copy), p7 (copy), p7Position (copy), n1 (ref), v29 (copy), Constants (copy), v40 (copy), vector3 (copy), v86 (copy), v28 (copy), AbsoluteSize (copy), v51 (copy), v53 (copy), current (copy), ChromeAnalytics (copy), t2 (copy)
					if shouldRejectMultiTouch(p7, input) then
						return
					end

					local inputPosition = input.Position
					local v122 = inputPosition - p7Position

					n1 = if not v29 then n1 + v122.Magnitude else v122.Magnitude

					if n1 > Constants.WINDOW_MIN_DRAG_DISTANCE then
						v40(true)

						local t5 = {
							X = math.clamp((v122 + vector3).X, v86.X, if not v28 then AbsoluteSize.X - (v51:getValue() - v86.X) else math.max(v86.X, AbsoluteSize.X - (v51:getValue() - v86.X))),
							Y = math.clamp((v122 + vector3).Y, v86.Y, if not v28 then AbsoluteSize.Y - (v53:getValue() - v86.Y) else math.max(v86.Y, AbsoluteSize.Y - (v53:getValue() - v86.Y)))
						}

						current.Position = UDim2.fromOffset(t5.X, t5.Y)
						ChromeAnalytics.default:onWindowDrag(t2.integration.id, inputPosition)
					end
				end)
			end
		end
	end, { v55 })

	local function v60(p9) -- line: 346
		-- upvalues: v55 (copy), v51 (copy), v53 (copy)
		local p9Parent = p9.Parent
		local XOffset = p9.Position.X.Offset
		local YOffset = p9.Position.Y.Offset
		local v94 = v55()
		local AbsoluteSize = p9Parent.AbsoluteSize

		return XOffset < v94.X or (XOffset > AbsoluteSize.X - (v51:getValue() - v94.X) or (YOffset < v94.Y or YOffset > AbsoluteSize.Y - (v53:getValue() - v94.Y)))
	end

	local v61 = React.useCallback(function(b1: boolean?) -- line: 363
		-- upvalues: v37 (copy), u42 (ref), v60 (copy), v55 (copy), v51 (copy), v53 (copy), v56 (copy), v50 (copy), TweenService (copy)
		if v37 == nil or v37.current == nil then
			return
		end

		assert(v37.current ~= nil)
		assert(v37.current.Parent ~= nil)

		local current = v37.current
		local XOffset = current.Position.X.Offset
		local YOffset = current.Position.Y.Offset

		if u42 and u42.PlaybackState == Enum.PlaybackState.Playing then
			u42:Cancel()
		end

		if v60(current) then
			if current == nil then
				return
			end

			local currentParent = v37.current.Parent
			local v101 = v55()
			local AbsoluteSize = currentParent.AbsoluteSize
			local n2 = 0
			local n3 = 0

			if AbsoluteSize.X > v51:getValue() then
				n2 = math.clamp(XOffset, v101.X, AbsoluteSize.X - (v51:getValue() - v101.X))
			end

			if AbsoluteSize.Y > v53:getValue() then
				n3 = math.clamp(YOffset, v101.Y, AbsoluteSize.Y - (v53:getValue() - v101.Y))
			end

			local uDim2 = UDim2.new(0, n2, 0, n3)

			v56(uDim2)

			if not b1 then
				v50(true)

				local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

				u42 = TweenService:Create(current, tweenInfo, {
					Position = uDim2
				})
				assert(u42 ~= nil)
				u42.Completed:Connect(function(_) -- line: 417
					-- upvalues: v50 (copy), u42 (ref)
					v50(false)
					u42 = nil
				end)
				u42:Play()

				return
			end

			current.Position = uDim2

			return
		end

		v56(UDim2.new(0, XOffset, 0, YOffset))
	end, { v55 })
	local v62 = React.useCallback(function(_, p12) -- line: 430
		-- upvalues: n1 (ref), v37 (copy), ChromeAnalytics (copy), t2 (copy), v60 (copy), u38 (ref), v40 (copy), Service (copy), v61 (copy)
		n1 = 0

		if p12.UserInputType == Enum.UserInputType.MouseButton1 or p12.UserInputType == Enum.UserInputType.Touch then
			if v37.current then
				ChromeAnalytics.default:onWindowTouchEnded(t2.integration.id, Vector2.new(v37.current.AbsolutePosition.X, v37.current.AbsolutePosition.Y), (v60(v37.current)))
			end

			if u38.current then
				u38.current:Disconnect()
				u38.current = nil
				v40(false)
				Service:gesture(t2.integration.id, nil)
				v61()
			end
		end
	end, {})
	local v63 = v27
	local v64 = useStyleSheet()

	return ReactRoblox.createPortal({
		Name = React.createElement("ScreenGui", {
			Name = Constants.WINDOW_HOST_GUI_NAME .. ":" .. t2.integration.id,
			[React.Change.AbsoluteSize] = debounce(function() -- line: 463
				-- upvalues: v61 (copy)
				v61()
			end, 0.2),
			DisplayOrder = if not FFlagTopBarSignalizeMenuOpen or not v47 then if not v48 then v63 else -1 else v47:map(function(p13) -- line: 467
				-- upvalues: v63 (copy)
				if p13 then
					return -1
				end

				return v63
			end),
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		}, {
			WindowFrame = React.createElement("Frame", {
				LayoutOrder = 1,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Size = React.joinBindings({
					v51,
					v53
				}):map(function(p14) -- line: 475
					-- upvalues: v61 (copy)
					v61(true)

					return UDim2.fromOffset(p14[1], p14[2])
				end),
				ref = v37,
				AnchorPoint = if not t2.integration.integration.windowAnchorPoint then nil else t2.integration.integration.windowAnchorPoint
			}, {
				WindowWrapper = React.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 1, 0)
				}, {
					Integration = t2.integration.component(t2) or nil,
					InputShield = React.createElement(Interactable, {
						ZIndex = 3,
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1, 1),
						Visible = v39
					}),
					InputWrapper = React.createElement("Frame", {
						ZIndex = 4,
						Size = UDim2.fromScale(1, 1),
						BackgroundTransparency = 1,
						[React.Event.InputBegan] = v59,
						[React.Event.InputEnded] = v62,
						[React.Event.MouseEnter] = v57,
						[React.Event.MouseLeave] = v58,
						[React.Event.Destroying] = v58
					})
				})
			}),
			FoundationStyleLink = React.createElement("StyleLink", {
				StyleSheet = v64
			})
		})
	}, CoreGui)
end
