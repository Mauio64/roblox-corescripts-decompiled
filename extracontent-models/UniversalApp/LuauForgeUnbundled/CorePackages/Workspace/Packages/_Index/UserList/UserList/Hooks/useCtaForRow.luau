local React = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/Foundation")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/DataHydration")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/RoactUtils")
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Enums")

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/RobloxAppHooks").useLocalUserId
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/NavigationRodux").Thunks.NavigateDown
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagSignalsNavP3Dispatch
local fFlagUserListCtaAnalyticsEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListCtaAnalyticsEnabled
local fFlagGameJoinCardSourceAttribution = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagGameJoinCardSourceAttribution
local fFlagUserListSurfaceExtensions = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/SharedFlags").FFlagUserListSurfaceExtensions
local FFlagUserListCanonicalCtaAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Flags/FFlagUserListCanonicalCtaAnalytics")
local FFlagUserListViewCtaAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Flags/FFlagUserListViewCtaAnalytics")
local FFlagUserListRowViewCta = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Flags/FFlagUserListRowViewCta")

local v5 = if FFlagUserListRowViewCta then require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Cta/mapClientActionsToRowCta") else nil

local reportCtaActivated = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Analytics/reportCtaActivated")
local reportViewCta = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Analytics/reportViewCta")
local navigationCommands = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/RobloxAppNavigation").NavigationCommands
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/UserList/RobloxAppEnums").AppPage

local dataStatus = DataHydration.DataStatus
local buttonTypes = Enums.ButtonTypes
local buttonVariant = Foundation.Enums.ButtonVariant

local mapServerActionsToRowCta = require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Cta/mapServerActionsToRowCta")
require("@game/CorePackages/Workspace/Packages/_Index/UserList/UserList/Common/Types")

local v6 = { primaryCta = nil, secondaryCta = nil, isLoading = true }

local function buildJoinCta(p2, p3, onActivated)
	local clone = table.clone(p2)
	clone.onActivated = onActivated
	clone.isDisabled = not p3.isInExperience
	clone.isLoading = p3.isLoading
	return clone
end

local function useCtaForRow(p2, p3, p4, p5, data, p6, p7)
	local v7 = useDispatch()
	local v8 = useLocalUserId()

	local v9 = React.useCallback(function(p8, joinSource)
		local v10 = { name = appPage.GameJoinCard, userId = p8, joinSource = 0 }

		if not fFlagGameJoinCardSourceAttribution then
			joinSource = nil
		end

		v10.joinSource = joinSource

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v10))
		else
			v7(navigateDown(v10))
		end
	end, { v7 })

	local v10 = React.useCallback(function()
		local v11 = {
			name = appPage.ProfilePlatform,
			detail = p5,
			extraProps = { profileType = Enums.EntityType.User }
		}

		if fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage(v11))
		else
			v7(navigateDown(v11))
		end
	end, { v7, p5 })

	local function fn()
		if data and data.showSelfProfileCta and p5 == v8 then
			local onActivated = v10

			if FFlagUserListViewCtaAnalytics then
				local analytics = data.analytics
				onActivated = function()
					reportViewCta(analytics)
					v10()
				end
			end

			return {
				primaryCta = {
					type = buttonTypes.View,
					onActivated = onActivated,
					variant = buttonVariant.Standard,
					minWidth = data.primaryCtaMinWidth,
					maxWidth = data.primaryCtaMaxWidth
				},
				secondaryCta = nil
			}
		else
			if FFlagUserListRowViewCta then
				local v14 = p5 == v8
				local v16 = if FFlagUserListCanonicalCtaAnalytics then p7 else nil
				local v17 = v5(p4, p5, v14, data, v16)

				if v17 ~= nil then
					return v17
				end
			end

			if p3 == nil or p3 == dataStatus.NotReady then
				return v6
			end

			local v16 = if FFlagUserListCanonicalCtaAnalytics then p7 else nil
			local v17 = mapServerActionsToRowCta(p2, p4, p5, data, v16)

			local primaryCta = v17.primaryCta

			if not primaryCta or primaryCta.type ~= buttonTypes.Join or not p6 then
				return v17
			end

			local v19 = p6
			local function fn2()
				if fFlagUserListCtaAnalyticsEnabled then
					local onCtaActivated = if data then data.onCtaActivated else nil

					if onCtaActivated ~= nil then
						onCtaActivated({ buttonType = buttonTypes.Join, userId = p5 })
					end
				end

				local analytics = if data then data.analytics else nil

				if FFlagUserListCanonicalCtaAnalytics then
					reportCtaActivated(analytics, buttonTypes.Join, p5, p7)
				end

				if fFlagUserListSurfaceExtensions and data and data.join then
					data.join.onActivated(p5)
					return
				end

				if not fFlagGameJoinCardSourceAttribution then
					analytics = nil
				end

				v9(p5, analytics)
			end

			local clone = table.clone(primaryCta)
			clone.onActivated = fn2
			clone.isDisabled = not v19.isInExperience
			clone.isLoading = v19.isLoading

			return { primaryCta = clone, secondaryCta = v17.secondaryCta }
		end
	end

	return React.useMemo(fn, {
		p2,
		p3,
		p4,
		p5,
		data,
		p6,
		v9,
		v8,
		v10,
		if FFlagUserListCanonicalCtaAnalytics then p7 else nil
	})
end

return useCtaForRow
