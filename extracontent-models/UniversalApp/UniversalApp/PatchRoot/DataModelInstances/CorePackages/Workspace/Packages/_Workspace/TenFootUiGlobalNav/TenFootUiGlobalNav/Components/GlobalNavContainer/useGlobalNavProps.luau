local TenFootUiGlobalNav = script:FindFirstAncestor("TenFootUiGlobalNav")
local TenFootUiGlobalNavParent = TenFootUiGlobalNav.Parent
local React = require(TenFootUiGlobalNavParent.React)
local Cryo = require(TenFootUiGlobalNavParent.Cryo)
local TenFootUiCommon = require(TenFootUiGlobalNavParent.TenFootUiCommon)
local TenFootUiContext = TenFootUiCommon.TenFootUiContext
local AppNotificationService = require(TenFootUiGlobalNavParent.RoactServiceTags).AppNotificationService
local makeGlobalNavAnalytics = require(TenFootUiGlobalNav.Analytics.makeGlobalNavAnalytics)
local GlobalNavDisplayOption = TenFootUiCommon.TenFootUiRNTypes.GlobalNavDisplayOption
local useLocalization = require(TenFootUiGlobalNavParent.Localization).Hooks.useLocalization
local useGlobalNavAnimation = require(TenFootUiGlobalNav.Components.GlobalNavContainer.useGlobalNavAnimation)
local getCurrentTabName = require(TenFootUiGlobalNavParent.NavigationRodux).Utils.getCurrentTabName

require(TenFootUiGlobalNav.Components.GlobalNav)

local FFlagFix10ftGlobalNavSelection = require(TenFootUiGlobalNavParent.SharedFlags).FFlagFix10ftGlobalNavSelection
local FFlagEnableConsoleRobloxLogo = require(TenFootUiGlobalNavParent.SharedFlags).FFlagEnableConsoleRobloxLogo

local function useGlobalNavProps(p1, p2) -- line: 19
	-- upvalues: React (copy), TenFootUiContext (copy), AppNotificationService (copy), makeGlobalNavAnalytics (copy), getCurrentTabName (copy), Cryo (copy), useLocalization (copy), FFlagEnableConsoleRobloxLogo (copy), useGlobalNavAnimation (copy), GlobalNavDisplayOption (copy), FFlagFix10ftGlobalNavSelection (copy)
	local v18 = React.useContext(TenFootUiContext)

	assert(v18, "TenFootUiContext must be configured before using GlobalNav")

	local v19 = v18.useRoactService(AppNotificationService)
	local v20 = v18.useRoactService(v18.RoactAnalytics)
	local v21 = makeGlobalNavAnalytics(v20, v18.buttonClick)
	local globalNavConfig = v18.globalNavConfig
	local v23 = getCurrentTabName(p1.state)

	local function v24(p3) -- line: 31
		-- upvalues: v23 (copy), v18 (copy), p1 (copy), v19 (copy), v21 (copy)
		local page = p3.page

		if page == v23 then
			v18.LuaAppEvents.ReloadPage:fire(page)

			return
		end

		p1.navigate(page)

		if p3.actionType then
			v19:ActionTaken(p3.actionType)
		end

		v21.ButtonActivated(page, v23)
	end

	local v25 = Cryo.List.map(globalNavConfig.tabs, function(p4) -- line: 48
		return p4.titleLocalizationKey
	end)
	local v26 = useLocalization(v25)
	local v27 = Cryo.List.map(globalNavConfig.options, function(p5) -- line: 53
		return p5.titleLocalizationKey
	end)
	local v28 = useLocalization(v27)
	local t1 = nil
	local t2 = nil
	local v31 = if not FFlagEnableConsoleRobloxLogo then nil else useGlobalNavAnimation(p2 == GlobalNavDisplayOption.ShowAll or p2 == GlobalNavDisplayOption.TabGroupOnly)
	local v32 = useGlobalNavAnimation(p2 == GlobalNavDisplayOption.ShowAll or p2 == GlobalNavDisplayOption.TabGroupOnly)
	local v33 = useGlobalNavAnimation(p2 == GlobalNavDisplayOption.ShowAll or p2 == GlobalNavDisplayOption.OptionGroupOnly)

	if v32.isVisible then
		local v34 = Cryo.List.findWhere(globalNavConfig.tabs, function(p6, _) -- line: 73
			-- upvalues: v23 (copy)
			return p6.page == v23
		end)
		local v35 = Cryo.List.map(globalNavConfig.tabs, function(p8, p9) -- line: 76
			-- upvalues: v26 (copy), v24 (copy), v23 (copy)
			return {
				title = v26[p9],
				icon = p8.iconImage,
				iconComponent = p8.iconComponent,
				onActivated = function() -- line: 81
					-- upvalues: v24 (copy), p8 (copy)
					v24(p8)
				end,
				showRoundedBackground = v23 == p8.page
			}
		end)

		t1 = {
			selection = { v34 },
			items = v35,
			padding = {
				left = 0,
				right = 0,
				top = 0,
				bottom = 0
			}
		}
	end

	if v33.isVisible then
		t2 = {
			items = Cryo.List.map(globalNavConfig.options, function(p10, p11) -- line: 95
				-- upvalues: v28 (copy), v24 (copy)
				return {
					label = v28[p11],
					icon = p10.iconComponent or p10.icon,
					onActivated = function() -- line: 99
						-- upvalues: v24 (copy), p10 (copy)
						v24(p10)
					end
				}
			end)
		}
	end

	return {
		tabGroupProps = t1,
		optionGroupProps = t2,
		animationProps = {
			logoGroupTransparency = if not FFlagEnableConsoleRobloxLogo then nil else v31.transparency,
			logoGroupRef = if not FFlagEnableConsoleRobloxLogo then nil else v31.ref,
			tabGroupTransparency = v32.transparency,
			tabGroupRef = v32.ref,
			optionGroupTransparency = v33.transparency,
			optionGroupRef = v33.ref
		},
		SelectionGroup = not not FFlagFix10ftGlobalNavSelection or nil,
		SelectionBehaviorLeft = if not FFlagFix10ftGlobalNavSelection then nil else Enum.SelectionBehavior.Stop,
		SelectionBehaviorRight = if not FFlagFix10ftGlobalNavSelection then nil else Enum.SelectionBehavior.Stop,
		SelectionBehaviorUp = if not FFlagFix10ftGlobalNavSelection then nil else Enum.SelectionBehavior.Stop
	}
end

return useGlobalNavProps
