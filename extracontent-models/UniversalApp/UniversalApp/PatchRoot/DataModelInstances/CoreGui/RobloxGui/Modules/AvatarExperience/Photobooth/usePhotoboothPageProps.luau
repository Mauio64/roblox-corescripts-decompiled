local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local CaptureService = game:GetService("CaptureService")
local Players = game:GetService("Players")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local RobloxAppHooks = require(CorePackages.Workspace.Packages.RobloxAppHooks)
local PermissionsProtocol = require(CorePackages.Workspace.Packages.PermissionsProtocol).PermissionsProtocol
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useTokens = Foundation.Hooks.useTokens
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useTopBarHeight = RobloxAppHooks.useTopBarHeight
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local ClearTryOns = require(CorePackages.Workspace.Packages.AvatarExperienceRodux).Actions.ClearTryOns
local ClearAnimationPreview = require(Modules.AvatarExperience.Common.Actions.ClearAnimationPreview)
local MenuItemEnum = require(CorePackages.Workspace.Packages.AvatarExperienceControlBar).Enums.MenuItemEnum
local SetCurrentToastMessage = require(Modules.LuaApp.Actions.SetCurrentToastMessage)
local RemoveCurrentToastMessage = require(Modules.LuaApp.Actions.RemoveCurrentToastMessage)
local ToastType = require(Modules.LuaApp.Enum.ToastType)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXPhotoboothCaptureServiceScreenshot = AvatarExperienceFlags.FFlagAXPhotoboothCaptureServiceScreenshot
local FFlagAXPhotoboothBugBashFixes = AvatarExperienceFlags.FFlagAXPhotoboothBugBashFixes
local FFlagAXPhotoboothShareModal = AvatarExperienceFlags.FFlagAXPhotoboothShareModal
local EngineFeature = game:GetEngineFeature("CaptureAllowedInUA")

local function selectAvatarType(p1) -- line: 46
	return p1.AvatarExperience.AvatarEditor.Character.AvatarType
