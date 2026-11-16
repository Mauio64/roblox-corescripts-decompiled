local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local Cryo = require(CorePackages.Packages.Cryo)
local Otter = require(CorePackages.Packages.Otter)
local React = require(CorePackages.Packages.React)
require(CorePackages.Packages.ReactOtter)
local carouselScrollButtons = require("@luauforge/bundled/edJ").CarouselScrollButtons
require("@game/CorePackages/Workspace/Packages/AppBlox")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local module = require("@luauforge/bundled/eeo")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module.FocusNavigationEventNameEnum
local Foundation = require(CorePackages.Packages.Foundation)

local useCursor = Foundation.Hooks.useCursor
local cursorType = Foundation.Enums.CursorType
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

local signal = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Signal
local systemInfoProtocol = require("@luauforge/bundled/bXg").SystemInfoProtocol

local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local useLastInput = Responsive.useLastInput

local UIBlox = require(CorePackages.Packages.UIBlox)
local images = UIBlox.App.ImageSet.Images
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local loadableImage = UIBlox.App.Loading.LoadableImage
local loadingStrategy = UIBlox.App.Loading.Enum.LoadingStrategy

local roundIconButton = require("@luauforge/bundled/fZd").RoundIconButton

local module3 = require("@luauforge/deferred/fZg")
local module4 = require("@luauforge/deferred/fZh")
local module5 = require("@luauforge/deferred/fZi")
local module6 = require("@luauforge/deferred/fZj")

local enableAudioPlaybackInApp = require("@luauforge/deferred/fZk").enableAudioPlaybackInApp

local fFlagFixMediaGalleryOversized = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFixMediaGalleryOversized
local fFlagLuaAppAddTestIdsForArrow = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddTestIdsForArrow
local getTestId = require("@game/CorePackages/Workspace/Packages/RoactUtils").getTestId

local fFlagLuaAppEdpMediaGalleryRedesign = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryRedesign

local fFlagLuaAppEdpMediaGalleryRedesignIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryRedesignIxp

local fFlagLuaAppEdpMediaGalleryVideoPreview = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryVideoPreview

local fFlagLuaAppEdpMediaGalleryVideoPreviewIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryVideoPreviewIxp

local fFlagLuaAppEdpMediaGalleryAutoAdvance = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryAutoAdvance

local fFlagLuaAppEdpMediaGalleryPreloadImage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryPreloadImage

local fFlagLuaAppEdpMediaGalleryFullScreen = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryFullScreen

local fFlagLuaAppEdpMediaGalleryRedesignTelemetry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryRedesignTelemetry

local fFlagLuaAppEdpMediaGalleryHeightJitterFix = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpMediaGalleryHeightJitterFix

local v5 = game:DefineFastFlag("LuaAppEdpMediaGalleryVideoAudioFix2", false)

local fStringLuaAppEdpAudioManufacturerDenyList = require("@game/CorePackages/Workspace/Packages/SharedFlags").FStringLuaAppEdpAudioManufacturerDenyList
pcall(function()
	local systemInfo = systemInfoProtocol.default:getSystemInfo({ systemInfoProtocol.InfoNames.MANUFACTURER })

	if typeof(systemInfo.manufacturer) == "string" then
		for k in fStringLuaAppEdpAudioManufacturerDenyList:gmatch("(%w+)") do
			if not (typeof(k) == "string" and string.lower(k) == string.lower(systemInfo.manufacturer)) then
				continue
			end

			v5 = false
		end
	end
end)

local defineFastFlag = game:DefineFastFlag("LuaAppEdpMediaGalleryPageIndicators3", false)
local defineFastFlag2 = game:DefineFastFlag("LuaAppEdpMediaGalleryTouchDrag", false)

local defineFastInt = game:DefineFastInt("LuaAppEdpMediaGalleryImageAutoAdvanceDuration", 5)

local defineFastInt2 = game:DefineFastInt("LuaAppMediaGalleryMinValidMeasuredWidthRatioPct", 50)

local v6 = {
	itemPadding = 16,
	borderRadius = UDim.new(0, 8),
	useSpring = true,
	springConfig = { frequency = 3, dampingRatio = 1, restingVelocityLimit = 0.05 },
	showCounter = true
}

local function getImageUri(value)
	local v7 = string.find(value, "http://www.roblox.com/asset/?id=", 1, true)

	if v7 and v7 == 1 then
		return `rbxthumb://type=Asset&id={string.sub(value, 33)}&w=768&h=432`
	end

	return value
end

