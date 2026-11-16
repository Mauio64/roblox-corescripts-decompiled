local parent = script:FindFirstAncestor("ChatUIPrimitives").Parent
local React = require(parent.React)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)

require(script.Parent.Parent.Types)
local getReplyPreview = require(script.Parent.Reply.getReplyPreview)
require(script.Parent.groupMessages)
local unpackContent = require(script.Parent.Parent.ContentKinds.unpackContent)

local function contentKindsKey(p)
	local v = {}

	for _, content in p.message.contents do
		local v2 = unpackContent(content)

		if v2 ~= nil then
			table.insert(v, v2)
		end
	end

	return table.concat(v, ",")
end

local function useMessageRowContents(callback)
	local getIdentity = React.useMemo(function()
		return function(p)
			local author = callback(p).message.author

			if author == nil then
				return nil
			end

			return {
				userId = author.userId,
				displayName = author.displayName,
				isRobloxVerified = false,
				avatarContent = `rbxthumb://type=AvatarHeadShot&id={author.userId}&w=150&h=150`
			}
		end
	end, { callback })

	local v = React.useMemo(function()
		return Signals.createComputed(function(p)
			return contentKindsKey(callback(p))
		end)
	end, { callback })
	local kindsKey = SignalsReact.useSignalState(v)

	local contents = React.useMemo(function()
		local result = {}

		for k, content in callback(false).message.contents do
			local kind = unpackContent(content)

			if kind ~= nil then
				table.insert(result, {
					kind = kind,
					getContent = function(p)
						local content2 = callback(p).message.contents[k]

						if unpackContent(content2) == kind then
							return content2
						end

						return content
					end
				})
			end
		end

		return result
	end, { callback, kindsKey })

	local v2 = React.useMemo(function()
		return Signals.createComputed(function(p)
			return getReplyPreview.getReplyText(callback(p).message)
		end)
	end, { callback })
	local v3 = React.useMemo(function()
		return Signals.createComputed(function(p)
			return getReplyPreview.getReplyLabel(callback(p).message)
		end)
	end, { callback })

	return {
		getIdentity = getIdentity,
		contents = contents,
		kindsKey = kindsKey,
		replyText = SignalsReact.useSignalState(v2),
		replyLabel = SignalsReact.useSignalState(v3)
	}
end

return useMessageRowContents
