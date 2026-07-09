local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("UserSearch").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local Analytics = require(script.Parent.Analytics)

local function useUserSearchAnalytics(t1: {[any]: any}?) -- line: 16
	-- upvalues: HttpService (copy), React (copy), Analytics (copy), Cryo (copy)
	local v8 = t1 and t1.userSearchSessionId or HttpService:GenerateGUID(false)

	return (React.useMemo(function() -- line: 20
		-- upvalues: Analytics (copy), Cryo (copy), t1 (copy), v8 (copy)
		return Analytics({
			infoForAllEvents = Cryo.Dictionary.join(t1 or {}, {
				userSearchSessionId = v8
			})
		})
	end, {
		t1,
		v8
	}))
end

return useUserSearchAnalytics
