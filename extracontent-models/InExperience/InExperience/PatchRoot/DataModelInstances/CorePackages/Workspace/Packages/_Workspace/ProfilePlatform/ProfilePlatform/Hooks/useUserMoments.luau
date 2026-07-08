local Parent = script:FindFirstAncestor("ProfilePlatform").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local SignalsReact = require(Parent.SignalsReact)
local SharedFlags = require(Parent.SharedFlags)
local MomentsGetMomentsUserStore = require(Parent.DataHydration.MomentsGetMomentsUserStore)

require(Parent.DataHydration.MomentsStoreTypes)

local GetDeletedMomentsStore = require(Parent.Moments.GetDeletedMomentsStore)
local FFlagMomentsRemoveDeletedFromProfile = SharedFlags.FFlagMomentsRemoveDeletedFromProfile

local function useUserMoments(s1: string?) -- line: 29
	-- upvalues: React (copy), MomentsGetMomentsUserStore (copy), Cryo (copy), FFlagMomentsRemoveDeletedFromProfile (copy), SignalsReact (copy), GetDeletedMomentsStore (copy)
	local v11, v12 = React.useState({})
	local v13, v14 = React.useState(nil)
	local v15, v16 = React.useState(false)
	local v17, v18 = React.useState(false)
	local v19, v20 = React.useState(false)

	React.useEffect(function() -- line: 36
		-- upvalues: s1 (copy), MomentsGetMomentsUserStore (copy), v18 (copy), v12 (copy), v14 (copy), v16 (copy)
		local v24 = if s1 == nil then nil else tonumber(s1)

		if v24 == nil then
			return
		end

		local u25 = false

		MomentsGetMomentsUserStore(false).getUserMoments(v24):andThen(function(p1) -- line: 44
			-- upvalues: u25 (ref), v18 (copy), v12 (copy), v14 (copy), v16 (copy)
			if not u25 then
				v18(false)
				v12(p1.moments)
				v14(p1.nextCursor)
				v16(p1.nextCursor ~= nil)
			end
		end):catch(function() -- line: 52
			-- upvalues: u25 (ref), v18 (copy)
			if not u25 then
				v18(true)
			end
		end)

		return function() -- line: 57
			-- upvalues: u25 (ref)
			u25 = true
		end
	end, { s1 })

	local v21 = React.useCallback(function() -- line: 62
		-- upvalues: s1 (copy), v13 (copy), v15 (copy), v19 (copy), v20 (copy), MomentsGetMomentsUserStore (copy), v12 (copy), Cryo (copy), v16 (copy), v14 (copy)
		local v26 = if s1 == nil then nil else tonumber(s1)

		if v26 == nil or v13 == nil or not v15 or v19 then
			return
		end

		v20(true)
		MomentsGetMomentsUserStore(false).getUserMoments(v26, v13):andThen(function(p2) -- line: 70
			-- upvalues: v12 (copy), Cryo (copy), v16 (copy), v13 (copy), v14 (copy)
			v12(function(p3) -- line: 71
				-- upvalues: Cryo (copy), p2 (copy)
				return Cryo.List.join(p3, p2.moments)
			end)
			v16(p2.nextCursor ~= nil and p2.nextCursor ~= v13)
			v14(p2.nextCursor)
		end):catch(function() -- line: 78
		end):finally(function() -- line: 79
			-- upvalues: v20 (copy)
			v20(false)
		end)
	end, {
		s1,
		v13,
		v15,
		v19
	})
	local v22 = v11

	if FFlagMomentsRemoveDeletedFromProfile then
		local v23 = SignalsReact.useSignalState(GetDeletedMomentsStore(false).getDeletedIds)

		v22 = React.useMemo(function() -- line: 94
			-- upvalues: v23 (copy), v11 (copy)
			if #v23 == 0 then
				return v11
			end

			local t1 = {}

			for _, v29 in v11 do
				if not table.find(v23, v29.momentId) then
					table.insert(t1, v29)
				end
			end

			return t1
		end, {
			v11,
			v23
		})
	end

	return {
		moments = v22,
		hasMore = v15,
		hasFailed = v17,
		isLoadingMore = v19,
		loadMore = v21
	}
end

return useUserMoments
