local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local React = require(UserListParent.React)
local DataHydration = require(UserListParent.DataHydration)
local RoactUtils = require(UserListParent.RoactUtils)
local Enums = require(UserList.Common.Enums)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local NavigateDown = require(UserListParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(UserListParent.SharedFlags).FFlagSignalsNavP3Dispatch
local FFlagUserListCtaAnalyticsEnabled = require(UserListParent.SharedFlags).FFlagUserListCtaAnalyticsEnabled
local NavigationCommands = require(UserListParent.RobloxAppNavigation).NavigationCommands
local AppPage = require(UserListParent.RobloxAppEnums).AppPage
local DataStatus = DataHydration.DataStatus
local ButtonTypes = Enums.ButtonTypes
local mapServerActionsToRowCta = require(UserList.Cta.mapServerActionsToRowCta)

require(UserList.Common.Types)

local t1 = {
	primaryCta = nil,
	secondaryCta = nil,
	isLoading = true
}

local function buildJoinCta(p1, t2: {[any]: any}, p2: ((...any) -> ...any)) -- line: 40
	local v22 = table.clone(p1)

	v22.onActivated = p2
	v22.isDisabled = not t2.isInExperience
	v22.isLoading = t2.isLoading

	return v22
end
local function useCtaForRow(p3, s1: string?, p4, s2: string, p5, t3: {[any]: any}?) -- line: 52
	-- upvalues: useDispatch (copy), React (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), NavigationCommands (copy), NavigateDown (copy), DataStatus (copy), t1 (copy), mapServerActionsToRowCta (copy), ButtonTypes (copy), FFlagUserListCtaAnalyticsEnabled (copy)
	local v29 = useDispatch()
	local v30 = React.useCallback(function(s3: string) -- line: 61
		-- upvalues: AppPage (copy), FFlagSignalsNavP3Dispatch (copy), NavigationCommands (copy), v29 (copy), NavigateDown (copy)
		local t4 = {
			name = AppPage.GameJoinCard,
			userId = s3
		}

		if FFlagSignalsNavP3Dispatch then
			NavigationCommands.down(NavigationCommands.fromLegacyPage(t4))

			return
		end

		v29(NavigateDown(t4))
	end, { v29 })

	return React.useMemo(function() -- line: 73
		-- upvalues: s1 (copy), DataStatus (copy), t1 (copy), mapServerActionsToRowCta (copy), p3 (copy), p4 (copy), s2 (copy), p5 (copy), ButtonTypes (copy), t3 (copy), FFlagUserListCtaAnalyticsEnabled (copy), v30 (copy)
		if s1 == nil or s1 == DataStatus.NotReady then
			return t1
		end

		local v33 = mapServerActionsToRowCta(p3, p4, s2, p5)
		local primaryCta = v33.primaryCta

		if primaryCta and primaryCta.type == ButtonTypes.Join and t3 then
			local t5 = {}
			local v36 = t3
			local v37 = table.clone(primaryCta)

			function v37.onActivated() -- line: 83
				-- upvalues: FFlagUserListCtaAnalyticsEnabled (copy), p5 (copy), ButtonTypes (copy), s2 (copy), v30 (copy)
				if FFlagUserListCtaAnalyticsEnabled then
					local v38 = if not p5 then nil else p5.onCtaActivated

					if v38 ~= nil then
						v38({
							buttonType = ButtonTypes.Join,
							userId = s2
						})
					end
				end

				v30(s2)
			end

			v37.isDisabled = not v36.isInExperience
			v37.isLoading = v36.isLoading
			t5.primaryCta = v37
			t5.secondaryCta = v33.secondaryCta

			return t5
		end

		return v33
	end, {
		p3,
		s1,
		p4,
		s2,
		p5,
		t3,
		v30
	})
end

return useCtaForRow
