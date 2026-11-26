local createSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals").createSignal

local function createDeepLinkStore()
	local signal, v5 = createSignal(nil)

	local signal2, v6 = createSignal(nil)

	local signal3, v7 = createSignal(nil)

	return {
		getDeepLinkedMomentId = signal,
		getDeepLinkedMomentTargetIdType = signal2,
		getPendingCommentsTarget = signal3,
		setDeepLinkedMomentId = function(p2)
			v5(p2)
			v6(nil)

			if p2 ~= nil then
				v7(nil)
			end
		end,
		setDeepLinkedMoment = function(p2, p3, p4)
			v5(p2)

			if p2 == nil then
				p3 = nil
			end

			v6(p3)

			if p2 ~= nil then
				v7(p4 ~= nil and {
					deepLinkId = p2,
					feedItemId = nil,
					commentId = p4.commentId
				} or nil)
			end
		end,
		resolvePendingCommentsTarget = function(p2, p3)
			local v8 = signal3(false)

			if v8 == nil or v8.deepLinkId ~= p2 then
				return
			end

			v7(p3 ~= nil and p3 ~= "" and {
				deepLinkId = p2,
				feedItemId = p3,
				commentId = v8.commentId
			} or nil)
		end,
		takeCommentsTarget = function(p2)
			local v8 = signal3(false)

			if v8 == nil or v8.feedItemId == nil or v8.feedItemId ~= p2 then
				return nil
			end

			v7(nil)
			return { commentId = v8.commentId }
		end
	}
end

return createDeepLinkStore
