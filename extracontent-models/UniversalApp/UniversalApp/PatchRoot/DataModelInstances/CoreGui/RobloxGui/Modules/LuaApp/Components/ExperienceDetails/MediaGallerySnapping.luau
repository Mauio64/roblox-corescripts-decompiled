local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Cryo = require(CorePackages.Packages.Cryo)
local Otter = require(CorePackages.Packages.Otter)
local React = require(CorePackages.Packages.React)

require(CorePackages.Packages.ReactOtter)

local CarouselScrollButtons = require(CorePackages.Workspace.Packages.CollectionViews).CarouselScrollButtons

require(CorePackages.Workspace.Packages.AppBlox)

local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local useCursor = Foundation.Hooks.useCursor
local CursorType = Foundation.Enums.CursorType
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local SystemInfoProtocol = require(CorePackages.Workspace.Packages.SystemInfoProtocol).SystemInfoProtocol
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local useBreakpointXOrSmaller = Responsive.useBreakpointXOrSmaller
local useLastInput = Responsive.useLastInput
local UIBlox = require(CorePackages.Packages.UIBlox)
local Images = UIBlox.App.ImageSet.Images
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel
local LoadableImage = UIBlox.App.Loading.LoadableImage
local LoadingStrategy = UIBlox.App.Loading.Enum.LoadingStrategy
local RoundIconButton = require(CorePackages.Workspace.Packages.VideoUtils).RoundIconButton
local MediaGalleryPageIndicators = require(script.Parent.MediaGalleryPageIndicators)
local MediaGalleryVideoItem = require(script.Parent.MediaGalleryVideoItem)
local useMediaGalleryRenderStepWhenVisible = require(script.Parent.Hooks.useMediaGalleryRenderStepWhenVisible)
local useVisibleMediaGalleryItems = require(script.Parent.Hooks.useVisibleMediaGalleryItems)
local enableAudioPlaybackInApp = require(CorePackages.Workspace.Packages.MediaPlayback).enableAudioPlaybackInApp
local FFlagFixMediaGalleryOversized = require(CorePackages.Workspace.Packages.SharedFlags).FFlagFixMediaGalleryOversized
local FFlagLuaAppEdpMediaGalleryRedesign = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryRedesign
local FFlagLuaAppEdpMediaGalleryRedesignIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryRedesignIxp
local FFlagLuaAppEdpMediaGalleryVideoPreview = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryVideoPreview
local FFlagLuaAppEdpMediaGalleryVideoPreviewIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryVideoPreviewIxp
local FFlagLuaAppEdpMediaGalleryAutoAdvance = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryAutoAdvance
local FFlagLuaAppEdpMediaGalleryPreloadImage = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryPreloadImage
local FFlagLuaAppEdpMediaGalleryFullScreen = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryFullScreen
local FFlagLuaAppEdpMediaGalleryRedesignTelemetry = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryRedesignTelemetry
local FFlagLuaAppEdpMediaGalleryHeightJitterFix = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpMediaGalleryHeightJitterFix
local u42 = game:DefineFastFlag("LuaAppEdpMediaGalleryVideoAudioFix2", false)
local FStringLuaAppEdpAudioManufacturerDenyList = require(CorePackages.Workspace.Packages.SharedFlags).FStringLuaAppEdpAudioManufacturerDenyList

pcall(function() -- line: 70
	-- upvalues: SystemInfoProtocol (copy), FStringLuaAppEdpAudioManufacturerDenyList (copy), u42 (ref)
	local v51 = SystemInfoProtocol.default:getSystemInfo({ SystemInfoProtocol.InfoNames.MANUFACTURER })

	if typeof(v51.manufacturer) == "string" then
		for match in FStringLuaAppEdpAudioManufacturerDenyList:gmatch("(%w+)") do
			if typeof(match) == "string" and string.lower(match) == string.lower(v51.manufacturer) then
				u42 = false
			end
		end
	end
end)

local v44 = game:DefineFastFlag("LuaAppEdpMediaGalleryPageIndicators3", false)
local v45 = game:DefineFastFlag("LuaAppEdpMediaGalleryTouchDrag", false)
local v46 = game:DefineFastInt("LuaAppEdpMediaGalleryImageAutoAdvanceDuration", 5)
local v47 = game:DefineFastInt("LuaAppMediaGalleryMinValidMeasuredWidthRatioPct", 50)
local t1 = {
	itemPadding = 16,
	useSpring = true,
	showCounter = true,
	borderRadius = UDim.new(0, 8),
	springConfig = {
		frequency = 3,
		dampingRatio = 1,
		restingVelocityLimit = 0.05
	}
}

local function getImageUri(p1) -- line: 154
	local v54 = string.find(p1, "http://www.roblox.com/asset/?id=", 1, true)

	if v54 and v54 == 1 then
		return `rbxthumb://type=Asset&id={ string.sub(p1, 33) }&w=768&h=432`
	end

	return p1
