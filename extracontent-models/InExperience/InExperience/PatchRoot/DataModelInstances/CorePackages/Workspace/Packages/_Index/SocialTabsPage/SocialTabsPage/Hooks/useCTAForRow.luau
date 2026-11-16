local SocialTabsPage = script:FindFirstAncestor("SocialTabsPage")
local parent = SocialTabsPage.Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local DataHydration = require(parent.DataHydration)
local DataStatus = DataHydration.DataStatus

local UserList = require(parent.UserList)
local ButtonTypes = UserList.Enums.ButtonTypes

local mapProfileCTAToRowCTA = require(SocialTabsPage.Utils.mapProfileCTAToRowCTA)
require(SocialTabsPage.Common.Types)

local function fn(): nil
	return nil
end

local function useCTAForRow(p, p2, p3: string, data)
	local v = if p then p.data else fn
	local v2 = if p then p.status else fn

	local v3 = useSignalState(v)
	local v4 = useSignalState(v2)

	return React.useMemo(function()
		if v4 == DataStatus.NotReady then
			return nil
		end

		local v5 = mapProfileCTAToRowCTA(v3, p2, p3)

		if not v5 or v5.type ~= ButtonTypes.Join or not data then
			return v5
		end

		local onActivated = v5.onActivated
		return {
			type = v5.type,
			onActivated = function()
				if onActivated then
					onActivated()
				end

				data.joinExperience()
			end,
			isDisabled = not data.isInExperience,
			isLoading = data.isLoading
		}
	end, { v3, v4, p2, p3, data })
end

return useCTAForRow
