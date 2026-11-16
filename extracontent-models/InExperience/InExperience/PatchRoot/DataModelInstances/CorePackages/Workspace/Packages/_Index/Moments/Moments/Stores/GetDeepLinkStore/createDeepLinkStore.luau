local parent = script:FindFirstAncestor("Moments").Parent

local Signals = require(parent.Signals)

local createSignal = Signals.createSignal

local function createDeepLinkStore()
	local signal, v = createSignal(nil)

	local signal2, v2 = createSignal(nil)

	local signal3, v3 = createSignal(nil)

	return {
		getDeepLinkedMomentId = signal,
		getDeepLinkedMomentTargetIdType = signal2,
		getPendingCommentsTarget = signal3,
		setDeepLinkedMomentId = function(p: string?)
			v(p)
			v2(nil)

			if p ~= nil then
				v3(nil)
			end
		end,
		setDeepLinkedMoment = function(deepLinkId: string?, p: string?, p2)
			v(deepLinkId)

			if deepLinkId == nil then
				p = nil
			end

			v2(p)

			if deepLinkId ~= nil then
				v3(p2 ~= nil and {
					deepLinkId = deepLinkId,
					feedItemId = nil,
					commentId = p2.commentId
				} or nil)
			end
		end,
		resolvePendingCommentsTarget = function(deepLinkId: string, feedItemId: string?)
			local v4 = signal3(false)

			if v4 == nil or v4.deepLinkId ~= deepLinkId then
				return
			end

			v3(feedItemId ~= nil and feedItemId ~= "" and {
				deepLinkId = deepLinkId,
				feedItemId = feedItemId,
				commentId = v4.commentId
			} or nil)
		end,
		takeCommentsTarget = function(p: string)
			local v4 = signal3(false)

			if v4 == nil or v4.feedItemId == nil or v4.feedItemId ~= p then
				return nil
			end

			v3(nil)
			return { commentId = v4.commentId }
		end
	}
end

return createDeepLinkStore
