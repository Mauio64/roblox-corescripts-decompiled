local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("SocialTestHelpers").Parent
local ReactRoblox = require(Parent.ReactRoblox)
local waitForEvents = require(Parent.TestUtils).DeferredLuaHelpers.waitForEvents
local MockNotificationService = require(Parent.MockEngineServices).MockNotificationService
local RobloxEventReceiver = require(Parent.RealtimeDelivery).RobloxEventReceiver

local function createMockRealtime() -- line: 15
	-- upvalues: MockNotificationService (copy), RobloxEventReceiver (copy), HttpService (copy), ReactRoblox (copy), waitForEvents (copy)
	local v8 = MockNotificationService.new()

	return RobloxEventReceiver.new(v8), {
		emitRealtimeEvent = function(s1: string, p1) -- line: 20
			-- upvalues: HttpService (copy), ReactRoblox (copy), v8 (copy), waitForEvents (copy)
			local json = HttpService:JSONEncode(p1)

			ReactRoblox.act(function() -- line: 22
				-- upvalues: v8 (copy), s1 (copy), json (copy), waitForEvents (copy)
				v8.RobloxEventReceived:Fire({
					namespace = s1,
					detail = json
				})
				waitForEvents()
			end)
		end,
		emitRealtimeConnectionState = function(p2, t1: {[any]: any}) -- line: 30
			-- upvalues: ReactRoblox (copy), v8 (copy), HttpService (copy), waitForEvents (copy)
			ReactRoblox.act(function() -- line: 34
				-- upvalues: v8 (copy), p2 (copy), HttpService (copy), t1 (copy), waitForEvents (copy)
				v8.RobloxConnectionChanged:Fire("signalR", p2, 0, HttpService:JSONEncode(t1))
				waitForEvents()
			end)
		end
	}
end

return createMockRealtime
