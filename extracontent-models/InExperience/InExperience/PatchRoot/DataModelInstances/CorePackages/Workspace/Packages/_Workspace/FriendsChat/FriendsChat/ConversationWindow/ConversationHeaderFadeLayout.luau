local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)
local ConversationHeaderFadeLayout = {}

function ConversationHeaderFadeLayout.getHeaderOverlapPadding(object)
	return object:map(function(p: number)
		return UDim.new(0, -p)
	end)
end

function ConversationHeaderFadeLayout.getHeaderVisibleHeight(height, fade)
	if type(fade) == "number" then
		local v = 1 - math.clamp(fade, 0, 1)
		return height:map(function(p: number)
			return p * v
		end)
	end

	if fade == nil then
		return height
	end

	return React.joinBindings({ height = height, fade = fade }):map(function(p)
		return p.height * (1 - math.clamp(p.fade, 0, 1))
	end)
end

function ConversationHeaderFadeLayout.getContentTopPadding(height, visibleHeight, canvasY)
	return React.joinBindings({ height = height, visibleHeight = visibleHeight, canvasY = canvasY }):map(function(data)
		local v = math.max(data.height - data.canvasY, 0)
		local v2 = math.min(data.height - data.visibleHeight, v)
		return data.height - v2
	end)
end

function ConversationHeaderFadeLayout.getHeaderInteractable(value)
	if type(value) == "number" then
		return value < 1
	end

	if value == nil then
		return true
	end

	return value:map(function(p: number): boolean
		return p < 1
	end)
end

return ConversationHeaderFadeLayout
