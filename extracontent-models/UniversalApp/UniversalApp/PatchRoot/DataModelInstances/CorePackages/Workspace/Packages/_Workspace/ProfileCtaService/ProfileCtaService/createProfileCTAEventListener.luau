local NotificationService = game:GetService("NotificationService")
local Players = game:GetService("Players")
local Parent = script:FindFirstAncestor("ProfileCtaService").Parent
local v4 = require(Parent.RealtimeDelivery).RobloxEventReceiver.new(NotificationService)
local getLocalPlayerUserId = require(Parent.DataHydration).DataHydrationUtils.getLocalPlayerUserId
local Constants = require(script.Parent.Constants)

local function createProfileCTAEventListener(p1: ((...any) -> ...any)) -- line: 24
	-- upvalues: getLocalPlayerUserId (copy), Players (copy), v4 (copy), Constants (copy)
	local u9 = getLocalPlayerUserId()
	local connection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function() -- line: 27
		-- upvalues: getLocalPlayerUserId (copy), u9 (ref)
		local v13 = getLocalPlayerUserId()

		if v13 ~= u9 then
			u9 = v13
		end
	end)
	local u11 = v4:observeEvent(Constants.FRIENDSHIP_NOTIFICATIONS, function(t1: {[any]: any}) -- line: 36
		-- upvalues: u9 (ref), p1 (copy)
		if not t1.EventArgs or (not t1.EventArgs.UserId1 or not t1.EventArgs.UserId2) then
			return
		end

		local v15 = if tostring(u9) ~= tostring(t1.EventArgs.UserId1) then tostring(t1.EventArgs.UserId1) else tostring(t1.EventArgs.UserId2)

		p1(v15)
	end)
	local u12 = v4:observeEvent(Constants.PRESENCE_BULK_NOTIFICATIONS, function(t2: {[any]: any}) -- line: 50
		-- upvalues: p1 (copy)
		if not t2 or type(t2) ~= "table" then
			return
		end

		for _, v in ipairs(t2) do
			if v and v.UserId then
				local str = tostring(v.UserId)

				p1(str)
			end
		end
	end)

	return function() -- line: 63
		-- upvalues: connection (ref), u11 (ref), u12 (ref)
		if connection then
			connection:Disconnect()
			connection = nil
		end

		if u11 then
			u11:disconnect()
			u11 = nil
		end

		if u12 then
			u12:disconnect()
			u12 = nil
		end
	end
end

return createProfileCTAEventListener
