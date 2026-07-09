local Parent = script:FindFirstAncestor("PeopleService").Parent
local Promise = require(Parent.Promise)

local function onPersonBlockButtonActivated(p1, p2, n1: number, s1: string, _: {[any]: any}, p3) -- line: 36
	-- upvalues: Promise (copy)
	p2:trackBlockUserButtonClick(p1.UserId, n1, s1)

	local t2 = {
		action = function(_, _: string, s3: string, _) -- line: 46
			-- upvalues: p2 (copy), p1 (copy), n1 (copy), s1 (copy)
			if s3 == "blockUser" then
				p2:trackBlockUser(p1.UserId, n1, s1)

				return
			end

			if s3 == "unblockUser" then
				p2:trackUnblockUser(p1.UserId, n1, s1)

				return
			end

			if s3 == "blockUserButtonClick" then
				p2:trackBlockUserButtonClick(p1.UserId, n1, s1)
			end
		end
	}
	local t3 = {
		player = p1,
		closeModal = function() -- line: 61
		end,
		analytics = t2,
		source = s1,
		onBlockingSuccess = p3 and p3.onBlockingSuccess or nil
	}
	local u12 = nil
	local v13 = Promise.new(function(resolve) -- line: 69
		-- upvalues: u12 (ref)
		u12 = resolve
	end)

	return {
		useToastFlow = true,
		modalProps = t3,
		promise = v13,
		resolvePromise = u12
	}
end

return onPersonBlockButtonActivated
