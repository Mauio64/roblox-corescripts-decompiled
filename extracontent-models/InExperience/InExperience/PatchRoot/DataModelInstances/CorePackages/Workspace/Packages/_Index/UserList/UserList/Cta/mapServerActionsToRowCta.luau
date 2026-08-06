local UserList = script:FindFirstAncestor("UserList")
local UserListParent = UserList.Parent
local Foundation = require(UserListParent.Foundation)
local Enums = require(UserList.Common.Enums)

require(UserList.Common.Types)

local IconName = Foundation.Enums.IconName
local ButtonTypes = Enums.ButtonTypes
local t1 = {
	AddFriend = {
		buttonType = ButtonTypes.Add,
		handlerKey = ButtonTypes.Add
	},
	AcceptFriendRequest = {
		supportsDismiss = true,
		buttonType = ButtonTypes.Accept,
		handlerKey = ButtonTypes.Accept
	},
	PendingFriendRequest = {
		isDisabled = true,
		buttonType = ButtonTypes.Pending
	},
	CannotAddFriend = {
		isDisabled = true,
		buttonType = ButtonTypes.Add
	},
	Chat = {
		buttonType = ButtonTypes.Chat,
		handlerKey = ButtonTypes.Chat
	},
	JoinExperience = {
		buttonType = ButtonTypes.Join
	}
}

local function v8() -- line: 41
end
local function isSupported(t2: {[any]: any}?, s1: string) -- line: 43
	if not t2 then
		return true
	end

	for _, v14 in t2 do
		if v14 == s1 then
			return true
		end
	end

	return false
end
local function mapServerActionsToRowCta(p1, p2, s2: string, p3) -- line: 55
	-- upvalues: t1 (copy), v8 (copy), ButtonTypes (copy), IconName (copy)
	if not p1 or not p1.buttons then
		return {
			primaryCta = nil,
			secondaryCta = nil
		}
	end

	local v19 = if not p3 then nil else p3.supportedActions
	local g27 = nil
	local v24 = nil

	for _, v21 in p1.buttons do
		local v22 = t1[v21.type]

		if not v22 then
			continue
		end

		local type = v21.type

		if not v19 then
			v24 = true
		else
			for _, v26 in v19 do
				if v26 == type then
					v24 = true
					g27 = true
				end

				if g27 then
					break
				end
			end

			if not g27 then
				v24 = false
			end
		end

		g27 = false

		if v24 then
			local v28 = if not v22.handlerKey then nil else p2[v22.handlerKey]
			local t3 = {
				type = v22.buttonType,
				onActivated = if not v28 then v8 else function() -- line: 74
					-- upvalues: v28 (copy), s2 (copy)
					v28(s2)
				end,
				isDisabled = v22.isDisabled,
				disabledReason = v21.disabledReason,
				minWidth = if not p3 then nil else p3.primaryCtaMinWidth,
				maxWidth = if not p3 then nil else p3.primaryCtaMaxWidth
			}
			local t4 = nil

			if v22.supportsDismiss and p3 and p3.showDismissForRequests then
				local v31 = p2[ButtonTypes.Dismiss]

				t4 = {
					type = ButtonTypes.Dismiss,
					icon = IconName.X,
					onActivated = if not v31 then v8 else function() -- line: 91
						-- upvalues: v31 (copy), s2 (copy)
						v31(s2)
					end
				}
			end

			return {
				primaryCta = t3,
				secondaryCta = t4
			}
		end
	end

	return {
		primaryCta = nil,
		secondaryCta = nil
	}
end

return mapServerActionsToRowCta
