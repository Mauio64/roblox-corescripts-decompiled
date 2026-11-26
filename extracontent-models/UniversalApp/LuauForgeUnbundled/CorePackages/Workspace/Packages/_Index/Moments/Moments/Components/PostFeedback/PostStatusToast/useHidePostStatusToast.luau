local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags")
local MomentsGetMomentsUserStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/MomentsGetMomentsUserStore")

local getLocalUserId = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Utils/getLocalUserId")
local GetPostStatusCardStore = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Stores/GetPostStatusCardStore")
local useMomentsTabIsVisible = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Hooks/useMomentsTabIsVisible")
local sendrPostStatusToast = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostFeedback/PostStatusToast/sendrPostStatusToast")
local v5

if SharedFlags.FFlagMomentsPostFeedback then
	v5 = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Loggers").Logger:new("Moments.Upload")
else
	v5 = nil
end

local function shouldHidePostStatusToast()
	local v6 = GetPostStatusCardStore(false)
	local v7 = false
	local v8 = false

	local set = {}
	local function noteLiveCardPost(p2)
		v7 = true

		if v6.hadToastHidden(p2) then
			return
		end

		if v6.hadToastProbablySpent(p2) then
			v8 = true
		else
			set[p2] = true
		end
	end

	for k, v9 in v6.getCards(false) do
		if v9.cardType ~= "Live" then
			continue
		end

		local id = v9.id
		v7 = true

		if v6.hadToastHidden(id) then
			continue
		end

		if v6.hadToastProbablySpent(id) then
			v8 = true
		else
			set[id] = true
		end
	end

	local v9 = getLocalUserId()

	local v10 = if v9 ~= nil then MomentsGetMomentsUserStore(false).getPendingUserMoments(false)[v9] else nil

	local momentIds = {}

	if v10 ~= nil then
		for k, v11 in v10 do
			local momentId = v11.moment.momentId

			if v6.hasHadLiveCard(momentId) then
				v7 = true

				if not v6.hadToastHidden(momentId) then
					if v6.hadToastProbablySpent(momentId) then
						v8 = true
					else
						set[momentId] = true
					end
				end
			elseif
				v11.status ~= "Moderated"
				and not (v6.hadToastHidden(momentId) or v6.isUploading(momentId))
			then
				if v6.hadToastProbablySpent(momentId) then
					v8 = true
				elseif v11.publishedMoment == nil and v6.isAwaitingLiveCard(momentId) then
					table.insert(momentIds, momentId)
				else
					return false, nil, false
				end
			end
		end
	end

	local count = 0
	local v11 = nil

	for k in set do
		count += 1
		v11 = k
	end

	if #momentIds > 0 then
		if count > 0 then
			return false, nil, false
		end

		if #momentIds == 1 then
			return true, momentIds[1], v8
		end

		return true, momentIds[#momentIds], true
	end

	if not v7 then
		return false, nil, false
	end

	if count == 1 then
		return true, v11, true
	end

	return true, nil, false
end

local function useHidePostStatusToast()
	local v6 = useMomentsTabIsVisible()
	React.useEffect(function()
		if v6 then
			return sendrPostStatusToast.listen(function(p2)
				if sendrPostStatusToast.isFailure(p2) then
					if v5 ~= nil then
						v5:debug("event=post_status_toast decision=shown reason=failure")
					end
				else
					local v7, v8, v9 = shouldHidePostStatusToast()

					if v5 ~= nil then
						v5:debug(
							"event=post_status_toast decision={} creditedMomentId={} guess={}",
							v7 and "hidden" or "shown",
							v8 or "nil",
							(tostring(v9))
						)
					end

					if v7 then
						sendrPostStatusToast.dismiss(p2)

						if v8 ~= nil then
							if v9 then
								GetPostStatusCardStore(false).markToastProbablySpentFor(v8)
							else
								GetPostStatusCardStore(false).markToastHiddenFor(v8)
							end
						end
					end
				end
			end)
		end

		return nil
	end, { v6 })
end

return useHidePostStatusToast
