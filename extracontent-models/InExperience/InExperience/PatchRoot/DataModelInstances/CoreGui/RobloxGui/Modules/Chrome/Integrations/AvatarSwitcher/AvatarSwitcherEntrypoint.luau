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
local Url = require(CorePackages.Workspace.Packages.Http).Url
local SideSheetPlacement = require(CorePackages.Workspace.Packages.Chrome).Enums.SideSheetPlacement
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagChromeWindowSignalConstraintsToggle = SharedFlags.FFlagChromeWindowSignalConstraintsToggle
local FFlagRemoveAvatarSwitcherIfUnsupported = SharedFlags.FFlagRemoveAvatarSwitcherIfUnsupported
local FFlagChromeActivatedMappedSignal = SharedFlags.FFlagChromeActivatedMappedSignal
local v20 = MappedSignal.new(Service:onIntegrationStatusChanged(), function() -- line: 26
	-- upvalues: Service (copy), Constants (copy)
	return Service:isWindowOpen(Constants.AVATAR_SWITCHER_ID)
end)
local v21 = if not FFlagRemoveAvatarSwitcherIfUnsupported then nil else Url.AVATAR_URL .. "v2/avatar/experience/get-experience-avatar-support"
local v22 = if not FFlagChromeWindowSignalConstraintsToggle then WindowSizeSignal.new(844, 754, false) else WindowSizeSignal.new(844, 754, false, true)
local u23 = StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.All) or StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.AvatarSwitcher)

local function getInitialAvailability() -- line: 44
	-- upvalues: u23 (ref), FFlagRemoveAvatarSwitcherIfUnsupported (copy), Service (copy)
	if u23 and not FFlagRemoveAvatarSwitcherIfUnsupported then
		return Service.AvailabilitySignal.Available
	end

	return Service.AvailabilitySignal.Unavailable
end

local v25 = Service:register({
	label = "Feature.AvatarSwitcher.Heading.SwitchAvatar",
	cachePosition = true,
	draggable = true,
	initialAvailability = if not u23 or FFlagRemoveAvatarSwitcherIfUnsupported then Service.AvailabilitySignal.Unavailable else Service.AvailabilitySignal.Available,
	id = Constants.AVATAR_SWITCHER_ID,
	sideSheetPlacement = SideSheetPlacement.Vertical,
	activated = function(_) -- line: 56
		-- upvalues: Service (copy), Constants (copy)
		Service:toggleWindow(Constants.AVATAR_SWITCHER_ID)
	end,
	isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 61
		-- upvalues: v20 (copy)
		return v20:get()
	end or v20,
	windowSize = v22,
	components = {
		Icon = function() -- line: 68
			-- upvalues: React (copy), AvatarSwitcherIcon (copy), v20 (copy)
			return React.createElement(AvatarSwitcherIcon, {
				isActive = v20
			})
		end,
		Window = function() -- line: 74
			-- upvalues: React (copy), AvatarSwitcherChromeWrapper (copy), v22 (copy)
			return React.createElement(AvatarSwitcherChromeWrapper, {
				maxWindowWidth = 844,
				maxWindowHeight = 754,
				windowSize = v22
			})
		end
	}
})
local u26 = not FFlagRemoveAvatarSwitcherIfUnsupported

local function updateAvatarSwitcherAvailability() -- line: 88
	-- upvalues: u23 (ref), u26 (ref), v25 (copy), Service (copy), Constants (copy)
	if u23 and u26 then
		v25.availability:available()

		return
	end

	if Service:isWindowOpen(Constants.AVATAR_SWITCHER_ID) then
		Service:toggleWindow(Constants.AVATAR_SWITCHER_ID)
	end

	v25.availability:unavailable()
end

ChromeUtils.setCoreGuiAvailability(v25, Enum.CoreGuiType.AvatarSwitcher, function(p2) -- line: 100
	-- upvalues: u23 (ref), u26 (ref), v25 (copy), Service (copy), Constants (copy)
	u23 = p2

	if u23 and u26 then
		v25.availability:available()

		return
	end

	if Service:isWindowOpen(Constants.AVATAR_SWITCHER_ID) then
		Service:toggleWindow(Constants.AVATAR_SWITCHER_ID)
	end

	v25.availability:unavailable()
end)

if FFlagRemoveAvatarSwitcherIfUnsupported then
	task.spawn(function() -- line: 107
		-- upvalues: HttpRbxApiService (copy), v21 (copy), HttpService (copy), u26 (ref), u23 (ref), v25 (copy), Service (copy), Constants (copy)
		if not game:IsLoaded() then
			game.Loaded:Wait()
		end

		local ok, result = pcall(function() -- line: 113
			-- upvalues: HttpRbxApiService (copy), v21 (copy), HttpService (copy)
			local AsyncFullUrl = HttpRbxApiService:GetAsyncFullUrl(v21)

			return HttpService:JSONDecode(AsyncFullUrl)
		end)

		if ok and result and result.experienceAvatarSupportType ~= 0 then
			u26 = true

			if u23 and u26 then
				v25.availability:available()

				return
			end

			if Service:isWindowOpen(Constants.AVATAR_SWITCHER_ID) then
				Service:toggleWindow(Constants.AVATAR_SWITCHER_ID)
			end

			v25.availability:unavailable()
		end
	end)
end

return v25
