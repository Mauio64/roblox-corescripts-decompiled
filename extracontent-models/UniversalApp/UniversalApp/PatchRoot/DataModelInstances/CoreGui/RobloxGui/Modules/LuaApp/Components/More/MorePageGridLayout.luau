local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Dash = require(CorePackages.Packages.Dash)
local React = require(CorePackages.Packages.React)
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local MorePageSettings = require(Modules.LuaApp.Components.More.Config.MorePageSettings)
local useMorePageItemsConfiguration = require(Modules.LuaApp.Hooks.useMorePageItemsConfiguration)
local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local MorePageContent = require(Modules.LuaApp.Components.More.MorePageContent)
local useAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).useAppPolicy
local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local useBreakpointXOrLarger = Responsive.useBreakpointXOrLarger
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useProperty = require(CorePackages.Workspace.Packages.GuiObjectUtils).useProperty
local FFlagLuaAppResponsiveEnginePreferredInput = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppResponsiveEnginePreferredInput
local FFlagFixMorePageLogOutCutOff = require(Modules.LuaApp.Flags.FFlagFixMorePageLogOutCutOff)
local FFlagEnableMorePageExitButtonSupport = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableMorePageExitButtonSupport
local FFlagEnableMorePageDirectionalLayoutRolloutFix = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableMorePageDirectionalLayoutRolloutFix
local v21 = game:DefineFastFlag("MorePageExitButtonNotAllowed", false)
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local FFlagLuaAppEnableMorePageProfileLink = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEnableMorePageProfileLink
local FFlagLuaAppsDefaultSelection = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppsDefaultSelection
local Sources = nil
local UserInfo = nil
local u27 = nil

if FFlagLuaAppEnableMorePageProfileLink then
	Sources = require(CorePackages.Workspace.Packages.SocialLuaAnalytics).Analytics.Enums.Sources
	UserInfo = require(Modules.LuaApp.Components.GridHome.Header.UserInfo)

	function u27() -- line: 43
		-- upvalues: React (copy), UserInfo (ref), Sources (ref)
		return React.createElement(UserInfo, {
			source = Sources.MorePageSelfWidget
		})
	end
end

local v28 = if not FFlagFixMorePageLogOutCutOff then nil else require(CorePackages.Workspace.Packages.AppNavBar).useNavBarPlacement

return function() -- line: 54
	-- upvalues: useStyle (copy), useBreakpointXOrLarger (copy), Responsive (copy), useSelector (copy), useMorePageItemsConfiguration (copy), React (copy), Dash (copy), MorePageSettings (copy), FFlagEnableMorePageDirectionalLayoutRolloutFix (copy), useAppPolicy (copy), useProperty (copy), UserInputService (copy), FFlagLuaAppResponsiveEnginePreferredInput (copy), FFlagEnableMorePageExitButtonSupport (copy), v21 (copy), FFlagFixMorePageLogOutCutOff (copy), v28 (copy), FFlagLuaAppEnableMorePageProfileLink (copy), u27 (ref), TopBar (copy), FFlagLuaAppsDefaultSelection (copy), ReactFocusNavigation (copy), FFlagEnableLeftNavOnConsole (copy), MorePageContent (copy)
	local BackgroundDefault = useStyle().Theme.BackgroundDefault
	local v30 = useBreakpointXOrLarger(Responsive.Keys.Medium)
	local v31 = useSelector(function(p1) -- line: 58
		return p1.TopBar.topBarHeight
	end)
	local v32 = useMorePageItemsConfiguration()
	local v33 = React.useMemo(function() -- line: 63
		-- upvalues: Dash (copy), v32 (copy), MorePageSettings (copy)
		return Dash.reduce(v32, function(p2, p3) -- line: 64
			-- upvalues: MorePageSettings (copy), Dash (copy)
			if p3.type == MorePageSettings.SectionType.Navigation then
				return {
					Dash.append(p2[1], p3.contents),
					p2[2]
				}
			end

			if p3.type == MorePageSettings.SectionType.Action then
				return {
					p2[1],
					Dash.append(p2[2], p3.contents)
				}
			end

			return p2
		end, {
			{},
			{}
		})
	end, { v32 })
	local v34 = false
	local v35

	if FFlagEnableMorePageDirectionalLayoutRolloutFix then
		v35 = useAppPolicy(function(p4) -- line: 84
			return p4.getMoreGridDirectionalLayoutPreferred()
		end)
	else
		local v36 = useProperty(UserInputService, "TouchEnabled")
		local v37 = useProperty(UserInputService, "KeyboardEnabled")
		local v38 = useProperty(UserInputService, "MouseEnabled")

		if FFlagLuaAppResponsiveEnginePreferredInput then
			local v39 = v36 or (v37 or v38)

			v35 = Responsive.usePreferredInput() == Responsive.Input.Directional and not v39
		else
			v35 = Responsive.usePreferredInput() == Responsive.Input.Directional
		end
	end

	if FFlagEnableMorePageExitButtonSupport then
		v34 = useAppPolicy(function(p5) -- line: 101
			return p5.getMorePageExitButtonEnabled()
		end) and not v21
	end

	local v40 = if not FFlagFixMorePageLogOutCutOff then nil else v28()
	local v41 = nil
	local t1

	if FFlagLuaAppEnableMorePageProfileLink then
		local v42 = useAppPolicy(function(p6) -- line: 114
			return p6.useGridPageLayout()
		end)
		local v43 = useBreakpointXOrLarger(Responsive.Keys.Large)

		if v42 then
			v41 = not v43
			t1 = {
				u27,
				TopBar.BuyRobuxButton,
				TopBar.NotificationsButton
			}
		else
			t1 = {
				TopBar.BuyRobuxButton,
				TopBar.NotificationsButton
			}
		end
	else
		t1 = {
			TopBar.BuyRobuxButton,
			TopBar.NotificationsButton
		}
	end

	local v45 = nil
	local v46 = nil

	if FFlagLuaAppsDefaultSelection then
		v45, v46 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior()
	end

	return React.createElement("Frame", {
		BorderSizePixel = 0,
		ref = if not FFlagLuaAppsDefaultSelection then nil else v46,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = if not v35 or FFlagEnableLeftNavOnConsole then BackgroundDefault.Color else nil,
		BackgroundTransparency = if not v35 or FFlagEnableLeftNavOnConsole then BackgroundDefault.Transparency else 1
	}, {
		TopBarMorePage = if not v35 then React.createElement(TopBar.Container, {
			leftItem = TopBar.BackButton,
			rightItems = t1,
			forceCompactMode = v41
		}) else nil,
		MorePageContent = React.createElement(MorePageContent, {
			defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else v45,
			isWideView = v30,
			isDirectional = v35,
			isExitButtonSupported = v34,
			itemTable = v33,
			topBarHeight = if not v35 then v31 else 0,
			navBarPlacement = v40
		})
	})
end
