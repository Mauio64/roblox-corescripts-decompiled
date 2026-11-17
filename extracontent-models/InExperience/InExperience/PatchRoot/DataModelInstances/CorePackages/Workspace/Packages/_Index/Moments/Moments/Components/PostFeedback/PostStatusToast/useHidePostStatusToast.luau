local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local MomentsGetMomentsUserStore = require(parent.DataHydration.MomentsGetMomentsUserStore)

local getLocalUserId = require(Moments.Utils.getLocalUserId)
local GetPostStatusCardStore = require(Moments.Stores.GetPostStatusCardStore)
local useMomentsTabIsVisible = require(Moments.Hooks.useMomentsTabIsVisible)
local sendrPostStatusToast = require(script.Parent.sendrPostStatusToast)
local v

if SharedFlags.FFlagMomentsPostFeedback then
	local Loggers = require(parent.Loggers)
	v = Loggers.Logger:new("Moments.Upload")
else
	v = nil
end

local function shouldHidePostStatusToast()
	local postStatusCardStore = GetPostStatusCardStore(false)
	local v2 = false
	local v3 = false

	local set = {}
	local function noteLiveCardPost(p: string) -- 2 equivalent calls inferred from this helper
		v2 = true

		if postStatusCardStore.hadToastHidden(p) then
			return
		end

		if postStatusCardStore.hadToastProbablySpent(p) then
			v3 = true
		else
			set[p] = true
		end
	end

	for _, v4 in postStatusCardStore.getCards(false) do
		if v4.cardType == "Live" then
			noteLiveCardPost(v4.id) -- inferred equivalent call
		end
	end

	local localUserId = getLocalUserId()
	local v4

	if localUserId ~= nil then
		v4 = MomentsGetMomentsUserStore(false).getPendingUserMoments(false)[localUserId]
	end

	local momentIds = {}

	if v4 ~= nil then
		for _, v5 in v4 do
			local momentId = v5.moment.momentId

			if postStatusCardStore.hasHadLiveCard(momentId) then
				noteLiveCardPost(momentId) -- inferred equivalent call
			elseif
				v5.status ~= "Moderated"
				and not (postStatusCardStore.hadToastHidden(momentId) or postStatusCardStore.isUploading(momentId))
			then
				if postStatusCardStore.hadToastProbablySpent(momentId) then
					v3 = true
				elseif v5.publishedMoment == nil and postStatusCardStore.isAwaitingLiveCard(momentId) then
					table.insert(momentIds, momentId)
				else
					return false, nil, false
				end
			end
		end
	end

	local count = 0
	local v5 = nil

	for k in set do
		count += 1
		v5 = k
	end

	if #momentIds > 0 then
		if count > 0 then
			return false, nil, false
		end

		if #momentIds == 1 then
			return true, momentIds[1], v3
		end

		return true, momentIds[#momentIds], true
	end

	if not v2 then
		return false, nil, false
	end

	if count == 1 then
		return true, v5, true
	end

	return true, nil, false
end

local function useHidePostStatusToast()
	local v2 = useMomentsTabIsVisible()
	React.useEffect(function()
		if v2 then
			return sendrPostStatusToast.listen(function(p)
				if sendrPostStatusToast.isFailure(p) then
					if v ~= nil then
						v:debug("event=post_status_toast decision=shown reason=failure")
					end
				else
					local v3, v4, v5 = shouldHidePostStatusToast()

					if v ~= nil then
						v:debug(
							"event=post_status_toast decision={} creditedMomentId={} guess={}",
							v3 and "hidden" or "shown",
							v4 or "nil",
							(tostring(v5))
						)
					end

					if v3 then
						sendrPostStatusToast.dismiss(p)

						if v4 ~= nil then
							if v5 then
								GetPostStatusCardStore(false).markToastProbablySpentFor(v4)
							else
								GetPostStatusCardStore(false).markToastHiddenFor(v4)
							end
						end
					end
				end
			end)
		end

		return nil
	end, { v2 })
end

return useHidePostStatusToast
