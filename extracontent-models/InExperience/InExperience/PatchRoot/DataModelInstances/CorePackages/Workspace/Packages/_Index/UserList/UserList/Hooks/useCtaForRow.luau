local UserList = script:FindFirstAncestor("UserList")
local parent = UserList.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local DataHydration = require(parent.DataHydration)
local RoactUtils = require(parent.RoactUtils)
local Enums = require(UserList.Common.Enums)

local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local SharedFlags = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local SharedFlags2 = require(parent.SharedFlags)
local FFlagUserListCtaAnalyticsEnabled = SharedFlags2.FFlagUserListCtaAnalyticsEnabled
local SharedFlags3 = require(parent.SharedFlags)
local FFlagGameJoinCardSourceAttribution = SharedFlags3.FFlagGameJoinCardSourceAttribution
local SharedFlags4 = require(parent.SharedFlags)
local FFlagUserListSurfaceExtensions = SharedFlags4.FFlagUserListSurfaceExtensions
local FFlagUserListCanonicalCtaAnalytics = require(UserList.Flags.FFlagUserListCanonicalCtaAnalytics)
local FFlagUserListViewCtaAnalytics = require(UserList.Flags.FFlagUserListViewCtaAnalytics)
local FFlagUserListRowViewCta = require(UserList.Flags.FFlagUserListRowViewCta)
local mapClientActionsToRowCta

if FFlagUserListRowViewCta then
	mapClientActionsToRowCta = require(UserList.Cta.mapClientActionsToRowCta)
else
	mapClientActionsToRowCta = nil
end

local reportCtaActivated = require(UserList.Analytics.reportCtaActivated)
local reportViewCta = require(UserList.Analytics.reportViewCta)
local RobloxAppNavigation = require(parent.RobloxAppNavigation)
local NavigationCommands = RobloxAppNavigation.NavigationCommands
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage

local DataStatus = DataHydration.DataStatus
local ButtonTypes = Enums.ButtonTypes
local ButtonVariant = Foundation.Enums.ButtonVariant

local mapServerActionsToRowCta = require(UserList.Cta.mapServerActionsToRowCta)
require(UserList.Common.Types)

local v = { primaryCta = nil, secondaryCta = nil, isLoading = true }

local function buildJoinCta(primaryCta, p, fn) -- 1 equivalent call inferred from this helper
	local clone = table.clone(primaryCta)
	clone.onActivated = fn
	clone.isDisabled = not p.isInExperience
	clone.isLoading = p.isLoading
	return clone
end

local function useCtaForRow(p, p2: string?, p3, p4: string, data, p5, p6: number?)
	local v2 = useDispatch()
	local v3 = useLocalUserId()

	local v4 = React.useCallback(function(userId: string, joinSource)
		local v4 = { name = AppPage.GameJoinCard, userId = userId, joinSource = 0 }

		if not FFlagGameJoinCardSourceAttribution then
			joinSource = nil
		end

		v4.joinSource = joinSource

		if FFlagSignalsNavP3Dispatch then
			NavigationCommands.down(NavigationCommands.fromLegacyPage(v4))
		else
			v2(NavigateDown(v4))
		end
	end, { v2 })

	local v5 = React.useCallback(function()
		local v5 = {
			name = AppPage.ProfilePlatform,
			detail = p4,
			extraProps = { profileType = Enums.EntityType.User }
		}

		if FFlagSignalsNavP3Dispatch then
			NavigationCommands.down(NavigationCommands.fromLegacyPage(v5))
		else
			v2(NavigateDown(v5))
		end
	end, { v2, p4 })

	local useMemo = React.useMemo
	local function fn()
		if data and data.showSelfProfileCta and p4 == v3 then
			local onActivated = v5

			if FFlagUserListViewCtaAnalytics then
				local analytics = data.analytics
				onActivated = function()
					reportViewCta(analytics)
					v5()
				end
			end

			return {
				primaryCta = {
					type = ButtonTypes.View,
					onActivated = onActivated,
					variant = ButtonVariant.Standard,
					minWidth = data.primaryCtaMinWidth,
					maxWidth = data.primaryCtaMaxWidth
				},
				secondaryCta = nil
			}
		else
			if FFlagUserListRowViewCta then
				local v6 = p4 == v3
				local v7

				if FFlagUserListCanonicalCtaAnalytics then
					v7 = p6
				end

				local v8 = mapClientActionsToRowCta(p3, p4, v6, data, v7)

				if v8 ~= nil then
					return v8
				end
			end

			if p2 == nil or p2 == DataStatus.NotReady then
				return v
			end

			local v6

			if FFlagUserListCanonicalCtaAnalytics then
				v6 = p6
			end

			local v7 = mapServerActionsToRowCta(p, p3, p4, data, v6)

			local primaryCta = v7.primaryCta

			if not primaryCta or primaryCta.type ~= ButtonTypes.Join or not p5 then
				return v7
			end

			local function fn2()
				if FFlagUserListCtaAnalyticsEnabled then
					local onCtaActivated

					if data then
						onCtaActivated = data.onCtaActivated
					end

					if onCtaActivated ~= nil then
						onCtaActivated({ buttonType = ButtonTypes.Join, userId = p4 })
					end
				end

				local analytics

				if data then
					analytics = data.analytics
				end

				if FFlagUserListCanonicalCtaAnalytics then
					reportCtaActivated(analytics, ButtonTypes.Join, p4, p6)
				end

				if FFlagUserListSurfaceExtensions and data and data.join then
					data.join.onActivated(p4)
					return
				end

				if not FFlagGameJoinCardSourceAttribution then
					analytics = nil
				end

				v4(p4, analytics)
			end

			return {
				primaryCta = buildJoinCta(primaryCta, p5, fn2), -- inferred equivalent call
				secondaryCta = v7.secondaryCta
			}
		end
	end

	local v6

	if FFlagUserListCanonicalCtaAnalytics then
		v6 = p6
	end

	return useMemo(fn, {
		p,
		p2,
		p3,
		p4,
		data,
		p5,
		v4,
		v3,
		v5,
		v6
	})
end

return useCtaForRow