end
local function MediaGallerySnapping(t2: {[any]: any}) -- line: 165
	-- upvalues: Cryo (copy), t1 (copy), FFlagLuaAppEdpMediaGalleryRedesign (copy), FFlagLuaAppEdpMediaGalleryRedesignIxp (copy), FFlagLuaAppEdpMediaGalleryVideoPreview (copy), FFlagLuaAppEdpMediaGalleryVideoPreviewIxp (copy), useDesignTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), React (copy), FFlagLuaAppEdpMediaGalleryHeightJitterFix (copy), v47 (copy), v45 (copy), FFlagLuaAppEdpMediaGalleryAutoAdvance (copy), u42 (ref), enableAudioPlaybackInApp (copy), Signal (copy), useLastInput (copy), Responsive (copy), Otter (copy), FFlagLuaAppEdpMediaGalleryRedesignTelemetry (copy), FFlagLuaAppEdpMediaGalleryFullScreen (copy), v46 (copy), useMediaGalleryRenderStepWhenVisible (copy), useBreakpointXOrSmaller (copy), useCursor (copy), CursorType (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy), ReactFocusNavigation (copy), UserInputService (copy), useVisibleMediaGalleryItems (copy), LoadableImage (copy), FFlagLuaAppEdpMediaGalleryPreloadImage (copy), LoadingStrategy (copy), MediaGalleryVideoItem (copy), ImageSetLabel (copy), Images (copy), RoundIconButton (copy), v44 (copy), MediaGalleryPageIndicators (copy), CarouselScrollButtons (copy), FFlagFixMediaGalleryOversized (copy)
	local v56 = Cryo.Dictionary.join(t1, t2)
	local u57 = nil

	if FFlagLuaAppEdpMediaGalleryRedesign then
		u57 = not FFlagLuaAppEdpMediaGalleryRedesignIxp or v56.mediaGalleryRedesignEnabledIxp
	end

	local v58 = if not FFlagLuaAppEdpMediaGalleryVideoPreview then nil else not FFlagLuaAppEdpMediaGalleryVideoPreviewIxp or v56.mediaGalleryVideoPreviewEnabledIxp
	local v59 = useDesignTokens()
	local v60 = if not FFlagRenameDeprecatedUIBloxTokens then v59.Global.Space_150 else v59.Size.Size_300
	local v61 = (not v56.itemAspectRatio or v56.itemAspectRatio == 0) and 1.7777777777777777 or v56.itemAspectRatio
	local v62, v63 = React.useState(Vector2.new(not FFlagLuaAppEdpMediaGalleryHeightJitterFix and 0 or (v56.initialWidth or 0), 0))
	local u64 = nil

	if FFlagLuaAppEdpMediaGalleryHeightJitterFix then
		u64 = React.useCallback(function(n1: number) -- line: 189
			-- upvalues: v56 (copy), v47 (copy)
			if v56.initialWidth == nil then
				return n1 > 0
			end

			return n1 >= v56.initialWidth * (v47 / 100)
		end, { v56.initialWidth })
	end

	local v65 = if v45 then nil else React.useRef(false)
	local v66 = React.useRef((Vector3.new()))
	local v67 = React.useRef(nil)
	local u68 = nil
	local u69 = nil
	local u70 = nil
	local u71 = nil
	local u72 = nil
	local v73 = nil
	local u74 = nil
	local u75 = nil
	local v76 = nil
	local v77 = nil
	local v78 = nil
	local u79 = nil
	local u80 = nil
	local v81 = nil
	local u82 = nil
	local u83 = nil
	local v84 = nil
	local v85 = nil
	local v86 = nil
	local v87 = nil
	local v88 = if not FFlagRenameDeprecatedUIBloxTokens then v59.Global.Size_250 else v59.Size.Size_500
	local v89 = if not FFlagRenameDeprecatedUIBloxTokens then v59.Global.Size_175 else v59.Size.Size_350
	local u90 = nil
	local u91 = nil
	local u92 = nil
	local v93 = nil
	local v94 = nil

	if FFlagLuaAppEdpMediaGalleryAutoAdvance or v45 then
		u83 = React.useRef(nil)
	end

	local u100, u103, u104, u110, u111, v112, u114

	if FFlagLuaAppEdpMediaGalleryRedesign then
		if FFlagLuaAppEdpMediaGalleryVideoPreview and u42 then
			local u95 = nil

			for _, v97 in v56.items do
				if v97.videoId then
					u95 = true

					break
				end
			end

			React.useEffect(function() -- line: 247
				-- upvalues: u95 (ref), enableAudioPlaybackInApp (copy)
				if u95 then
					task.delay(0, function() -- line: 249
						-- upvalues: enableAudioPlaybackInApp (copy)
						enableAudioPlaybackInApp()
					end)
				end
			end, { u95 })
		end

		local v98, v99 = React.useState(v56.startIndex or 1)

		u68 = v98
		u69 = v99
		React.useEffect(function() -- line: 258
			-- upvalues: v56 (copy)
			local t3 = {}

			for _, v154 in v56.items do
				if v154.imageId then
					local imageId = v154.imageId
					local v156 = string.find(imageId, "http://www.roblox.com/asset/?id=", 1, true)

					table.insert(t3, if not v156 or v156 ~= 1 then imageId else `rbxthumb://type=Asset&id={ string.sub(imageId, 33) }&w=768&h=432`)
				end
			end

			if #t3 > 0 then
				task.spawn(function() -- line: 266
					-- upvalues: t3 (copy)
					game:GetService("ContentProvider"):PreloadAsync(t3)
				end)
			end
		end, { v56.items })
		u100 = React.useCallback(function(n2: number) -- line: 273
			-- upvalues: v62 (copy), v56 (copy)
			if n2 == 1 then
				return Vector2.new(0, 0)
			end

			local v158 = v62.X + v56.itemPadding

			return Vector2.new(v158, 0)
		end, {
			v56.itemPadding,
			v62
		})

		local v101, v102 = React.useBinding(u100(u68))

		u103 = v101
		u104 = v102
		React.useEffect(function() -- line: 284
			-- upvalues: u104 (ref), u100 (ref), u68 (ref)
			u104(u100(u68))
		end, {
			u100,
			u68
		})
		u72 = React.useRef(Signal.new())

		local v105 = useLastInput()

		v87 = v105 == Responsive.Input.Directional
		v73 = if not u57 then nil else v105 == Responsive.Input.Pointer

		if FFlagLuaAppEdpMediaGalleryAutoAdvance then
			local v106, v107 = React.useBinding(0)

			u79 = v106
			u80 = v107

			local v108

			v81, v108 = React.useBinding(0)
			u82 = v108
		end

		local v109 = React.useRef(false)

		u110 = React.useCallback(function(s1: string, b1: boolean?) -- line: 303
			-- upvalues: v109 (copy), u103 (ref), v62 (copy), v56 (copy), u68 (ref), FFlagLuaAppEdpMediaGalleryAutoAdvance (copy), u57 (ref), u80 (ref), u82 (ref), u72 (ref), Otter (copy), u104 (ref), FFlagLuaAppEdpMediaGalleryRedesignTelemetry (copy), u69 (ref)
			if v109.current then
				return
			end

			local v161 = u103:getValue()
			local v162 = v62.X + v56.itemPadding
			local u163, u164

			if s1 == "Right" then
				u163 = u68 + 1
				u164 = v161 + Vector2.new(v162, 0)
			else
				u163 = u68 - 1
				u164 = v161 - Vector2.new(v162, 0)
			end

			if u163 < 1 or #v56.items < u163 then
				return
			end

			if FFlagLuaAppEdpMediaGalleryAutoAdvance and u57 then
				u80(0)
				u82(0)
			end

			if u57 then
				u72.current:fire(u163)
			end

			v109.current = true

			local v165 = Otter.createSingleMotor(0)

			v165:onStep(function(n3: number) -- line: 338
				-- upvalues: u104 (ref), v161 (copy), u164 (ref)
				u104(v161:Lerp(u164, n3))
			end)

			if v56.useSpring then
				v165:setGoal(Otter.spring(1, v56.springConfig))
			else
				v165:setGoal(Otter.instant(1))
			end

			v165:onComplete(function() -- line: 348
				-- upvalues: v109 (copy), v56 (copy), FFlagLuaAppEdpMediaGalleryRedesignTelemetry (copy), u163 (ref), b1 (copy), u69 (ref)
				v109.current = false

				if v56.onSwipe then
					v56.onSwipe()
				end

				if FFlagLuaAppEdpMediaGalleryRedesignTelemetry and v56.onMediaGalleryMediaChanged and v56.items and v56.items[u163] then
					local v202 = v56.items[u163]

					v56.onMediaGalleryMediaChanged(v202.imageId, v202.videoId, v202.isYouTubeVideo, b1)
				end

				u69(u163)
			end)

			return function() -- line: 368
				-- upvalues: v165 (copy)
				v165:destroy()
			end
		end, {
			v56.items,
			v56.itemPadding,
			v56.useSpring,
			v56.springConfig,
			v56.onSwipe,
			v62,
			u68,
			u103,
			u57
		})
		u74 = React.useCallback(function() -- line: 385
			-- upvalues: u110 (ref)
			u110("Left")
		end, { u110 })
		u75 = React.useCallback(function() -- line: 389
			-- upvalues: u110 (ref)
			u110("Right")
		end, { u110 })
		u111 = React.useCallback(function(_, p3) -- line: 394
			-- upvalues: u110 (ref)
			if p3 == Enum.SwipeDirection.Right then
				u110("Left")

				return
			end

			if p3 == Enum.SwipeDirection.Left then
				u110("Right")
			end
		end, { u110 })
		v112 = React.useCallback(function(p4) -- line: 403
			-- upvalues: FFlagLuaAppEdpMediaGalleryHeightJitterFix (copy), u64 (ref), v63 (copy)
			if not FFlagLuaAppEdpMediaGalleryHeightJitterFix or u64(p4.AbsoluteSize.X) then
				v63(p4.AbsoluteSize)
			end
		end, { if not FFlagLuaAppEdpMediaGalleryHeightJitterFix then nil else u64 })

		local v113

		v113, v93 = React.useState(true)
		u92 = v113
		u90 = React.useMemo(function() -- line: 415
			-- upvalues: Signal (copy)
			return Signal.new()
		end, {})
		u91 = React.useMemo(function() -- line: 418
			-- upvalues: Signal (copy)
			return Signal.new()
		end, {})
		u114 = React.useCallback(function() -- line: 421
			-- upvalues: v56 (copy), u68 (ref), u90 (ref)
			local v169 = v56.items[u68]

			if v169 and v169.videoId then
				u90:fire()
			end
		end, {
			u68,
			v56.items,
			u90
		})

		if not v45 then
			v76 = React.useCallback(function(_, p6) -- line: 430
				-- upvalues: v65 (copy), v66 (copy)
				if p6.UserInputType == Enum.UserInputType.Touch then
					v65.current = false
					v66.current = p6.Position
				end
			end, {})
			v77 = React.useCallback(function(_, p8) -- line: 437
				-- upvalues: v66 (copy), v65 (copy)
				if p8.UserInputType == Enum.UserInputType.Touch and (v66.current and v66.current.X and math.abs(p8.Position.X - v66.current.X) > 50) then
					v65.current = true
				end
			end, {})
			v78 = React.useCallback(function(_, p10) -- line: 450
				-- upvalues: v66 (copy)
				if p10.UserInputType == Enum.UserInputType.Touch then
					v66.current = Vector3.new()
				end
			end, {})
		end

		if FFlagLuaAppEdpMediaGalleryAutoAdvance then
			if FFlagLuaAppEdpMediaGalleryVideoPreview then
				v84 = React.useCallback(function() -- line: 459
					-- upvalues: FFlagLuaAppEdpMediaGalleryFullScreen (copy), v56 (copy), u110 (ref)
					if FFlagLuaAppEdpMediaGalleryFullScreen and v56.isFullscreen then
						return
					end

					u110("Right", true)
				end, { u110 })
			end

			local v115 = React.useCallback(function(n4: number) -- line: 468
				-- upvalues: v109 (copy), u79 (ref), v46 (copy), u110 (ref), u80 (ref), u82 (ref)
				if not v109.current then
					local v177 = u79:getValue() + n4

					if v177 >= v46 then
						u110("Right", true)

						return
					end

					u80(v177)
					u82(v177 / v46)
				end
			end, {
				u79,
				u110
			})
			local v116 = React.useCallback(function() -- line: 483
				-- upvalues: u80 (ref), u82 (ref)
				u80(0)
				u82(0)
			end, {})
			local v117 = nil

			if FFlagLuaAppEdpMediaGalleryVideoPreview and v58 and v56.items and v56.items[u68] and v56.items[u68].videoId then
				v117 = true
			end

			useMediaGalleryRenderStepWhenVisible(if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else v56.isOccluded, if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else v56.isFullscreen, if not FFlagLuaAppEdpMediaGalleryVideoPreview or not v58 then nil else v117, u83, v115, v116, if not FFlagLuaAppEdpMediaGalleryRedesignIxp then nil else v56.mediaGalleryRedesignEnabledIxp, if not FFlagLuaAppEdpMediaGalleryVideoPreviewIxp then nil else v56.mediaGalleryVideoPreviewEnabledIxp)
		end

		if FFlagLuaAppEdpMediaGalleryFullScreen then
			React.useEffect(function() -- line: 512
				-- upvalues: u57 (ref), u69 (ref), v56 (copy)
				if u57 then
					u69(v56.startIndex or 1)
				end
			end, {
				v56.startIndex,
				u57
			})
		end

		v85 = useBreakpointXOrSmaller(Responsive.Keys.Small)
		v94 = useCursor(CursorType.Invisible)

		local v118 = React.useCallback(function() -- line: 523
			-- upvalues: v56 (copy), u68 (ref)
			if v56.onFullscreenToggleButtonActivated and (v56.items and v56.items[u68]) then
				local v178 = v56.items[u68].videoId ~= nil

				v56.onFullscreenToggleButtonActivated(u68, v178)
			end
		end, {
			v56.onFullscreenToggleButtonActivated,
			u68,
			v56.items
		})
		local v119 = v56.items and (u68 and (v56.items[u68] and v56.items[u68].videoId ~= nil))
		local v120 = React.useCallback(function() -- line: 534
			-- upvalues: v119 (copy), u91 (ref)
			if v119 then
				u91:fire()
			end
		end, {
			u91,
			v119
		})
		local v121 = React.useMemo(function() -- line: 540
			-- upvalues: FocusNavigationEventNameEnum (copy), v56 (copy), v119 (copy), u92 (ref)
			return {
				[Enum.KeyCode.ButtonL1] = FocusNavigationEventNameEnum.TabBackward,
				[Enum.KeyCode.ButtonR1] = FocusNavigationEventNameEnum.TabForward,
				[Enum.KeyCode.ButtonR3] = if not v56.isFullscreen then FocusNavigationEventNameEnum.Fullscreen else FocusNavigationEventNameEnum.ExitFullscreen,
				[Enum.KeyCode.ButtonL3] = if v119 then if not u92 then FocusNavigationEventNameEnum.Mute else FocusNavigationEventNameEnum.Unmute else nil
			}
		end, {
			v56.isFullscreen,
			u92,
			v119
		})
		local v122 = React.useMemo(function() -- line: 553
			-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), u74 (ref), u75 (ref), v118 (copy), v120 (copy)
			return {
				[FocusNavigationEventNameEnum.TabBackward] = {
					handler = InputHandlers.onRelease(u74)
				},
				[FocusNavigationEventNameEnum.TabForward] = {
					handler = InputHandlers.onRelease(u75)
				},
				[FocusNavigationEventNameEnum.Fullscreen] = {
					handler = InputHandlers.onRelease(v118)
				},
				[FocusNavigationEventNameEnum.ExitFullscreen] = {
					handler = InputHandlers.onRelease(v118)
				},
				[FocusNavigationEventNameEnum.Mute] = {
					handler = InputHandlers.onRelease(v120)
				},
				[FocusNavigationEventNameEnum.Unmute] = {
					handler = InputHandlers.onRelease(v120)
				}
			}
		end, {
			u74,
			u75,
			v118,
			v120
		})
		local v123 = ReactFocusNavigation.useEventMap(v121)

		v86 = ReactFocusNavigation.useEventHandlerMap(v122, v123)
	else
		local v124, v125 = React.useBinding(v56.startIndex or 1)

		u70 = v124
		u71 = v125

		function u100(n5: number) -- line: 581
			-- upvalues: v62 (copy), v56 (copy)
			local v180 = v62.X + v56.itemPadding

			return Vector2.new(v180 * (n5 - 1), 0)
		end

		local v126, v127 = React.useBinding(u100(u70:getValue()))

		u103 = v126
		u104 = v127
		React.useEffect(function() -- line: 589
			-- upvalues: u104 (ref), u100 (ref), u70 (ref)
			u104(u100(u70:getValue()))
		end, { v62 })

		function u110(s2: string) -- line: 593
			-- upvalues: u70 (ref), v56 (copy), u71 (ref), u100 (ref), u103 (ref), Otter (copy), u104 (ref), v45 (copy), v65 (copy)
			local v182 = if s2 ~= "Right" then u70:getValue() - 1 else u70:getValue() + 1

			if v182 >= 1 and v182 <= #v56.items then
				u71(v182)

				local v183 = u100(u70:getValue())
				local v184 = u103:getValue()
				local v185 = Otter.createSingleMotor(0)

				v185:onStep(function(n6: number) -- line: 611
					-- upvalues: u104 (ref), v184 (copy), v183 (copy)
					u104(v184:Lerp(v183, n6))
				end)

				if v56.useSpring then
					v185:setGoal(Otter.spring(1, v56.springConfig))
				else
					v185:setGoal(Otter.instant(1))
				end

				v185:onComplete(function() -- line: 621
					-- upvalues: v45 (copy), v65 (copy), v56 (copy)
					if not v45 then
						v65.current = false
					end

					if v56.onSwipe then
						v56.onSwipe()
					end
				end)

				return
			end
		end
		function u111(_, p12) -- line: 632
			-- upvalues: u110 (ref)
			if p12 == Enum.SwipeDirection.Right then
				u110("Left")

				return
			end

			if p12 == Enum.SwipeDirection.Left then
				u110("Right")
			end
		end
		function v112(p13) -- line: 641
			-- upvalues: FFlagLuaAppEdpMediaGalleryHeightJitterFix (copy), u64 (ref), v63 (copy)
			if not FFlagLuaAppEdpMediaGalleryHeightJitterFix or u64(p13.AbsoluteSize.X) then
				v63(p13.AbsoluteSize)
			end
		end
		function u114(p14) -- line: 651
			-- upvalues: v45 (copy), v65 (copy), v56 (copy)
			if not v45 and v65.current then
				return
			end

			if v56.onPreviewActivated then
				return v56.onPreviewActivated(p14)
			end
		end

		if not v45 then
			function v76(_, p16) -- line: 663
				-- upvalues: v65 (copy), v66 (copy)
				if p16.UserInputType == Enum.UserInputType.Touch then
					v65.current = false
					v66.current = p16.Position
				end
			end
			function v77(_, p18) -- line: 670
				-- upvalues: v66 (copy), v65 (copy)
				if p18.UserInputType == Enum.UserInputType.Touch and (v66.current and math.abs(p18.Position.X - v66.current.X) > 50) then
					v65.current = true
				end
			end
			function v78(_, p20) -- line: 679
				-- upvalues: v66 (copy)
				if p20.UserInputType == Enum.UserInputType.Touch then
					v66.current = Vector3.new()
				end
			end
		end
	end

	if v45 then
		React.useEffect(function() -- line: 688
			-- upvalues: UserInputService (copy), u83 (ref), u111 (ref)
			local u196 = false
			local connection = UserInputService.TouchStarted:Connect(function(p21) -- line: 691
				-- upvalues: u83 (ref), u196 (ref)
				local current = u83.current

				if current then
					local AbsolutePosition = current.AbsolutePosition
					local AbsoluteSize = current.AbsoluteSize

					if p21.Position.X >= AbsolutePosition.X and p21.Position.X <= AbsolutePosition.X + AbsoluteSize.X and p21.Position.Y >= AbsolutePosition.Y and p21.Position.Y <= AbsolutePosition.Y + AbsoluteSize.Y then
						u196 = true
					end
				end
			end)
			local connection2 = UserInputService.TouchEnded:Connect(function(_) -- line: 709
				-- upvalues: u196 (ref)
				u196 = false
			end)
			local connection3 = UserInputService.TouchDrag:Connect(function(p23) -- line: 713
				-- upvalues: u196 (ref), u111 (ref)
				if u196 then
					u111(nil, p23)
				end
			end)

			return function() -- line: 719
				-- upvalues: connection (copy), connection2 (copy), connection3 (copy)
				connection:Disconnect()
				connection2:Disconnect()
				connection3:Disconnect()
			end
		end, { u111 })
	end

	local v128 = if not FFlagLuaAppEdpMediaGalleryRedesign then nil else useVisibleMediaGalleryItems(v56.items, u68)
	local v129 = nil

	if FFlagLuaAppEdpMediaGalleryRedesign and u57 then
		local v130 = if not FFlagRenameDeprecatedUIBloxTokens then v59.Global.Size_100 else v59.Size.Size_200
		local v131 = if not v85 then if not FFlagRenameDeprecatedUIBloxTokens then v59.Global.Size_350 else v59.Size.Size_700 else if not FFlagRenameDeprecatedUIBloxTokens then v59.Global.Size_200 else v59.Size.Size_400
		local v132 = if not FFlagRenameDeprecatedUIBloxTokens then v59.Global.Size_500 else v59.Size.Size_1000

		v129 = v130 + v131 + v132
	end

	local t4 = {}

	for v134, v135 in if not FFlagLuaAppEdpMediaGalleryRedesign then v56.items else v128 do
		local u136 = if not FFlagLuaAppEdpMediaGalleryRedesign then v134 else if u68 ~= 1 then u68 - 2 + v134 else v134
		local v137 = "Item" .. u136
		local createElement = React.createElement
		local t5 = {
			LayoutOrder = u136,
			Size = UDim2.new(1, 0, 0, v62.X / v61),
			TextTransparency = 1,
			Text = "",
			BackgroundTransparency = 1,
			AutoButtonColor = false,
			[React.Event.InputBegan] = if not v45 then v76 else nil,
			[React.Event.InputChanged] = if not v45 then v77 else nil,
			[React.Event.InputEnded] = if not v45 then v78 else nil,
			[React.Event.Activated] = if not FFlagLuaAppEdpMediaGalleryRedesign then (not FFlagLuaAppEdpMediaGalleryVideoPreview or (not v58 or not v135.videoId)) and function() -- line: 772
				-- upvalues: u114 (ref), u136 (ref)
				u114(u136)
			end or nil else nil,
			[React.Event.TouchSwipe] = if not v45 then u111 else nil,
			Selectable = not u57 and nil
		}
		local t6 = {}
		local v141

		if FFlagLuaAppEdpMediaGalleryVideoPreview and v58 and v135.videoId then
			v141 = nil
		else
			local createElement2 = React.createElement
			local v143 = LoadableImage
			local t7 = {
				BackgroundTransparency = 1,
				ZIndex = 1,
				useShimmerAnimationWhileLoading = true,
				cornerRadius = v56.borderRadius,
				Size = UDim2.fromScale(1, 1)
			}
			local v147

			if u57 then
				local imageId = v135.imageId
				local v146 = string.find(imageId, "http://www.roblox.com/asset/?id=", 1, true)

				v147 = if not v146 or v146 ~= 1 then imageId else `rbxthumb://type=Asset&id={ string.sub(imageId, 33) }&w=768&h=432`
			else
				v147 = v135.imageId
			end

			t7.Image = v147
			t7.ScaleType = Enum.ScaleType.Crop
			t7.loadingStrategy = if not FFlagLuaAppEdpMediaGalleryPreloadImage then nil else LoadingStrategy.Eager
			v141 = createElement2(v143, t7)
		end

		t6.Image = v141
		t6.Video = if not FFlagLuaAppEdpMediaGalleryVideoPreview or (not v58 or not v135.videoId) then nil else React.createElement(MediaGalleryVideoItem, {
			ZIndex = 1,
			video = v135.videoId,
			thumbnail = v135.imageId,
			Size = UDim2.fromScale(1, 1),
			cornerRadius = v56.borderRadius.Offset,
			itemIndex = u136,
			isFullscreen = if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else v56.isFullscreen,
			isMediaGalleryOccluded = if not FFlagLuaAppEdpMediaGalleryFullScreen then nil else v56.isOccluded,
			videoPlaybackCoordinator = v56.videoPlaybackCoordinator,
			onVideoProgressChanged = if not FFlagLuaAppEdpMediaGalleryAutoAdvance then nil else u82,
			onVideoEnded = if not FFlagLuaAppEdpMediaGalleryAutoAdvance then nil else v84,
			videoAnalytics = v56.videoAnalytics,
			universeId = v56.universeId,
			toggleVideoPlaybackSignal = if u136 ~= u68 then nil else u90,
			toggleMuteSignal = if u136 ~= u68 then nil else u91,
			onMutedChanged = if u136 ~= u68 then nil else v93
		})
		t6.GradientOverlay = if not FFlagLuaAppEdpMediaGalleryRedesign or not u57 then nil else if not FFlagLuaAppEdpMediaGalleryVideoPreview or (not v58 or not v135.videoId) then React.createElement("Frame", {
			BorderSizePixel = 0,
			ZIndex = 2,
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, 0, 0, v129),
			BackgroundColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then v59.Global.Color.Black else v59.Color.Extended.Black.Black_100)).Color3
		}, {
			Gradient = React.createElement("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(1, 0.2)
				})
			}),
			UICorner = React.createElement("UICorner", {
				CornerRadius = v56.borderRadius
			})
		}) else nil
		t6.PlayButton = if not v135.isYouTubeVideo then nil else React.createElement("TextButton", {
			Size = UDim2.new(0, 60, 0, 45),
			AnchorPoint = Vector2.new(1, 1),
			Position = UDim2.new(1, -v60, 1, -v60),
			TextTransparency = 1,
			Text = "",
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 0.5,
			ZIndex = (not FFlagLuaAppEdpMediaGalleryRedesign or not u57) and 2 or 3,
			[React.Event.Activated] = function() -- line: 853
				-- upvalues: v56 (copy), u136 (ref)
				if v56.onVideoPlayActivated then
					v56.onVideoPlayActivated(u136)
				end
			end
		}, {
			PlayButtonCorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			}),
			PlayIcon = React.createElement(ImageSetLabel, {
				BackgroundTransparency = 1,
				ZIndex = 2,
				Size = UDim2.fromOffset(26, 26),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Image = Images["icons/common/play"]
			})
		})
		t6.FullscreenButton = if not FFlagLuaAppEdpMediaGalleryFullScreen or (not u57 or not v56.onFullscreenToggleButtonActivated) then nil else React.createElement(RoundIconButton, {
			ZIndex = 3,
			Selectable = false,
			icon = not v56.isFullscreen and "two-arrows-from-center" or "two-arrows-to-center",
			onActivated = function() -- line: 877
				-- upvalues: v56 (copy), u136 (ref), v135 (copy)
				v56.onFullscreenToggleButtonActivated(u136, v135.videoId ~= nil)
			end,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -if not FFlagRenameDeprecatedUIBloxTokens then v59.Global.Space_250 else v59.Size.Size_500, 0, if not FFlagRenameDeprecatedUIBloxTokens then v59.Global.Space_250 else v59.Size.Size_500)
		})
		t4[v137] = createElement("TextButton", t5, t6)
	end

	local v148, v149

	if v62.X < 500 then
		v148 = if not FFlagRenameDeprecatedUIBloxTokens then v59.Global.Space_300 else v59.Size.Size_600
		v149 = if not FFlagRenameDeprecatedUIBloxTokens then v59.Global.Space_100 else v59.Size.Size_200
	else
		v148 = if not FFlagRenameDeprecatedUIBloxTokens then v59.Global.Space_400 else v59.Size.Size_800
		v149 = if not FFlagRenameDeprecatedUIBloxTokens then v59.Global.Space_200 else v59.Size.Size_400
	end

	local v150 = if not v56.showCounter or not not FFlagLuaAppEdpMediaGalleryRedesign and u57 then nil else React.createElement("TextLabel", {
		BackgroundTransparency = 1,
		RichText = true,
		LineHeight = 1,
		Size = UDim2.fromScale(0, 1),
		AutomaticSize = Enum.AutomaticSize.X,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Text = if not FFlagLuaAppEdpMediaGalleryRedesign then u70:map(function(p24) -- line: 913
			-- upvalues: v56 (copy)
			return `<b>{ p24 } / { #v56.items }</b>`
		end) else `<b>{ u68 } / { #v56.items }</b>`,
		Font = if not FFlagRenameDeprecatedUIBloxTokens then v59.Semantic.Typography.CaptionHeader.Font else v59.Typography.CaptionLarge.Font,
		TextSize = if not FFlagRenameDeprecatedUIBloxTokens then v59.Semantic.Typography.CaptionHeader.FontSize else v59.FontSize.FontSize_300,
		TextColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then v59.Semantic.Color.Text.Emphasis else v59.Color.Content.Emphasis)).Color3,
		TextTransparency = ((if not FFlagRenameDeprecatedUIBloxTokens then v59.Semantic.Color.Text.Emphasis else v59.Color.Content.Emphasis)).Transparency,
		ref = v67
	})

	return React.createElement((not FFlagLuaAppEdpMediaGalleryRedesign or not u57) and "Frame" or "TextButton", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ref = v86,
		AutoButtonColor = (not FFlagLuaAppEdpMediaGalleryRedesign or not u57) and nil,
		Text = if not FFlagLuaAppEdpMediaGalleryRedesign or not u57 then nil else "",
		[React.Event.Activated] = if not FFlagLuaAppEdpMediaGalleryRedesign or not u57 then nil else u114,
		SelectionBehaviorRight = if not FFlagLuaAppEdpMediaGalleryRedesign or not u57 then nil else Enum.SelectionBehavior.Stop,
		SelectionImageObject = if not FFlagLuaAppEdpMediaGalleryRedesign or (not u57 or not v56.isFullscreen) then nil else v94,
		SelectionGroup = FFlagLuaAppEdpMediaGalleryRedesign and not not u57 or nil
	}, {
		ScrollingFrame = React.createElement("ScrollingFrame", {
			Selectable = false,
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.new(1, 0, 0, v62.X / v61),
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			CanvasPosition = u103,
			ScrollingEnabled = false,
			ScrollBarImageTransparency = 1,
			ScrollBarThickness = if not FFlagLuaAppEdpMediaGalleryRedesign or (not u57 or not v56.clipsNonCurrentItems) then nil else 0,
			ScrollingDirection = Enum.ScrollingDirection.X,
			ClipsDescendants = not not FFlagLuaAppEdpMediaGalleryRedesign and (not not u57 and v56.clipsNonCurrentItems),
			ZIndex = 1,
			[React.Change.AbsoluteSize] = v112,
			ref = if not FFlagLuaAppEdpMediaGalleryAutoAdvance and not v45 then nil else u83
		}, {
			Layout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, v56.itemPadding)
			}),
			Items = React.createElement(React.Fragment, {}, t4)
		}),
		Counter = if not v56.showCounter or not not FFlagLuaAppEdpMediaGalleryRedesign and u57 then nil else React.createElement("Frame", {
			BackgroundTransparency = 0.3,
			BorderSizePixel = 0,
			ZIndex = 2,
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.new(0.5, 0, 1, -v60),
			Size = UDim2.fromOffset((v67.current and v67.current.AbsoluteSize.X or 0) + v149 * 2, v148),
			BackgroundColor3 = ((if not FFlagRenameDeprecatedUIBloxTokens then v59.Semantic.Color.Background.Default else v59.Color.Surface.Surface_0)).Color3
		}, {
			TextLabel = v150,
			Corner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			})
		}),
		PageIndicators = if not FFlagLuaAppEdpMediaGalleryRedesign or (not u57 or (not v44 or (not (#v56.items > 1) or not not FFlagLuaAppEdpMediaGalleryFullScreen and v56.isFullscreen))) then nil else React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			AnchorPoint = Vector2.new(0.5, 1),
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.fromOffset(0, if not FFlagRenameDeprecatedUIBloxTokens then v59.Global.Size_100 else v59.Size.Size_200),
			Position = UDim2.new(0.5, 0, 1, if not v85 then -if not FFlagRenameDeprecatedUIBloxTokens then v59.Global.Size_350 else v59.Size.Size_700 else -if not FFlagRenameDeprecatedUIBloxTokens then v59.Global.Size_200 else v59.Size.Size_400)
		}, {
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, v89),
				VerticalAlignment = Enum.VerticalAlignment.Center
			}),
			PageLeftGamepadIcon = if not v87 then nil else React.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = -1,
				Image = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonL1),
				ImageTransparency = if not (u68 <= 1) then nil else 0.5,
				Size = UDim2.fromOffset(v88, v88)
			}),
			Indicators = React.createElement(MediaGalleryPageIndicators, {
				numberOfItems = #v56.items,
				mediaGalleryStartIndex = v56.startIndex or 1,
				currentItemProgressBinding = if not FFlagLuaAppEdpMediaGalleryAutoAdvance then nil else v81,
				mediaGalleryScrolledSignal = u72.current,
				useSpring = v56.useSpring,
				springConfig = v56.springConfig
			}),
			PageRightGamepadIcon = if not v87 then nil else React.createElement("ImageLabel", {
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Image = UserInputService:GetImageForKeyCode(Enum.KeyCode.ButtonR1),
				ImageTransparency = if not (#v56.items <= u68) then nil else 0.5,
				Size = UDim2.fromOffset(v88, v88)
			})
		}),
		ScrollButtons = if not FFlagLuaAppEdpMediaGalleryRedesign or (not u57 or not v73) then nil else React.createElement(CarouselScrollButtons, {
			ZIndex = 10,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Size = UDim2.new(1, if not FFlagLuaAppEdpMediaGalleryFullScreen or not v56.isFullscreen then if not FFlagRenameDeprecatedUIBloxTokens then v59.Global.Size_500 else v59.Size.Size_1000 else 0, 1, 0),
			buttonOffsetFromEdge = if not FFlagLuaAppEdpMediaGalleryFullScreen or not v56.isFullscreen then nil else if not FFlagRenameDeprecatedUIBloxTokens then v59.Global.Space_250 else v59.Size.Size_500,
			leftScrollingEnabled = u68 > 1,
			rightScrollingEnabled = u68 < #v56.items,
			handleScrollLeft = u74,
			handleScrollRight = u75
		}),
		SizeConstraint = React.createElement("UISizeConstraint", {
			MinSize = Vector2.new(if not FFlagFixMediaGalleryOversized then v62.X else 0, v62.X / v61)
		})
	})
end

if FFlagLuaAppEdpMediaGalleryVideoPreview then
	return (React.memo(MediaGallerySnapping))
end

return MediaGallerySnapping
