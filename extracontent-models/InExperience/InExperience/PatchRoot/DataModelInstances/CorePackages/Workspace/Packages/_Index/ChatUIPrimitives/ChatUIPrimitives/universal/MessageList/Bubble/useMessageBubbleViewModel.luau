local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

require(script.Parent.Parent.Parent.Types)
require(script.Parent.Parent.groupMessages)
local isObservingAuthor = require(script.Parent.Parent.isObservingAuthor)
local ObservingUserContext = require(script.Parent.Parent.ObservingUserContext)
local useMessageRowContents = require(script.Parent.Parent.useMessageRowContents)
local getBubbleCornerRadii = require(script.Parent.getBubbleCornerRadii)
local Sizing = require(script.Parent.Parent.Parent.Sizing)
require(script.Parent.Types)

local function renderKeyOf(p) -- 1 equivalent call inferred from this helper
	local author = p.message.author
	local v = author == nil and "" or author.userId
	local v2 = p.message.deliveryState == nil and "" or p.message.deliveryState
	return `{p.groupPosition.isFirst}|{p.groupPosition.isLast}|{v}|{v2}`
end

local function useMessageBubbleViewModel(callback)
	local v = ObservingUserContext.useObservingUserId()
	local cornerRadius = Sizing.useSizing().bubble.cornerRadius
	local v2 = useMessageRowContents(callback)
	local v3 = React.useMemo(function()
		return Signals.createComputed(function(p)
			return renderKeyOf(callback(p)) -- inferred equivalent call
		end)
	end, { callback })
	local v4 = SignalsReact.useSignalState(v3)
	local v5 = v2.replyLabel ~= nil

	local v6 = React.useMemo(function()
		local v6 = callback(false)
		local observingAuthor = isObservingAuthor(v6.message.author, v)
		local v7 = v6.message.author ~= nil
		local alignment = observingAuthor and "right" or "left"
		return {
			alignment = alignment,
			groupPosition = v6.groupPosition,
			isObservingUser = observingAuthor,
			showUsername = v6.groupPosition.isFirst and v7 and not (observingAuthor or v5),
			showAvatar = not observingAuthor and v6.groupPosition.isLast and v7,
			cornerRadii = getBubbleCornerRadii(v6.groupPosition, alignment, cornerRadius),
			deliveryState = v6.message.deliveryState
		}
	end, { callback, v4, v, cornerRadius, v5 })

	return {
		alignment = v6.alignment,
		groupPosition = v6.groupPosition,
		isObservingUser = v6.isObservingUser,
		showUsername = v6.showUsername,
		showAvatar = v6.showAvatar,
		cornerRadii = v6.cornerRadii,
		getIdentity = v2.getIdentity,
		contents = v2.contents,
		deliveryState = v6.deliveryState,
		replyText = v2.replyText,
		replyLabel = v2.replyLabel
	}
end

return useMessageBubbleViewModel
