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
local EngineFeature = game:GetEngineFeature("AddAvatarsSwitcherToCoreGUI")
local v21 = MappedSignal.new(Service:onIntegrationStatusChanged(), function() -- line: 27
	-- upvalues: Service (copy), Constants (copy)
	return Service:isWindowOpen(Constants.AVATAR_SWITCHER_ID)
end)
local v22 = if not FFlagRemoveAvatarSwitcherIfUnsupported then nil else Url.AVATAR_URL .. "v2/avatar/experience/get-experience-avatar-support"
local v23 = if not FFlagChromeWindowSignalConstraintsToggle then WindowSizeSignal.new(844, 754, false) else WindowSizeSignal.new(844, 754, false, true)
local u24 = not EngineFeature or (StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.All) or StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.AvatarSwitcher))

local function getInitialAvailability() -- line: 49
	-- upvalues: EngineFeature (copy), u24 (ref), FFlagRemoveAvatarSwitcherIfUnsupported (copy), Service (copy)
	if EngineFeature then
		if u24 and not FFlagRemoveAvatarSwitcherIfUnsupported then
			return Service.AvailabilitySignal.Available
		end

		return Service.AvailabilitySignal.Unavailable
	end

	if FFlagRemoveAvatarSwitcherIfUnsupported then
		return Service.AvailabilitySignal.Unavailable
	end

	return Service.AvailabilitySignal.Available
end

local v26 = Service:register({
	label = "Feature.AvatarSwitcher.Heading.SwitchAvatar",
	cachePosition = true,
	draggable = true,
	initialAvailability = if not EngineFeature then if not FFlagRemoveAvatarSwitcherIfUnsupported then Service.AvailabilitySignal.Available else Service.AvailabilitySignal.Unavailable else if not EngineFeature then if not FFlagRemoveAvatarSwitcherIfUnsupported then Service.AvailabilitySignal.Available else Service.AvailabilitySignal.Unavailable else if not u24 or FFlagRemoveAvatarSwitcherIfUnsupported then Service.AvailabilitySignal.Unavailable else Service.AvailabilitySignal.Available,
	id = Constants.AVATAR_SWITCHER_ID,
	sideSheetPlacement = SideSheetPlacement.Vertical,
	activated = function(_) -- line: 72
		-- upvalues: Service (copy), Constants (copy)
		Service:toggleWindow(Constants.AVATAR_SWITCHER_ID)
	end,
	isActivated = not FFlagChromeActivatedMappedSignal and function() -- line: 77
		-- upvalues: v21 (copy)
		return v21:get()
	end or v21,
	windowSize = v23,
	components = {
		Icon = function() -- line: 84
			-- upvalues: React (copy), AvatarSwitcherIcon (copy), v21 (copy)
			return React.createElement(AvatarSwitcherIcon, {
				isActive = v21
			})
		end,
		Window = function() -- line: 90
			-- upvalues: React (copy), AvatarSwitcherChromeWrapper (copy), v23 (copy)
			return React.createElement(AvatarSwitcherChromeWrapper, {
				maxWindowWidth = 844,
				maxWindowHeight = 754,
				windowSize = v23
			})
		end
	}
})

if EngineFeature then
	local u27 = not FFlagRemoveAvatarSwitcherIfUnsupported

	local function updateAvatarSwitcherAvailability() -- line: 105
		-- upvalues: u24 (ref), u27 (ref), v26 (copy), Service (copy), Constants (copy)
		if u24 and u27 then
			v26.availability:available()

			return
		end

		if Service:isWindowOpen(Constants.AVATAR_SWITCHER_ID) then
			Service:toggleWindow(Constants.AVATAR_SWITCHER_ID)
		end

		v26.availability:unavailable()
	end

	ChromeUtils.setCoreGuiAvailability(v26, Enum.CoreGuiType.AvatarSwitcher, function(p2) -- line: 117
		-- upvalues: u24 (ref), u27 (ref), v26 (copy), Service (copy), Constants (copy)
		u24 = p2

		if u24 and u27 then
			v26.availability:available()

			return
		end

		if Service:isWindowOpen(Constants.AVATAR_SWITCHER_ID) then
			Service:toggleWindow(Constants.AVATAR_SWITCHER_ID)
		end

		v26.availability:unavailable()
	end)

	if FFlagRemoveAvatarSwitcherIfUnsupported then
		task.spawn(function() -- line: 124
			-- upvalues: HttpRbxApiService (copy), v22 (copy), HttpService (copy), u27 (ref), u24 (ref), v26 (copy), Service (copy), Constants (copy)
			if not game:IsLoaded() then
				game.Loaded:Wait()
			end

			local ok, result = pcall(function() -- line: 130
				-- upvalues: HttpRbxApiService (copy), v22 (copy), HttpService (copy)
				local AsyncFullUrl = HttpRbxApiService:GetAsyncFullUrl(v22)

				return HttpService:JSONDecode(AsyncFullUrl)
			end)

			if ok and result and result.experienceAvatarSupportType ~= 0 then
				u27 = true

				if u24 and u27 then
					v26.availability:available()

					return
				end

				if Service:isWindowOpen(Constants.AVATAR_SWITCHER_ID) then
					Service:toggleWindow(Constants.AVATAR_SWITCHER_ID)
				end

				v26.availability:unavailable()
			end
		end)
	end
elseif FFlagRemoveAvatarSwitcherIfUnsupported then
	task.spawn(function() -- line: 147
		-- upvalues: HttpRbxApiService (copy), v22 (copy), HttpService (copy), v26 (copy)
		if not game:IsLoaded() then
			game.Loaded:Wait()
		end

		local ok, result = pcall(function() -- line: 153
			-- upvalues: HttpRbxApiService (copy), v22 (copy), HttpService (copy)
			local AsyncFullUrl = HttpRbxApiService:GetAsyncFullUrl(v22)

			return HttpService:JSONDecode(AsyncFullUrl)
		end)

		if ok and result and result.experienceAvatarSupportType ~= 0 then
			v26.availability:available()
		end
	end)
end

return v26
