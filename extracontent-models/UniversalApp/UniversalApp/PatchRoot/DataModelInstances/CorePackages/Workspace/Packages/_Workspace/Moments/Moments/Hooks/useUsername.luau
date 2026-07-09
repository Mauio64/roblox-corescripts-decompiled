local Moments = script:FindFirstAncestor("Moments")
local MomentsParent = Moments.Parent
local React = require(MomentsParent.React)
local SignalsReact = require(MomentsParent.SignalsReact)
local GetUsersStore = require(Moments.Stores.GetUsersStore)
local Players = game:GetService("Players")
local useSignalState = SignalsReact.useSignalState

return function(n1: number) -- line: 18
	-- upvalues: GetUsersStore (copy), useSignalState (copy), React (copy), Players (copy)
	local v9 = GetUsersStore(false)
	local username = useSignalState(v9.getUserProfile((tostring(n1)))).username

	React.useEffect(function() -- line: 23
		-- upvalues: username (copy), Players (copy), n1 (copy), v9 (copy)
		if username ~= nil then
			return
		end

		local u11 = false

		task.spawn(function() -- line: 30
			-- upvalues: Players (copy), n1 (copy), u11 (ref), v9 (copy)
			local ok, result = pcall(function() -- line: 31
				-- upvalues: Players (copy), n1 (copy)
				return Players:GetNameFromUserIdAsync(n1)
			end)

			if ok and not u11 then
				v9.updateUsername(n1, result)
			end
		end)

		return function() -- line: 39
			-- upvalues: u11 (ref)
			u11 = true
		end
	end, {
		n1,
		username,
		v9.updateUsername
	})

	return username
end
