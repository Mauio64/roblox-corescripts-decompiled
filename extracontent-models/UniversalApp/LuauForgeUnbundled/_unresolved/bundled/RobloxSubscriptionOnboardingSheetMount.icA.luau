local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local Signals = require(CorePackages.Packages.Signals)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module = require("@luauforge/bundled/dSY")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module2 = require("@luauforge/bundled/icB")
local default = require("@luauforge/bundled/bZe").LinkingProtocol.default

local module3 = require("@luauforge/bundled/dFu")
local module4 = require("@luauforge/bundled/ghP")
local module5 = require("@luauforge/bundled/gOQ")
local module6 = require("@luauforge/bundled/fBQ")
local module7 = require("@luauforge/bundled/fHu")
local module8 = require("@luauforge/bundled/fBO")
local module9 = require("@luauforge/bundled/fHx")
local module10 = require("@luauforge/bundled/fHi")
local module11 = require("@luauforge/bundled/fHg")
local module12 = require("@luauforge/bundled/dKL")
local module13 = require("@luauforge/bundled/fJq")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local colorMode = Foundation.Enums.ColorMode
local useTokens = Foundation.Hooks.useTokens

local useSignalState = SignalsReact.useSignalState

local fFlagEditProfileFramesEnabled = module13
	and SharedFlags.FFlagEditProfileImageV2Enabled
	and SharedFlags.FFlagEditProfileFramesEnabled

local function openDeepLink(p2, callback)
	default:isURLRegistered(p2):andThen(function(p3)
		if not p3 then
			callback()
			return
		end

		if not default:isInternalDlicEnabled() then
			default:detectURL(p2)

			return
		end

		default:detectDeeplinkIntent((default:createInternalDlic(p2, default.DeepLinkSource.LuaInternal)))
	end)
end

local themeKeys = {}

for k, category in module9.Categories do
	if category.id == module9.Category.Special then
		continue
	end

	for k2, themeKey in category.themeKeys do
		table.insert(themeKeys, themeKey)
	end
end

local labels = {}

for k, label in module6.Labels do
	labels[k] = label
end

local function RobloxSubscriptionOnboardingSheetMount(p2)
	local onClose = p2.onClose
	local v5 = useDispatch()
	local v6 = module8(false)
	local v7 = useSignalState(v6.getColorThemeKey)
	local v8 = useSignalState(v6.getWriteStatus) == "Pending"
	local v9 = module10()
	local v10 = useLocalization(labels)
	local v11 = useTokens().Config.ColorMode.Name == colorMode.Light

	local v12 = module11()
	local hasRobloxPlusSubscription = v12.hasRobloxPlusSubscription
	local canSeeExclusiveThemes = v12.canSeeExclusiveThemes

	local v13 = hasRobloxPlusSubscription and canSeeExclusiveThemes
	local v15 = useSignalState((React.useMemo(function()
		local userSettingsStore = module.UserSettings.getUserSettingsStore(false)
		return Signals.createComputed(function(p3)
			return {
				status = userSettingsStore.getAccountThemeStatus(p3),
				themeKey = userSettingsStore.getAccountTheme(p3)
			}
		end)
	end, {})))
	local v16 = v13 and v15.status ~= "NotReady"

	local state, setState = React.useState(false)
	React.useEffect(function()
		if not v16 then
			return nil
		end

		local thread = task.delay(1, setState, true)
		return function()
			task.cancel(thread)
		end
	end, { v16 })

	local v17 = not v13 or v16 and (v15.themeKey == nil or (v15.themeKey == v7 or state))

	local ref = React.useRef(false)

	if hasRobloxPlusSubscription and v17 then
		ref.current = true
	end

	local v18 = React.useMemo(function()
		return {
			currentKey = v7,
			shuffleKeys = not canSeeExclusiveThemes and {} or themeKeys,
			getLabel = function(p3)
				return v10[p3] or p3
			end,
			getSwatchColor = function(p3)
				return module7.get(p3, v11)
			end,
			isSaving = v8,
			showsThemes = canSeeExclusiveThemes,
			previewTheme = function(p3)
				if not canSeeExclusiveThemes or labels[p3] == nil then
					return
				end

				v6.setColorThemeKey(p3)
			end,
			equipTheme = function(p3, p4)
				if not canSeeExclusiveThemes or labels[p3] == nil or labels[p4] == nil then
					return
				end

				v6.setColorThemeKey(p4)
				v9(p3)
			end
		}
	end, { v6, v7, v8, v9, v10, v11, canSeeExclusiveThemes })

	local v19 = React.useCallback(function()
		onClose()
		local function fn()
			local v24 = if module12 then module3.Home else module3.More
			v5(module4({
				{ name = v24 },
				{ name = module3.Settings },
				{ name = module3.Accessibility }
			}, true))
		end

		local v20 = "roblox://navigation/device_preferences?callback=roblox%3A%2F%2Fnavigation%2Fplus_onboarding"
		default:isURLRegistered("roblox://navigation/device_preferences?callback=roblox%3A%2F%2Fnavigation%2Fplus_onboarding"):andThen(function(p3)
			if not p3 then
				fn()
				return
			end

			if not default:isInternalDlicEnabled() then
				default:detectURL(v20)

				return
			end

			default:detectDeeplinkIntent((default:createInternalDlic(
				v20,
				default.DeepLinkSource.LuaInternal
			)))
		end)
	end, { v5, onClose })

	local v20 = React.useCallback(function(p3)
		onClose()
		local function navigateDirectly()
			v5(module5(
				avatarScreen.EditProfileImage,
				{ mode = "framesOnly", initialFrameAssetId = p3 },
				true
			))
		end

		if not fFlagEditProfileFramesEnabled then
			v5(module5(
				avatarScreen.EditProfileImage,
				{ mode = "framesOnly", initialFrameAssetId = p3 },
				true
			))

			return
		end

		local v21 = "roblox://navigation/avatar_profile_frames?callback=roblox%3A%2F%2Fnavigation%2Fplus_onboarding"

		if p3 then
			v21 ..= "&frameassetid=" .. p3
		end

		default:isURLRegistered(v21):andThen(function(p4)
			if not p4 then
				navigateDirectly()
				return
			end

			if not default:isInternalDlicEnabled() then
				default:detectURL(v21)

				return
			end

			default:detectDeeplinkIntent((default:createInternalDlic(
				v21,
				default.DeepLinkSource.LuaInternal
			)))
		end)
	end, { v5, onClose })

	if ref.current then
		return React.createElement(module2.RobloxSubscriptionOnboardingSheetContainer, {
			theme = v18,
			onClose = onClose,
			onAppThemesActivated = v19,
			onProfileFramesActivated = v20
		})
	end

	return nil
end

return RobloxSubscriptionOnboardingSheetMount