local function MediaGallerySnapping(p2)
	local joined = Cryo.Dictionary.join(v6, p2)
	local v7

	if fFlagLuaAppEdpMediaGalleryRedesign then
		v7 = not fFlagLuaAppEdpMediaGalleryRedesignIxp or joined.mediaGalleryRedesignEnabledIxp
	else
		v7 = nil
	end

	local v8

	if fFlagLuaAppEdpMediaGalleryVideoPreview then
		v8 = not fFlagLuaAppEdpMediaGalleryVideoPreviewIxp or joined.mediaGalleryVideoPreviewEnabledIxp
	end

	local v9 = useDesignTokens()
	local size_300 = v9.Size.Size_300
	local v10 = (not joined.itemAspectRatio or joined.itemAspectRatio == 0) and 16 / 9
		or joined.itemAspectRatio

	local state, setState = React.useState(Vector2.new(
		fFlagLuaAppEdpMediaGalleryHeightJitterFix and joined.initialWidth or 0,
		0
	))
	local v11

	if fFlagLuaAppEdpMediaGalleryHeightJitterFix then
		v11 = React.useCallback(function(p3): boolean
			if joined.initialWidth == nil then
				return p3 > 0
			end

			return joined.initialWidth * (defineFastInt2 / 100) <= p3
		end, { joined.initialWidth })
	else
		v11 = nil
	end

	local ref = if not defineFastFlag2 then React.useRef(false) else nil
	local ref2 = React.useRef((Vector3.new()))
	local ref3 = React.useRef(nil)

	local v12 = nil
	local v13 = nil
	local v14 = nil

	local ref4 = nil
	local v15 = nil

	local v16 = nil
	local v17 = nil

	local v18 = nil
	local v19 = nil
	local v20 = nil
	local v21 = nil
	local v22 = nil
	local v23 = nil
	local v24 = nil
	local ref5 = nil
	local v25 = nil
	local v26 = nil
	local v27 = nil
	local v28 = nil
	local size_500 = v9.Size.Size_500
	local size_350 = v9.Size.Size_350
	local v29 = nil
	local v30 = nil
	local v31 = nil
	local setState2 = nil
	local v32 = nil

	if fFlagLuaAppEdpMediaGalleryAutoAdvance or defineFastFlag2 then
		ref5 = React.useRef(nil)
	end

	local v33, v34, v35, v36, v37, v38, v39

	if fFlagLuaAppEdpMediaGalleryRedesign then
		if fFlagLuaAppEdpMediaGalleryVideoPreview and v5 then
			local flag = nil

			for k, item in joined.items do
				if item.videoId then
					flag = true
					break
				end
			end

			React.useEffect(function()
				if flag then
					task.delay(0, function()
						enableAudioPlaybackInApp()
					end)
				end
			end, { flag })
		end

		local state2, setState3 = React.useState(joined.startIndex or 1)
		v12 = state2

		React.useEffect(function()
			local v41 = {}

			for k, item in joined.items do
				if not item.imageId then
					continue
				end

				local v42 = item.imageId
				local v43 = string.find(v42, "http://www.roblox.com/asset/?id=", 1, true)

				if v43 and v43 == 1 then
					v42 = `rbxthumb://type=Asset&id={string.sub(v42, 33)}&w=768&h=432`
				end

				table.insert(v41, v42)
			end

			if #v41 > 0 then
				task.spawn(function()
					local ContentProvider = game:GetService("ContentProvider")
					ContentProvider:PreloadAsync(v41)
				end)
			end
		end, { joined.items })

		v33 = React.useCallback(function(p3)
			if p3 == 1 then
				return Vector2.new(0, 0)
			end

			local v41 = state.X + joined.itemPadding
			return Vector2.new(v41, 0)
		end, { joined.itemPadding, state })

		v34, v35 = React.useBinding(v33(v12))

		React.useEffect(function()
			v35(v33(v12))
		end, { v33, v12 })

		ref4 = React.useRef(signal.new())

		local v41 = useLastInput()
		v28 = v41 == Responsive.Input.Directional

		if v7 then
			v15 = v41 == Responsive.Input.Pointer
		end

		if fFlagLuaAppEdpMediaGalleryAutoAdvance then
			v21, v22 = React.useBinding(0)
			v23, v24 = React.useBinding(0)
		end

		local ref6 = React.useRef(false)

		v36 = React.useCallback(function(p3, p4)
			if ref6.current then
				return
			end

			local value = v34:getValue()
			local v42 = state.X + joined.itemPadding
			local v43, v44

			if p3 == "Right" then
				v43 = v12 + 1
				v44 = value + Vector2.new(v42, 0)
			else
				v43 = v12 - 1
				v44 = value - Vector2.new(v42, 0)
			end

			if v43 < 1 or #joined.items < v43 then
				return
			end

			if fFlagLuaAppEdpMediaGalleryAutoAdvance and v7 then
				v22(0)
				v24(0)
			end

			if v7 then
				ref4.current:fire(v43)
			end

			ref6.current = true

			local singleMotor = Otter.createSingleMotor(0)
			singleMotor:onStep(function(p5)
				v35(value:Lerp(v44, p5))
			end)

			if joined.useSpring then
				singleMotor:setGoal(Otter.spring(1, joined.springConfig))
			else
				singleMotor:setGoal(Otter.instant(1))
			end

			singleMotor:onComplete(function()
				ref6.current = false

				if joined.onSwipe then
					joined.onSwipe()
				end

				if
					fFlagLuaAppEdpMediaGalleryRedesignTelemetry
					and joined.onMediaGalleryMediaChanged
					and joined.items
					and joined.items[v43]
				then
					local item = joined.items[v43]
					joined.onMediaGalleryMediaChanged(item.imageId, item.videoId, item.isYouTubeVideo, p4)
				end

				setState3(v43)
			end)

			return function()
				singleMotor:destroy()
			end
		end, {
			joined.items,
			joined.itemPadding,
			joined.useSpring,
			joined.springConfig,
			joined.onSwipe,
			state,
			v12,
			v34,
			v7
		})

		v16 = React.useCallback(function()
			v36("Left")
		end, { v36 })

		v17 = React.useCallback(function()
			v36("Right")
		end, { v36 })

		v37 = React.useCallback(function(p3, p4)
			if p4 == Enum.SwipeDirection.Right then
				v36("Left")
			elseif p4 == Enum.SwipeDirection.Left then
				v36("Right")
			end
		end, { v36 })

		local function fn(p3)
			if not fFlagLuaAppEdpMediaGalleryHeightJitterFix or v11(p3.AbsoluteSize.X) then
				setState(p3.AbsoluteSize)
			end
		end

		v38 = React.useCallback(fn, { if fFlagLuaAppEdpMediaGalleryHeightJitterFix then v11 else nil })
		local state3
		state3, setState2 = React.useState(true)
		v31 = state3

		v29 = React.useMemo(function()
			return signal.new()
		end, {})
		v30 = React.useMemo(function()
			return signal.new()
		end, {})
		v39 = React.useCallback(function()
			local item = joined.items[v12]

			if item and item.videoId then
				v29:fire()
			end
		end, { v12, joined.items, v29 })

		if not defineFastFlag2 then
			v18 = React.useCallback(function(p3, p4)
				if p4.UserInputType == Enum.UserInputType.Touch then
					ref.current = false
					ref2.current = p4.Position
				end
			end, {})

			v19 = React.useCallback(function(p3, p4)
				if
					p4.UserInputType == Enum.UserInputType.Touch
					and ref2.current
					and ref2.current.X
					and math.abs(p4.Position.X - ref2.current.X) > 50
				then
					ref.current = true
				end
			end, {})

			v20 = React.useCallback(function(p3, p4)
				if p4.UserInputType == Enum.UserInputType.Touch then
					ref2.current = Vector3.new()
				end
			end, {})
		end

		if fFlagLuaAppEdpMediaGalleryAutoAdvance then
			if fFlagLuaAppEdpMediaGalleryVideoPreview then
				v25 = React.useCallback(function()
					if fFlagLuaAppEdpMediaGalleryFullScreen and joined.isFullscreen then
						return
					end

					v36("Right", true)
				end, { v36 })
			end

			local v44 = React.useCallback(function(p3)
				if not ref6.current then
					local v45 = v21:getValue() + p3

					if defineFastInt <= v45 then
						v36("Right", true)
					else
						v22(v45)
						v24(v45 / defineFastInt)
					end
				end
			end, { v21, v36 })

			local v45 = React.useCallback(function()
				v22(0)
				v24(0)
			end, {})

			local v46 = fFlagLuaAppEdpMediaGalleryVideoPreview
				and v8
				and joined.items
				and joined.items[v12]
				and joined.items[v12].videoId
				and true
				or nil

			local isOccluded = if fFlagLuaAppEdpMediaGalleryFullScreen then joined.isOccluded else nil
			local isFullscreen = if fFlagLuaAppEdpMediaGalleryFullScreen then joined.isFullscreen else nil

			if not (fFlagLuaAppEdpMediaGalleryVideoPreview and v8) then
				v46 = nil
			end

			local mediaGalleryRedesignEnabledIxp

			if fFlagLuaAppEdpMediaGalleryRedesignIxp then
				mediaGalleryRedesignEnabledIxp = joined.mediaGalleryRedesignEnabledIxp
			end

			local v48 = if fFlagLuaAppEdpMediaGalleryVideoPreviewIxp then joined.mediaGalleryVideoPreviewEnabledIxp else nil
			module5(isOccluded, isFullscreen, v46, ref5, v44, v45, mediaGalleryRedesignEnabledIxp, v48)
		end

		if fFlagLuaAppEdpMediaGalleryFullScreen then
			React.useEffect(function()
				if v7 then
					setState3(joined.startIndex or 1)
				end
			end, { joined.startIndex, v7 })
		end

		v26 = useBreakpointXOrSmaller(Responsive.Keys.Small)

		v32 = useCursor(cursorType.Invisible)

		local v44 = React.useCallback(function()
			if joined.onFullscreenToggleButtonActivated and joined.items and joined.items[v12] then
				local v45 = joined.items[v12].videoId ~= nil
				joined.onFullscreenToggleButtonActivated(v12, v45)
			end
		end, { joined.onFullscreenToggleButtonActivated, v12, joined.items })

		local v45 = joined.items and v12 and joined.items[v12] and joined.items[v12].videoId ~= nil
		local v46 = React.useCallback(function()
			if v45 then
				v30:fire()
			end
		end, { v30, v45 })

		local v47 = React.useMemo(function()
			local v48 = {
				[Enum.KeyCode.ButtonL1] = focusNavigationEventNameEnum.TabBackward,
				[Enum.KeyCode.ButtonR1] = focusNavigationEventNameEnum.TabForward
			}
			local buttonR3 = Enum.KeyCode.ButtonR3
			local v49 = if joined.isFullscreen then focusNavigationEventNameEnum.ExitFullscreen else focusNavigationEventNameEnum.Fullscreen
			v48[buttonR3] = v49

			local buttonL3 = Enum.KeyCode.ButtonL3
			local v50

			if v45 then
				v50 = if v31 then focusNavigationEventNameEnum.Unmute else focusNavigationEventNameEnum.Mute
			end

			v48[buttonL3] = v50
			return v48
		end, { joined.isFullscreen, v31, v45 })

		local v48 = React.useMemo(function()
			return {
				[focusNavigationEventNameEnum.TabBackward] = {
					handler = InputHandlers.onRelease(v16)
				},
				[focusNavigationEventNameEnum.TabForward] = {
					handler = InputHandlers.onRelease(v17)
				},
				[focusNavigationEventNameEnum.Fullscreen] = {
					handler = InputHandlers.onRelease(v44)
				},
				[focusNavigationEventNameEnum.ExitFullscreen] = {
					handler = InputHandlers.onRelease(v44)
				},
				[focusNavigationEventNameEnum.Mute] = {
					handler = InputHandlers.onRelease(v46)
				},
				[focusNavigationEventNameEnum.Unmute] = {
					handler = InputHandlers.onRelease(v46)
				}
			}
		end, { v16, v17, v44, v46 })

		local v49 = ReactFocusNavigation.useEventMap(v47)
		v27 = ReactFocusNavigation.useEventHandlerMap(v48, v49)
	else
		v13, v14 = React.useBinding(joined.startIndex or 1)

		v33 = function(p3)
			local v40 = state.X + joined.itemPadding
			return Vector2.new(v40 * (p3 - 1), 0)
		end

		v34, v35 = React.useBinding(v33(v13:getValue()))

		React.useEffect(function()
			v35(v33(v13:getValue()))
		end, { state })

		v36 = function(p3)
			local v40 = if p3 == "Right" then v13:getValue() + 1 else v13:getValue() - 1

			if not (v40 >= 1 and v40 <= #joined.items) then
				return
			end

			v14(v40)

			local v41 = v33(v13:getValue())
			local value = v34:getValue()
			local singleMotor = Otter.createSingleMotor(0)
			singleMotor:onStep(function(p4)
				v35(value:Lerp(v41, p4))
			end)

			if joined.useSpring then
				singleMotor:setGoal(Otter.spring(1, joined.springConfig))
			else
				singleMotor:setGoal(Otter.instant(1))
			end

			singleMotor:onComplete(function()
				if not defineFastFlag2 then
					ref.current = false
				end

				if joined.onSwipe then
					joined.onSwipe()
				end
			end)
		end

		v37 = function(p3, p4)
			if p4 == Enum.SwipeDirection.Right then
				v36("Left")
			elseif p4 == Enum.SwipeDirection.Left then
				v36("Right")
			end
		end

		v38 = function(p3)
			if not fFlagLuaAppEdpMediaGalleryHeightJitterFix or v11(p3.AbsoluteSize.X) then
				setState(p3.AbsoluteSize)
			end
		end

		v39 = function(p3)
			if (defineFastFlag2 or not ref.current) and joined.onPreviewActivated then
				return joined.onPreviewActivated(p3)
			end
		end

		if not defineFastFlag2 then
			v20 = function(p3, p4)
				if p4.UserInputType == Enum.UserInputType.Touch then
					ref2.current = Vector3.new()
				end
			end

			v19 = function(p3, p4)
				if
					p4.UserInputType == Enum.UserInputType.Touch
					and ref2.current
					and math.abs(p4.Position.X - ref2.current.X) > 50
				then
					ref.current = true
				end
			end

			v18 = function(p3, p4)
				if p4.UserInputType == Enum.UserInputType.Touch then
					ref.current = false
					ref2.current = p4.Position
				end
			end
		end
	end

	if defineFastFlag2 then
		React.useEffect(function()
			local flag = false

			local touchStartedConnection = UserInputService.TouchStarted:Connect(function(p3)
				local current = ref5.current

				if current then
					local absolutePosition = current.AbsolutePosition
					local absoluteSize = current.AbsoluteSize

					if
						p3.Position.X >= absolutePosition.X
						and p3.Position.X <= absolutePosition.X + absoluteSize.X
						and p3.Position.Y >= absolutePosition.Y
						and p3.Position.Y <= absolutePosition.Y + absoluteSize.Y
					then
						flag = true
					end
				end
			end)

			local touchEndedConnection = UserInputService.TouchEnded:Connect(function(otherPart)
				flag = false
			end)

			local touchDragConnection = UserInputService.TouchDrag:Connect(function(p3)
				if flag then
					v37(nil, p3)
				end
			end)

			return function()
				touchStartedConnection:Disconnect()
				touchEndedConnection:Disconnect()
				touchDragConnection:Disconnect()
			end
		end, { v37 })
	end

	local v40 = if fFlagLuaAppEdpMediaGalleryRedesign then module6(joined.items, v12) else nil
	local v41

	if fFlagLuaAppEdpMediaGalleryRedesign and v7 then
		local size_200 = v9.Size.Size_200
		local v42 = if v26 then v9.Size.Size_400 else v9.Size.Size_700
		local size_1000 = v9.Size.Size_1000

		v41 = size_200 + v42 + size_1000
	end

	local children = {}

	if not fFlagLuaAppEdpMediaGalleryRedesign then
		v40 = joined.items
	end

	for total, v42 in v40 do
		if fFlagLuaAppEdpMediaGalleryRedesign and v12 ~= 1 then
			total = v12 - 2 + total
		end

		local v43 = "Item" .. total
		local createElement = React.createElement
		local v45 = {
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			["LayoutOrder"] = nil,
			LayoutOrder = total
		}

		local tag = React.Tag
		local v46 = if fFlagLuaAppAddTestIdsForArrow then getTestId("discovery-edp-media-gallery-item", total) else nil
		v45[tag] = v46

		v45.Size = UDim2.new(1, 0, 0, state.X / v10)
		v45.TextTransparency = 1
		v45.Text = ""
		v45.BackgroundTransparency = 1
		v45.AutoButtonColor = false
		local inputBegan = React.Event.InputBegan
		v45[inputBegan] = if not defineFastFlag2 then v18 else nil
		local inputChanged = React.Event.InputChanged
		v45[inputChanged] = if not defineFastFlag2 then v19 else nil
		local inputEnded = React.Event.InputEnded
		v45[inputEnded] = if not defineFastFlag2 then v20 else nil
		v45[React.Event.Activated] = not (fFlagLuaAppEdpMediaGalleryRedesign or fFlagLuaAppEdpMediaGalleryVideoPreview and v8 and v42.videoId)
			and function()
				v39(total)
			end
			or nil
		local touchSwipe = React.Event.TouchSwipe
		v45[touchSwipe] = if not defineFastFlag2 then v37 else nil
		v45.Selectable = if v7 then false else nil
		local v53

		if not (fFlagLuaAppEdpMediaGalleryVideoPreview and v8 and v42.videoId) then
			local createElement2 = React.createElement
			local v55 = {
				cornerRadius = joined.borderRadius,
				Size = UDim2.fromScale(1, 1),
				Image = 0,
				ScaleType = 0,
				BackgroundTransparency = 1,
				ZIndex = 1,
				useShimmerAnimationWhileLoading = true,
				loadingStrategy = 0
			}
			local v56

			if v7 then
				v56 = v42.imageId
				local v57 = string.find(v56, "http://www.roblox.com/asset/?id=", 1, true)

				if v57 and v57 == 1 then
					v56 = `rbxthumb://type=Asset&id={string.sub(v56, 33)}&w=768&h=432`
				end
			else
				v56 = v42.imageId
			end

			v55.Image = v56
			v55.ScaleType = Enum.ScaleType.Crop

			local v57 = if fFlagLuaAppEdpMediaGalleryPreloadImage then loadingStrategy.Eager else nil
			v55.loadingStrategy = v57
			v53 = createElement2(loadableImage, v55)
		end

		local v54

		if fFlagLuaAppEdpMediaGalleryVideoPreview and v8 and v42.videoId then
			local createElement2 = React.createElement
			local v56 = {
				video = v42.videoId,
				thumbnail = v42.imageId,
				Size = UDim2.fromScale(1, 1),
				cornerRadius = joined.borderRadius.Offset,
				ZIndex = 1,
				itemIndex = total,
				isFullscreen = 0,
				isMediaGalleryOccluded = 0,
				videoPlaybackCoordinator = 0,
				onVideoProgressChanged = 0,
				onVideoEnded = 0,
				videoAnalytics = 0,
				universeId = 0,
				toggleVideoPlaybackSignal = 0,
				toggleMuteSignal = 0,
				onMutedChanged = 0
			}

			local v57 = if fFlagLuaAppEdpMediaGalleryFullScreen then joined.isFullscreen else nil
			v56.isFullscreen = v57
			local v58 = if fFlagLuaAppEdpMediaGalleryFullScreen then joined.isOccluded else nil
			v56.isMediaGalleryOccluded = v58
			v56.videoPlaybackCoordinator = joined.videoPlaybackCoordinator
			v56.onVideoProgressChanged = if fFlagLuaAppEdpMediaGalleryAutoAdvance then v24 else nil

			v56.onVideoEnded = if fFlagLuaAppEdpMediaGalleryAutoAdvance then v25 else nil
			v56.videoAnalytics = joined.videoAnalytics
			v56.universeId = joined.universeId
			local v61 = if total == v12 then v29 else nil
			v56.toggleVideoPlaybackSignal = v61
			local v62 = if total == v12 then v30 else nil
			v56.toggleMuteSignal = v62
			local v63 = if total == v12 then setState2 else nil
			v56.onMutedChanged = v63
			v54 = createElement2(module4, v56)
		end

		local v55 = if fFlagLuaAppEdpMediaGalleryRedesign and v7 and not (fFlagLuaAppEdpMediaGalleryVideoPreview and v8 and v42.videoId) then React.createElement("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, v41),
			BackgroundColor3 = v9.Color.Extended.Black.Black_100.Color3,
			BorderSizePixel = 0,
			ZIndex = 2
		}, {
			Gradient = React.createElement("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0.2)
				})
			}),
			UICorner = React.createElement("UICorner", {
				CornerRadius = joined.borderRadius
			})
		}) else nil
		local v56

		if v42.isYouTubeVideo then
			local createElement2 = React.createElement
			local v58 = {
				["Size"] = nil,
				Size = UDim2.new(0, 60, 0, 45),
				AnchorPoint = Vector2.new(1, 1),
				Position = UDim2.new(1, -size_300, 1, -size_300),
				TextTransparency = 1,
				Text = "",
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 0.5,
				ZIndex = fFlagLuaAppEdpMediaGalleryRedesign and v7 and 3 or 2
			}

			local tag2 = React.Tag
			local v59 = if fFlagLuaAppAddTestIdsForArrow then getTestId("discovery-edp-media-gallery-video-play", total) else nil
			v58[tag2] = v59

			v58[React.Event.Activated] = function()
				if joined.onVideoPlayActivated then
					joined.onVideoPlayActivated(total)
				end
			end

			v56 = createElement2("TextButton", v58, {
				PlayButtonCorner = React.createElement("UICorner", {
					CornerRadius = UDim.new(1, 0)
				}),
				PlayIcon = React.createElement(imageSetLabel, {
					Size = UDim2.fromOffset(26, 26),
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Image = images["icons/common/play"],
					BackgroundTransparency = 1,
					ZIndex = 2
				})
			})
		end

		local v57

		if fFlagLuaAppEdpMediaGalleryFullScreen and v7 and joined.onFullscreenToggleButtonActivated then
			v57 = React.createElement(roundIconButton, {
				icon = joined.isFullscreen and "two-arrows-to-center" or "two-arrows-from-center",
				onActivated = function()
					joined.onFullscreenToggleButtonActivated(total, v42.videoId ~= nil)
				end,
				AnchorPoint = Vector2.new(1, 0),
				Position = UDim2.new(1, -v9.Size.Size_500, 0, v9.Size.Size_500),
				ZIndex = 3,
				Selectable = false
			})
		end

		children[v43] = createElement("TextButton", v45, {
			Image = v53,
			Video = v54,
			GradientOverlay = v55,
			PlayButton = v56,
			FullscreenButton = v57
		})
	end

	local v42, v43

	if state.X < 500 then
		v42 = v9.Size.Size_600
		v43 = v9.Size.Size_200
	else
		v42 = v9.Size.Size_800
		v43 = v9.Size.Size_400
	end

	local v44

	if joined.showCounter and not (fFlagLuaAppEdpMediaGalleryRedesign and v7) then
		local createElement = React.createElement
		local v46 = {
			Size = UDim2.fromScale(0, 1),
			AutomaticSize = Enum.AutomaticSize.X,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			BackgroundTransparency = 1,
			Text = 0,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			TextColor3 = 0,
			TextTransparency = 0,
			RichText = true,
			LineHeight = 1,
			ref = 0
		}
		local v47

		if fFlagLuaAppEdpMediaGalleryRedesign then
			v47 = `<b>{v12} / {#joined.items}</b>`
		else
			v47 = v13:map(function(p3)
				return `<b>{p3} / {#joined.items}</b>`
			end)
		end

		v46.Text = v47

		local v48 = if not foundationFontFaceMigration then v9.Typography.CaptionLarge.Font else nil
		v46.Font = v48

		local v49 = if foundationFontFaceMigration then normalizeFontFace(v9.Typography.CaptionLarge.Font) else nil
		v46.FontFace = v49

		v46.TextSize = v9.FontSize.FontSize_300
		v46.TextColor3 = v9.Color.Content.Emphasis.Color3
		v46.TextTransparency = v9.Color.Content.Emphasis.Transparency

		v46.ref = ref3
		v44 = createElement("TextLabel", v46)
	end

	local createElement = React.createElement

	local v46 = {
		["BackgroundTransparency"] = nil,
		["BackgroundTransparency"] = nil,
		["BackgroundTransparency"] = nil,
		["BackgroundTransparency"] = nil,
		["BackgroundTransparency"] = nil,
		["BackgroundTransparency"] = nil,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ref = v27
	}
	local v47 = if fFlagLuaAppEdpMediaGalleryRedesign and v7 then false else nil
	v46.AutoButtonColor = v47
	v46.Text = fFlagLuaAppEdpMediaGalleryRedesign and v7 and "" or nil
	local activated = React.Event.Activated
	local v48 = if fFlagLuaAppEdpMediaGalleryRedesign and v7 then v39 else nil
	v46[activated] = v48

	local v49 = if fFlagLuaAppEdpMediaGalleryRedesign and v7 then Enum.SelectionBehavior.Stop else nil
	v46.SelectionBehaviorRight = v49

	if not (fFlagLuaAppEdpMediaGalleryRedesign and v7 and joined.isFullscreen) then
		v32 = nil
	end

	v46.SelectionImageObject = v32

	v46.SelectionGroup = fFlagLuaAppEdpMediaGalleryRedesign and v7 and true or nil

	local createElement2 = React.createElement
	local v51 = {
		Selectable = false,
		BackgroundTransparency = 1,
		["AnchorPoint"] = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.new(1, 0, 0, state.X / v10),
		AutomaticCanvasSize = Enum.AutomaticSize.XY,
		CanvasPosition = v34,
		ScrollingEnabled = false,
		ScrollBarImageTransparency = 1,
		ScrollBarThickness = fFlagLuaAppEdpMediaGalleryRedesign and v7 and joined.clipsNonCurrentItems and 0 or nil,
		ScrollingDirection = Enum.ScrollingDirection.X
	}

	local v52 = if fFlagLuaAppEdpMediaGalleryRedesign and v7 then joined.clipsNonCurrentItems else false
	v51.ClipsDescendants = v52

	v51.ZIndex = 1
	v51[React.Change.AbsoluteSize] = v38
	local v53 = if fFlagLuaAppEdpMediaGalleryAutoAdvance or defineFastFlag2 then ref5 else nil
	v51.ref = v53
	local children2 = {
		ScrollingFrame = createElement2("ScrollingFrame", v51, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, joined.itemPadding)
			}),
			Items = React.createElement(React.Fragment, {}, children)
		}),
		Counter = 0,
		PageIndicators = 0,
		ScrollButtons = 0,
		SizeConstraint = 0
	}

	local v54 = if joined.showCounter and not (fFlagLuaAppEdpMediaGalleryRedesign and v7) then React.createElement("Frame", {
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, -size_300),
		Size = UDim2.fromOffset((ref3.current and ref3.current.AbsoluteSize.X or 0) + v43 * 2, v42),
		BackgroundTransparency = 0.3,
		BackgroundColor3 = v9.Color.Surface.Surface_0.Color3,
		BorderSizePixel = 0,
		ZIndex = 2
	}, {
		TextLabel = v44,
		Corner = React.createElement("UICorner", { CornerRadius = UDim.new(1, 0) })
	}) else nil
	children2.Counter = v54
	local v55

	if
		fFlagLuaAppEdpMediaGalleryRedesign
		and v7
		and defineFastFlag
		and #joined.items > 1
		and not (fFlagLuaAppEdpMediaGalleryFullScreen and joined.isFullscreen)
	then
		local createElement3 = React.createElement
		local v57 = {
			AnchorPoint = Vector2.new(0.5, 1),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(0, v9.Size.Size_200),
			Position = 0,
			ZIndex = 2
		}
		local newUDim2 = UDim2.new
		local v61 = if v26 then -v9.Size.Size_400 else -v9.Size.Size_700
		v57.Position = newUDim2(0.5, 0, 1, v61)

		local v62 = {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, size_350),
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			PageLeftGamepadIcon = 0,
			Indicators = 0,
			PageRightGamepadIcon = 0
		}

		local v63 = if v28 then React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = -1,
			Image = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonL1),
			ImageTransparency = v12 <= 1 and 0.5 or nil,
			Size = UDim2.fromOffset(size_500, size_500)
		}) else nil
		v62.PageLeftGamepadIcon = v63

		local createElement4 = React.createElement
		local v65 = {
			numberOfItems = #joined.items,
			mediaGalleryStartIndex = joined.startIndex or 1,
			currentItemProgressBinding = 0,
			mediaGalleryScrolledSignal = 0,
			useSpring = 0,
			springConfig = 0
		}

		if not fFlagLuaAppEdpMediaGalleryAutoAdvance then
			v23 = nil
		end

		v65.currentItemProgressBinding = v23

		v65.mediaGalleryScrolledSignal = ref4.current
		v65.useSpring = joined.useSpring
		v65.springConfig = joined.springConfig
		v62.Indicators = createElement4(module3, v65)

		local v66 = if v28 then React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Image = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonR1),
			ImageTransparency = #joined.items <= v12 and 0.5 or nil,
			Size = UDim2.fromOffset(size_500, size_500)
		}) else nil
		v62.PageRightGamepadIcon = v66
		v55 = createElement3("Frame", v57, v62)
	end

	children2.PageIndicators = v55
	local v56

	if fFlagLuaAppEdpMediaGalleryRedesign and v7 and v15 then
		local createElement3 = React.createElement
		local v58 = {
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Size = UDim2.new(
				1,
				fFlagLuaAppEdpMediaGalleryFullScreen and joined.isFullscreen and 0 or v9.Size.Size_1000,
				1,
				0
			),
			buttonOffsetFromEdge = 0,
			ZIndex = 10,
			leftScrollingEnabled = 0,
			rightScrollingEnabled = 0,
			handleScrollLeft = 0,
			handleScrollRight = 0
		}

		local v59 = if fFlagLuaAppEdpMediaGalleryFullScreen and joined.isFullscreen then v9.Size.Size_500 else nil
		v58.buttonOffsetFromEdge = v59

		v58.leftScrollingEnabled = v12 > 1
		v58.rightScrollingEnabled = v12 < #joined.items
		v58.handleScrollLeft = v16
		v58.handleScrollRight = v17
		v56 = createElement3(carouselScrollButtons, v58)
	end

	children2.ScrollButtons = v56

	children2.SizeConstraint = React.createElement("UISizeConstraint", {
		MinSize = Vector2.new(fFlagFixMediaGalleryOversized and 0 or state.X, state.X / v10)
	})
	return createElement(
		fFlagLuaAppEdpMediaGalleryRedesign and v7 and "TextButton" or "Frame",
		v46,
		children2
	)
end

if fFlagLuaAppEdpMediaGalleryVideoPreview then
	return React.memo(MediaGallerySnapping)
end

return MediaGallerySnapping
