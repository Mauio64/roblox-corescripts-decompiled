local Chrome = script:FindFirstAncestor("Chrome")

local CorePackages = game:GetService("CorePackages")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

local React = require(CorePackages.Packages.React)
local Service = require(Chrome.Service)
local ChromeUtils = require(Chrome.ChromeShared.Service.ChromeUtils)
local MappedSignal = ChromeUtils.MappedSignal
local WindowSizeSignal = require(Chrome.ChromeShared.Service.WindowSizeSignal)
local Constants = require(Chrome.ChromeShared.Unibar.Constants)
local AvatarSwitcherChromeWrapper = require(Chrome.Integrations.AvatarSwitcher.AvatarSwitcherChromeWrapper)
local AvatarSwitcherIcon = require(Chrome.Integrations.AvatarSwitcher.AvatarSwitcherIcon)
local Http = require(CorePackages.Workspace.Packages.Http)
local Url = Http.Url

local Chrome2 = require(CorePackages.Workspace.Packages.Chrome)
local SideSheetPlacement = Chrome2.Enums.SideSheetPlacement

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagChromeWindowSignalConstraintsToggle = SharedFlags.FFlagChromeWindowSignalConstraintsToggle
local FFlagRemoveAvatarSwitcherIfUnsupported = SharedFlags.FFlagRemoveAvatarSwitcherIfUnsupported
local FFlagAvatarWorkshopReplacesAvatarSwitcher = SharedFlags.FFlagAvatarWorkshopReplacesAvatarSwitcher

local v = MappedSignal.new(Service:onIntegrationStatusChanged(), function()
	return Service:isWindowOpen(Constants.AVATAR_SWITCHER_ID)
end)
local v2

if FFlagRemoveAvatarSwitcherIfUnsupported then
	v2 = Url.AVATAR_URL .. "v2/avatar/experience/get-experience-avatar-support"
else
	v2 = nil
end

local windowSize

if FFlagChromeWindowSignalConstraintsToggle then
	windowSize = WindowSizeSignal.new(844, 754, false, true)
else
	windowSize = WindowSizeSignal.new(844, 754, false)
end

local v3 = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.All)
	or StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.AvatarSwitcher)

local function getInitialAvailability() -- 1 equivalent call inferred from this helper
	if v3 and not FFlagRemoveAvatarSwitcherIfUnsupported then
		return Service.AvailabilitySignal.Available
	end

	return Service.AvailabilitySignal.Unavailable
end

local v4 = Service:register({
	initialAvailability = getInitialAvailability(), -- inferred equivalent call
	id = Constants.AVATAR_SWITCHER_ID,
	label = FFlagAvatarWorkshopReplacesAvatarSwitcher and "CommonUI.Features.Label.Avatar" or "Feature.AvatarSwitcher.Heading.SwitchAvatar",
	sideSheetPlacement = SideSheetPlacement.AboveFold,
	activated = function(_)
		Service:toggleWindow(Constants.AVATAR_SWITCHER_ID)
	end,
	isActivated = v,
	cachePosition = true,
	draggable = true,
	windowSize = windowSize,
	components = {
		Icon = function()
			return React.createElement(AvatarSwitcherIcon, { isActive = v })
		end,
		Window = function()
			return React.createElement(AvatarSwitcherChromeWrapper, {
				windowSize = windowSize,
				maxWindowWidth = 844,
				maxWindowHeight = 754
			})
		end
	}
})

local v5 = not FFlagRemoveAvatarSwitcherIfUnsupported

local function updateAvatarSwitcherAvailability() -- 2 equivalent calls inferred from this helper
	if v3 and v5 then
		v4.availability:available()
		return
	end

	if Service:isWindowOpen(Constants.AVATAR_SWITCHER_ID) then
		Service:toggleWindow(Constants.AVATAR_SWITCHER_ID)
	end

	v4.availability:unavailable()
end

ChromeUtils.setCoreGuiAvailability(v4, Enum.CoreGuiType.AvatarSwitcher, function(p)
	v3 = p
	updateAvatarSwitcherAvailability() -- inferred equivalent call
end)

if FFlagRemoveAvatarSwitcherIfUnsupported then
	task.spawn(function()
		if not game:IsLoaded() then
			game.Loaded:Wait()
		end

		local success, result = pcall(function()
			return HttpService:JSONDecode((HttpRbxApiService:GetAsyncFullUrl(v2)))
		end)

		if success and result and result.experienceAvatarSupportType ~= 0 then
			v5 = true
			updateAvatarSwitcherAvailability() -- inferred equivalent call
		end
	end)
end

return v4
