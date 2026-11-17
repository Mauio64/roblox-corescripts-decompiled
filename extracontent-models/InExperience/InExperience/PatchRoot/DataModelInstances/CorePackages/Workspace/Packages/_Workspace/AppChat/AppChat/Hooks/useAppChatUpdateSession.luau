local SessionService = game:GetService("SessionService")

local parent = script:FindFirstAncestor("AppChat").Parent

local React = require(parent.React)
local useEffect = React.useEffect
local useRef = React.useRef

local ChatSessionRefCount = require(script.Parent.ChatSessionRefCount)

return function(flag: boolean?, p)
	local v = flag == nil or flag
	local v2 = p or SessionService
	local v3 = useRef(false)

	if v then
		if not v3.current then
			ChatSessionRefCount.acquire(v2)
			v3.current = true
		end
	elseif v3.current then
		ChatSessionRefCount.release(v2)
		v3.current = false
	end

	useEffect(function()
		return function()
			if v3.current then
				ChatSessionRefCount.release(v2)
				v3.current = false
			end
		end
	end, {})
end