end
local function usePhotoboothPageProps() -- line: 50
	-- upvalues: useTokens (copy), useNavigation (copy), useDispatch (copy), RoactGamepad (copy), useSelector (copy), selectIsPortrait (copy), FFlagAXPhotoboothBugBashFixes (copy), selectAvatarType (copy), useTopBarHeight (copy), UserInputService (copy), useLocalization (copy), React (copy), ClearTryOns (copy), ClearAnimationPreview (copy), MenuItemEnum (copy), Constants (copy), AvatarScreen (copy), SetCurrentToastMessage (copy), ToastType (copy), RemoveCurrentToastMessage (copy), CoreGui (copy), CaptureService (copy), FFlagAXPhotoboothShareModal (copy), Players (copy), PermissionsProtocol (copy), FFlagAXPhotoboothCaptureServiceScreenshot (copy), EngineFeature (copy)
	local v36 = useTokens()
	local v37 = useNavigation()
	local v38 = useDispatch()
	local v39 = RoactGamepad.useRootFocusController()
	local v40 = useSelector(selectIsPortrait)
	local v41 = if not FFlagAXPhotoboothBugBashFixes then nil else useSelector(selectAvatarType)
	local v42 = useTopBarHeight()
	local Platform = UserInputService:GetPlatform()
	local v44 = useLocalization({
		PhotoPermissionTitle = "Feature.Captures.Title.AllowPhotoAccessInfo",
		PhotoPermissionLabel = "Feature.Captures.Description.AllowPhotoAccessInfo",
		ScreenshotToastTitle = "Feature.Captures.Toast.CaptureSaved",
		ScreenshotToastLabel = "Feature.Captures.Toast.CaptureSavedToDevice"
	})

	React.useEffect(function() -- line: 66
		-- upvalues: v38 (copy), ClearTryOns (copy), ClearAnimationPreview (copy)
		v38(ClearTryOns())
		v38(ClearAnimationPreview())

		return function() -- line: 71
			-- upvalues: v38 (copy), ClearTryOns (copy), ClearAnimationPreview (copy)
			v38(ClearTryOns())
			v38(ClearAnimationPreview())
		end
	end, {})

	local v45 = React.useCallback(function() -- line: 78
		-- upvalues: v37 (copy)
		v37.pop()
	end, { v37 })
	local v46, v47 = React.useState("")
	local v48, v49 = React.useState(false)
	local v50, v51 = React.useState(nil)

	local function updateScreenshotPath(s1: string?) -- line: 89
		-- upvalues: v51 (copy)
		v51(s1)
	end

	local v53 = React.useCallback(function() -- line: 93
		-- upvalues: v49 (copy), v51 (copy)
		v49(false)
		v51(nil)
	end, {})
	local v54 = React.useRef(nil)
	local v55 = React.useRef(false)
	local v56 = React.useRef(nil)
	local v57 = React.useCallback(function() -- line: 107
		-- upvalues: v54 (copy), v56 (copy)
		if v54.current then
			if not v56.current then
				v56.current = game:GetService("TweenService"):Create(v54.current, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundTransparency = 1
				})
			end

			if v56.current then
				v56.current:Cancel()
				v54.current.BackgroundTransparency = 0
				v56.current:Play()
			end
		end
	end, {})
	local v58 = React.useCallback(function(p2) -- line: 129
		-- upvalues: FFlagAXPhotoboothBugBashFixes (copy), MenuItemEnum (copy), v41 (copy), Constants (copy), v37 (copy), AvatarScreen (copy), v47 (copy), v46 (copy)
		if FFlagAXPhotoboothBugBashFixes and (p2 == MenuItemEnum.Photobooth.Animations and v41 == Constants.AvatarType.R6) then
			v37.navigate(AvatarScreen.R15UpgradePrompt, {
				bodyTextKey = "Feature.Avatar.Message.R15AnimationsPrompt",
				onSwitchSelected = function() -- line: 139
					-- upvalues: v47 (copy), MenuItemEnum (copy)
					v47(MenuItemEnum.Photobooth.Animations)
				end
			})

			return
		end

		if p2 == v46 then
			v47("")

			return
		end

		v47(p2)
	end, if not FFlagAXPhotoboothBugBashFixes then { v46 } else {
		v46,
		v41,
		v37
	})
	local v59 = React.useMemo(function() -- line: 159
		-- upvalues: MenuItemEnum (copy), v58 (copy), v46 (copy)
		return {
			{
				type = "icon",
				icon = "icons/controls/emoteOff",
				id = MenuItemEnum.Photobooth.Animations,
				onActivated = function() -- line: 165
					-- upvalues: v58 (copy), MenuItemEnum (copy)
					v58(MenuItemEnum.Photobooth.Animations)
				end,
				isActive = v46 == MenuItemEnum.Photobooth.Animations
			},
			{
				type = "icon",
				icon = "icons/common/image-off",
				id = MenuItemEnum.Photobooth.Scenes,
				onActivated = function() -- line: 174
					-- upvalues: v58 (copy), MenuItemEnum (copy)
					v58(MenuItemEnum.Photobooth.Scenes)
				end,
				isActive = v46 == MenuItemEnum.Photobooth.Scenes
			}
		}
	end, if not FFlagAXPhotoboothBugBashFixes then { v58 } else {
		v58,
		v46
	})
	local v60 = React.useCallback(function() -- line: 186
		-- upvalues: v38 (copy), SetCurrentToastMessage (copy), v44 (copy), ToastType (copy)
		v38(SetCurrentToastMessage({
			isLocalized = true,
			toastMessage = v44.PhotoPermissionTitle,
			toastSubMessage = v44.PhotoPermissionLabel,
			toastType = ToastType.InformationMessage
		}))
	end, {
		v44,
		v38
	})
	local v61 = if not FFlagAXPhotoboothBugBashFixes then nil else React.useCallback(function() -- line: 196
		-- upvalues: v38 (copy), SetCurrentToastMessage (copy), v44 (copy), ToastType (copy)
		v38(SetCurrentToastMessage({
			isLocalized = true,
			toastMessage = v44.ScreenshotToastTitle,
			toastSubMessage = v44.ScreenshotToastLabel,
			toastType = ToastType.InformationMessage
		}))
	end, {
		v44,
		v38
	})
	local v62 = React.useCallback(function() -- line: 208
		-- upvalues: v55 (copy), FFlagAXPhotoboothBugBashFixes (copy), v38 (copy), RemoveCurrentToastMessage (copy), CoreGui (copy), UserInputService (copy), Platform (copy), CaptureService (copy), v57 (copy), FFlagAXPhotoboothShareModal (copy), Players (copy), v51 (copy), v49 (copy), v61 (copy)
		task.spawn(function() -- line: 209
			-- upvalues: v55 (copy), FFlagAXPhotoboothBugBashFixes (copy), v38 (copy), RemoveCurrentToastMessage (copy), CoreGui (copy), UserInputService (copy), Platform (copy), CaptureService (copy), v57 (copy), FFlagAXPhotoboothShareModal (copy), Players (copy), v51 (copy), v49 (copy), v61 (copy)
			if v55.current then
				return
			end

			v55.current = true

			local t1 = {}

			if FFlagAXPhotoboothBugBashFixes then
				v38(RemoveCurrentToastMessage())

				local PageWrapper = CoreGui:FindFirstChild("PageWrapper")

				if PageWrapper then
					local AppContainer = PageWrapper:FindFirstChild("AppContainer")

					if AppContainer then
						for _, child in pairs(AppContainer:GetChildren()) do
							if child.Name == "Toast" and child:IsA("ScreenGui") then
								child.Enabled = false
								table.insert(t1, child)
							end
						end
					end
				end
			end

			local LuaAppScreenGui = CoreGui:FindFirstChild("LuaAppScreenGui")

			if LuaAppScreenGui then
				LuaAppScreenGui.Enabled = false
			end

			local MouseIconEnabled = UserInputService.MouseIconEnabled

			UserInputService.MouseIconEnabled = false
			task.spawn(function() -- line: 242
				-- upvalues: Platform (copy), CaptureService (copy), LuaAppScreenGui (copy), UserInputService (copy), MouseIconEnabled (copy), v57 (copy), FFlagAXPhotoboothBugBashFixes (copy), t1 (copy), FFlagAXPhotoboothShareModal (copy), Players (copy), v51 (copy), v49 (copy), v61 (copy), v55 (copy)
				local v84 = game.ScreenshotReady:Wait()

				if Platform == Enum.Platform.Android then
					CaptureService:SaveCaptureToExternalStorage(v84)
				end

				if LuaAppScreenGui then
					LuaAppScreenGui.Enabled = true
				end

				UserInputService.MouseIconEnabled = MouseIconEnabled
				v57()

				if FFlagAXPhotoboothBugBashFixes then
					for _, v86 in t1 do
						if v86.Parent and v86:IsA("ScreenGui") then
							v86.Enabled = true
						end
					end

					table.clear(t1)
				end

				if FFlagAXPhotoboothShareModal and Players.LocalPlayer and Players.LocalPlayer:GetUnder13() == false then
					v51(v84)
					v49(true)
				end

				if v61 then
					v61()
				end

				v55.current = false
			end)
			CoreGui:TakeScreenshot()
		end)
	end, {
		v57,
		v60,
		Platform
	})
	local v63 = React.useCallback(function() -- line: 289
		-- upvalues: v55 (copy), FFlagAXPhotoboothBugBashFixes (copy), v38 (copy), RemoveCurrentToastMessage (copy), CoreGui (copy), UserInputService (copy), CaptureService (copy), v57 (copy), FFlagAXPhotoboothShareModal (copy), Players (copy), v51 (copy), v49 (copy), v61 (copy)
		task.spawn(function() -- line: 290
			-- upvalues: v55 (copy), FFlagAXPhotoboothBugBashFixes (copy), v38 (copy), RemoveCurrentToastMessage (copy), CoreGui (copy), UserInputService (copy), CaptureService (copy), v57 (copy), FFlagAXPhotoboothShareModal (copy), Players (copy), v51 (copy), v49 (copy), v61 (copy)
			if v55.current then
				return
			end

			v55.current = true

			local t2 = {}

			if FFlagAXPhotoboothBugBashFixes then
				v38(RemoveCurrentToastMessage())

				local PageWrapper = CoreGui:FindFirstChild("PageWrapper")

				if PageWrapper then
					local AppContainer = PageWrapper:FindFirstChild("AppContainer")

					if AppContainer then
						for _, child in pairs(AppContainer:GetChildren()) do
							if child.Name == "Toast" and child:IsA("ScreenGui") then
								child.Enabled = false
								table.insert(t2, child)
							end
						end
					end
				end
			end

			local LuaAppScreenGui = CoreGui:FindFirstChild("LuaAppScreenGui")

			if LuaAppScreenGui then
				LuaAppScreenGui.Enabled = false
			end

			local MouseIconEnabled = UserInputService.MouseIconEnabled

			UserInputService.MouseIconEnabled = false
			CaptureService:CaptureScreenshot(function(p3) -- line: 322
				-- upvalues: v57 (copy), LuaAppScreenGui (copy), UserInputService (copy), MouseIconEnabled (copy), v55 (copy), CaptureService (copy), FFlagAXPhotoboothBugBashFixes (copy), t2 (copy), FFlagAXPhotoboothShareModal (copy), Players (copy), v51 (copy), v49 (copy), v61 (copy)
				v57()

				local thread = task.delay(10, function() -- line: 325
					-- upvalues: LuaAppScreenGui (copy), UserInputService (copy), MouseIconEnabled (copy), v55 (copy)
					if LuaAppScreenGui then
						LuaAppScreenGui.Enabled = true
					end

					UserInputService.MouseIconEnabled = MouseIconEnabled
					v55.current = false
				end)

				task.spawn(function() -- line: 333
					-- upvalues: CaptureService (copy), p3 (copy), thread (ref), LuaAppScreenGui (copy), FFlagAXPhotoboothBugBashFixes (copy), t2 (copy), FFlagAXPhotoboothShareModal (copy), Players (copy), v51 (copy), v49 (copy), v61 (copy), UserInputService (copy), MouseIconEnabled (copy), v55 (copy)
					local ok, result = pcall(function() -- line: 334
						-- upvalues: CaptureService (copy), p3 (copy)
						return CaptureService:GetCaptureFilePathAsync(p3)
					end)

					if thread then
						task.cancel(thread)
						thread = nil
					end

					if ok and result then
						CaptureService:SaveCaptureToExternalStorage(result)
					end

					if LuaAppScreenGui then
						LuaAppScreenGui.Enabled = true
					end

					if FFlagAXPhotoboothBugBashFixes then
						for _, v94 in t2 do
							if v94.Parent and v94:IsA("ScreenGui") then
								v94.Enabled = true
							end
						end

						table.clear(t2)
					end

					if FFlagAXPhotoboothShareModal and Players.LocalPlayer and Players.LocalPlayer:GetUnder13() == false then
						v51(result)
						v49(true)
					end

					if v61 then
						v61()
					end

					UserInputService.MouseIconEnabled = MouseIconEnabled
					v55.current = false
				end)
			end)
		end)
	end, {
		v57,
		v60,
		Platform
	})
	local v64 = React.useCallback(function() -- line: 380
		-- upvalues: Platform (copy), PermissionsProtocol (copy), v62 (copy), v60 (copy), FFlagAXPhotoboothCaptureServiceScreenshot (copy), EngineFeature (copy), v63 (copy)
		if Platform == Enum.Platform.IOS or Platform == Enum.Platform.Android then
			PermissionsProtocol.default:hasPermissions({ PermissionsProtocol.Permissions.WRITE_MEDIA_STORAGE }):andThen(function(p4) -- line: 388
				-- upvalues: PermissionsProtocol (copy), v62 (copy), v60 (copy)
				if p4.status == PermissionsProtocol.Status.AUTHORIZED then
					v62()

					return
				end

				PermissionsProtocol.default:requestPermissions({ PermissionsProtocol.Permissions.WRITE_MEDIA_STORAGE }):andThen(function(p5) -- line: 398
					-- upvalues: PermissionsProtocol (copy), v62 (copy), v60 (copy)
					if p5.status == PermissionsProtocol.Status.AUTHORIZED or p5.status == PermissionsProtocol.Status.UNSUPPORTED then
						v62()

						return
					end

					v60()
				end):catch(function(p6) -- line: 409
					-- upvalues: v60 (copy)
					warn("Permission request failed:", p6)
					v60()
				end)
			end):catch(function(p7) -- line: 415
				-- upvalues: v60 (copy)
				warn("Permission check failed:", p7)
				v60()
			end)

			return
		end

		if FFlagAXPhotoboothCaptureServiceScreenshot and EngineFeature then
			v63()

			return
		end

		v62()
	end, {
		v62,
		v60
	})
	local v65 = React.useMemo(function() -- line: 429
		-- upvalues: MenuItemEnum (copy), v58 (copy), v64 (copy)
		return {{
			type = "icon",
			icon = "icons/controls/screenshot",
			isActive = false,
			id = MenuItemEnum.Photobooth.Screenshot,
			onActivated = function() -- line: 435
				-- upvalues: v58 (copy), v64 (copy)
				v58("")
				v64()
			end
		}}
	end, {
		v58,
		v64
	})

	return {
		tokens = v36,
		isPortrait = v40,
		topBarHeight = v42,
		onBackButtonPressed = v45,
		focusController = v39,
		firstMenuItems = v59,
		secondMenuItems = v65,
		activeMenuItemId = v46,
		onMenuItemActivated = v58,
		flashRef = v54,
		isShareModalVisible = v48,
		screenshotPath = v50,
		onShareModalClose = v53
	}
end

return usePhotoboothPageProps
