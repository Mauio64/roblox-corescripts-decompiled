local Parent = script:FindFirstAncestor("AppChat").Parent
local Mock = require(Parent.LuaSocialLibrariesDeps).Mock

return function(t1: {[any]: any}) -- line: 18
	-- upvalues: Mock (copy)
	local v4 = Mock.MagicMock.new()

	v4.id = if t1.id == nil then t1.title else t1.id
	v4.title = t1.title
	v4.participants = t1.participants or {}

	local dateTime = DateTime.fromUnixTimestamp(t1.unixTime or 0)

	v4.lastUpdated = {
		GetShortRelativeTime = function() -- line: 25
			-- upvalues: t1 (copy)
			return t1.shortRelativeTime or "0"
		end,
		GetLongRelativeTime = function() -- line: 28
			-- upvalues: t1 (copy)
			return t1.longRelativeTime or "0"
		end,
		GetUnixTimestamp = function() -- line: 31
			-- upvalues: t1 (copy)
			return t1.unixTime or 0
		end,
		dateTime = dateTime,
		Format = function(_, p2) -- line: 35
			-- upvalues: dateTime (copy)
			return dateTime:FormatLocalTime(p2, "en-us")
		end
	}
	v4.serverState = "CREATED"
	v4.messages = t1.messages
	v4.isDefaultTitle = t1.isDefaultTitle ~= nil and t1.isDefaultTitle
	v4.previewContent = nil
	v4.osaAcknowledgementStatus = "not_applicable"
	v4.hasUnreadMessages = t1.hasUnreadMessages ~= nil and t1.hasUnreadMessages
	v4.moderationType = nil
	v4.userPendingStatus = nil
	v4.shortRelativeTime = t1.shortRelativeTime or "0"
	v4.hasGroupUp = false
	v4.lastMessageContent = nil

	return v4
end
