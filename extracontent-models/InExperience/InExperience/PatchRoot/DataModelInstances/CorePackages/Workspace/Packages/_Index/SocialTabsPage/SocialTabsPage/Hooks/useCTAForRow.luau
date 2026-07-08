local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local SocialTabsPageParent = SocialTabsPage.Parent
local React = require(SocialTabsPageParent.React)
local useSignalState = require(SocialTabsPageParent.SignalsReact).useSignalState
local DataStatus = require(SocialTabsPageParent.DataHydration).DataStatus
local ButtonTypes = require(SocialTabsPageParent.UserList).Enums.ButtonTypes
local mapProfileCTAToRowCTA = require(SocialTabsPage.Utils.mapProfileCTAToRowCTA)

require(SocialTabsPage.Common.Types)

local function v8() -- line: 27
	return nil
end
local function useCTAForRow(p1, p2, s1: string, t1: {[any]: any}?) -- line: 31
	-- upvalues: v8 (copy), useSignalState (copy), React (copy), DataStatus (copy), mapProfileCTAToRowCTA (copy), ButtonTypes (copy)
	local v14 = if not p1 then v8 else p1.data
	local v15 = if not p1 then v8 else p1.status
	local v16 = useSignalState(v14)
	local v17 = useSignalState(v15)

	return React.useMemo(function() -- line: 43
		-- upvalues: v17 (copy), DataStatus (copy), mapProfileCTAToRowCTA (copy), v16 (copy), p2 (copy), s1 (copy), ButtonTypes (copy), t1 (copy)
		if v17 == DataStatus.NotReady then
			return nil
		end

		local v18 = mapProfileCTAToRowCTA(v16, p2, s1)

		if v18 and v18.type == ButtonTypes.Join and t1 then
			local onActivated = v18.onActivated

			return {
				type = v18.type,
				onActivated = function() -- line: 54
					-- upvalues: onActivated (copy), t1 (copy)
					if onActivated then
						onActivated()
					end

					t1.joinExperience()
				end,
				isDisabled = not t1.isInExperience,
				isLoading = t1.isLoading
			}
		end

		return v18
	end, {
		v16,
		v17,
		p2,
		s1,
		t1
	})
end

return useCTAForRow
